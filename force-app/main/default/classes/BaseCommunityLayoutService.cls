/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is the controller class of BaseCommunityLayout component
*/
public with sharing class BaseCommunityLayoutService {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This inner class will make the wrapper of requested data on load.
*/
    public class VerticalMgmtWrapper {
        Boolean showLeaveTab;
        Boolean showTaskTab = false;
        Boolean showWalkme = false;
        Boolean showPatDesktop = false;
        Boolean showPatMobile = false;
        Id accountId;
        Map<String,String> labelAndContentWrapperMap;
        Map<String, Map<Integer, Walkthrough__mdt>> walkthroughMap;
        String walkthroughCompleted = '';
    }
    /**
* @author : Daksh
* @description : This method is used to fetch all the required data on load.
* @return : LightningResponse
*/
    public static LightningResponse getVerticalMgmtWrapperData(){
        LightningResponse response = new LightningResponse();
        try{
            VerticalMgmtWrapper dataWrapper = new VerticalMgmtWrapper();
            Map<String, FeatureControl__mdt> masterLabelToFeatureControlRecord =
                FeatureControlService.getFeatureControlRecord(
                    new Set<String> { labelToContentMap.get('FEATURECONTROLTASKTAB'),
                    'EnableWalkme', 'EnableLeaveTab', 'EnablePATMobile','EnablePATDesktop'
            });
            dataWrapper.showTaskTab = masterLabelToFeatureControlRecord.get(
                labelToContentMap.get('FEATURECONTROLTASKTAB')
            ).Active__c;
            Boolean isEnabledWalkme = masterLabelToFeatureControlRecord.get(
                    'EnableWalkme'
            ).Active__c;
            Boolean isEnabledPatMobile = masterLabelToFeatureControlRecord.get(
                    'EnablePATMobile'
            ).Active__c;
            Boolean isEnabledPatDesktop = masterLabelToFeatureControlRecord.get(
                    'EnablePATDesktop'
            ).Active__c;
            Boolean isEnableLeaveTab = masterLabelToFeatureControlRecord.get(
                'EnableLeaveTab'
            ).Active__c;
            User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
            List<Account> acctList = new List<Account>();
            if(String.isNotBlank(userDetail.EmployeeID__c)){
                acctList = AccountDomain.queryAcctFromEmpId(userDetail.EmployeeID__c);
            }
            if(!isEnableLeaveTab){
                dataWrapper.showLeaveTab = isEnableLeaveTab;
            }
            else{
                if(!acctList.isEmpty()){
                    dataWrapper.showLeaveTab = checkSalariedOrContractorAcct(acctList[0]);
                }
            }
            // Added by Ankit on 26-11-2020 for TH-2137
            dataWrapper.showWalkme = isEnabledWalkme;
            dataWrapper.showPatMobile = isEnabledPatMobile;
            dataWrapper.showPatDesktop = isEnabledPatDesktop;
            dataWrapper.walkthroughCompleted = userDetail.WalkThroughCompleted__c;
            dataWrapper.labelAndContentWrapperMap = labelToContentMap;
            dataWrapper.walkthroughMap = FeatureControlService.getWalkthroughRecord();
            response.payLoad = JSON.serialize(dataWrapper);
        }
        catch(Exception ex){
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent('VerticalNavigationController.cls on Load',ex);
        }
        return response;
    }
    /**
* @author : Daksh
* @description : This method check whether the Employee Group of Account is Salaried/Contractor.
* @return : Boolean
* @param  acctRecd
*/
    @TestVisible
    private static Boolean checkSalariedOrContractorAcct(Account acctRecd){
        List<String> salariedEmp = (labelToContentMap.get('SALARIEDEMPLOYEE')).split(',');
        List<String> contractorEmp = (labelToContentMap.get('CONTRACTOREMPLOYEE')).split(',');
        String acctEmpGroup = acctRecd.Employee_Class__c;
        if(salariedEmp.contains(acctEmpGroup)){
            return true;
        }
        else if(contractorEmp.contains(acctEmpGroup)){
            return checkSalariedDirectReportToUser(acctRecd.Employee_ID__c,salariedEmp);
        }
        else{
            return false;
        }
    }
    /**
* @author : Daksh
* @description : This method is check whether contractor is with at least one salaried direct reports.
* @return : Boolean
* @param  empId
* @param  salariedEmp
*/
    public static Boolean checkSalariedDirectReportToUser
        (String empId,List<String> salariedEmp){
            if(String.isNotBlank(empId)){
                if(AccountDomain.queryAcctListFromEmpId(empId,salariedEmp).isEmpty()){
                    return false;
                }
                else{
                    return true;
                }
            }
            else{
                return false;
            }
        }

    /**
     * @author      Abhishek Setia
     * @description Generate JWT token used in ChatBot
     * @param       formFactor
     * @return      String
     */    
    public static String getJWTTokenService(String formFactor){    
        try{
            User usr = UserDomain.queryUserBasedOnId(UserInfo.getUserId());        
            String uniqTeamhubIdentifier=(formFactor==labelToContentMap.get('FORM_FACTOR_DESKTOP'))?
                labelToContentMap.get('UNIQUE_TEAMHUB_IDENTIFIER_DESKTOP'):
                (formFactor==labelToContentMap.get('FORM_FACTOR_PHONE'))?
                labelToContentMap.get('UNIQUE_TEAMHUB_IDENTIFIER_MOBILE'):'';        
            if(String.isNotBlank(usr.EmployeeID__c) && String.isNotBlank(uniqTeamhubIdentifier)){
                Auth.JWT jwt = new Auth.JWT();
                jwt.setSub(usr.EmployeeID__c); 
                jwt.setIss(uniqTeamhubIdentifier);                    
                //Additional claims to set scope
                Map<String, Object> claims = new Map<String, Object>();
                claims.put('alg', 'HS256');                        
                jwt.setAdditionalClaims(claims);
                //Create the object that signs the JWT bearer token
                Auth.JWS jws = new Auth.JWS(jwt, 
                    labelToContentMap.get('PAT_CERT_DEVNAME'));                    
                //Get the resulting JWS in case debugging is required
                return jws.getCompactSerialization();
            }
            return null;
        }catch(Exception ex){
            return null;
        }    
        
    }    
}