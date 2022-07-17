/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is to create user test data
*/
@isTest
public class UserTestData {
/**
* @author : Praveen Tiwari
* @description : This methods create a User record
* @return : User
* @param profileName
* @param roleName
*/
    public static User getUser(String profileName, String roleName){
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt;  
        Profile prof = [Select Id from Profile Where Name = :profileName];
        User u = new User(Alias = 'standt', Email='testinguser@testorg.com', 
                          EmailEncodingKey='ISO-8859-1', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_AU', ProfileId = prof.Id, 
                          TimeZoneSidKey='Australia/Sydney', UserName=uniqueName+'@test'+orgId+'.org');
        return u;
    }

    /**
     * @author      Abhishek Setia
     * @description Creates User
     * @param       profileName
     * @return      User
     */
    public static User createUser(String profileName)
    {
        Profile pr = [SELECT Id FROM Profile WHERE Name=:profileName];
        User usr = new User();
        usr.LastName = 'test1';
        usr.Email='standarduser@testorg.com';
        usr.Alias = 'standt';
        usr.ProfileId = pr.id;
        usr.EmailEncodingKey='UTF-8';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.TimeZoneSidKey = 'Asia/Kolkata';
        usr.UserName='standarduser101@testorg.com';
        usr.EmployeeID__c='Test0';
        insert usr;
        return usr;
    }
}