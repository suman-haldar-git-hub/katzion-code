/**
* @Author       :       Suman Nandy
* @Date     :       03-Sep-2020
* @Desc     :       This class will be used by national stockakeform
* */

/**
* @description StoreController
*/
public without sharing class NSTUpdateController {
    

    /**
* @description saveCheckOutDetail
*/
    @AuraEnabled
    public static string saveCheckOutDetail(String reqId,String duration, String comment,String token)
    {
        try
        {
            NSTRequest__c req =[Select Id,Break_Duration__c,Comments__c,Status__c from NSTRequest__c where Id =:reqId];
            req.Break_Duration__c=duration;
            req.Comments__c=comment;
            //req.EndTime__c=datetime.now().time();
            req.VisitedDate_End__c=System.Now();
            update req;
            return 'Success';
        }          
        catch(Exception ex)
        {
            throw createAuraHandledException.createException('Unhandled Exception at StoreController --> saveCheckOutDetail'+ex); 
        }                
    }
    
    
    /**
* @description getNSTRequestDetail
* @return  NSTRequest__c
*/
    @AuraEnabled(cacheable=true)
    public static NSTRequestData getNSTRequestDetail(String payrollId)
    {   
        try{
            /*
            List<NSTRequest__c> reqDetail=[Select Id,Store__r.State__c,Store__r.Store_Type__c,Break_Duration__c,
                                     Comments__c,Distance_Travelled__c,Division__c,EndTime__c,
                                     PayrollID__c,ManagerUser__c,
                                     Name,StartTime__c,Status__c,Store__c,StoreName__c,Time_Travel__c,VisitedDate__c
                                     from NSTRequest__c where PayrollID__c =: payrollId AND VisitedDate__c=:System.today()];*/
            System.debug('System.today()' + System.today());
            //********************* QUERY to GET THREE DAYS DATA **************************************
            List<NSTRequest__c> reqDetail=[Select Id,Store__r.State__c,Store__r.Store_Type__c,Break_Duration__c,
                                     Comments__c,Distance_Travelled__c,
                                     PayrollID__c,ManagerUser__c,
                                     Name,Status__c,Store__c,StoreName__c,Time_Travel__c,
                                     VisitedDate_Start__c,VisitedDate_End__c,Timezone__c
                                     from NSTRequest__c 
                                     where PayrollID__c =: payrollId 
                                     AND VisitedDate_Start__c <=:System.today() +1 
                                     AND VisitedDate_Start__c >=:System.today() -1];
            //************************* Declare variable for NSTRequest__c and rec found flag***************
            NSTRequest__c nstreq;
            Boolean isRecFound=false;
            
            //************************ Check if record exist ***********************************************
            if(reqDetail!= null)
            {
                
            	for(NSTRequest__c req:reqDetail)
            	{
                    
                    if(req.Timezone__c== null || req.Timezone__c == '' )
                    {
                       req.Timezone__c='Australia/Sydney'; 
                    }
                    System.debug('System.today()' +System.now().format('MM/dd/YYYY',req.Timezone__c)); 
                    System.debug('req.Timezone__c' + req.Timezone__c);
					string  todaydate=System.now().format('MM/dd/YYYY',req.Timezone__c);
					Integer todayday= Integer.valueof(todaydate.mid(3,2));
					Integer todaymonth = Integer.valueof(todaydate.mid(0,2));
					Integer todayyear= Integer.valueof(todaydate.mid(6,4));
                    Integer reqday,reqmonth,reqyear;
                    if(req.VisitedDate_Start__c != null)
                    {
                		string reqdate=req.VisitedDate_Start__c.format('MM/dd/YYYY',req.Timezone__c);  
						reqday= Integer.valueof(reqdate.mid(3,2));
						reqmonth = Integer.valueof(reqdate.mid(0,2));
						reqyear= Integer.valueof(reqdate.mid(6,4));
                	}
                    
                    if(reqday == todayday && reqmonth == todaymonth && reqyear == todayyear)
                    {
                        nstreq=req;
                        isRecFound=true;
                        break;
                    }
            	}
            }
            
            
            if(isRecFound == true)
            {
                              
                NSTRequestData data=new NSTRequestData();
                data.PayrollID=nstreq.PayrollID__c;
                data.Id=nstreq.Id;
                data.State=nstreq.Store__r.State__c;
                data.Store_Type=nstreq.Store__r.Store_Type__c;
                data.Store=nstreq.Store__c;
                data.ManagerUser=nstreq.ManagerUser__c;
                data.Distance_Travelled=nstreq.Distance_Travelled__c;
                data.Time_Travel=nstreq.Time_Travel__c;
                data.Break_Duration=nstreq.Break_Duration__c;
                data.Comments=nstreq.Comments__c;
                data.Status=nstreq.Status__c;
                data.Timezone=nstreq.Timezone__c;
                
                If(nstreq.VisitedDate_Start__c != null)
                {
                    //data.StartTime=nstreq.VisitedDate_Start__c.format('MM/dd/yyyy HH:mm:ss','America/Los_Angeles'); 
                    data.StartTime=nstreq.VisitedDate_Start__c.format('HH:mm',nstreq.Timezone__c);  
                }
                If(nstreq.VisitedDate_End__c != null)
                {
                    data.EndTime=nstreq.VisitedDate_End__c.format('HH:mm',nstreq.Timezone__c); 
                }
                system.debug('Data'+data);
                return data;
            }
            else{
                return null;
            }
            
        }          
        catch(Exception ex)
        {
            throw createAuraHandledException.createException('Unhandled Exception at NSTController --> getNSTRequestDetail' + ex); 
        }                         
    }
    
    public class NSTRequestData{
        @AuraEnabled
        public string PayrollID{get;set;}
        @AuraEnabled
        public string Id{get;set;}
        @AuraEnabled
        public string State{get;set;}
        @AuraEnabled
        public string Store_Type{get;set;}
        @AuraEnabled
        public string Store{get;set;}
         @AuraEnabled
        public string ManagerUser{get;set;}
        @AuraEnabled
        public Decimal Distance_Travelled{get;set;}
        @AuraEnabled
        public Decimal Time_Travel{get;set;}
        @AuraEnabled
        public string Break_Duration{get;set;}
        @AuraEnabled
        public string Comments{get;set;}
        @AuraEnabled
        public string Timezone{get;set;}
        
       
        @AuraEnabled
        public string Status{get;set;}
        
        @AuraEnabled
        public string EndTime{get;set;}
        @AuraEnabled
        public string StartTime{get;set;}

    }

}