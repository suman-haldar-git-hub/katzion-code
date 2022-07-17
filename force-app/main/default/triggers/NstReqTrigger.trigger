trigger NstReqTrigger on NSTRequest__c (before insert, before update) {
    
    string reqdate;
    //*********************** GET ALL ACCOUNT ID ***********************
    List<Id> AccID = New List<Id>();
    for(NSTRequest__c nstreq : Trigger.new){
        if( nstreq.PayrollID__c != null){
            AccID.add(nstreq.PayrollID__c);
        }
    }
    
    //************* GET ACCOUNT ID AND PAYROLL ID MAP********************
    List<Account> accList = [SELECT Id, Employee_ID__c FROM Account WHERE id in :AccID];
    Map<Id,String> empmap=new Map<Id, String>();
    for(Account acc: accList)
    {
        empmap.put(acc.Id, acc.Employee_ID__c);       
    }
    
    //************************* GET STATE TIME ZONE MAPPING DATA ****************************
    List<StateTimeZoneMapping__mdt> mapping=[SELECT State__c,Timezone__c FROM StateTimeZoneMapping__mdt];
    Map<String,String> statetimezone=new Map<String, String>();
    for(StateTimeZoneMapping__mdt mapdata: mapping)
    {
        statetimezone.put(mapdata.State__c, mapdata.Timezone__c); 
    }
    
    
    //************************* MODIFY NAME, TIMEZONE and STATUS ****************************
    for (Integer i = 0; i < Trigger.new.size(); i++)
    {
        //******************** SET THE TIME ZONE ************************
        
        if(Trigger.new[i].State__c != null && Trigger.new[i].Timezone__c == null)
        {
            Trigger.new[i].Timezone__c= statetimezone.get(Trigger.new[i].State__c); 
        }
        
        //******************** SET THE NAME ************************
        if(Trigger.new[i].Timezone__c != null)
        {
            reqdate=Trigger.new[i].VisitedDate_Start__c.format('YYYY-MM-dd',Trigger.new[i].Timezone__c);   
        }
        else
        {   
            Trigger.new[i].Timezone__c='Australia/Sydney';
            reqdate=Trigger.new[i].VisitedDate_Start__c.format('YYYY-MM-dd',Trigger.new[i].Timezone__c);   
        }
        Trigger.new[i].Name= empmap.get(Trigger.new[i].PayrollID__c)  + ' - '+ reqdate;
        
        //******************** SET THE STATUS ************************
        if(Trigger.new[i].VisitedDate_End__C == null){
            Trigger.new[i].Status__c='Checkout-Pending';
        }
        else{
            Trigger.new[i].Status__c='Checkout-Completed';
        }
    }
    
    //Added by Prathamesh-Remove Timezone issue and Separate Date and Time 
    if(Trigger.isInsert && Trigger.isBefore){
        NstReqTriggerHandler.OnBeforeInsert(Trigger.new);                
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        NstReqTriggerHandler.OnBeforeUpdate(Trigger.new);                
    }
    //Added by Prathamesh-Remove Timezone issue and Separate Date and Time 
}