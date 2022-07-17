/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This is an Adapter Class for MultiselectCaseFilesController Class.
*/
public inherited sharing class MultiselectCaseFilesAdapter {
    
    /**
     * @author : Sumit Banarji
     * @param caseIds
     * @param recordId
     * @return List
     * @description : This method is query files
    */
    public static List<ContentDoc> getFiles(Set<String> caseIds, String recordId) {
        
        if(caseIds.size() > 0 && recordId != Null) {
            set<Id> caseContentDocId = new set<Id>();
            //Get content documents related to the record
            for (ContentDocumentLink linkEntity : ContentDocumentLinkDomain.getContentDocLinks(recordId)){
                caseContentDocId.add(linkEntity.ContentDocumentId);
            }

            map<Id, String> caseMap = new map<Id, String>();
            //Creating Case Detail Map
            for(Case cs : CaseDomain.queryCases(caseIds)){
                caseMap.put(cs.Id, cs.CaseNumber);
            }

            List<ContentDoc> contentDocs = new List<ContentDoc>();
            //Creating Content Document wrapper
            for (ContentDocumentLink linkEntity :ContentDocumentLinkDomain.queryRelatedContentDocumentLink(caseIds, caseContentDocId)) {
                
                ContentDoc conDoc = new ContentDoc();
                conDoc.id = linkEntity.Id;
                conDoc.caseNumber = caseMap.get(linkEntity.LinkedEntityId);
                conDoc.caseId = linkEntity.LinkedEntityId; 
                conDoc.fileId = linkEntity.ContentDocumentId;                   
                conDoc.title = linkEntity.ContentDocument.LatestPublishedVersion.Title;
                
                contentDocs.add(conDoc);
            }

            //Returning Content Document Wrapper
            return contentDocs;
        }
        else {
            //Returning Empty Wrapper
            return new List<ContentDoc>();
        }
    }

    /**
     * @author : Sumit Banarji
     * @param contentDocIds
     * @param caseId
     * @description : This method is used create Content Document Link
    */
    public static void saveFiles(set<String> contentDocIds, String caseId) {
        
        if(contentDocIds.size() > 0 && caseId != NUll){
            List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
            //Creating content document links
            for(String conDocId : contentDocIds) {
                contentDocumentLinks.add(new ContentDocumentLink(LinkedEntityId = caseId, ContentDocumentId = conDocId));
            }

            //Calling Domain Class to Insert Content Docuemnts
            ContentDocumentLinkDomain.insertContentDocumentLink(contentDocumentLinks);
        }
    }

    /**
     * @author : Sumit Banarji
     * @description : This is wrapper class for Content Document to be shown LWC
    */
    public class ContentDoc {
        public String id;
        public String caseNumber;
        public String caseId;
        public String fileId;
        public String title;
    }
}