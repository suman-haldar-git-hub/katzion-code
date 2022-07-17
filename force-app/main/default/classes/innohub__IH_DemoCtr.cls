/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IH_DemoCtr {
    global IH_DemoCtr() {

    }
    @AuraEnabled
    global static List<innohub__Demo_Vote__c> checkAllVotes(List<Id> demos) {
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
    global static innohub__Demo_Scorecard__c firstSubmissionCheck(String theRecordId, User theUser) {
        return null;
    }
    @AuraEnabled
    global static User getCreator(String creatorId) {
        return null;
    }
    @AuraEnabled
    global static innohub__Demo__c getDemo(String recordId) {
        return null;
    }
    @AuraEnabled
    global static List<innohub__Demo__c> getDemos(String selectedFilter, String searchFiltersJSON) {
        return null;
    }
    @AuraEnabled
    global static User getLoggedInUser() {
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
}
