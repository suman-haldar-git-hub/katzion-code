/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IH_EventCtr {
    global IH_EventCtr() {

    }
    @AuraEnabled
    global static innohub__Event__c checkAvailability(Id theEvent) {
        return null;
    }
    @AuraEnabled
    global static innohub__Event_Member__c checkIfEventMember(innohub__Event__c theEvent, User theUser) {
        return null;
    }
    @AuraEnabled
    global static innohub__Event_Member__c createEventMember(innohub__Event__c theEvent, User theUser) {
        return null;
    }
    @AuraEnabled
    global static List<innohub__Event__c> getCampaignes(String selectedFilter, String searchFiltersJSON) {
        return null;
    }
    @AuraEnabled
    global static User getCreator(String creatorId) {
        return null;
    }
    @AuraEnabled
    global static innohub__Event__c getEvent(String recordId) {
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
    global static innohub__Event_Member__c removeEventMember(innohub__Event__c theEvent) {
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
