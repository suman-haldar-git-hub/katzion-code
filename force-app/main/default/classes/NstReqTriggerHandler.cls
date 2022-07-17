public class NstReqTriggerHandler {
    /*Before insert logic*/
    public static void OnBeforeInsert(List<NSTRequest__c> newRecords) {
        populateClockedIn_DateTime(newRecords);   
        populateClockedOut_DateTime(newRecords);
    }
    
    /*Before Update logic*/
    public static void OnBeforeUpdate(List<NSTRequest__c> newRecords) {
        List<NSTRequest__c> listnstReqObj1=new List<NSTRequest__c>();
        List<NSTRequest__c> listnstReqObj2=new List<NSTRequest__c>();
        List<NSTRequest__c> listnstReqObj3=new List<NSTRequest__c>();
        for(NSTRequest__c nstReqObj: newRecords){
            NSTRequest__c oldnstReqObj = (NSTRequest__c)Trigger.oldMap.get(nstReqObj.Id);
            if(nstReqObj.VisitedDate_Start__c!=null && nstReqObj.VisitedDate_Start__c!=oldnstReqObj.VisitedDate_Start__c){
                listnstReqObj1.add(nstReqObj);    
            }
            if(nstReqObj.VisitedDate_End__c!=null && nstReqObj.VisitedDate_End__c!=oldnstReqObj.VisitedDate_End__c){
                   listnstReqObj2.add(nstReqObj);    
               }
        }
        if(listnstReqObj1!=null && listnstReqObj1.size()>0){
            populateClockedIn_DateTime(listnstReqObj1);
        }
        if(listnstReqObj2!=null && listnstReqObj2.size()>0){
            populateClockedOut_DateTime(listnstReqObj2);
        }
    }
    
    /*public static void OnBeforeUpdate(List<NSTRequest__c> newRecords) {
		populateClockedIn_DateTime(newRecords);
		populateClockedOut_DateTime(newRecords);        
	}*/
    
    public static void populateClockedIn_DateTime(List<NSTRequest__c> newRecords) {
        for(NSTRequest__c reqObj :newRecords){
            system.debug('***Timezone'+reqObj.Timezone__c);
            if(reqObj.Timezone__c!=null && reqObj.VisitedDate_Start__c!=null){
                
                DateTime clocked_In=reqObj.VisitedDate_Start__c;
                
                String clocked_In_Date=clocked_In.format('dd/MM/yyyy', reqObj.Timezone__c);
                reqObj.VisitedDate_Start_Date__c=clocked_In_Date;
                system.debug('***clocked_In_Date'+clocked_In_Date);
                
                //String clocked_In_Time=clocked_In.format('hh:mm a', reqObj.Timezone__c);
                String clocked_In_Time=clocked_In.format('HH:mm', reqObj.Timezone__c);
                reqObj.VisitedDate_Start_Time__c=clocked_In_Time;
                system.debug('***clocked_In_Time'+clocked_In_Time);
                
            }	    
        }
    }
    
    public static void populateClockedOut_DateTime(List<NSTRequest__c> newRecords) {
        for(NSTRequest__c reqObj :newRecords){
            system.debug('***Timezone'+reqObj.Timezone__c);
            if(reqObj.Timezone__c!=null && reqObj.VisitedDate_End__c!=null){
                DateTime clocked_Out=reqObj.VisitedDate_End__c;
                
                String clocked_Out_Date=clocked_Out.format('dd/MM/yyyy', reqObj.Timezone__c);
                reqObj.VisitedDate_End_Date__c=clocked_Out_Date;
                system.debug('***clocked_Out_Date'+clocked_Out_Date);
                
                //String clocked_Out_Time=clocked_Out.format('hh:mm a', reqObj.Timezone__c);
                String clocked_Out_Time=clocked_Out.format('HH:mm', reqObj.Timezone__c);
                reqObj.VisitedDate_End_Time__c=clocked_Out_Time;
                system.debug('***clocked_Out_Time'+clocked_Out_Time);       
            }	    
        }
    }
    
    /*public static void populateClockedIn(List<NSTRequest__c> newRecords) {
        for(NSTRequest__c reqObj :newRecords){
            system.debug('***Timezone'+reqObj.Timezone__c);
            String clockedInDate=reqObj.VisitedDate_Start_Date__c;	
            String[] clockedInDateSplit = clockedInDate.split('/');
            String day=clockedInDateSplit[0];	    
            String month=clockedInDateSplit[1];	    
            String year=clockedInDateSplit[2];
            String clockedInTime=reqObj.VisitedDate_Start_Time__c;	
            String[] clockedInTimeSplit = clockedInTime.split(':');
            String hour=clockedInTimeSplit[0];	    
            String minuteWithAMPM=clockedInTimeSplit[1];
            String minute=minuteWithAMPM.substring(0, 2);
            String ampm=minuteWithAMPM.substring(3, 5);
            string second = '00';
            if(ampm=='PM'){
                Integer h=Integer.valueOf(hour);
                h=12+h;
                hour=String.valueOf(h);    
            }
            
            string stringDateTime = year + '-' + month + '-' + day + ' ' + hour + ':' 
                + minute +  ':' + second;
            system.debug('***stringDateTime'+stringDateTime);            
            Datetime dt = Datetime.valueOfGMT(stringDateTime);
            system.debug('***dt'+dt);
            Datetime clockedInDateTime =DateTime.newInstance(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day), Integer.valueOf(hour), Integer.valueOf(minute), Integer.valueOf(second));
            system.debug('***dt1'+clockedInDateTime);
            reqObj.VisitedDate_Start__c=dt;
            
        }
    }*/
}