/**
* @author : Manohara Dudi
* @company : SaaSFocus A Cognizant Company
* @description : Batch class for updating Case Status and reason 
*/
global class UpdateCaseTransactionRecBatch implements Database.Batchable<SObject>, Database.Stateful {
    User u;
    /**
    * @Author : Manohara Dudi
    * @description :This method used to query the required data.
    * @param bc
    * @return Database.QueryLocator
    */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Integer month = System.today().month();//return number, the month of today
        Integer day = System.today().day();// retun number, the day of today
        string query;
        DateTime lastYeardate = system.now().addYears(-1);// return last year date from today
        DateTime currentyearDate = system.now().addDays(-1);// return previous day
        Integer day1; // Store day value for condition 1
        Integer month1; // Store month value for condition 1
        Integer day2; // Store day value for condition 2
        Integer month2; // Store month value for condition 2
        String detaulOwnerName;
         for(FeatureControl__mdt obj : 
            FeatureControlDomain.getFeatureControlRecord(new set<String>{'1APR','1JUL','CASDEFAULTEOWNER'})){
            if(obj.MasterLabel == '1APR'){
                day1 = Integer.valueOf(obj.Content__c.split(':')[0]);
                month1 = Integer.valueOf(obj.Content__c.split(':')[1]);
            }
            else if(obj.MasterLabel == '1JUL'){
                day2 = Integer.valueOf(obj.Content__c.split(':')[0]);
                month2 = Integer.valueOf(obj.Content__c.split(':')[1]);
            }
            else if(obj.MasterLabel == 'CASDEFAULTEOWNER'){
                detaulOwnerName = obj.Content__c;
            }
        }
        u = UserDomain.searchUserByUserName(detaulOwnerName);
        if(!Test.isRunningTest())
        {
            if (month == month1 && day == day1)
            {
                query = 'SELECT Id, Owner.Type, RecordType.Name, Category__c, Sub_Category__c FROM Case WHERE RecordType.Name =\'Transaction\' AND Category__c =\'Pay and the Basics\' AND Sub_Category__c = \'Salary Sacrifice\' AND CreatedDate >=: lastYeardate  AND CreatedDate <=: currentyearDate AND Status!= \'Closed\'';
                system.debug('query==>'+query);
            }
            else if (month == month2 && day == day2)
            {
                query = 'SELECT Id, Owner.Type, RecordType.Name, Category__c, Sub_Category__c FROM Case WHERE RecordType.Name =\'Query Case\' AND Category__c =\'Pay and the Basics\' AND Sub_Category__c = \'Leave Forms\' AND CreatedDate >=: lastYeardate AND CreatedDate <=: lastYeardate AND Status!= \'Closed\'';
                system.debug('query==>'+query);
            }
        }
        else
        {
            query = 'SELECT Id, Owner.Type, RecordType.Name, Category__c,Priority, Sub_Category__c FROM Case WHERE RecordType.Name IN (\'Transaction\',\'Query Case\') AND Category__c =\'Pay and the Basics\' AND Sub_Category__c IN (\'Computing Device\',\'Leave Forms\') AND CreatedDate <=: currentyearDate';
        }
        
        return Database.getQueryLocator(query);
    }
    /**
    * @Author : Manohara Dudi
    * @description :This method used to perform operations on queried data.
    * @param bc
    * @param scope
    */
    global void execute(Database.BatchableContext bc, List<Case> scope) {
       
        List<Case> caseList= new List<Case>();
        for(Case cs : scope){
            cs.Status='Closed';
            cs.Reason='Rejected';
            cs.CaseApproved__c ='Rejected';
            if(cs.Owner.Type == 'Queue' && u!=null){
                cs.OwnerId = u.Id;
            } 
            caseList.add(cs);
        }
        if(!caseList.isEmpty())
        {
            Database.update(caseList,false);
        }
        System.debug('caseList' + caseList);
    }
    /**
    * @Author : Manohara Dudi
    * @description :This method used to perform final operations.
    * @param bc
    */
    global void finish(Database.BatchableContext bc) {
        System.debug('Finish Block');
    }
}