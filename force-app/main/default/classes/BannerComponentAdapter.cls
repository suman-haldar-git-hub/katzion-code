/**
* @Author : Monika Bisht
* @Company : Cognizant
* @description : This class will be used to show and hide banner.
*/
public inherited sharing class BannerComponentAdapter{
    /**
     * @author : Monika Bisht
     * @description : getAlertFlag 
     * @return : Boolean
     * @param recordIds  
     */
    public static boolean getAlertFlag(set<string> recordIds) {
        list<case> objCase = CaseDomain.queryCases(recordIds);
        List<BannerMaster__mdt> listBannerMaster = BannerMaster__mdt.getall().values();
        boolean checkUserFlag = false;
        Set<string> setQueueRoleName = new Set<String>();
        Set<string> setCaseOwnerId = new Set<String>();
        setCaseOwnerId.add(objCase[0].ownerid);
        for(BannerMaster__mdt objBannerMaster : listBannerMaster){
            if(!objCase.isEmpty() && objCase[0].owner.name == objBannerMaster.Queues__c 
               && objBannerMaster.Active__c == True){
               return true;
            }
            if(objBannerMaster.Active__c == True && objBannerMaster.Roles__c != null){
                setQueueRoleName.addall(objBannerMaster.Roles__c.split(','));
            }
        }
        if(checkObjectName(objCase[0].ownerid) == 'User' && setQueueRoleName.size() > 0){
            checkUserFlag = checkUser(setCaseOwnerId,setQueueRoleName);  
        }
        return checkUserFlag;
    } 
    /**
     * @author : Monika Bisht
     * @description : checkUser 
     * @return : Boolean
     * @param setOwnerId  
     * @param setRoleName  
     */
    Public static boolean checkUser(set<String> setOwnerId,set<string> setRoleName){
        list<User>lstusers =  UserDomain.getUserBasedOnRoles(setOwnerId,setRoleName);
        if(lstusers.size()>0){
            return true;
        }
        return false;
    }
    /**
     * @author : Monika Bisht
     * @description : checkObjectName 
     * @return : SobjectName
     * @param myId   
     */
    Public static string checkObjectName(id myId){
        return myId.getSObjectType().getDescribe().getName();
    }
}