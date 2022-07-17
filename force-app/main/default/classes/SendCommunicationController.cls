/**
* @author : Monika Bisht
* @company : Cognizant
* @description : This class will be use to Delete associate object based on cancellation of communication.
*/
public with sharing class SendCommunicationController{
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Monika Bisht
    * @description : This method contains the logic to fetch recordId on edit.
    * @param recordId
    * @return : commRecordId
    */
    private static String deleteAllChildFromCommunication(String recordId){
        List<Audience__c> listAud = new List<Audience__c>();
        Set<Id> setOfChildCommunicationId = new Set<Id>();
        Set<id> setOfCampaign = new Set<id>();
        List<CampaignContent__c> listCamCont = new List<CampaignContent__c>();
        Campaign objCamp;
        String commRecordId;
        String communicationType = '';
        for(Communication__c objCom:CommunicationDomain.getInActiveCommunicationByRecordId(recordId)){
            if(CommunicationService.isCommunicationType(objCom)) {
                for(Audience__c objAud : objCom.Audiences__r){
                    listAud.add(objAud);
                }
                if(objCom.Campaign__c != null){
                    setOfCampaign.add(objCom.Campaign__c);
                }
                communicationType = labelToContentMap.get('TYPECOMMUNICATION');
            }
            commRecordId = objCom.id;
        }
        if(!setOfCampaign.isEmpty()){
            for(CampaignContent__c objCampCont:CampaignContentDomain.getCampOfComm(setOfCampaign)){
                listCamCont.add(objCampCont);
                objCamp = new Campaign(id = objCampCont.Campaign__c);
            }
        }
        // delete Audience for Communication
        // Delete Campaign content and Campaign
        if(communicationType == labelToContentMap.get('TYPECOMMUNICATION')) {
            CommunicationService.deleteCommunicationChild(listAud, listCamCont, objCamp);
        }
        return commRecordId;
    }
    /**
* @author : Monika Bisht
* @description : This method is used to fetch recordId, checkbox and cancel reason on edit.
* @param recordId
* @param isActive
* @param cancelComment
* @return : map<string,string>
*/
    public static map<string,string> updateCommunicationRecords
        (String recordId, Boolean isActive, String cancelComment)
    {
        map<string,string> resultMap = new map<string,string>();
        try{
            // Changes done by Ankit Singh
            // no need to query if we are only updating.
            //Communication__c objCom = CommunicationDomain.getCommunicationRecordById(recordId);
            if(String.isNotBlank(cancelComment)) {
                Communication__c objCommunication = new Communication__c(
                    Id = recordId,
                    Active__c = isActive,
                    ReasonofCancellation__c = cancelComment
                );
                CommunicationDomain.dmlOnCommunicationRecd(objCommunication, 'update');
                // Added by Ankit Singh
                deleteAllChildFromCommunication(recordId);
            }
            else{
                resultMap.put('status','error');
                resultMap.put('errormsg','');
            }
        }
        catch(Exception ex){
            //log exception
            PublishLogEventService.publishExceptionEvent(
                'SendCommunicationController.cls on updateCommunicationRecords',
                ex
            );
        }
        return resultMap;
    }
    /**
* @author : Daksh Madan
* @description : This method will insert Audience,Campaign,CampaignContent__c
* @return : String
* @param jsonString
* @param labelToContentMap
*/
    public static String insertCommunicationRelatedRecords(
        String jsonString,
        Map<String, String> labelToContentMap
    ){
        String commRecdId = '';
        try{
            //deserialize jsonString
            SendCommunicationController.DataWrapper dataWrapObj = (SendCommunicationController.DataWrapper)
                System.JSON.deserialize(jsonString, SendCommunicationController.DataWrapper.class);
            //getting the values after deserializing
            Map<String, Object> utlCommunicationObj = (Map<String, Object>)
                    JSON.deserializeUntyped(dataWrapObj.utlCommunicationRecord);
            String type = (String) utlCommunicationObj.get('Type__c');
            Campaign primaryCampaign = dataWrapObj.primaryCampaign;
            List<Knowledge__kav> knowledgeArticleList = dataWrapObj.knowledgeArticleList;
            Datetime scheduleTimeForCommunication = dataWrapObj.scheduleTimeForCommunication;
            Datetime taskDueDate = dataWrapObj.dueDate;
            List<Id> multiSelectLookupIds = dataWrapObj.multiSelectLookupIds;
            Campaign childCampaign;
            Communication__c communicationRecord;
            if(type == labelToContentMap.get('TYPECOMMUNICATION')) {
                //insert child campaign record
                childCampaign = new Campaign(
                        Name = primaryCampaign.Name,
                        ParentId = primaryCampaign.Id,
                        CommunicationSubject__c = dataWrapObj.commSubject 
                );
                CampaignDomain.dmlOnCampaignRecd(new List<Campaign>{childCampaign},'insert');
                //insert Communication__c record
                communicationRecord = new Communication__c(
                        Campaign__c = childCampaign.Id,
                        ScheduledDate__c = scheduleTimeForCommunication,
                        Active__c= true,
                        Description__c='New Communiation Record Created!',
                        Type__c = type
                );
            } else if(type == labelToContentMap.get('TYPEUTLACTION')) {
                primaryCampaign = new Campaign();
                primaryCampaign = CampaignDomain.getCampaignRecordByCode(
                        labelToContentMap.get('CAMPAIGNCODEUTLNOTIF')
                );
                //insert child campaign record
                childCampaign = new Campaign(
                        Name = primaryCampaign.Name,
                        ParentId = primaryCampaign.Id
                );
                CampaignDomain.dmlOnCampaignRecd(new List<Campaign>{childCampaign},'insert');
                communicationRecord = new Communication__c(
                        Campaign__c = childCampaign.Id,
                        ScheduledDate__c = scheduleTimeForCommunication,
                        Active__c = true,
                        ActionURL__c = (String)utlCommunicationObj.get('ActionURL__c'),
                        SystemToAction__c = (String)utlCommunicationObj.get('SystemToAction__c'),
                        TaskDescription__c = (String)utlCommunicationObj.get('TaskDescription__c'),
                        TaskDueDate__c = taskDueDate.addHours(12).addMinutes(59),
                        TaskTitle__c = (String)utlCommunicationObj.get('TaskTitle__c'),
                        OriginatingSystem__c = (String)utlCommunicationObj.get('OriginatingSystem__c'),
                        Type__c = type,
                        AssigneeEmployeeId__c = UserDomain.queryUserBasedOnId(
                                UserInfo.getUserId()
                        ).EmployeeID__c
                );
            }
            CommunicationDomain.dmlOnCommunicationRecd(communicationRecord,'insert');
            //insert Audience__c record
            List<Audience__c> audienceList = new List<Audience__c>();
            Map<String, String> audienceDataMap = new Map<String, String>();
            audienceDataMap.put('childCampaignName', childCampaign.Name);
            audienceDataMap.put('primaryCampaignName', primaryCampaign.Name);
            audienceDataMap.put('type', type);
            audienceDataMap.put('communicationRecordId', String.valueOf(communicationRecord.Id));
            audienceList = CommunicationService.getAudienceList(
                    multiSelectLookupIds,
                    audienceDataMap,
                    audienceList
            );
            AudienceDomain.dmlOnAudienceList(audienceList,'insert');
            //insert CampaignContent__c records
            if(type == labelToContentMap.get('TYPECOMMUNICATION')) {
                List<CampaignContent__c> campaignContentList = new List<CampaignContent__c>();
                Set<String> setRecId = new Set<String>();
                Set<Id> setRecIds = new Set<Id>();
                Map<String, String> mapImageKeyToUrl = new Map<String, String>();
                for(Knowledge__kav obj : knowledgeArticleList){
                    setRecId.add(obj.id);
                    setRecIds.add(obj.id);// Added as ContentDistributionService.fetchPublicUrl accepts Id's.
                }
                //Added by sunil to dynamically fetch ContentDocumentList and ContentDistribution
                mapImageKeyToUrl = ContentDistributionService.fetchPublicUrl(setRecIds);
                integer seq = 0;
                for(Knowledge__kav article : KnowledgeDomain.getArticlesForPreview(setRecId)){
                
                        campaignContentList.add(
                                new CampaignContent__c(
                                        Campaign__c=childCampaign.Id,
                                        KnowledgeArticle__c=article.Id,
                                        ThumbnailURL__c = mapImageKeyToUrl.containsKey(article.Id+'-'+labelToContentMap.get('THUMBNAIL'))?
                                       mapImageKeyToUrl.get(article.Id+'-'+labelToContentMap.get('THUMBNAIL')):'',
                                        EmailHeaderURL__c = mapImageKeyToUrl.containsKey(article.Id+'-'+labelToContentMap.get('EMAILHEADER'))?
                                       mapImageKeyToUrl.get(article.Id+'-'+labelToContentMap.get('EMAILHEADER')):'',
                                        Name=primaryCampaign.Name + ' child Campaign Content',
                                        Sequence__c = seq
                                )
                        );
                        seq++;
                }
                CampaignContentDomain.dmlOnCampaignContentList(campaignContentList,'insert');
            }
            //returning Id of newly created Communication record.
            Communication__c communicationRecd = CommunicationDomain.getCommunicationRecordById(
                    communicationRecord.Id
            );
            commRecdId = String.valueOf(communicationRecord.Id);
            //update child campaign name
            Campaign childCamp = CampaignDomain.getCampaignRecordById(childCampaign.Id);
            childCamp.Name = communicationRecd.Name + '-' + primaryCampaign.CampaignCode__c;
            CampaignDomain.dmlOnCampaignRecd(new List<Campaign>{childCamp},'update');
        }
        catch(Exception ex){
            //log exception
            PublishLogEventService.publishExceptionEvent(
                'SendCommunicationController.cls on insertCommunicationRelatedRecords',
                ex
            );
        }
        return commRecdId;
    }
    /**
    * @author : Daksh Madan
    * @description : This class will act as wrapper for jsonString.
    */
    public class DataWrapper{
        //wrapper variables
        public List<Id> multiSelectLookupIds;
        public Campaign primaryCampaign;
        public List<Knowledge__kav> knowledgeArticleList;
        public DateTime scheduleTimeForCommunication;
        public String utlCommunicationRecord;
        public DateTime dueDate;
        public String commSubject;
    }
    /**
    * @author : Monika Bisht
    * @description : This method use for edit functionality of send communication
    * @param commId
    * @return : Commnicate
    */
    public static Communicate fetchCommunicateRec(string commId){
        Communicate objCom  = new Communicate();
        try{
            string objCamaign = '';
            map<id,list<Knowledge__kav>> mapknow = new map<id,list<Knowledge__kav>>();
            Communication__c objCommunication = CommunicationDomain.getCommunicationRecordById(commId);
            objCamaign = objCommunication.Campaign__c;
            if(string.isNotBlank(objCamaign)){
                for(CampaignContent__c objComm :CampaignContentDomain.getCampContentBasedOnCampaign(objCamaign)){
                    Knowledge__kav know = new Knowledge__kav();
                    know.id = objComm.KnowledgeArticle__r.id;
                    know.Title = objComm.KnowledgeArticle__r.Title;
                    know = objComm.KnowledgeArticle__r;
                    if(!mapknow.containsKey(objComm.Campaign__c)){
                        list<Knowledge__kav> lstKnowledge = new list<Knowledge__kav>();
                        lstKnowledge.add(know);
                        mapknow.put(objComm.Campaign__c,lstKnowledge);
                    }else{
                        mapknow.get(objComm.Campaign__c).add(know);
                    }
                }
            }
            objCom = editSendCommunition(CommunicationDomain.getCommunicationWithAudiences(commId),mapknow);
        }
        catch(Exception ex){
            //log exception
            PublishLogEventService.publishExceptionEvent(
                'SendCommunicationController.cls on fetchCommunicateRec',
                ex
            );
        }
        return objCom;
    }
    /**
    * @author : Monika Bisht
    * @description : This method use for edit functionality of send communication
    * @param lstCommunication
    * @param mapknow
    * @return : Commnicate
    */
    public static Communicate editSendCommunition(
        List<Communication__c> lstCommunication,
        Map<id,list<Knowledge__kav>> mapknow
    ) {
        Communicate objCom  =new Communicate();
        for(Communication__c objComm :lstCommunication){
            objCom.objCommunication = objComm;
            if(objComm.ScheduledDate__c < system.now())
            {
                objCom.isValid = true;
            }
            for(Audience__c objAud :objComm.Audiences__r){
                LstAuidience aud = new LstAuidience();
                if(objAud.Contact__c != null){
                    aud.id = objAud.Contact__r.id;
                    //aud.name = objAud.Contact__r.name;
                    aud.isContact = true;
                    objCom.lstAud.add(aud);
                }else if(objAud.DistributionList__c != null){
                    aud.id  = objAud.DistributionList__r.id;
                    //aud.name  = objAud.DistributionList__r.name;
                    aud.isContact = false;
                    objCom.lstAud.add(aud);
                }
            }
            if(mapknow != null && mapknow.size() > 0){
                for(Knowledge__kav know : mapknow.get(objComm.Campaign__c)){
                    LstArticle article = new LstArticle();
                    article.art= know;
                    objCom.objArticle.add(article);
                }
            }
        }
        return objCom;
    }
    /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : This wrapper class used to fetch all the associated record with communication.
    */
    Public class Communicate{
        @AuraEnabled
        Public list<LstArticle> objArticle;
        @AuraEnabled
        Public Communication__c objCommunication;
        @AuraEnabled
        Public Boolean isValid;
        @AuraEnabled
        Public list<LstAuidience> lstAud;
        /**
        * @author : Monika Bisht
        * @company : Cognizant
        * @description : This is the constructor of wrapper class.
        */
        Public Communicate(){
            objArticle = new list<LstArticle>();
            lstAud = new list<LstAuidience>();
            objCommunication = new Communication__c();
            isValid = false;
        }
    }
    /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : This is a wrapper class used in Commnicate wrapper .
    */
    Public class LstAuidience{
        @AuraEnabled
        Public boolean isContact;
        @AuraEnabled
        Public string id;
        @AuraEnabled
        Public string name;
        /**
        * @author : Monika Bisht
        * @company : Cognizant
        * @description : This is a constructor of wrapper .
        */
        Public LstAuidience(){
            isContact = false;
        }
    }
    /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : This is a wrapper class used in Commnicate wrapper .
    */
    Public class LstArticle{
        @AuraEnabled
        Public Knowledge__kav art;
        /**
        * @author : Monika Bisht
        * @company : Cognizant
        * @description : This is a constructor of wrapper .
        */
        Public LstArticle(){
            art = new Knowledge__kav();
        }
    }
    /**
    * @author : Sunil Kumar
    * @description : This method is used to fetch Knowledge records in sorted orders.
    * @return : String
    * @param ids
    */
    @AuraEnabled
    public static String getArticlesForPreview(
        String ids
    ){
        return SendCommunicationService.getArticlesForPreview(ids);
    }
    
}