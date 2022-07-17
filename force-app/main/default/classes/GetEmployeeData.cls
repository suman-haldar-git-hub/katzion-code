/**
@author : Sunil
@company : Cognizant
@description : This class is used for Get Employee Data for Learning API.
*/
global without sharing class GetEmployeeData{
    Static Integer counter = 0;
    Static User u = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
    Static IntegrationConfig__c apiDetails = IntegrationConfig__c.getValues('LEARNINGAPIDETAILS');
    Static String accessToken = apiDetails.AccessToken__c;
    private static Map<String, String> labelToContentMap =
        CommunityContentInfoService.getMappingFromMetadeta();
    Static List<UniversalTaskList__c> utl = UniversalTaskListDomain.getLearningTask();
    
    /**
    * @Author : Sunil
    * @description : This method is used to call the learning API.
    */
    global Static void getData(){
        if(!apiDetails.Active__c){return;}
        long learningTimeStamp;
        learningTimeStamp = checkLearningTime(utl);
        HttpRequest req;
        HTTPResponse res;
        try{
        if(accessToken != null && counter < 2 ){
        req = new HttpRequest();
        req.setEndpoint(apiDetails.Endpoint__c.replace('[XXX1]',u.EmployeeID__c).replace
            ('[XXX2]',String.valueOf(learningTimeStamp)));
        req.setMethod(apiDetails.Method__c);
        req.setHeader('Authorization','Bearer '+accessToken);
        req.setTimeOut(120000);
        Http http = new Http();
        res = http.send(req);
        }
        if((res != null && !String.valueOf(res.getStatusCode()).StartsWith('2')) ||
            accessToken == null){
            accessToken  = LearningAPILogin.Login();
            counter += 1;
            apiDetails.AccessToken__c = accessToken;
            if(!test.isRunningTest()){
                getData();
            }
            update apiDetails;
        }
       PublishLogEventService.publishWebCalloutEventAsync(
                'GetEmployeeData.cls on callout',
                '',
                req.getEndpoint(),
                req.getMethod(),
                '',
                res.getBody(),
                res.getStatus()!= null?res.getStatus():'',
                res.getStatusCode(),
                ''
            );
    
    }
    catch(Exception ex){
        PublishLogEventService.publishExceptionEvent(
            'GetEmployeeData.cls on getData',
            ex
        );
    }
    }
    /**
    * @Author : Sunil
    * @description : This method is used to validate Learning Time.
    * @return long
    * @param utl
    */
    public static long checkLearningTime(List<UniversalTaskList__c> utl){
        long learningTimeStamp;
        if(utl.size() > 0){
            learningTimeStamp = utl[0].ReceivedDate__c.getTime();
        }
        else{
            learningTimeStamp = System.Now().addDays(
            Integer.valueOf(labelToContentMap.get('UTLLEARNINGDAYS'))).getTime();
        }
        return learningTimeStamp;
    }

}