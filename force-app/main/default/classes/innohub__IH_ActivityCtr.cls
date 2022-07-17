/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IH_ActivityCtr {
    global IH_ActivityCtr() {

    }
    @AuraEnabled
    global static List<innohub__Activity__c> getActivities(String selectedFilter, String searchFiltersJSON) {
        return null;
    }
    @AuraEnabled
    global static innohub__Activity__c getActivity(String recordId) {
        return null;
    }
    @AuraEnabled
    global static User getCreator(String creatorId) {
        return null;
    }
    @AuraEnabled
    global static List<innohub.IH_ActivityCtr.myRecordTypeStructure> getIdeaRecordTypes() {
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
    global static Map<String,String> getRecordTypeRadio() {
        return null;
    }
    @AuraEnabled
    global static List<String> getTypes() {
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
