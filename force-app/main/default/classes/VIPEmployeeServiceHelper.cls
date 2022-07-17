/**
 * @description       : This is helper class for VIPEmployeeService class.
 * @author            : Prathamesh Lad
 * @group             : 
 * @last modified on  : 04-19-2021
 * @last modified by  : Prathamesh Lad
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   03-31-2021   Prathamesh Lad   Initial Version
**/

global inherited sharing virtual class VIPEmployeeServiceHelper{
    /**
    * @description This method is used to get PayrollId from RequestURI
    * @author Prathamesh Lad | 04-06-2021 
    * @param requestURI 
    * @return String 
    **/
    public static String getPayrollId(String requestURI){
        String accountId = requestURI.substring(requestURI.lastIndexOf('/')+1);
        return accountId; 
    }

    /**
    * @description This method is used to get TeamMember Details using payrollId
    * @author Prathamesh Lad | 04-06-2021 
    * @param payrollId 
    * @return Account 
    **/
    public static Account getTeamMemberDetails(String payrollId){
        List<String> listPayrollId=new List<String>();
        listPayrollId.add(payrollId);
        List<Account> listAccount=AccountDomain.getAccountDetails(listPayrollId);
        if(listAccount.size()>0){
            return listAccount[0];
        }
        return null;
    }

    /**
    * @description This method is used to retrieve VIP Master records using account details
    * @author Prathamesh Lad | 04-06-2021 
    * @param objAccount 
    * @return List<VIP_Employee_Matrix__c> 
    **/
    public static List<VIP_Employee_Matrix__c> getVIPMasterRecords(Account objAccount){
        String baseQuery='Select id, Is_VIP__c from VIP_Employee_Matrix__c';
        Map<String,String> whereMap=new Map<String,String>();
        if(objAccount.Position__c!=null){
            whereMap.put('Position',objAccount.Position__c);
        }
        if(objAccount.Division__c!=null){
            whereMap.put('Division',objAccount.Division__c);            
        }
        if(objAccount.Location_Name__c!=null){
            whereMap.put('Location Name',objAccount.Location_Name__c);   
        }
        if(objAccount.State__c!=null){
            whereMap.put('State',objAccount.State__c);           
        }
        
        List<VIP_Employee_Matrix__c> vipEmployessData=new List<VIP_Employee_Matrix__c>();
        if(whereMap.keySet()!=null && whereMap.keySet().size()>0){
            baseQuery=constructWhereClause(baseQuery,whereMap);
            vipEmployessData=VIPEmployeeMatrixDomain.getVIPEmployeeDetails(baseQuery);
        }
        return vipEmployessData;
    }

    
    /**
    * @description This method is used to find VIPFlag from VIP Master records
    * @author Prathamesh Lad | 04-06-2021 
    * @param vipEmployessData 
    * @return String 
    **/
    public static String getVIPFlag(List<VIP_Employee_Matrix__c> vipEmployessData){
        String isVIP=ConstantsUtility.VIPFLAG_No;
        for(VIP_Employee_Matrix__c vipEmpData :vipEmployessData){
            if(vipEmpData.Is_VIP__c=='Yes'){
                isVIP=ConstantsUtility.VIPFLAG_YES;              
            }
        }
        return isVIP;
    }

    /**
    * @description This method is used to construct VIP service Response using VIPFlag and Account 
    * @author Prathamesh Lad | 04-06-2021 
    * @param vipFlag 
    * @param objAccount 
    * @param errorMsg 
    * @return VIPServiceResponse 
    **/
    public static VIPServiceResponse getResponse
        (String vipFlag, Account objAccount, String errorMsg){
        VIPServiceResponse objVIPServiceResponse=new VIPServiceResponse();
        if(objAccount!=null){
            objVIPServiceResponse.employeeId=objAccount.Employee_ID__c;
            objVIPServiceResponse.vipFlag=vipFlag;
            if(objAccount.Position__c!=null){
                objVIPServiceResponse.position=objAccount.Position__c;
            }else{
                objVIPServiceResponse.position='';
            }
            if(objAccount.Division__c!=null){
                objVIPServiceResponse.division=objAccount.Division__c;
            }else{
                objVIPServiceResponse.division='';
            }
            if(objAccount.Location_Name__c!=null){
                objVIPServiceResponse.locationName=objAccount.Location_Name__c;
            }else{
                objVIPServiceResponse.locationName='';
            }
            if(objAccount.State__c!=null){
                objVIPServiceResponse.state=objAccount.State__c;
            }else{
                objVIPServiceResponse.state='';
            }
        }else{
            objVIPServiceResponse.employeeId='';
            objVIPServiceResponse.vipFlag=vipFlag;
            objVIPServiceResponse.position='';
            objVIPServiceResponse.division='';
            objVIPServiceResponse.locationName='';
            objVIPServiceResponse.state='';            
        }
        if(errorMsg==null){
            objVIPServiceResponse.errorMsg='';
        }else{
            objVIPServiceResponse.errorMsg=errorMsg;
        }
        return objVIPServiceResponse;
    }
    
    /**
    * @description This is helper method to construct BaseQuery
    * @author Prathamesh Lad | 04-06-2021 
    * @param baseQuery 
    * @param whereMap 
    * @return String 
    **/
    private static String constructWhereClause(String baseQuery, Map<String,String> whereMap){
        if(whereMap.size() > 0){
            baseQuery += ' WHERE ';
            Integer i = 0;
            for(String key: whereMap.keySet()){
                String value = whereMap.get(key);
                baseQuery +='(Type__c = \'' + key + '\' AND Value__c = \'' + value + '\')';
                if(i < whereMap.size() -1){
                    baseQuery += ' OR ';
                } 
                ++i;
            }
        }
    	return baseQuery;
	}
    
    /**
    * @description This method is used to send email notifications
    * @author Prathamesh Lad | 04-06-2021 
    * @param accountId 
    **/
    public static void notifyUsers(Id accountId){
        //Find OrgWide Address
        List<OrgWideEmailAddress> listowea 
            = OrgWideAddressDomain.getOrgWideAddress(Label.IVRIntegration_OrgWideAddress);

        List<String> emailTemplates=new List<String>();
        emailTemplates.add('PositionNotificationTemplate');

    	//Find EmailTemplate Id
    	List<EmailTemplate> listEmailtempObj
        	=EmailTemplateDomain.getEmailTemplate(emailTemplates); 
            
        //Find Email Ids
        List<User> listUsers= new List<User>();
        General_Setting__c obj = General_Setting__c.getValues('Emails');
        if(obj!=null){
            String emails = obj.HR_Smart_IVR_Emails__c;
            List<String> listEmails=emails.split(',');
            
            //Find User Details using Email Ids
            if(listEmails!=null && listEmails.size()>0){
                listUsers=UserDomain.getUserDetails(listEmails);
            }                
        }
            
        if(listUsers.size()>0){
        	List<EmailService.EmailWrapper> listWrapObj=new List<EmailService.EmailWrapper>(); 
            for(User userObj :listUsers){
            	Messaging.SingleEmailMessage emailToSent 
                	= Messaging.renderStoredEmailTemplate
                      (listEmailtempObj[0].Id, userObj.Id, accountId);
                EmailService.EmailWrapper wrapObj=new EmailService.EmailWrapper();
                wrapObj.subject = emailToSent.getSubject();
                wrapObj.htmlBody = emailToSent.getHtmlBody();
                wrapObj.plainTextBody = emailToSent.getPlainTextBody();
                wrapObj.targetObjectId=userObj.Id;
                wrapObj.saveAsActivity = false;
                if(listowea!=null){
                    wrapObj.orgWideAddress= listowea[0].Id; 
                }
                listWrapObj.add(wrapObj);	                       
            }
            if(listWrapObj.size()>0){
            	EmailService.sendEmail(listWrapObj);
            }            
    	}	    	   
    }

    /**
    * @description Inner Class is used for returning the response 
    * @author Prathamesh Lad | 04-06-2021 
    **/
    global class VIPServiceResponse{
        public String employeeId;
        public String vipFlag;
        public String position;
        public String division;
        public String locationName;
        public String state;
        public String errorMsg;
    }
}