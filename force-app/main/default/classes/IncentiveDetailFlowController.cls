/**
* @author : Amit Sharma
* @company : Cognizant
* @description  This class is used as a controller class for incentive
  detail screen
*/
public with sharing class IncentiveDetailFlowController {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return list of custom metadata 
    * @return : List<CommunityContentInfo__mdt>
    * @param caseCurrentStage - use to get current case approval status
    * @param isModifyApplication - true/false
    */
    @AuraEnabled
    public static List<CommunityContentInfo__mdt> getContentFromMetadata (
                                                        String caseCurrentStage, 
                                                      Boolean isModifyApplication){
        
        List<CommunityContentInfo__mdt> lstObjCommContentInfo = 
                                            new List<CommunityContentInfo__mdt>();                                                
        Set<String> setDeveloperName = new Set<String> {'INCENTIVESUBMITTED',
                        'INCENTIVERECEIVED'};
        String formEndDateValue = getFormEndDate();
        
        for(CommunityContentInfo__mdt objCustomMetadata : 
                            CommunityContentInfoDomain.queryCommContentInfo(setDeveloperName)){                                             
            if(isModifyApplication(caseCurrentStage,isModifyApplication,objCustomMetadata)){
                String contentValue = objCustomMetadata.Content__c; 
                String str = contentValue.replace('formEndDate', formEndDateValue);
                objCustomMetadata.Content__c = str;  
                lstObjCommContentInfo.add(objCustomMetadata);
            }
            else if(caseCurrentStage == 'Pending' && !isModifyApplication &&
                            objCustomMetadata.DeveloperName == 'INCENTIVERECEIVED'){
                lstObjCommContentInfo.add(objCustomMetadata);
            }
            else if(caseCurrentStage == 'Approved' && 
                            objCustomMetadata.DeveloperName == 'INCENTIVERECEIVED'){
                lstObjCommContentInfo.add(objCustomMetadata);
            }
            
        } 
        return lstObjCommContentInfo;
    }
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return true/false
    * @return : Boolean - true/false
    * @param caseCurrentStage
    * @param isModifyApplication
    * @param objCustomMetadata
    */
    public static Boolean isModifyApplication(String caseCurrentStage, 
                    Boolean isModifyApplication, CommunityContentInfo__mdt objCustomMetadata){
        Boolean isValidToModify = false;
        if(caseCurrentStage == 'Pending' && isModifyApplication && 
                         objCustomMetadata.DeveloperName == 'INCENTIVESUBMITTED'){
            isValidToModify = true;
        }
        return isValidToModify ;
    }
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return string of date format
    * @return : String
    */
    public Static String getFormEndDate(){
        String formEndDateValue = '';
        List<Form__c> formLst = new List<Form__c>();
        Set<String> formTab = new Set<String>();
        formTab.add(labelToContentMap.get('FORMTABMYINCENTIVE'));
        formLst = FormDomain.getFormBasedOnFormTab(formTab);
        if(!formLst.isEmpty() && formLst[0].EndDate__c != null){
            DateTime myDateTime = formLst[0].EndDate__c;
            String daySuffix = getDayOfMonthSuffix(formLst[0].EndDate__c.day());
            formEndDateValue = myDateTime.format('d')+daySuffix + ' '+
                            myDateTime.format('MMM')+ ' '+
                                myDateTime.format('yyyy');
        }
        return formEndDateValue;
    }
    
    /** 
    * @author : Amit Sharma
    * @description : This method is used to return day of month suffix 
    * @return : String
    * @param n - day integer value
    */
    public Static String getDayOfMonthSuffix(Integer n) {
        if (n == null) {
            return '';
        }

        if (n >= 11 && n <= 13) {
            return 'th';
        }

        Integer modResult = Math.mod(n, 10);        
        if (modResult == 1) { 
            return 'st'; 
        } else if (modResult == 2) { 
            return 'nd'; 
        } else if (modResult == 3) { 
            return 'rd'; 
        } else { 
            return 'th';
        }
    }
}