/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IH_UserVoiceCtr {
    global IH_UserVoiceCtr() {

    }
    @AuraEnabled
    global static User getCreator(String creatorId) {
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
    global static innohub__User_Voice__c getUserVoice(String recordId) {
        return null;
    }
    @AuraEnabled
    global static List<innohub__User_Voice__c> getUserVoices(String selectedFilter, String searchFiltersJSON) {
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
