/**
* @author : Monika Bisht
* @company : Cognizant
* @description : This class is controller class  Lightning components.
*/
public with sharing class TransferOwnershipController {
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
     /**
    * @author : Monika Bisht
    * @description : This method is used to get the metadata.
    * @return : GetMapMetadata
    */
    @AuraEnabled
    public static GetMapMetadata setMetadataMethod(){
        GetMapMetadata mapMetadata = new GetMapMetadata();
        try{
            mapMetadata.labelAndContentWrapperMap = labelToContentMap;
        }
        catch(Exception ex){
            //log exception
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return mapMetadata;
    }
    /**
    * @author : Monika Bisht
    * @description : This method is used to get the metadata.
    */
    public class GetMapMetadata {
        @AuraEnabled
        public Map<string,string> labelAndContentWrapperMap;
    }
    /**
    * @author : Monika Bisht
    * @description : This method is used to get the User details.
    * @return : List<SObJectResult>
    * @param objectName
    * @param fieldName
    * @param value
    */
    @AuraEnabled
    public static List<SObJectResult> transferOwnershipMethod(String objectName, String fieldName, String value){
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        try{
            if(string.isnotblank(value)){
                String sQuery = '';
                string buProfileId = labelToContentMap.get('BUPROFILEID');
                string ctProfileId = labelToContentMap.get('CTPROFILEID');
                sQuery = 'Select Id,Profile.Name,ProfileId,' +fieldName+' FROM '+objectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\' AND (ProfileId =: buProfileId OR ProfileId =: ctProfileId) AND IsActive = True limit 5';
                String sQueryUpdated = sQuery;
                List <user> lstOfRecords = Database.query(sQueryUpdated);
                if(!lstOfRecords.isEmpty()){
                    for(user so : lstOfRecords) {
                        String fieldvalue = (String)so.get(fieldName);
                        String profileData= so.Profile.Name;
                        sObjectResultList.add(new SObjectResult(fieldvalue, so.Id,profileData));
                    }
                }
            }
        }
        catch(Exception ex){
            //log exception
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return sObjectResultList;
    }
    /**
    * @author : Monika Bisht
    * @description : This method is used to get the User details.
    */
    public class SObJectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public string profileName;
        /**
        * @author : Monika Bisht
        * @description : This method is used to get the User details.
        * @param recNameTemp
        * @param recIdTemp
        * @param profileNameTemp
        */
        public SObJectResult(String recNameTemp, Id recIdTemp,string profileNameTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
            profileName = profileNameTemp;
        }
    }
    /**
    * @author : Monika Bisht
    * @description : This method is used to update owner of DL.
    * @param selectedUserName
    * @param distributionId
    * @return : ReturnWrapper
    */
    @AuraEnabled
    public static ReturnWrapper setOwnershipMethod(String selectedUserName, String distributionId){
        ReturnWrapper objWrappper = new ReturnWrapper();
        try{
            if(string.isNotEmpty(selectedUserName)){
                string loginUserProfileName = UserDomain.queryLoggedInUserProfileName();
                objWrappper.currentLoginUserProfile = loginUserProfileName;
                DistributionList__c objDistribution = DistributionDomain.getDistributionById(distributionId);
                if(objDistribution.ownerId != null){
                     objWrappper.currentUserCreatedById = objDistribution.ownerId;
                     objWrappper.currentOwnerName = objDistribution.owner.name;
                }
                if(loginUserProfileName == labelToContentMap.get('PROFILEBUSINESSUNITADMIN')){
                    if(objDistribution.ownerId == UserInfo.getUserId()){
                        user objuser = UserDomain.searchCTorBUAdminUser(selectedUserName);
                        objDistribution.ownerid = objuser.id;
                        update objDistribution;
                    }
                }
                if(loginUserProfileName != labelToContentMap.get('PROFILEBUSINESSUNITADMIN')){
                    user objuser = UserDomain.searchCTorBUAdminUser(selectedUserName);
                    objDistribution.ownerid = objuser.id;
                    update objDistribution;
                }
            }
        }
        catch(Exception ex){
            //log exception
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
        return objWrappper;
    }
     /**
    * @author : Monika Bisht
    * @description : Wrapper class used to pass data 
    */
    Public class ReturnWrapper{
        @AuraEnabled
        Public string currentLoginUserProfile;
        @AuraEnabled
        Public string currentUserCreatedById;
        @AuraEnabled
        Public string currentOwnerName;
    }
}