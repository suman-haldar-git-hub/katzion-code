/*
Author:             Sally Montgomery
Created Date:       17th July 2016
Brief:              CheckDeleteTask Extension
Override for Delete on Task to disable delete for ***CHAT*** Chat Transcripts

Visualforce Page:   PreventChatTranscriptDelete
Test Class:         N/A
Apex Class:         CheckDeleteTask.cls   
Version Control:    v1.0

@Revision History:  17th July 2016     -   Test class created

@Test Coverage:     XXX%    -   17th July 2016
*/

public with sharing class CheckDeleteTask
{
    private ApexPages.standardcontroller stdCtrl;
    Public Task taskrec {get;set;}
    
    
    public CheckDeleteTask(ApexPages.Standardcontroller std)
    {
        stdCtrl=std;
    }
    
    public PageReference checkDeleteTask()
    {
        Task tsk=(Task) stdctrl.getRecord();
        system.debug('xxxxTaskIdxxxx:'+tsk.Id);
        //tskrec = [SELECT ID, Chat_Transcript__c FROM Task WHERE ID = :tsk.Id LIMIT 1];
        taskrec = new Task();
        taskrec = [Select Id, WhatId, Chat_Transcript__c From Task Where ID = :tsk.Id LIMIT 1];
        
        
        system.debug('xxxxChat Transcriptxxxx:'+taskrec.Chat_Transcript__c);
        if (taskrec.Chat_Transcript__c != True)
        {
            
            performDML(JSON.serialize(taskrec));
            
            return null;
        }
        else
        {
            return null;
        }
    }
    
    @future
    public static void performDML(String obj) {
        if(Task.sObjectType.getDescribe().isDeletable()){
            delete (Task) JSON.deserialize(obj, Task.class);        
        }          
    } 
}