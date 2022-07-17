/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to display events on Home Page
*/
public with sharing class HomePageEventController {
    /**
    * @author :Ankit Singh
    * @description : This method return top five events of future date
    * @return List<Knowledge__kav>
    */
    @AuraEnabled
    public static ResponseWrapper getEvents() {
        ResponseWrapper objResponse = new ResponseWrapper();
        List<Knowledge__kav> knowledgeArticleList = 
            new List<Knowledge__kav>();
        try{
            knowledgeArticleList = 
                KnowledgeDomain.getfutureEvents();
            objResponse.listKnowledge = knowledgeArticleList;
            objResponse.eventCount = objResponse.listKnowledge.size();
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent('HomePageEventController.cls on load',ex);}
        return objResponse;
    }
    /**
    * @author :Ankit Singh
    * @description : This method return list of knowledge and count
    */
    Public class ResponseWrapper{
        @AuraEnabled
        Public List<Knowledge__kav> listKnowledge;
        @AuraEnabled
        Public integer eventCount;
        /**
        * @author :Ankit Singh
        * @description : This method return list of knowledge and count
        */
        Public ResponseWrapper(){
            listKnowledge = new List<Knowledge__kav>();
        }
    }
}