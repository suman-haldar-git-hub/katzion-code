/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test data builder class for Contact object.
*/
@isTest
public class ContactTestData {
    /**
* @author : Daksh Madan
* @company : Cognizant
* @description : This will create the contact records.
* @return : List<Contact>
* @param count
* @param accountId
*/
    public static List<Contact> createContactRecords(Integer count,Id accountId){
        // List Intilization
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            Contact singleRecord = new Contact();
            singleRecord.LastName = 'Contact Test Date '+i;
            singleRecord.AccountId = accountId;
            contactList.add(singleRecord);
        }
        return contactList;
    }
}