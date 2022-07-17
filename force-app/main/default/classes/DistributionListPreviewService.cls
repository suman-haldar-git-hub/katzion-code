/**
* @author : Sunil
* @company : SaaSFocus A Cognizant Company
* @description : This is the service class of DistributionListPreview component
*/
public with sharing class DistributionListPreviewService {
    static Map<String, String> mapPicklist = 
    CreateCommunicationAudienceService.createPicklistMap();
    /**
    * @author : Sunil
    * @description : This method is used to DistributionList__c data on load.
    * @return LightningResponse
    * @param recordId
    */
    @AuraEnabled
    public static LightningResponse generateReport(String recordId) {
        String dlAccountMapping = 
        FeatureControlDomain.getFeatureControlRecord('DLACCOUNTMAPPING').Content__c;
        List<wrapper> lstWrapper = new List<wrapper>();
        String query = 'SELECT ';
        for(String s : dlAccountMapping.split(';')){
            if(s.split(':') != NULL){
                query += s.split(':')[0]+',';
            }
        }
        query = query.removeEnd(',');
        query += ' FROM DistributionList__c WHERE Id=\''+recordId+'\'';
        System.debug('query'+query);
        DistributionList__c  objDL = DistributionDomain.getDistributionRecordById(query);
        if(objDL != NULL){
            for(String s : dlAccountMapping.split(';')){
                string t='';
                if(objDL.get(s.split(':')[0]) !=null){
                for(String u : String.valueOf(objDL.get(s.split(':')[0])).split(';'))
                {
                    if(mapPicklist.containskey(u)){
                        t += mapPicklist.get(u)+',';
                    }
                    
                }
                }
                if(string.isNotEmpty(t)){
                t = t.removeEnd(',');
                lstWrapper.add(new wrapper(s.split(':')[1],
                s.split(':').size()>2?s.split(':')[2]:'equals',t));
                }
            }
        }
        string reportURL = 
            FeatureControlDomain.getFeatureControlRecord('DLPREVIEWREPORTURL').Content__c+
            EncodingUtil.urlEncode(Json.serialize(lstWrapper), 'UTF-8');
        LightningResponse response = new LightningResponse();
        response.payload = reportURL;
        return response;
    }
    /**
    * @author : Sunil
    * @company : SaaSFocus A Cognizant Company
    * @description : This is the wrapper class of report filters.
    */
    public class Wrapper{
        public String column;
        public String operator;
        public String value;
        /**
        * @author : Sunil
        * @description : This method is the constructor of wrapper class.
        * @param col
        * @param opr
        * @param val
        */
        public wrapper(String col, String opr, String val){
            this.column = col;
            this.operator = opr;
            this.value = val;
        }
    }
    
    
}