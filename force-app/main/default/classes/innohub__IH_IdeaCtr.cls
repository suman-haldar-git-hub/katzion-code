/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IH_IdeaCtr {
    global IH_IdeaCtr() {

    }
    @AuraEnabled
    global static List<innohub__Innovation_Idea_Vote__c> checkAllVotes(List<Id> ideas) {
        return null;
    }
    @AuraEnabled
    global static Boolean checkVote(Id recordId) {
        return null;
    }
    @AuraEnabled
    global static Boolean downvote(Id recordId) {
        return null;
    }
    @AuraEnabled
    global static User getCreator(String creatorId) {
        return null;
    }
    @AuraEnabled
    global static innohub__Innovation_Idea__c getIdea(String recordId) {
        return null;
    }
    @AuraEnabled
    global static List<innohub.IH_IdeaCtr.myRecordTypeStructure> getIdeaRecordTypesButton() {
        return null;
    }
    @AuraEnabled
    global static List<innohub__Innovation_Idea__c> getIdeas(String selectedFilter, String searchFiltersJSON, String customField, String userField) {
        return null;
    }
    @AuraEnabled
    global static innohub__Innovation_Idea__c getLatestIdea() {
        return null;
    }
    @AuraEnabled
    global static Boolean getLoggedInUser(Id recordId, User theUser) {
        return null;
    }
    @AuraEnabled
    global static String getPicklistLabel(String picklistAPIName) {
        return null;
    }
    @AuraEnabled
    global static List<String> getPicklistValues(String picklistAPIName) {
        return null;
    }
    @AuraEnabled
    global static Double getPoints(String recordId) {
        return null;
    }
    @AuraEnabled
    global static String getRecordTypeName(String recordTypeId) {
        return null;
    }
    @AuraEnabled
    global static Map<String,String> getRecordTypeRadio() {
        return null;
    }
    @AuraEnabled
    global static String isApproved(String recordId) {
        return null;
    }
    @AuraEnabled
    global static Boolean upvote(Id recordId) {
        return null;
    }
global class Filter {
    global String filterName {
        get;
        set;
    }
    global List<String> selectedFilters {
        get;
        set;
    }
    global Filter() {

    }
}
global class ideaWrapper {
    global List<innohub__Innovation_Idea__c> ideas {
        get;
        set;
    }
    global List<Group> ownerQueues {
        get;
        set;
    }
    global List<User> ownerUsers {
        get;
        set;
    }
    global ideaWrapper() {

    }
}
global class myRecordTypeStructure {
    global String myRecordTypeDescription {
        get;
        set;
    }
    global Id myRecordTypeId {
        get;
        set;
    }
    global String myRecordTypeLabel {
        get;
        set;
    }
    global myRecordTypeStructure(Id myId, String myLabel, String myDescription) {

    }
}
}
