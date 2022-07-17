/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This Domain Class is used to query and UniversalTaskList object
*/
public inherited sharing class UniversalTaskListDomain {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
        
    /**
    * @Author : Ankit Singh
    * @description :This method return UniversalTaskList for logged in User
    * @return lstTask
    * @param paramsMap
    * @param setOfStatus
    */
    public static List<UniversalTaskList__c> getLoggedInUserTask(
        Map<String, String> paramsMap,
        Set<String> setOfStatus
    ) {
        Integer initialRows = Integer.valueOf(paramsMap.get('initialRows'));
        String rowOffset= paramsMap.containsKey('offset')?paramsMap.get('offset'):'0';
        DateTime pastTwoMonthDate = (DateTime) System.today().addmonths(-2);
        DateTime currentTime = System.now();
        Id loggedInUserId = UserInfo.getUserId();
        Set<String> recordTypeSet = loginUserTaskQueryRecordtype(paramsMap);        
        String type = (paramsMap.containsKey('type') && String.isNotBlank(paramsMap.get('type')))?paramsMap.get('type'):'';
        List<String> listType = (String.isNotBlank(type))?type.split(','):new List<String>();
        System.debug('listType='+listType);
        List<UniversalTaskList__c> lstTask = new List<UniversalTaskList__c>();
        String strquery = 'SELECT Id, Name, Status__c, ReceivedDate__c, SubmittedForAccount__c, Title__c, ';
        strquery+= 'SubmittedForAccount__r.Name, Description__c, DueDate__c, toLabel(OriginatingSystem__c), ';
        strquery+= 'CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,HideLearningAssignment__c, ';
        // Added RecordTypeName__c field in query for TH-2918 issue by Amit Sharma
        strquery+= 'RecordType.Name, SystemOfAction__c, Type__c,RecordTypeName__c, Category__c ,SubmittedByAccount__r.Name ';
        strquery+= 'FROM UniversalTaskList__c ';
        strquery+= 'WHERE OwnerId=:loggedInUserId ';
        strquery+= 'AND THStatus__c IN: setOfStatus ';
        strquery+= 'AND RecordType.Name IN:recordTypeSet ';
        strquery+= 'AND HideLearningAssignment__c!=true ';
        strquery+=loginUserTaskQueryFiltertype(paramsMap,listType);
        strquery+=loginUserTaskQuerylimit(paramsMap);                
        strquery+=' OFFSET '+rowOffset;
        System.debug('strquery='+strquery);
        lstTask = System.Database.query(strquery);        
        return lstTask;
    }

    /**
    * @author       Abhishek Setia
    * @description  Record type condition for method getLoggedInUserTask
    * @param        paramsMap
    * @return       Set<String>
    */
    public static Set<String> loginUserTaskQueryRecordtype(Map<String, String> paramsMap){
        Set<String> recordTypes = new Set<String>();
        if(paramsMap.containsKey('approvalRecordType') && paramsMap.get('approvalRecordType')=='true'){
            recordTypes.add(labelToContentMap.get('UTLRECORDTYPEAPPROVAL'));
        }
        if(paramsMap.containsKey('taskRecordType') && paramsMap.get('taskRecordType')=='true'){
            recordTypes.add(labelToContentMap.get('UTLRECORDTYPETASK'));
        }
        return recordTypes;
    }
    
    /**
    * @author       Abhishek Setia
    * @description  Query break for method getLoggedInUserTask
    * @param        paramsMap
    * @param        listType
    * @return       String
    */
    public static String loginUserTaskQueryFiltertype(
        Map<String, String> paramsMap,
        List<String> listType
    ){
        String query='';
        String filterType = paramsMap.get('filterType');
        String columnSorting = paramsMap.get('columnSorting');
        if(String.isNotBlank(filterType)){
            if(filterType == 'Archive'){
                query+= ' AND CreatedDate <=: currentTime';
                query+= ' AND CreatedDate >=: pastTwoMonthDate';
            }else if((filterType == 'My Task' || filterType == 'My Approval') && !listType.isEmpty()){            
                query += ' AND OriginatingSystem__c IN :listType ';            
            }            
        }
        if(String.isNotBlank(columnSorting)) {
            query+= columnSorting;
        }        
        return query;
    }

    /**
    * @author       Abhishek Setia
    * @description  Query break for method getLoggedInUserTask
    * @param        paramsMap
    * @return       String
    */
    public static String loginUserTaskQuerylimit(
        Map<String, String> paramsMap
    ){
        String query='';
        String keyword = (paramsMap.containsKey('keyword'))?paramsMap.get('keyword'):'';
        query+= (paramsMap.containsKey('countTotal') && 
            paramsMap.get('countTotal')=='true' || String.isNotBlank(keyword))?' LIMIT 2000':' LIMIT :initialRows';
        return query;
    }

    /**
    * @author : Ankit Singh
    * @description :This method returns total record count of UniversalTaskList.
    * @return : totalRecord
    * @param setOfStatus
    */
    public static Integer getTotalCountOfTask(Set<String> setOfStatus) {
        Integer totalRecord = [
                SELECT COUNT()
                FROM UniversalTaskList__c
                WHERE OwnerId =: UserInfo.getUserId()
                AND THStatus__c =: setOfStatus
                AND HideLearningAssignment__c!=true
        ];
        return totalRecord;
    }

    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @param wrapParam
    * @param setOfStatus
    * @param filterType
    * @return allTask
    *
    public static List<UniversalTaskList__c> getNextTaskUsingOffset(
        String wrapParam,
        Set<String> setOfStatus,
        String filterType
    ) {
        Map<String, Object> wrapLimitObj = (Map<String, Object>) JSON.deserializeUntyped(wrapParam);
        Integer rowLimit = (Integer)wrapLimitObj.get('rowLimit');
        Integer rowOffset = (Integer)wrapLimitObj.get('rowOffset');
        String columnSorting = (String)wrapLimitObj.get('sortingData');
        DateTime pastTwoMonthDate = (DateTime) System.today().addmonths(-2);
        DateTime currentTime = System.now();
        Set<String> recordTypeSet = new Set<String>{
            labelToContentMap.get('UTLRECORDTYPETASK'),
            labelToContentMap.get('UTLRECORDTYPEAPPROVAL')
        };
        List<UniversalTaskList__c> allTask = new List<UniversalTaskList__c>();
        Id loggedInUserId = UserInfo.getUserId();
        String strquery = 'SELECT Id, Status__c, ReceivedDate__c, SubmittedForAccount__c, Title__c, ';
        strquery+= 'SubmittedForAccount__r.Name, Description__c, DueDate__c, OriginatingSystem__c, ';
        strquery+= 'CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c, ';
        strquery+= 'RecordType.Name, SystemOfAction__c, Type__c, Category__c ,SubmittedByAccount__r.Name ';
        strquery+= 'FROM UniversalTaskList__c ';
        strquery+= 'WHERE OwnerId=:loggedInUserId ';
        strquery+= 'AND THStatus__c IN:setOfStatus ';
        strquery+= 'AND RecordType.Name IN:recordTypeSet ';
        if(String.isNotBlank(filterType) && filterType == 'Archive') {
            strquery+= ' AND CreatedDate <=: currentTime';
            strquery+= ' AND CreatedDate >=: pastTwoMonthDate';
        }
        if(String.isNotBlank(columnSorting)) {
            strquery+= columnSorting;
        }
        strquery+= ' LIMIT :rowLimit OFFSET :rowOffset';
        allTask = System.Database.query(strquery);
        return allTask;
    }*/

    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @return allTask
    */
    public static List<UniversalTaskList__c> getAllTaskForLoggedInUser() {
        List<UniversalTaskList__c> allTask = new List<UniversalTaskList__c>();
        allTask = [
                SELECT Id, Status__c, OwnerId, THStatus__c, HideLearningAssignment__c
                FROM UniversalTaskList__c
                WHERE OwnerId =: UserInfo.getUserId()
                AND HideLearningAssignment__c!=true LIMIT 2000
        ];
        return allTask;
    }

    /**
    * @author :Monika Bisht
    * @description : This method To return all the task according to filter criteria.
    * @return allTask
    */
    public static List<UniversalTaskList__c> taskAndApproval() {
        List<UniversalTaskList__c> allTask = new List<UniversalTaskList__c>();
        Set<String> recordTypeSet = new Set<String>{
            labelToContentMap.get('UTLRECORDTYPETASK'),
            labelToContentMap.get('UTLRECORDTYPEAPPROVAL')
        };
        Set<String> thStatusSet = new Set<String>{
            labelToContentMap.get('STATUSMYAPPROVAL'),
            labelToContentMap.get('STATUSMYTASK')
        };
        allTask = [
                SELECT Id,THStatus__c, OwnerId, Title__c,toLabel(OriginatingSystem__c),ReceivedDate__c,
                DueDate__c,ActionUrl__c,RecordType.Name,NextTwoBusinessDaysF__c
                FROM UniversalTaskList__c
                WHERE OwnerId =: UserInfo.getUserId()
                AND THStatus__c IN: thStatusSet
                AND RecordType.Name IN: recordTypeSet
                ORDER BY ReceivedDate__c ASC
        ];
        return allTask;
    }

    /**
    * @author :Ankit Singh
    * @description : This method Query UTL List by using set Of UTL Id
    * @return utlRecordList
    * @param setOfUTLId
    */
    public static List<UniversalTaskList__c> getUTLRecorcdBySetOfId(
        Set<Id> setOfUTLId
    ) {
        List<UniversalTaskList__c> utlRecordList = new List<UniversalTaskList__c>();
        utlRecordList = [
                SELECT Id, Status__c, ReceivedDate__c, SubmittedForAccount__c, Title__c,
                SubmittedForAccount__r.Name, Description__c, DueDate__c, OriginatingSystem__c,
                CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
                RecordType.Name, PrimarySourceId__c, SystemOfAction__c,
                AssignedToAccount__c,AssignedToAccount__r.PersonContactId
                FROM UniversalTaskList__c
                WHERE Id IN: setOfUTLId
        ];
        return utlRecordList;
    }
    /**
    * @author :Monika Bisht
    * @description : This method To return all the task where child task secondarySourceId match with Parent task primarySourceId.
    * @return allUniversalTask
    * @param setOfSecondarySourceId
    */
    public static List<UniversalTaskList__c> childAndParentSourceId(set<string> setOfSecondarySourceId) {
        List<UniversalTaskList__c> allUniversalTask = new List<UniversalTaskList__c>();
        allUniversalTask = [select id,PrimarySourceId__c,SecondarySourceId__c from UniversalTaskList__c 
        where PrimarySourceId__c IN: setOfSecondarySourceId];
        return allUniversalTask;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method returns Universal Task record based on given Id.
    * @return UniversalTaskList__c
    * @param taskId
    */
    public static UniversalTaskList__c getTaskBasedOnId(String taskId){
        return [
            SELECT Id, Status__c, ReceivedDate__c, SubmittedForAccount__c, Title__c, Category__c,
                SubmittedForAccount__r.Name, Description__c, DueDate__c, OriginatingSystem__c,
                CompletedDate__c, OwnerId, NextTwoBusinessDaysF__c, THStatus__c, ActionUrl__c,
                RecordType.Name, toLabel(SystemOfAction__c), DeepLink__c,Type__c
            FROM UniversalTaskList__c
            WHERE Id =: taskId
        ];
    }
    
    /**
    * @author : Sunil Kumar
    * @description : This method returns Universal Task record based on given Emp Id.
    * @return List<UniversalTaskList__c>
    * @param empIdSet
    * @param setStatus
    * @param setRecType
    */
    public static List<UniversalTaskList__c> getTaskBasedOnEmpId(List<String> empIdSet,
    Set<String> setStatus,
    Set<String> setRecType){
        return [
            Select id, RecordType.DeveloperName, THStatus__c,AssignedToAccount__c,
            AssignedToAccount__r.Employee_ID__c,OwnerId
            FROM UniversalTaskList__c 
            WHERE //AssignedToAccount__r.Employee_ID__c IN :
            OwnerId IN:
            empIdSet
            AND 
            RecordType.DeveloperName IN : 
            setRecType
            AND
            THStatus__c IN : setStatus
        ];
    }
    
    /**
    * @author : Sunil
    * @description : This method returns Universal Task record of SubType LearningAssignment.
    * @return List<UniversalTaskList__c
    */
    public static List<UniversalTaskList__c> getLearningTask(){
        Set<String> setStatus = new Set<String>(
            labelToContentMap.get('UTLPENDINGSTATUS').split(';'));
        return new List<UniversalTaskList__c>([
            SELECT Id, ReceivedDate__c, SystemOfAction__c
            FROM UniversalTaskList__c
            WHERE OwnerId =: UserInfo.getUserId()
            AND SystemOfAction__c =: labelToContentMap.get('UTLSYSTEMOFACTIONSF')
            AND TaskSubType__c =: labelToContentMap.get('UTLSUBTYPELEARNING')
            AND RecordType.Name =: labelToContentMap.get('UTLRECORDTYPETASK')
            AND Status__c IN :setStatus
            AND ReceivedDate__c != NULL
            ORDER BY ReceivedDate__c ASC LIMIT 1
          
        ]);
    }

    /**
    * @author :Ankit Singh
    * @description : This method To return all the task getUTLRecord From PrimarySourceId Set
    * @return allUniversalTask
    * @param setOfPrimarySourceId
    */
    public static List<UniversalTaskList__c> getUTLRecordFromPrimarySourceId(
        Set<String> setOfPrimarySourceId
    ) {
        List<UniversalTaskList__c> allUniversalTask = new List<UniversalTaskList__c>();
        allUniversalTask = [
                SELECT Id, SecondarySourceId__c
                FROM UniversalTaskList__c
                WHERE SecondarySourceId__c IN: setOfPrimarySourceId
        ];
        return allUniversalTask;
    }
    /**
    * @author :Sunil
    * @description : This method will return all the tasks with given Expense8Id
    * @return UniversalTaskList__c
    * @param setExpense8Id
    * @param setTaskId
    */
    public static List<UniversalTaskList__c> getUTLRecordFromExpense8Id(
        Set<String> setExpense8Id,
        Set<String> setTaskId
    ) {
        List<UniversalTaskList__c> allUniversalTask = new List<UniversalTaskList__c>();
        allUniversalTask = [
                SELECT Id, Status__c, Expense8Id__c,
                RecordType.DeveloperName, IsChildFlag__c 
                FROM UniversalTaskList__c
                WHERE Expense8Id__c IN: setExpense8Id
                AND OriginatingSystem__c =: labelToContentMap.get('ORIGINATINGSYSTEMEXPENSE8')
                AND Id NOT IN: setTaskId
                AND (
                Status__c =: labelToContentMap.get('UNSUBMITTEDSTATUS')
                OR
                Status__c =: labelToContentMap.get('REJECTEDSTATUS') 
                OR 
                (
                Status__c =: labelToContentMap.get('SUBMITTEDSTATUS')
                //AND 
                //RecordType.DeveloperName =: labelToContentMap.get('UTLRECORDTYPEAPPROVAL') 
                ))
        ];
        return allUniversalTask;
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method To return all the tasks From SecondarySourceId Set
    * @return allUniversalTask
    * @param setOfSecondaryIds
    */
    public static List<UniversalTaskList__c> getUTLRecordFromSecondarySourceId(
        Set<String> setOfSecondaryIds
    ) {
        List<UniversalTaskList__c> allUniversalTask = new List<UniversalTaskList__c>();
        allUniversalTask = [
                SELECT Id, Name, SecondarySourceId__c, Status__c
                FROM UniversalTaskList__c
                WHERE SecondarySourceId__c IN: setOfSecondaryIds
                AND Status__c != '3'
        ];
        return allUniversalTask;
    }
    /**
    * @Author : Sunil Kumar
    * @description :This method return Task with Nudges RecordType For CurrentWeek
    * @return lstTask
    * @param setOfOwnerId
    */
    public static List<UniversalTaskList__c> getNudgesTaskForCurrentWeek(Set<Id> setOfOwnerId) {
        List<UniversalTaskList__c> lstTask = new List<UniversalTaskList__c>();
        lstTask = [
                SELECT Id, 
                TYPEOF Owner
                WHEN User THEN EmployeeID__c END
                FROM UniversalTaskList__c
                WHERE Type__c =: labelToContentMap.get('RECORDTYPENUDGE')
                AND OwnerId IN: setOfOwnerId
                AND ReceivedDate__c = LAST_N_DAYS:14
        ];
        return lstTask;
    }
}