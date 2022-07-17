/**
* @Author :Sunil
* @Company :Cognizant
* @description :This is the batch class to create Campaign Member record from Communication and Audience record.
*/
global class CreateUtlAudienceBatch implements Database.Batchable<sObject>{
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    public String campaignId;
    public String recordId;
    public String campaignCode;
    public String assigneeEmpId;
    public String taskTitle;
    public Datetime taskDueDate;
    public String originatingSys;
    public String sysToAction;
    public String taskDesc;
    public String actionUrl;
    Map<String, String> mapAccIdToContactTd = new Map<String, String>();
    Map<String, String> mapContIdToEmpId = new Map<String, String>();
    Map<String, User> mapEmpIdToUser = new Map<String, User>();
    Set<String> setAccountId;
    List<Communication__c> lstComm = new List<Communication__c>();
    Set<String> setArea;
    Set<String> setBrand;
    Set<String> setCareerLevel;
    Set<String> setDescription;
    Set<String> setEmployeeGroup;
    Set<String> setEmployeeSubgroup;
    Set<String> setGroup;
    Set<String> setLocation;
    Set<String> setRegion;
    Set<String> setOpsSupport;
    Set<String> setCountry;
    Set<String> setLineManager;
    Set<String> setDOA;
    String setTMIdentifier;
    Set<String> setCompany;
    static Map<String, String> mapPicklist = 
    CreateCommunicationAudienceService.createPicklistMap();
    /**
    * @Author :Sunil
    * @Company :Cognizant
    * @description :This is the constructon of batch class.
    * @param lstParams
    */
    @InvocableMethod(label='exuete the batch CreateUtlAudienceBatch' 
                     description='This method will execute the CreateUtlAudienceBatch')
    public static void executeBatchMethod(List<String> lstParams) {
        String campId = lstParams[0].split(':')[0];
        String comId = lstParams[0].split(':')[1];
        Integer batchSize = Integer.valueOf(lstParams[0].split(':')[2]);
        Boolean isUtlFeatureEnabled = FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLBATCHES')
        ).EnableUTLBatches__c;
        if(isUtlFeatureEnabled) {
            Database.executeBatch(new CreateUtlAudienceBatch(campId,comId), batchSize);
        }
    }
    /**
    * @Author :Sunil
    * @Company :Cognizant
    * @description :This is the constructon of batch class.
    * @param campId
    * @param comId
    */
    global CreateUtlAudienceBatch(String campId,String comId){
        this.campaignId = campId;
        this.recordId = comId;
        lstComm = CommunicationDomain.getCommunicationForBatch(comId);
    }
    /**
    * @Author : Sunil
    * @description : This method will query Audience record based on Communication Id.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String query = 'Select Id,Communication__c,Contact__c,Contact__r.AccountId,DistributionList__c,';
        query += 'DistributionList__r.Active__c,DistributionList__r.Area__c,';
        query += 'DistributionList__r.Brand__c,DistributionList__r.CareerLevel__c,';
        query += 'DistributionList__r.Description__c,';
        query += 'DistributionList__r.EmployeeGroup__c,DistributionList__r.EmployeeSubgroup__c,';
        query += 'DistributionList__r.Group__c,DistributionList__r.Location__c,';
        query += 'DistributionList__r.Region__c,DistributionList__r.Country__c,';
        query += 'DistributionList__r.OpsSupport__c,DistributionList__r.IsLineManager__c,';
        query += 'DistributionList__r.HasDOA__c,Communication__r.Campaign__r.Parent.CampaignCode__c,';
        query += 'Communication__r.AssigneeEmployeeId__c,Communication__r.TaskTitle__c,';
        query += 'Communication__r.TaskDueDate__c,Communication__r.OriginatingSystem__c,';
        query += 'Communication__r.SystemToAction__c,Communication__r.TaskDescription__c,';
        query += 'DistributionList__r.TeamMemberIdentifier__c,DistributionList__r.Company__c,';
        query += 'Communication__r.ActionURL__c';
        query += ' FROM Audience__c WHERE Communication__c=:recordId AND Communication__r.Active__c=true';
        return Database.getQueryLocator(Query);
    }
    /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<Audience__c> scope){
        try{
            createCampaignMembers(scope);
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent
            ('CreateUtlAudienceBatch.cls on execute',ex);}
    }
    /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    * @param audienceList
    */
    private void createCampaignMembers(List<Audience__c> audienceList){
        setAccountId= new Set<String>();
        setArea = new Set<String>();
        setBrand = new Set<String>();
        setCareerLevel = new Set<String>();
        setDescription = new Set<String>();
        setEmployeeGroup = new Set<String>();
        setEmployeeSubgroup = new Set<String>();
        setGroup = new Set<String>();
        setLocation = new Set<String>();
        setRegion = new Set<String>();
        setOpsSupport = new Set<String>();
        setCountry = new Set<String>();
        setLineManager = new Set<String>();
        setDOA = new Set<String>();
        setTMIdentifier = '';
        setCompany = new Set<String>();
        For(Audience__c obj : audienceList){
            if(String.isNotEmpty(obj.Contact__c)){
                //setAccountId.add(obj.Contact__r.AccountId);
                mapAccIdToContactTd.put(obj.Contact__r.AccountId, obj.Contact__c);
            }
            if(String.isEmpty(campaignCode)){
                campaignCode = obj.Communication__r.Campaign__r.Parent.CampaignCode__c;
            }
            setArea = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.Area__c,setArea,mapPicklist);
            setBrand = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.Brand__c,setBrand,mapPicklist);
            setCareerLevel = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.CareerLevel__c,setCareerLevel,mapPicklist);
            setEmployeeGroup = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.EmployeeGroup__c,setEmployeeGroup,mapPicklist);
            setEmployeeSubgroup = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.EmployeeSubgroup__c,setEmployeeSubgroup,mapPicklist);
            setGroup = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.Group__c,setGroup,mapPicklist);
            setLocation = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.Location__c,setLocation,mapPicklist);
            setRegion = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.Region__c,setRegion,mapPicklist);
            setOpsSupport = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.OpsSupport__c,setOpsSupport,mapPicklist);
            setCountry = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.Country__c,setCountry,mapPicklist);
            setLineManager = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.IsLineManager__c,setLineManager,mapPicklist);
            setDOA = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.HasDOA__c,setDOA,mapPicklist);
            setTMIdentifier = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.TeamMemberIdentifier__c,setTMIdentifier,mapPicklist);
            setCompany = 
            CreateCommunicationAudienceService.createCollectionData(obj.DistributionList__r.Company__c,setCompany ,mapPicklist);
        }
        String queryAcc = '';
        queryAcc = createQuery(new QueryParams
            (queryAcc,'CompanyCode__c','setCompany', ' IN: '),setCompany.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'Area_Dept_Name__c','setArea', ' IN: '),setArea.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'BrandCode__c','setBrand', ' IN: '),setBrand.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'CareerLevelCode__c','setCareerLevel', ' IN: '),setCareerLevel.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'Employee_Class__c','setEmployeeGroup', ' IN: '),setEmployeeGroup.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'Employee_Type__c','setEmployeeSubgroup', ' IN: '),setEmployeeSubgroup.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'GroupCode__c','setGroup', ' IN: '),setGroup.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'Location_Name__c','setLocation', ' IN: '),setLocation.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'RegionCode__c','setRegion', ' IN: '),setRegion.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'OpsSupport__c','setOpsSupport', ' IN: '),setOpsSupport.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'Country__c','setCountry', ' IN: '),setCountry.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'IsLineManager__c','setLineManager', ' IN: '),setLineManager.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'HasDOA__c','setDOA', ' IN: '),setDOA.size());
        queryAcc = createQuery(new QueryParams
            (queryAcc,'TeamMemberIdentifier__c',setTMIdentifier, ' INCLUDES('),setTMIdentifier.length());    
        if(String.isNotEmpty(queryAcc) || mapAccIdToContactTd.keyset().size() > 0){
            batchQuery(queryAcc,mapAccIdToContactTd.keyset());
        }
    }
     /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    * @param queryAcc
    * @param setAccountIds
    */
    public void batchQuery(String queryAcc, set<String> setAccountIds){
        system.debug('queryAcc---'+queryAcc);
        queryAcc = String.isNotEmpty(queryAcc) && setAccountIds.size() > 0?
                ' FROM Account WHERE ('+queryAcc+') OR Id in:setAccountIds LIMIT 50000':
                String.isNotEmpty(queryAcc) && setAccountIds.size() == 0?
                ' FROM Account WHERE ('+queryAcc+') LIMIT 50000':
                ' FROM Account WHERE Id in:setAccountIds LIMIT 50000';
        queryAcc = 
            'Group__c,Location_Name__c,Region__c,OpsSupport__c'+queryAcc;
        queryAcc = 
            'Employee_Class__c,Employee_Type__c,Employee_ID__c,'+queryAcc;
        queryAcc = 
            'Select id,PersonContactId,Area_Dept_Name__c,Brand__c,CareerLevel__c,CareerLevelCode__c,'+queryAcc;

        system.debug('queryAcc---'+queryAcc);
        List<Account> lstAcc = new List<Account>();    
        lstAcc = database.query(queryAcc);
        For (Account objAcc: lstAcc){
            mapContIdToEmpId.put(objAcc.PersonContactId, objAcc.Employee_ID__c);
            mapAccIdToContactTd.put(objAcc.Id, objAcc.PersonContactId);
        }
        if(mapContIdToEmpId.keyset().size()>0){
            mapEmpIdToUser = createUserMap(mapContIdToEmpId.values());
        }
        For (Account objAcc: lstAcc){
            if(mapEmpIdToUser.containsKey(objAcc.Employee_ID__c)){
                setAccountId.add(objAcc.Id);
            }
            }
        createCampaignViaContact();  
    }
    /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    */
    public void createCampaignViaContact(){
        List<String> lstAccountId = new List<String>();
        List<UniversalTaskList__c> lstUtlToInsert = new List<UniversalTaskList__c>();
         List<CampaignMember> lstCMToInsert = new List<CampaignMember>();
         List<Communication__c> lstCommToInsert = new List<Communication__c>();
         List<Sobject> lstObjToInsert = new List<Sobject>();
        if(setAccountId.size()>0){
            lstAccountId.addAll(setAccountId);
            integer count = 0;
            Integer listSize = Integer.valueOf(labelToContentMap.get('UTLRECORDSLIMIT'));
            count = lstAccountId.size() / listSize;
            count += math.mod(lstAccountId.size(),listSize)>0?1:0; 
                for(Integer i=0;i<count;i++){
                    Communication__c objComm = lstComm[0].clone();
                    objComm.ParentCommunication__c = recordId;
                    objComm.ExternalId__c = lstComm[0].Name+'_'+i;
                    lstCommToInsert.add(objComm);
            }
             //insert lstCommToInsert;
             for(Integer i = 0 ; i < lstCommToInsert.size(); i++){
                for(Integer j=(i*listSize);(j<(i*listSize)+listSize) && j<lstAccountId.size() ; j++){
                    UniversalTaskList__c objTask = 
                    new UniversalTaskList__c(
                                            Communication__r = new Communication__c (ExternalId__c = lstCommToInsert[i].ExternalId__c),
                                            Status__c = labelToContentMap.get('UTLTASKSTATUS'),
                                            AssignedToAccount__c = lstAccountId[j],
                                            SubmittedByAccount__r = new Account
                                                        (Employee_Id__c = lstComm[0].AssigneeEmployeeId__c),
                                            SubmittedForAccount__r = new Account
                                                        (Employee_Id__c = lstComm[0].AssigneeEmployeeId__c),
                                            Title__c = lstComm[0].TaskTitle__c,
                                            DueDate__c = lstComm[0].TaskDueDate__c,
                                            OriginatingSystem__c = lstComm[0].OriginatingSystem__c,
                                            SystemOfAction__c = lstComm[0].SystemToAction__c,
                                            Description__c = lstComm[0].TaskDescription__c,
                                            DeepLink__c = lstComm[0].ActionURL__c,
                                            RecordTypeId = Schema.SObjectType.UniversalTaskList__c.getRecordTypeInfosByName().
                                                        get(labelToContentMap.get('UTLRECORDTYPETASK')).getRecordTypeId(),
                                            SubmittedDate__c = System.now(),
                                            ReceivedDate__c = System.now()
                                            
                                            );
                                            
                    lstUtlToInsert.add(objTask);
                     
                }
            }
            lstObjToInsert.addAll(lstCommToInsert);
            lstObjToInsert.addAll(lstUtlToInsert);
                Database.insert(lstObjToInsert,false);
                for(UniversalTaskList__c sr : lstUtlToInsert){
                    if(validateEligibility(sr)){
                        lstCMToInsert.add(new CampaignMember(
                                contactId = mapAccIdToContactTd.get(sr.AssignedToAccount__c),
                                User__c = mapEmpIdToUser.get(
                                    mapContIdToEmpId.get(mapAccIdToContactTd.get
                                    (sr.AssignedToAccount__c))).Id,
                                CampaignId = campaignId, 
                                UniversalTask__c = sr.Id));
                    }
                    
                }
            Database.insert(lstCMToInsert,false);  
        }
    }

     /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    * @return Boolean
    * @param sr
    */
    public Boolean validateEligibility(UniversalTaskList__c sr){
        System.debug('5555 '+sr);
        return  sr.Id !=null && ( 
                       (
                        labelToContentMap.get('CAMPAIGNCODEUTLNOTIF').contains(campaignCode) &&
                        mapEmpIdToUser.get(
                            mapContIdToEmpId.get(mapAccIdToContactTd.get
                            (sr.AssignedToAccount__c))).TaskNotification__c &&
                            mapEmpIdToUser.get(
                            mapContIdToEmpId.get(mapAccIdToContactTd.get
                            (sr.AssignedToAccount__c))).TaskNotificationChannel__c.contains(
                            labelToContentMap.get('UTLNOFICITAIONEMAIL'))
                        ) 
                         
                    );
    
    }
    /**
    * @Author : Sunil
    * @description : This method will execute post-processing operations.
    * @param bc
    */
    global void finish(Database.BatchableContext bc){
        System.debug('Finish block'); 
    } 
    /**
    * @Author : Sunil
    * @description : This method will create the dynamic query.
    * @param objParam
    * @param setSize
    * @return String
    */
    public string createQuery(queryParams objParam,Integer setSize){
        system.debug('objParam++++'+objParam);
        if(setSize>0){
            If(string.isEmpty(objParam.strQuery)){
                if(objParam.queryFilter != null && objParam.queryFilter.equalsIgnoreCase(' INCLUDES(')) {
                    objParam.strQuery += ' '+objParam.fieldName+objParam.queryFilter+objParam.setName+')';
                }
                else {
                    objParam.strQuery += ' '+objParam.fieldName+objParam.queryFilter+objParam.setName;
                }
            }
            else{
                if(objParam.queryFilter != null && objParam.queryFilter.equalsIgnoreCase(' INCLUDES(')) {
                    objParam.strQuery += ' AND '+objParam.fieldName+objParam.queryFilter+objParam.setName+')';
                }
                else {
                    objParam.strQuery += ' AND '+objParam.fieldName+objParam.queryFilter+objParam.setName;
                }
            }
        }
        system.debug('objParam.strQuery----'+objParam.strQuery);
        return objParam.strQuery;
    }
    /**
    * @Author : Sunil
    * @description : This method will creates Map of employee Id and User and return to CreateUtlAudienceBatch.
    * @param lstEmpId
    * @return Map<String, User>
    */
    public Map<String, User> createUserMap(List<String> lstEmpId){
        Map<String, User> mapEmpIdToUser = new Map<String, User>();
        For(User objUser : UserDomain.getUserRecordsForUtl(lstEmpId)){
            mapEmpIdToUser.put(objUser.EmployeeID__c, objUser);
        }
        return mapEmpIdToUser;
    }
    /**
    * @Author :Sunil
    * @Company :Cognizant
    * @description :This is the wrapper class for query Params.
    */
    public class QueryParams{
        string strQuery;
        string fieldName;
        string setName;
        String queryFilter;
        /**
        * @Author : Sunil
        * @description : This method will create the dynamic query.
        * @param strQuery
        * @param fieldName
        * @param setName
        * @param queryFilter
        */
        public queryParams(string strQuery,string fieldName,string setName, String queryFilter){
            this.strQuery = strQuery;
            this.fieldName = fieldName;
            this.setName = setName;
            this.queryFilter = queryFilter;
        }
    }
}