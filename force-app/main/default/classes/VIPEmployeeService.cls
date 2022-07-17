/**
* @description       : This class is responsible for below items.
                       @HttpGet annotation is used at the method level which enables 
                       to expose an Apex method as a REST resource. 
                       get payroll Id from the request uri.
                       get team member details based on payroll details.
                       get records from VIP employee matrix objects based on team member details.
                       find VIP flag from the VIP employee matrix records.
                       Send Y,N,E and Team member details as a response of service.
* @author            : Prathamesh Lad
* @group             : 
* @last modified on  : 04-19-2021
* @last modified by  : Prathamesh Lad
* Modifications Log 
* Ver   Date         Author           Modification
* 1.0   03-31-2021   Prathamesh Lad   Initial Version
**/
@RestResource(urlMapping='/GetVIPFlag/*')
global with sharing class VIPEmployeeService extends VIPEmployeeServiceHelper{
    /**
    * @description This method is called when an HTTP GET request is sent, 
    *               and returns the specified resource.
    * @author Prathamesh Lad | 04-01-2021 
    * @return VIPEmployeeServiceHelper.VIPServiceResponse
    **/
    @HttpGet
    global static VIPEmployeeServiceHelper.VIPServiceResponse doGet() {
        //Response
        VIPEmployeeServiceHelper.VIPServiceResponse respObj;

        try{
            //Request
            RestRequest req = RestContext.request;
            
            //Find Payroll Id using Requestfrom
            String payRollId=getPayrollId(req.requestURI);
            
            //If PayrollId is found 
            if(payRollId!=null && !String.isEmpty(payRollId)){
                //Find Account/Team Member Details using payrollId
                Account objAccount=getTeamMemberDetails(payRollId);
                
                //If Account/Team member detail is found
                if(objAccount!=null){
                    //Find VIP Master records using Account detail
                    List<VIP_Employee_Matrix__c> vipEmployessData=
                        getVIPMasterRecords(objAccount);
                    
                    //If VIP Master records are found  
                    if(vipEmployessData.size()>0){
                        String vipFlag= getVIPFlag(vipEmployessData);
                        respObj=getResponse(vipFlag, objAccount, null);    
                    }
                    //If VIP Master records are not found then return response with VIPFlag as E
                    else{
                        respObj=getResponse(ConstantsUtility.VIPFLAG_ERROR, objAccount, null);
                        //Notify Users if Position is not empty
                        if(objAccount.Position__c!=null){
                            notifyUsers(objAccount.Id);
                        }                    
                    }
                }
                //If Account/Team Member detail is not found then return response with VIPFlag as E
                else{
                    objAccount=new Account();
                    objAccount.Employee_ID__c=payRollId;
                    respObj=getResponse(ConstantsUtility.VIPFLAG_ERROR, objAccount, null);
                }
            }
            //If PayrollId is not found then return response with VIPFlag as E
            else{
                respObj=getResponse(ConstantsUtility.VIPFLAG_ERROR, null, null);
            }
        }catch(Exception e){
            respObj=getResponse(ConstantsUtility.VIPFLAG_ERROR, null, e.getMessage());
            Exceptionlogwrapper obj = new Exceptionlogwrapper();
            obj.debugMessage = 'Error in the VIPEmployeeService';
            obj.debuglevel = 'Error';
            obj.logCode='1001'; 
            obj.source='VIPEmployeeService';
            obj.sourceFunction='doGet';
            obj.ex = e;
            publishlogeventservice.publishExceptionEvent(obj);
        }
        return respObj;
    }
}