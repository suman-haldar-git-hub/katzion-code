/**
 * @author      Abhishek Setia
 * @description Handles logic related to Object 'UniversalTaskList__c'
 */
public with sharing class UniversalTaskListFilterService {

    /**
    * @author       Abhishek Setia
    * @description  Return UniversalTaskList for logged in User
    * @return       lstTask
    * @param        paramsMap
    * @param        setOfStatus
    */
    public static List<UniversalTaskList__c> filterRecordsOnSearch(
        Map<String, String> paramsMap,
        Set<String> setOfStatus){
        
            List<UniversalTaskList__c> utlRecordList = UniversalTaskListDomain.getLoggedInUserTask(paramsMap,setOfStatus);        
            String keyword = (paramsMap.containsKey('keyword'))?paramsMap.get('keyword'):'';
            String filterType = paramsMap.get('filterType');
            if(String.isNotBlank(keyword) && String.isNotBlank(filterType)){
                List<UniversalTaskList__c> newUtlRecordList=new List<UniversalTaskList__c>();            
                for(UniversalTaskList__c utl:utlRecordList){
                    if(criteriaOnFilter(utl,paramsMap)){
                        newUtlRecordList.add(utl);
                    }
                }
                return newUtlRecordList;                                
            }   
            return utlRecordList;     
    }


    /**
    * @author       Abhishek Setia
    * @description  Conditions on filter of record UniversalTaskList__c for 
                    ActionCentre - My Tasks, My Approvals, Archive tab.
                    Only called within method - filterRecordsOnSearch
    * @return       Boolean
    * @param        utl
    * @param        paramsMap
    */
    private static Boolean criteriaOnFilter(UniversalTaskList__c utl,Map<String, String> paramsMap){
        String keyword = paramsMap.get('keyword');
        String filterType = paramsMap.get('filterType');
        if((String.isNotBlank(utl.SubmittedForAccount__r.Name) && utl.SubmittedForAccount__r.Name.containsIgnoreCase(keyword))||
            (String.isNotBlank(utl.Title__c) && utl.Title__c.containsIgnoreCase(keyword))||
            (filterType=='Archive' && String.isNotBlank(utl.OriginatingSystem__c) &&
            utl.OriginatingSystem__c.containsIgnoreCase(keyword))){
                return true;
            }else{
                return false;
            }

    }
    
}