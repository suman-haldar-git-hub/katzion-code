/**
* @author : Monika Bisht
* @company : Cognizant
* @description : This class will be use to show custom report.
*/
public with sharing class ReportOnCommunicationController{
     /**
    * @author : Monika Bisht
    * @description : This method return list of wrapper class
    * @return : lstResponse
    */
    @AuraEnabled
    public static list<ResponseWrapper> reportData()
    {
        set<id> campId = new set<id>();
        map<string,list<Knowledge__kav>> mapknow = new map<string,list<Knowledge__kav>>();
        map<string,list<CamaignAud>> mapCommunitcation = new map<string,list<CamaignAud>>();
        list<Communication__c> listCommunication = CommunicationDomain.getCommunicationForReport();                                                    
            for(Communication__c objCom : listCommunication){ 
                campId.add(objCom.Campaign__c);                         
                if(mapCommunitcation.containsKey(objCom.Campaign__r.Name)){
                    for(Audience__c objAud :objCom.Audiences__r){
                        CamaignAud aud = new CamaignAud();
                        aud.contact = objAud.Contact__r.name;
                        aud.createdByName = objCom.Campaign__r.CreatedBy.name;
                        aud.statusName =  objCom.Status__c;
                        aud.distributionlist = objAud.DistributionList__r.name;
                        aud.commsCreated = Date.valueOf(objCom.Createddate);
                        mapCommunitcation.get(objCom.Campaign__r.Name).add(aud);
                    }
                }else{
                    list<CamaignAud> lstAud = new list<CamaignAud>();
                    for(Audience__c objAud :objCom.Audiences__r){
                        CamaignAud aud = new CamaignAud();
                        aud.contact = objAud.Contact__r.name;
                        aud.createdByName = objCom.Campaign__r.CreatedBy.name;
                        aud.statusName =  objCom.Status__c;
                        aud.distributionlist = objAud.DistributionList__r.name;
                        aud.commsCreated = Date.valueOf(objCom.Createddate);
                        lstAud.add(aud);
                    }
                    mapCommunitcation.put(objCom.Campaign__r.Name,lstAud);
                }
            } 
         for(CampaignContent__c objComm : CampaignContentDomain.getCampOfComm(campId)){
            Knowledge__kav know = new Knowledge__kav();
            know.id = objComm.KnowledgeArticle__r.id;
            know.Title = objComm.KnowledgeArticle__r.Title;
            if(!mapknow.containsKey(objComm.Campaign__r.Name)){
                list<Knowledge__kav> lstKnowledge = new list<Knowledge__kav>();
                lstKnowledge.add(know);
                mapknow.put(objComm.Campaign__r.Name,lstKnowledge);
            }else{
                mapknow.get(objComm.Campaign__r.Name).add(know);
            }
        } 
        list<ResponseWrapper> lstResponse = communicationReport(listCommunication,mapknow,mapCommunitcation);
        return lstResponse;
    }
    /**
    * @author : Monika Bisht
    * @description : This method return list of wrapper class
    * @return : lstResponse
    * @param listCommunication
    * @param mapknow
    * @param mapCommunitcation
    */
    public static list<ResponseWrapper> communicationReport(List<Communication__c> listCommunication,map<string,list<Knowledge__kav>> mapknow,
                                                            map<string,list<CamaignAud>> mapCommunitcation)
    {
        list<ResponseWrapper> lstResponse = new list<ResponseWrapper>();
        set<string> campaignName = new set<string>();
        for(Communication__c objCom : listCommunication){
            if(!campaignName.contains(objCom.Campaign__r.Name)){
                campaignName.add(objCom.Campaign__r.Name);
                ResponseWrapper objResponse = new ResponseWrapper();
                objResponse.campaignName = objCom.Campaign__r.Name;
                for(CamaignAud objAud :mapCommunitcation.get(objCom.Campaign__r.Name)){
                    LstAuidience aud = new LstAuidience();
                    aud.contact = objAud.contact ;
                    aud.distributionlist = objAud.distributionlist;
                    aud.createdByName = objAud.createdByName;
                    aud.statusName =  objAud.statusName;
                    aud.commsCreated = Date.valueOf(objCom.Createddate);
                    objResponse.lstAud.add(aud);
                }
                objResponse.audCount = objResponse.lstAud.size();
                for(Knowledge__kav know : mapknow.get(objCom.Campaign__r.Name)){
                    LstArticle objArticle = new LstArticle();
                    objArticle.article= know.title;
                    objResponse.listArticle.add(objArticle);
                }
                objResponse.articleCount = objResponse.listArticle.size();
                lstResponse.add(objResponse);
            }
        }
        return lstResponse;
    }
     /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : This wrapper class used to fetch require data for report.
    */  
     Public class ResponseWrapper{
        @AuraEnabled
            Public string campaignName;
        @AuraEnabled
            Public integer audCount;
        @AuraEnabled
            Public integer articleCount;
        @AuraEnabled
        Public list<LstAuidience> lstAud;
        @AuraEnabled
        Public list<LstArticle> listArticle;
        /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : Constructor.
    */
        Public ResponseWrapper(){
            lstAud = new list<LstAuidience>();
            listArticle = new list<LstArticle>();
        }
    }
    /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : This wrapper class used to fetch require data for report.
    */
    Public class LstAuidience{
        @AuraEnabled
        Public string contact;
        @AuraEnabled
        Public string distributionlist;
        @AuraEnabled
        Public string createdByName;
        @AuraEnabled
        Public string statusName;    
        @AuraEnabled
        Public Date commsCreated;
    }
    /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : This wrapper class used to fetch require data for report.
    */
    Public class LstArticle{
        @AuraEnabled
        Public string article;
    }
    /**
    * @author : Monika Bisht
    * @company : Cognizant
    * @description : This wrapper class used to fetch require data for report.
    */
    Public class CamaignAud{
        @AuraEnabled
        Public string contact;
        @AuraEnabled
        Public string distributionlist;
        @AuraEnabled
        Public string createdByName;
        @AuraEnabled
        Public string statusName;
        @AuraEnabled
        Public Date commsCreated;
    }
}