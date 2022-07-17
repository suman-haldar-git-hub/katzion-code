/**
* @author: Praveen Tiwari
* @company:SaaSFocus
* @since: 08-10-2021
* @description : helper class of CommonFlowComponentService class
*/
public inherited sharing class CommonFlowComponentServiceHelper {
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Praveen Tiwari
    * @company : SaaSFocus A Cognizant Company
    * @description : This method is used to check if application window is open or not.
    * @return  Boolean
    */
    public static Boolean checkMyIncentiveApplicationWindow(){
        Boolean isOpen = false;
        List<Form__c> formLst = new List<Form__c>();
        Set<String> formTab = new Set<String>();
        formTab.add(labelToContentMap.get('FORMTABMYINCENTIVE'));
        formLst = FormDomain.getFormBasedOnFormTab(formTab);
        if(!formLst.isEmpty() && formLst[0].StartDate__c != null && formLst[0].EndDate__c != null){
            formLst[0] = SalarySacrificeContainerService.checkApplicationWindow(formLst[0]);
            isOpen = formLst[0].Active__c;
        }
        return isOpen;
    }
    /**
    * @author : Praveen Tiwari
    * @company : SaaSFocus A Cognizant Company
    * @description : This method is used to check if purchase leave window is open or not.
    * @return Boolean
    */
    public static Boolean checkPurchaseLeaveWindow(){
        Boolean isEligible = true;
        Date todayDate = System.today();
        String[] getDateComparedFromLabel
            = labelToContentMap.get('PURCHASELEAVEVISIBILITYDATECOMPAREDFROM').split('/');
        String[] getDateComparedToLabel
            = labelToContentMap.get('PURCHASELEAVEVISIBILITYDATECOMPAREDTO').split('/');
        Date fromDate = Date.newInstance(
            todayDate.year(),
            Integer.valueOf(getDateComparedFromLabel[1]),
            Integer.valueOf(getDateComparedFromLabel[0])
        );
        Date toDate = Date.newInstance(
            todayDate.year(),
            Integer.valueOf(getDateComparedToLabel[1]),
            Integer.valueOf(getDateComparedToLabel[0])
        );
        //check if today's date is between the application close window
        //If yes then user is not eligible to apply
        if(todayDate >= fromDate && todayDate <= toDate){
            isEligible = false;
        }
        return isEligible;
    }
}