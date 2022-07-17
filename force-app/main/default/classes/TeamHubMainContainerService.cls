/**
* @author : Daksh
* @company : Cognizant
* @description : This class will be used to communicate backend and controller TeamHubMainContainer.
*/
public class TeamHubMainContainerService {
    /**
* @author : Daksh
* @description : This method is used to call getRequestedData method of TeamHubMainContainerController class to get all the required data on load.
* @return : TeamHubMainContainerController.RequestDataWrapper
*/
    @auraEnabled
    public static TeamHubMainContainerController.RequestDataWrapper getRequestedDataOnLoad(){
        return TeamHubMainContainerController.getRequestedDataOnLoad();
    }
}