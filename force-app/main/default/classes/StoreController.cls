/**
 * @Author		:		Suman Nandy
 * @Date		:		8-Jun-2020
 * @Desc		:		Controller for Lookup Lightning Component
 * */

/**
 * @description StoreController
 */

public without sharing class StoreController {

    /**
     * @description searchStore
     * @param searchStr
     * @param storeType
     * @return Store
     */
    @AuraEnabled
    public static String searchStore(String searchStr,String storeType)
    {	
        try{
            //Store type name has been modified as part of NSTFORM
            if(storeType == 'DANS')
            {
                storeType='Dan Murphys';
            }
            
        	searchStr = '%'+  searchStr + '%';      
    		List<Store__C> listStore= [SELECT Postal_Code__c,State__c,Store_Name__c,Store_Number_Text__c,Store_Type__c FROM Store__C where Store_Type__c  = :storeType and (Store_Name__c like :searchStr OR Store_Number_Text__c like :searchStr OR Postal_Code_Text__c like :searchStr)];
            //List<Store__C> listStore= [SELECT State__c,Store_Name__c,Store_Number_Text__c,Store_Type__c FROM Store__C where Store_Type__c  = :storeType and (Store_Name__c like :searchStr OR Store_Number_Text__c like :searchStr OR Postal_Code_Text__c like :searchStr)];
            return JSON.serialize(listStore) ;
        }
        catch(Exception ex)
        {
           throw createAuraHandledException.createException('Unhandled Exception at StoreController --> searchStore'); 
        }
    }
    
    /**
     * @description searchEmployee
     * @param payrollId
     * @param birthDay
     * @param empType
     * @return Employee
     */
     @AuraEnabled
    public static String searchEmployee(String payrollId,String birthDay, String empType)
    {	
        try{
			empType = empType + '%';     
            //List<Account> listAccount= [SELECT FIRSTName,LastName,PersonEmail,Employee_ID__c From Account WHERE Area_Dept_Name__c like :empType and Employee_ID__c = :payrollId and Birthdate_text__c=:birthDay];
       		//return JSON.serialize(listAccount) ; 
            // Added Active = TRUE check as part of User Story 457
            List<Account> listAccount= [SELECT FIRSTName,LastName,PersonEmail,Employee_ID__c,Area_Dept_Name__c From Account WHERE Employee_ID__c = :payrollId and Birthdate_text__c=:birthDay AND Active__c = 'Y'];
       		return JSON.serialize(listAccount) ;
        }
        catch(Exception ex)
        {
           throw createAuraHandledException.createException('Unhandled Exception at StoreController --> searchEmployee'); 
        }
    }

	/**
     * @description addStoreNomination
     * @param PayrollID
     * @param accountId
     * @param Emailid
     * @param storetoAdd
     * @param storetoRemove
     * @param token
     * @return String Success
     */    
    @AuraEnabled
    public static String addStoreNomination(String PayrollID,String accountId,String Emailid,String storetoAdd,String storetoRemove, String token)
    {	
      	Boolean captchaValidationResult = GoogleRecaptchaAPI.captchaValidationResult(token);
        if(!captchaValidationResult){
         	throw createAuraHandledException.createException('reCaptcha verification failed. Please contact to your System Administrator.');
        }
        
        //Add StoreNominationRequest
        try{
			StoreNominationRequest__c stRequest=new StoreNominationRequest__c();
        	stRequest.Payroll_ID__c=PayrollID;
        	stRequest.Email__C = Emailid;
            stRequest.Account__C=accountId;
            stRequest.IsActive__c = true;
        	Insert stRequest;
        	List<StoreNominationRequestDetail__c> liststdetail=new List<StoreNominationRequestDetail__c>();
       
        	//Add StoreNominationRequestDetail for Store to be Added
            if(storetoAdd != null && storetoAdd != '')
        	{
        		List<String> liststoretoAdd = storetoAdd.split(',');
        		for(String st: liststoretoAdd)
        		{
         			StoreNominationRequestDetail__c stdetail=new StoreNominationRequestDetail__c();	
            		stdetail.StoreNominationRequest__c=stRequest.Id;
            		stdetail.Store__c=st;
            		stdetail.Nomination_Type__c='Add';
            		liststdetail.add(stdetail);
        		}   
        	}
        
        	//Add StoreNominationRequestDetail for Store to be removed
        	if(storetoRemove != null && storetoRemove != '')
        	{
        		List<String> liststoretoRemove = storetoRemove.split(',');
         		for(String st: liststoretoRemove)
        		{
         			StoreNominationRequestDetail__c stdetail=new StoreNominationRequestDetail__c();	
            		stdetail.StoreNominationRequest__c=stRequest.Id;
            		stdetail.Store__c=st;
            		stdetail.Nomination_Type__c='Remove';
            		liststdetail.add(stdetail);
        		}
        		

    		}
            Insert liststdetail;
        	Return 'Success'; 
        }
        catch(Exception ex)
        {
           throw createAuraHandledException.createException('Unhandled exception at StoreController-->addStoreNomination'); 
        }
  	}  
    /**
     * @description addStoreNominationSubmit
     * @param payrollId
     * @param accountId
     * @param emailId
     * @param storeToAdd
     * @param storeToRemove
     * @param responseKey
     * @return String Success
     * This method has been created for Big W form as part of User Story 457 by Saniya Virmani
     */    
    @AuraEnabled
    public static String addStoreNominationSubmit(String payrollId,String accountId,String emailId,String storeToAdd,String storeToRemove, String responseKey)
    {	
        lightningResponse response = new lightningResponse();
        Boolean captchaValidationResult = false;
        try{
            captchaValidationResult = ReCaptchaService.verifyCaptcha(responseKey, 'ALL');
        }
        catch(Exception e){
            if(!captchaValidationResult){         	
                throw createAuraHandledException.createException(ConstantsUtility.RECAPTCHA_FAIL);
            }
            else{            
                LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
                logExceptionEvent.DebugLevel__c	= 'Error'; 
                logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
                logExceptionEvent.ExceptionMessage__c = e.getMessage();
                logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
                logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
                logExceptionEvent.User__c = UserInfo.getUserId();
                
                LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent); 
                
                throw createAuraHandledException.createException(e.getMessage());
            }
        }
        
        //Add StoreNominationRequest
        try{
            response.isError = false;
			StoreNominationRequest__c stRequest=new StoreNominationRequest__c();
        	stRequest.Payroll_ID__c=PayrollID;
        	stRequest.Email__C = Emailid;
            stRequest.Account__C=accountId;
            stRequest.IsActive__c = true;
        	Insert stRequest;
        	List<StoreNominationRequestDetail__c> liststdetail=new List<StoreNominationRequestDetail__c>();
            if(storetoAdd != null && storetoAdd != '')
        	{
        		List<String> liststoretoAdd = storetoAdd.split(',');
        		for(String st: liststoretoAdd)
        		{
         			StoreNominationRequestDetail__c stdetail=new StoreNominationRequestDetail__c();	
            		stdetail.StoreNominationRequest__c=stRequest.Id;
            		stdetail.Store__c=st;
            		stdetail.Nomination_Type__c='Add';
            		liststdetail.add(stdetail);
        		}   
        	}
        
        	//Add StoreNominationRequestDetail for Store to be removed
        	if(storetoRemove != null && storetoRemove != '')
        	{
        		List<String> liststoretoRemove = storetoRemove.split(',');
         		for(String st: liststoretoRemove)
        		{
         			StoreNominationRequestDetail__c stdetail=new StoreNominationRequestDetail__c();	
            		stdetail.StoreNominationRequest__c=stRequest.Id;
            		stdetail.Store__c=st;
            		stdetail.Nomination_Type__c='Remove';
            		liststdetail.add(stdetail);
        		}
    		}
            Insert liststdetail;    
            response.errorOrSuccessMessage = 'Request submitted successfully.';
        	Return JSON.serialize(response); 
        }
        catch(Exception e)
        {
           if(e.getMessage() == ConstantsUtility.STORE_NOMINATION_UNSUCCESSFUL){
                throw createAuraHandledException.createException(ConstantsUtility.STORE_NOMINATION_UNSUCCESSFUL);
            }
            else {
                response.isError = true;
                response.errorType = e.getTypeName();
                response.errorOrSuccessMessage = e.getMessage();

                LogExceptionEvent__e logExceptionEvent = new LogExceptionEvent__e();
                logExceptionEvent.DebugLevel__c	= 'Error'; 
                logExceptionEvent.ExceptionLineNumber__c = e.getLineNumber();
                logExceptionEvent.ExceptionMessage__c = e.getMessage();
                logExceptionEvent.ExceptionStackTrace__c = e.getStackTraceString();
                logExceptionEvent.ExceptionTypeName__c = e.getTypeName();
                logExceptionEvent.Source__c = 'StoreController';
            	logExceptionEvent.SourceFunction__c = 'addStoreNominationSubmit';
                logExceptionEvent.User__c = UserInfo.getUserId();
                
                LogExceptionDomain.publishLogExceptionEvent(logExceptionEvent); 

                throw createAuraHandledException.createException(e.getMessage());
            }
        }
  	}  
}