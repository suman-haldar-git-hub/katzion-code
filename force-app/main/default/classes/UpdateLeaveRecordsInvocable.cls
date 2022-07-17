/**
* @author : Daksh
* @company : SaaSFocus A Cognizant Company
* @description : This is a Invocable class of CreateOrUpdateLeave process builder.
*/
public with sharing class UpdateLeaveRecordsInvocable {
    /**
* @author : Daksh
* @description : This invocable method which will invoke UpdateLeaveRecordsQueueable for 
leave record update.
* @param  leaveList
*/
    @InvocableMethod(label='updateSubmByUserAndApvUser')
    public static void updateSubmByUserAndApvUser(List<Leave__c> leaveList){
        try{
            Set<Id> submByIdSet = new Set<Id>();
            for(Leave__c leaveRecd : leaveList){
                submByIdSet.add(leaveRecd.SubmittedBy__c);
            }
            makeEmpIdAndLineMagSetFromAcct
                (leaveList,AccountDomain.queryAccountBasedOnIdSet(submByIdSet));
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'UpdateLeaveRecordsQueueable.cls on Load',
                ex
            );
        }
    }
    /**
* @author : Daksh
* @description : This method will create set of Account's Employee_ID__c & Line_Manager__c.
* @param  leaveList
* @param  acctList
*/
    private static void makeEmpIdAndLineMagSetFromAcct(List<Leave__c> leaveList, List<Account> acctList){
        Set<String> empIdSet = new Set<String>();
        Set<String> lineMangIdSet = new Set<String>();
        Map<Id,Account> idVsAccountMap = new Map<Id,Account>();
        for(Account acctRecd : acctList){
            idVsAccountMap.put(acctRecd.Id,acctRecd);
            String acctEmpId = acctRecd.Employee_ID__c;
            String acctLineMangId = acctRecd.Line_Manager__c;
            if(String.isNotBlank(acctEmpId)){
                empIdSet.add(acctEmpId);
            }
            if(String.isNotBlank(acctLineMangId)){
                lineMangIdSet.add(acctLineMangId);
            }
        }
        Map<String,User> empIdVsUserMap = 
            getMapOfEmpIdVsUserRecd(empIdSet,lineMangIdSet);
        if(!empIdVsUserMap.isEmpty()){
            updateLeaveRecds(leaveList,idVsAccountMap,empIdVsUserMap);
        }
    }
    /**
* @author : Daksh
* @description : This method will return the user list.
* @return : Map<String,User>
* @param  empIdSet
* @param  lineMangIdSet
*/
    private static Map<String,User> getMapOfEmpIdVsUserRecd
        (Set<String> empIdSet, Set<String> lineMangIdSet){
            Map<String,User> empIdVsUserMap = new Map<String,User>();
            List<User> userList = new List<User>();
            if(!empIdSet.isEmpty()){
                userList.addAll(UserDomain.getUserRecords(empIdSet));
            }
            if(!lineMangIdSet.isEmpty()){
                userList.addAll(UserDomain.getUserRecords(lineMangIdSet));
            }
            if(!userList.isEmpty()){
                for(User userRecd : userList){
                    empIdVsUserMap.put(userRecd.EmployeeID__c,userRecd);
                }
            }
            return empIdVsUserMap;
        }
    /**
* @author : Daksh
* @description : This method will contains the logic of leave record updation.
* @param  leaveList
* @param  idVsAccountMap
* @param  empIdVsUserMap
*/
    private static void updateLeaveRecds
        (List<Leave__c> leaveList, Map<Id,Account> idVsAccountMap,Map<String,User> empIdVsUserMap){
            Map<Id,Leave__c> idVsLeaveMap = new Map<Id,Leave__c>();
            for(Leave__c leaveRecd : leaveList){
                String submById = leaveRecd.SubmittedBy__c;
                if(idVsAccountMap.containsKey(submById)){
                    Account acctRecd = idVsAccountMap.get(submById);
                    String empIdAcct = acctRecd.Employee_ID__c;
                    String lineMangIdAcct = acctRecd.Line_Manager__c;
                    if(empIdVsUserMap.containsKey(empIdAcct)){
                        User userRecd = empIdVsUserMap.get(empIdAcct);
                        if(idVsLeaveMap.containsKey(leaveRecd.Id)){
                            idVsLeaveMap.get(leaveRecd.Id).SubmittedByUser__c = userRecd.Id;
                        }
                        else{
                            idVsLeaveMap.put(
                                leaveRecd.Id,
                                new Leave__c(
                                    Id = leaveRecd.Id,
                                    SubmittedByUser__c = userRecd.Id
                                ));
                        }
                    }
                    if(empIdVsUserMap.containsKey(lineMangIdAcct)){
                        User userRecd = empIdVsUserMap.get(lineMangIdAcct);
                        if(idVsLeaveMap.containsKey(leaveRecd.Id)){
                            idVsLeaveMap.get(leaveRecd.Id).ApproverUser__c = userRecd.Id;
                        }
                        else{
                            idVsLeaveMap.put(
                                leaveRecd.Id,
                                new Leave__c(
                                    Id = leaveRecd.Id,
                                    ApproverUser__c = userRecd.Id
                                ));
                        }
                    }
                }
            }
            update idVsLeaveMap.values();
        }   
}