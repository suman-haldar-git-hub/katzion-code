/**
* @author : Daksh
* @company : Cognizant
* @description : This controller class contains and manage all server-side methods.
*/
public class TeamHubMainContainerController {
    public static List<Knowledge__kav> knowledgeArticleList = new List<Knowledge__kav>();
    /**
* @author : Daksh
* @description : This method is used to get all the requested Data on on load.
* @return : TeamHubMainContainerController.RequestDataWrapper
*/
    public static TeamHubMainContainerController.RequestDataWrapper getRequestedDataOnLoad(){
        try{
            knowledgeArticleList = KnowledgeDomain.getKnowledgeArticleList();
        }
        catch(Exception ex){ PublishLogEventService.publishExceptionEvent
                ('TeamHubMainContainerController.cls on load',ex);}
        TeamHubMainContainerController.RequestDataWrapper requestDataWrap = 
            new TeamHubMainContainerController.RequestDataWrapper(knowledgeArticleList);
        return requestDataWrap;
    }
    /**
* @author : Daksh
* @company : Cognizant
* @description : This inner class will make the wrapper of requested data on load.
*/
    public class RequestDataWrapper{
        @auraEnabled
        public List<Knowledge__kav> knowledgeArticleList;
        /**
* @author : Daksh
* @description : This is the Parameterized Constructor to initialize knowledgeArticleList.
* @param knowledgeArticleList
*/
        public RequestDataWrapper(List<Knowledge__kav> knowledgeArticleList){
            this.knowledgeArticleList = knowledgeArticleList;
        }
    }
}