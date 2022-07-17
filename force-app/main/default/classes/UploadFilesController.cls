/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This class is to fetch files and return to the component where we're displaying files.
*/
public with sharing class UploadFilesController {
    
/**
* @author : Akshansh Jain
* @description : This method is used to query ContentVersion to get uploaded file.
* @return : List<ContentVersion>
* @param recordId
*/
@AuraEnabled
public static List<ContentVersion> getAllFiles(List<String> recordId){
    List<ContentVersion> response = new List<ContentVersion>();
    Set<Id> documentIds = new Set<Id>();
    documentIds.addAll((List<Id>)recordId);
    if(!documentIds.isEmpty()){
        response = ContentVersionDomain.getContentVersionList(documentIds);
    }
    return response;
}

    /**
* @author : Praveen Tiwari
* @description : This method is used to query ContentVersion to get uploaded file.
* @return : List<ContentVersion>
* @param recordId
*/
    @AuraEnabled
    public static List<ContentVersion> getFiles(String recordId){
        List<ContentVersion> response = new List<ContentVersion>();
        Set<Id> documentIds = new Set<Id>();
        documentIds.add(recordId);
        if(!documentIds.isEmpty()){
            response = ContentVersionDomain.getContentVersionList(documentIds);
        }
        return response;
    }
    
/**
* @author : Amit Sharma
* @description : This method is used to return list of ContentVersion object based on 
                 passed Case object id.
* @return : List<ContentVersion>
* @param caseRecordId
*/
    @AuraEnabled
    public static List<ContentVersion> getFilesData(String caseRecordId){
         Set<Id> documentIds = new Set<Id>();
         List<ContentVersion> lstContentVersion = new List<ContentVersion>();
         for(ContentDocumentLink cdLink : ContentDocumentLinkDomain.getContentDocLinks(caseRecordId)){
            documentIds.add(cdLink.ContentDocumentId);
         }
         if(!documentIds.isEmpty()){
            lstContentVersion = ContentVersionDomain.getContentVersionList(documentIds);
         }
         
         return lstContentVersion;
    }
    
    /**
* @author : Amit Sharma
* @description : This method is used to return list of ContentVersion object based on 
*                passed Case object id and current user
* @return : List<ContentVersion>
* @param caseRecordId
*/
    @AuraEnabled
    public static List<ContentVersion> getFilesDataCurrentUser(String caseRecordId){
         Set<Id> documentIds = new Set<Id>();
         List<ContentVersion> lstContentVersion = new List<ContentVersion>();
         for(ContentDocumentLink cdLink : ContentDocumentLinkDomain.getContentDocLinks(caseRecordId)){
            documentIds.add(cdLink.ContentDocumentId);
         }
         if(!documentIds.isEmpty()){
            lstContentVersion = ContentVersionDomain.getContentVersionOfCurrentUse(
                                documentIds, UserInfo.getUserId());
         }
         
         return lstContentVersion;
    }
    
    /**
* @author : Amit Sharma
* @description : This method is used to return wrapper of content for all Case Approved 
* @return : wrapper<String,String>
* @param caseCurrentStage
*/
    @AuraEnabled
    public static List<CommunityContentInfo__mdt> getContentFromMetadata(String caseCurrentStage){
         
        List<CommunityContentInfo__mdt> lstCustomSetting = new List<CommunityContentInfo__mdt>();
        Set<String> setDeveloperName = new Set<String> {'SSPending','SSApproved','SSRejected'};
         
        for(CommunityContentInfo__mdt commContentInfo : 
                                                  CommunityContentInfoDomain.queryCommContentInfo(
                                                                setDeveloperName)){
            if(caseCurrentStage == 'Pending' && commContentInfo.DeveloperName == 'SSPending'){
                lstCustomSetting.add(commContentInfo);
                
            }else if(caseCurrentStage == 'Approved' && commContentInfo.DeveloperName == 'SSApproved'){
                lstCustomSetting.add(commContentInfo); 
            }
            else if(caseCurrentStage == 'Rejected' && commContentInfo.DeveloperName == 'SSRejected'){
                lstCustomSetting.add(commContentInfo);
            }
        }       
        
        return lstCustomSetting;
    }
    /**
    * @author : Amit Sharma
    * @description : This method is used to query Account object and related case object based on 
      logged in user.
    * @return : Boolean
    */
    @AuraEnabled
    public static Boolean isSubmitNewApplicationVisible(){
        Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
        Integer relatedCaseSize = Integer.ValueOf(labelToContentMap.get('TransactionCaseSize'));
        
        User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        List<Account> acctList = new List<Account>();
        if(String.isNotBlank(userDetail.EmployeeID__c)){
            acctList = AccountDomain.queryAccountWithTransactionCase(userDetail.EmployeeID__c);
        }
        if(!acctList.isEmpty() && !acctList[0].Cases.isEmpty() && 
                                                  acctList[0].Cases.size() >= relatedCaseSize){
            return false;
        }
        return true;
        
    }
}