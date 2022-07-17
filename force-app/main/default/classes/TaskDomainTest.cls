/**
@Author : Monika Bisht
@Company : SaasFocus A Cognizant Company
@description : This test class is used to cover positive and negative scenarios of
TaskDomain class.
*/
@isTest(SeeAllData=false)
public without sharing class TaskDomainTest {
    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : create set up data
    */
    @testSetUp
    static void setUpData() {
        Id taskRecdTypeId = 
                Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Nudge').
                getRecordTypeId();
        List<Task> taskList = TaskTestData.createTaskRecds(20, taskRecdTypeId);
        insert taskList;
    }

    /**
    @Author : Monika Bisht
    @Company : SaasFocus A Cognizant Company
    @description : Test TaskDomain method
    */
    @isTest
    static void testTaskDomain() {
        List<Task> listTask = new List<Task>();
        listTask = [SELECT Id, status,OwnerId FROM Task];
        set<id> setOfOwnerId = new set<id>();
        setOfOwnerId.add(listTask[0].OwnerId);
        System.assert(!listTask.isEmpty());
        TaskDomain.getNudgesTaskForCurrentWeek(setOfOwnerId);
    }
}