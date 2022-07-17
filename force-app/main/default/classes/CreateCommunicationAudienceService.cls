/**
* @Author :Sunil
* @Company :Cognizant
* @description :This is the batch class to create Campaign Member record from Communication and Audience record.
*/
public inherited sharing class CreateCommunicationAudienceService {
    /**
    * @Author : Sunil
    * @description : This method will create the collections data.
    * @param strValue
    * @param setValue
    * @param mapPicklist
    * @return set<string>
    */
    public static Set<String> createCollectionData(String strValue,
            Set<String> setValue,Map<String, String> mapPicklist){
        if(string.isNotEmpty(strValue)){
            for(String s : strValue.split(';')){
                if(mapPicklist!=null && mapPicklist.containsKey(s)){
                    setValue.add(mapPicklist.get(s));
                }
                else
                {
                    setValue.add(s);
                }
            }
        }
        return setValue;
    }

    /**
    * @Author : Sunil
    * @description : This method will create the collections data.
    * @param strValue
    * @param includesParam
    * @param mapPicklist
    * @return string
    */
    public static String createCollectionData(
        String strValue,
        String includesParam,
        Map<String, String> mapPicklist
        ) {
            if(string.isNotEmpty(strValue)){
                for(String s : strValue.split(';')){
                    if(mapPicklist!=null && mapPicklist.containsKey(s)){
                        includesParam += '\'' + s +'\',';
                    }
                }
            }
            includesParam = includesParam.removeEnd(',');
            return includesParam;
    }

     /**
    * @Author : Sunil
    * @description : This method will creates Map of employee Id and User and return to CreateCommunicationAudienceBatch.
    * @return Map<String, String>
    */
    public static Map<String, String> createPicklistMap(){
        Map<String, String> mapPicklist = new Map<String, String>();
        List<String> fieldApiList = (Label.FIELDAPIVALUESOFOBJECTFIELD).split(',');
        //getting records of Object_Field__c object.
        Map<Id,Object_Field__c> objectFieldMap = 
        ObjectFieldDomain.getMapOfObjectFieldRecords(fieldApiList, 'DistributionList__c');
        //getting records of Picklist_Field_Value__c object.
        Map<Id, Picklist_Field_Value__c> picklistFieldValueMap = 
        PicklistFieldValueDomain.getMapOfPicklistFieldValueRecords(objectFieldMap.keySet());
        
        For(Picklist_Field_Value__c obj : picklistFieldValueMap.values()){
                if(obj.Object_Field__r.Field_API__c == 'OpsSupport__c' 
                || 
                obj.Object_Field__r.Field_API__c == 'Area__c'){
                    mapPicklist.put(obj.PrimaryUniqueKey__c , obj.Web_Value__c);
                }
                else{
                     mapPicklist.put(obj.PrimaryUniqueKey__c , obj.Picklist_Field_Value__c);
                }
                
                
            }
            System.debug('mapPicklist---'+mapPicklist);
    return mapPicklist;
    }
}