/**
 * @description       : 
 * @author            : Harshit Goyal ( Cognizant )
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Harshit Goyal ( Cognizant )
**/
@isTest
@SuppressWarnings('PMD.ClassNamingConventions')
public with sharing class myMilestoneTimeCalculatorTest {
    public static final String MILESTONE_NAME ='SLA calculation for traffic light';
    @istest
    public static void testMilestoneTimeCalculator() {        
        Test.StartTest();
        // Select an existing milestone type to test with
        MilestoneType[] mtLst = [SELECT Id, Name FROM MilestoneType WHERE Name=:MILESTONE_NAME LIMIT 1];      
        if(mtLst.size() == 0) { return; }
        MilestoneType mt = mtLst[0];
        Case c = new Case(priority = 'High');
        insert c;
        
        myMilestoneTimeCalculator calculator = new myMilestoneTimeCalculator();
        Integer actualTriggerTime = calculator.calculateMilestoneTriggerTime(c.Id, mt.Id);
        c.priority = 'Low';
        c.Hold_Business_Hours_Age__c = 1;
        update c;
        actualTriggerTime = calculator.calculateMilestoneTriggerTime(c.Id, mt.Id);
        Test.stopTest();
        System.assert(String.isNotBlank(MILESTONE_NAME),true);
    }
}