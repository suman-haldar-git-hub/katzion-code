/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is the controller class of VerticalNavigation component
*/
public class VerticalNavigationService {
	
    /**
* @author : Daksh
* @description : This method is used to fetch all data on load.
* @return : LightningResponse
*/
    @AuraEnabled
    public static LightningResponse fetchRequiredDataOnLoad(){
        return VerticalNavigationController.getVerticalMgmtWrapperData();
    }
}