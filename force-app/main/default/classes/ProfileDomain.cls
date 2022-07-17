/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This class is utlity class for all the SOQL for Profile object.
*/
public with sharing class ProfileDomain {
    /**
* @author : Daksh Madan
* @description : This method is used to profile User object records based on profileId.
* @return : Profile
* @param profileId
*/
    public static Profile queryProfileBasedOnId(String profileId){
        return [Select Name from Profile where Id =: profileId];
    }
}