/*
@author : Praveen Tiwari
@company : Cognizant
@description : This is test data builder class for ContentDocumentLink.
*/
@isTest
public class ContentDocumentLinkTestData {
/**
* @author : Praveen Tiwari
* @description : This will create the ContentDocumentLink data.
* @return : List<ContentDocumentLink>
* @param count
* @param linkedEnityId
* @param docId
*/
    public static List<ContentDocumentLink> create(Integer count, String linkedEnityId, String docId) {
        // List Intilization
        List<ContentDocumentLink> contentVersionLinkList = new List<ContentDocumentLink>();
        for (Integer i = 0; i < count; i++) {
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = linkedEnityId; 
            contentlink.ContentDocumentId = docId;
            contentlink.Visibility = 'AllUsers';
            contentVersionLinkList.add(contentlink);
        }
        return contentVersionLinkList;
    }
}