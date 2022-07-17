/*
    Author:             Sekar Krishnan
    Created Date:       17th July 2016
    Brief:              Test Class for CheckDeleteTask Extension
    
    Visualforce Page:   PreventChatTranscriptDelete
    Test Class:         CheckDeleteTaskTestsk
    Apex Class:         CheckDeleteTask.cls   
    Version Control:    v1.0

    @Revision History:  17th July 2016     -   Test class created

    @Test Coverage:     100%    -   21st July 2016
*/
@isTest
private class CheckDeleteTaskTestsk{
     @isTest 
    static void CheckDeleteTask() {
                
            Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
            insert caseRec;

            // create transaction cases
            Id transcationCaseId= Id.valueOf(caseRec.Transaction_Case__c); 
            List<Case> cases = TestUtility.createTrxCases(3,transcationCaseId);
            insert cases;
               
          // create task for ***Other CHAT - Task1***
            Task taskRec = new Task();
            taskRec.Description = 'Other CHAT1';
            taskRec.Chat_Transcript__c = false;
            insert taskRec  ;
            system.debug('Test Case 1'+taskRec);
            
          // create task for ***Other CHAT  - Task2***
            Task taskRec1 = new Task();
            taskRec1.Description = 'Other CHAT2';
            taskRec1.Chat_Transcript__c = false;
            insert taskRec1  ;
     
        
        // create task for ***Non CHAT***
          
            List<task> Fetchtask =  [SELECT Id,Chat_Transcript__c,WhatId
                                     FROM task
                                     where Chat_Transcript__c = false limit 2];

            Integer I=0 ;
               for (task j : Fetchtask)
              { task tasklist = Fetchtask.get(i);    
               
               if (tasklist.Chat_Transcript__c != true)
                {try
                {
                    system.debug('expected result'+tasklist);
                    CheckDeleteTask controller = 
                    new CheckDeleteTask(new ApexPages.StandardController(tasklist));
                    PageReference pageRef = controller.checkDeleteTask();
                    system.assertEquals(pageRef, null);
                    }
                 catch(Exception e1)
                 {  System.assert(ApexPages.hasMessages(ApexPages.Severity.info));
                    System.assertEquals(ApexPages.getMessages().size(), 1);
                    Boolean expectedExceptionThrown =  e1.getMessage().contains('success');
                    System.assertEquals(expectedExceptionThrown,true);
                 }
                }
               i++;
        }       
        
        // create task for ***CHAT***
                {try{ 
                    Task taskRec2 = new Task();
                    taskRec2.Description = '***CHAT***';
                    taskRec2.Chat_Transcript__c = False;
                    insert taskRec2;
                    
                    CheckDeleteTask controller2 = 
                    new CheckDeleteTask(new ApexPages.StandardController(taskRec2));
                    PageReference pageRef2 = controller2.checkDeleteTask();
                    PageReference q2 = Page.PreventChatTranscriptDelete;
                    system.assertEquals(pageRef2,null);
                }
                 catch(Exception e2)
                 {  System.assert(ApexPages.hasMessages(ApexPages.Severity.Error));
                    System.assertEquals(ApexPages.getMessages().size(), 1);
                    Boolean expectedExceptionThrown =  e2.getMessage().contains('system');
                    System.assertEquals(expectedExceptionThrown, false);
                 }
               }
    }
      }