/**
*@author : Ashish Singh
*@company : cognizant
*@description : This class is the apex controller for FetchGuestUserIPAddress visualforce page
*/
public class GetGuestUserIPAddressController{
    /**
    * @description This is being used to fetch IP Address
    * @author Ashish Singh | 25-01-2022
    * return String
    **/
    public String ipAddress{get; set;} 
    
    /**
    * @description This method is fetches the IP Address
    * @author Ashish Singh | 25-01-2022
    **/
    public GetGuestUserIPAddressController(){
        ipAddress = ApexPages.currentPage().getHeaders().get('True-Client-IP');
        ipAddress = String.isBlank(ipAddress) ? ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP') : ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
    }
}
