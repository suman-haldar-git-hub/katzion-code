/**
* @Author : Praveen Tiwari
* @Company : Cognizant
* @description : This class is utlity class for all the SOQL for Contact object.
*/
public with sharing class ContactDomain {
/**
* @Author :Praveen Tiwari
* @description :This method is used to query Contact object based on passed record id.
* @return Contact
* @param contactId
*/
    public static Contact queryContactBasedOnId(Id contactId){
        return [Select Id, Name From Contact Where Id =:contactId];
    }
}