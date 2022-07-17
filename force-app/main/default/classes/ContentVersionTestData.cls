/*
@author : Praveen Tiwari
@company : Cognizant
@description : This is test data builder class for ContentVersion.
*/
@isTest
public class ContentVersionTestData {
/**
* @author : Praveen Tiwari
* @description : This will create the ContentVersion data.
* @return : List<ContentVersion>
* @param count
*/
    public static List<ContentVersion> create(Integer count) {
        // List Intilization
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        for (Integer i = 0; i < count; i++) {
            ContentVersion contentVersionInsert = new ContentVersion(
                Title = 'Test'+i,
                PathOnClient = 'Test.jpg',
                VersionData = Blob.valueOf('Test Content Data'+i),
                IsMajorVersion = true
            );
            contentVersionList.add(contentVersionInsert);
        }
        return contentVersionList;
    }
}