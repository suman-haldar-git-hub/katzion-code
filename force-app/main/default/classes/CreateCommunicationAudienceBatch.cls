/**
* @Author :Sunil
* @Company :Cognizant
* @description :This is the batch class to create Campaign Member record from Communication and Audience record.
*/
global class CreateCommunicationAudienceBatch implements Database.Batchable<sObject>{
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    public String campaignId;
    public String recordId;
    public String campaignCode;
    Set<String> setContactId;
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
    Map<String, Integer> mapEmpIdToTaskCount = 
    new  Map<String, Integer>();
    Map<string, Account> mapEmpIdToAccount = 
    new Map<string, Account>();
    static Map<String, String> mapPicklist = 
    CreateCommunicationAudienceService.createPicklistMap();
    /**
    * @Author :Sunil
    * @Company :Cognizant
    * @description :This is the constructon of batch class.
    * @param lstParams
    */
    @InvocableMethod(label='exuete the batch CreateCommunicationAudienceBatch' 
                     description='This method will execute the CreateCommunicationAudienceBatch')
    public static void executeBatchMethod(List<string> lstParams) {
        string campId = lstParams[0].split(':')[0];
        string comId = lstParams[0].split(':')[1];
        Integer batchSize = Integer.valueOf(lstParams[0].split(':')[2]);
        Boolean isCommFeatureEnabled = FeatureControlDomain.getFeatureControlRecord(
                labelToContentMap.get('FEATURECONTROLBATCHES')
        ).EnableCommsBatches__c;
        if(isCommFeatureEnabled) {
            Database.executeBatch(new CreateCommunicationAudienceBatch(campId,comId), batchSize);
        }
    }
    /**
    * @Author :Sunil
    * @Company :Cognizant
    * @description :This is the constructon of batch class.
    * @param campId
    * @param comId
    */
    global CreateCommunicationAudienceBatch(string campId,string comId){
        this.campaignId = campId;
        this.recordId = comId;
    }
    /**
    * @Author : Sunil
    * @description : This method will query Audience record based on Communication Id.
    * @return Database.QueryLocator
    * @param bc
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String query = 'Select Id,Communication__c,Contact__c,DistributionList__c,';
        query += 'DistributionList__r.Active__c,DistributionList__r.Area__c,';
        query += 'DistributionList__r.Brand__c,DistributionList__r.CareerLevel__c,';
        query += 'DistributionList__r.Description__c,';
        query += 'DistributionList__r.EmployeeGroup__c,DistributionList__r.EmployeeSubgroup__c,';
        query += 'DistributionList__r.Group__c,DistributionList__r.Location__c,';
        query += 'DistributionList__r.Region__c,DistributionList__r.Country__c,';
        query += 'DistributionList__r.OpsSupport__c,DistributionList__r.IsLineManager__c,';
        query += 'DistributionList__r.TeamMemberIdentifier__c,DistributionList__r.Company__c,';
        query += 'DistributionList__r.HasDOA__c,Communication__r.Campaign__r.Parent.CampaignCode__c';
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
            ('CreateCommunicationAudienceBatch.cls on execute',ex);}
    }
    /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    * @param audienceList
    */
    private void createCampaignMembers(List<Audience__c> audienceList){
        setContactId = new Set<string>();
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
            if(string.isNotEmpty(obj.Contact__c)){
                setContactId.add(obj.Contact__c);
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
        string queryAcc = '';
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
        if(string.isNotEmpty(queryAcc) || setContactId.size() > 0){
            batchQuery(queryAcc,setContactId);
        }
    }
     /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    * @param queryAcc
    * @param setContactId
    */
    public void batchQuery(string queryAcc, set<string> setContactId){
        Map<string, String> mapContIdToEmpId = new Map<string, String>();
        Map<String, User> mapEmpIdToUser = new Map<String, User>();
        queryAcc = string.isNotEmpty(queryAcc) && setContactId.size() > 0?
                ' FROM Account WHERE ('+queryAcc+') OR PersonContactId in:setContactId LIMIT 50000':
                string.isNotEmpty(queryAcc) && setContactId.size() == 0?
                ' FROM Account WHERE ('+queryAcc+') LIMIT 50000':
                ' FROM Account WHERE PersonContactId in:setContactId LIMIT 50000';
            //queryAcc = ' FROM Account WHERE PersonContactId in:setContactId';//'+queryAcc;
        queryAcc = 
            'Group__c,Location_Name__c,Region__c,OpsSupport__c'+queryAcc;
        queryAcc = 
            'CommunicationNotification__c,CommunicationNotificationChannel__c,'+queryAcc;
        queryAcc = 
            'DailySummaryDigestNotificationChannel__c,WeeklySummaryDigestNotificationChannel__c,'+queryAcc;
        queryAcc = 
            'DailySummaryDigestNotification__c,WeeklySummaryDigestNotification__c,'+queryAcc;
        queryAcc = 
            'Employee_Class__c,Employee_Type__c,Employee_ID__c,'+queryAcc;            
        queryAcc = 
            'Select id,PersonContactId,Area_Dept_Name__c,Brand__c,CareerLevel__c,CareerLevelCode__c,'+queryAcc;
         For (Account objAcc: database.query(queryAcc)){
            if(!setContactId.contains(objAcc.PersonContactId)){
                setContactId.add(objAcc.PersonContactId);
            }
            mapEmpIdToAccount.put(objAcc.Employee_ID__c, objAcc);
            mapContIdToEmpId.put(objAcc.PersonContactId, objAcc.Employee_ID__c);
        }
        if(mapContIdToEmpId.keyset().size()>0){
            mapEmpIdToUser = createUserMap(mapContIdToEmpId.values());
        }
        createCampaignViaContact(setContactId,mapEmpIdToUser,mapContIdToEmpId);   
    }
    /**
    * @Author : Sunil
    * @description : This method will process each batch of records and creates campaign members.
    * @param setContactId
    * @param mapEmpIdToUser
    * @param mapContIdToEmpId
    */
    public void createCampaignViaContact(set<string> setContactId, 
        map<string,user> mapEmpIdToUser, map<string,string> mapContIdToEmpId){
        List<string> lstContactId = new List<string>();
        List<CampaignMember> lstCMToInsert = new List<CampaignMember>();
        if(SetContactId.size()>0){
            lstContactId.addAll(SetContactId);
            For(String conId : lstContactId){
                if(//mapEmpIdToUser.containsKey(mapContIdToEmpId.get(conId)) &&
                    validateCampaignMember(mapEmpIdToAccount.get(
                        mapContIdToEmpId.get(conId)))
                ){
                    lstCMToInsert.add(new CampaignMember(
                                contactId = conId,CampaignId = campaignId, 
                                User__c = mapEmpIdToUser.get(mapContIdToEmpId.get(conId))!=null?mapEmpIdToUser.get(mapContIdToEmpId.get(conId)).Id:null,
                                OpenTaskCount__c = mapEmpIdToTaskCount.get(mapContIdToEmpId.get(conId)+
                                '-'+labelToContentMap.get('UTLRECORDTYPETASK')),
                                OpenApprovalCount__c = mapEmpIdToTaskCount.get(mapContIdToEmpId.get(conId)+
                                '-'+labelToContentMap.get('UTLRECORDTYPEAPPROVAL'))));
                }
                
            }
            if(lstCMToInsert.size()>0){
                Database.insert(lstCMToInsert,false);
            }    
        }
    }
    /**
    * @Author : Sunil
    * @description : This method will create the collections data.
    * @param objAcc
    * @return Boolean
    */
    public Boolean validateCampaignMember(Account objAcc){
        
                return  ((labelToContentMap.get('CAMPAIGNCODEWEEKLY').contains(campaignCode) &&
                        objAcc.WeeklySummaryDigestNotification__c
                        ) 
                        ||
                        (
                        labelToContentMap.get('CAMPAIGNCODEDAILY').contains(campaignCode) &&
                        objAcc.DailySummaryDigestNotification__c
                        ) 
                        ||
                        (labelToContentMap.get('CAMPAIGNCODEIMMDT').contains(campaignCode)) &&
                        objAcc.CommunicationNotification__c
                        );
                            
    }
    /**
    * @Author : Sunil
    * @description : This method will execute post-processing operations.
    * @param bc
    */
    global void finish(Database.BatchableContext bc){
        System.debug('This is Finish Block');
    }
    /**
    * @Author : Sunil
    * @description : This method will create the dynamic query.
    * @param objParam
    * @param setSize
    * @return string
    */
    public string createQuery(queryParams objParam,Integer setSize){
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
        return objParam.strQuery;
    }
    /**
    * @Author : Sunil
    * @description : This method will creates Map of employee Id and User and return to CreateCommunicationAudienceBatch.
    * @param lstEmpId
    * @return Map<String, User>
    */
    public Map<String, User> createUserMap(List<string> lstEmpId){
        List<User> lstUsr = new List<User>();
        List<string> lstUsrId = new List<string>();
        Set<String> setStatus = new Set<String>(
            labelToContentMap.get('UTLPENDINGSTATUS').split(';'));
        Set<String> setRecType = new Set<String>{labelToContentMap.get('UTLRECORDTYPETASK'),
        labelToContentMap.get('UTLRECORDTYPEAPPROVAL')
        };
        lstUsr = UserDomain.getUserRecordsForComm(lstEmpId, setStatus, setRecType);
        Map<String, User> mapEmpIdToUser = new Map<String, User>();
        Integer taskCount, approvalCount;
        For(User objUser : lstUsr){
            mapEmpIdToUser.put(objUser.EmployeeID__c, objUser);
            lstUsrId.add(objUser.Id);
        }
        For(UniversalTaskList__c objTsk: UniversalTaskListDomain.getTaskBasedOnEmpId(
            lstUsrId, setStatus, setRecType)){
            if(objTsk.RecordType.DeveloperName == labelToContentMap.get('UTLRECORDTYPETASK')){
                if( !mapEmpIdToTaskCount.containsKey(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPETASK'))){
                    mapEmpIdToTaskCount.put(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPETASK'),1);
                }
                else{
                    mapEmpIdToTaskCount.put(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPETASK'),
                    mapEmpIdToTaskCount.get(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPETASK'))+1);
                }
            }
            if(objTsk.RecordType.DeveloperName == labelToContentMap.get('UTLRECORDTYPEAPPROVAL')){
                if( !mapEmpIdToTaskCount.containsKey(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPEAPPROVAL'))){
                    mapEmpIdToTaskCount.put(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPEAPPROVAL'),1);
                }
                else{
                    mapEmpIdToTaskCount.put(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPEAPPROVAL'),
                    mapEmpIdToTaskCount.get(objTsk.AssignedToAccount__r.Employee_ID__c+'-'+
                labelToContentMap.get('UTLRECORDTYPEAPPROVAL'))+1);
                }
            }
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