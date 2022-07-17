/*
Purpose    : This class will search a pre-authenticaed email address by searching it in Salesforce user base
It be used for the Salesforce OpenID for configuration of SSO from Google to Salesforce
Created by : Gayani Devapriya (Cloud Sherpas)
Created on : 17th July 2015
*/
global class GoogleAppsRegistrationHandler implements Auth.RegistrationHandler {

    global User createUser(Id portalId ,Auth.UserData data){
        
        String googleEmail = data.email;
        if(googleEmail == null){
            return null;
        }else{
            //Domain match will not be required - if required can implement here  like this  // if (!email.contains('@yourdomain.com')) return null;
            //Email address will be searched.
            User oUser;
            try{
                oUser = [Select Id, FirstName, LastName, Email, Username from User where email =: googleEmail limit 1];
            }
            catch(Exception ex){
                return null;
            }
            return oUser;
        }
    }
    
    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        //nothing on this scenario
    }
    
 
}