/**
* @author : Anubha Billore
* @company : Cognizant
* @description : This class is utility class for all SOQL and DMLs for Communication object
*/
public inherited sharing class CommunicationDomain {
/**
* @author : Anubha Billore
* @description : This method is used to query Communication object based on passed record id.
* @return : List<Communication__c>
* @param campaignIds
*/
    public static List<Communication__c> getCommunicationRecords(Set<Id> campaignIds) {
        return [
            SELECT Id, Campaign__c, Active__c , ScheduledDate__c
            FROM Communication__c
            WHERE Campaign__c IN:campaignIds
            AND Active__c = true
            AND ScheduledDate__c >: system.now()
        ];
    }
    /**
* @author : Monika Bisht
* @description : This method is used to query Communication object based on passed record id.
* @return : List<Communication__c>
* @param recordId
*/
    public static List<Communication__c> getInActiveCommunicationByRecordId(Id recordId) {
        return
        [
                SELECT id, Active__c, Campaign__c, ReasonofCancellation__c, ScheduledDate__c,
                Type__c,
                (
                        SELECT id FROM Audiences__r
                ),
                (
                        SELECT id FROM Communications__r
                )
                FROM Communication__c
                WHERE id =: recordId
                AND Active__c = false
                AND ReasonofCancellation__c != null
        ];
    }

    /**
    * @author : Monika Bisht
    * @description : This method is used to get Communication record and their related child Audiences.
    * @return : List<Communication__c>
    * @param commId
    */
    public static List<Communication__c> getCommunicationWithAudiences(String commId){
        return
        [
                SELECT id,Campaign__c,Campaign__r.id,Campaign__r.name, Campaign__r.TemplateCode__c,
                ScheduledDate__c,Active__c,ReasonofCancellation__c,Type__c, ActionURL__c,
                Description__c, Status__c, SystemToAction__c, TaskDescription__c, TaskDueDate__c,
                TaskTitle__c, OriginatingSystem__c, Campaign__r.CommunicationSubject__c,
                (
                        SELECT id,Contact__c,DistributionList__c,Contact__r.id,Contact__r.name,
                        DistributionList__r.id,DistributionList__r.name
                        FROM Audiences__r
                )
                FROM Communication__c
                WHERE id =: commId
        ];
    }
    /**
* @author : Monika Bisht
* @description : This method is used to get Communication record based on id.
* @return : Communication__c
* @param commId
*/
    public static Communication__c getCommunicationRecordById(String commId){
        return [SELECT Id, Active__c, Campaign__c, Campaign__r.CampaignCode__c, ReasonofCancellation__c,Name
                FROM Communication__c
                WHERE Id =: commId];
    }
    /**
* @author : Daksh Madan
* @description : This method is used to insert Communication__c Record.
* @param commRecd
* @param operation
*/
    public static void dmlOnCommunicationRecd(Communication__c commRecd,String operation){
        if(operation.equalsIgnoreCase('insert')){
            insert commRecd;
        }
        else if(operation.equalsIgnoreCase('update')){
            update commRecd;
        }
    }
    /**
* @author : Monika Bisht
* @description : This method is used to get Communication record for custom report.
* @return : list<Communication__c>
*/
    public static list<Communication__c> getCommunicationForReport(){
        
        // Modifier - @Nadeem Shaikh
        // ToDo: Change the Campaign__r.Code != 'UTL NOTIF' check to custom label of custom metadata reference based on the existing usage
        return [SELECT id,CreatedDate,Campaign__c,Campaign__r.Name,Campaign__r.CampaignCode__c,Campaign__r.id,Campaign__r.CreatedBy.name,Status__c,  
              (SELECT id,Contact__c,DistributionList__c,Contact__r.id,Contact__r.name,
               DistributionList__r.id,DistributionList__r.name FROM Audiences__r)  
               FROM Communication__c 
               WHERE Campaign__c != null AND Campaign__r.Parent.CampaignCode__c != 'UTL NOTIF'
               ORDER BY CreatedDate DESC limit 5];
    }

    /**
    * @author : Ankit Singh
    * @description : This method is used get child communication record
    * @param communicationId
    * @return : list<Communication__c>
    */
    public static List<Communication__c> getChildCommunication(String communicationId) {
        return [
                SELECT id, ParentCommunication__c
                FROM Communication__c
                WHERE ParentCommunication__c =:communicationId
        ];
    }
    /**
    * @author : Sunil
    * @description : This method is used to get Communication record based on Id.
    * @return : List<Communication__c>
    * @param commId
    */
    public static List<Communication__c> getCommunicationForBatch(String commId){
        return
        [
                SELECT id, Name, AssigneeEmployeeId__c, TaskTitle__c,
                TaskDueDate__c, OriginatingSystem__c, SystemToAction__c,
                TaskDescription__c, ActionURL__c
                FROM Communication__c
                WHERE id =: commId
        ];
    }
}