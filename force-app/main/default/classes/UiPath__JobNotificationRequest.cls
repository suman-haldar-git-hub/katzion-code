/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class JobNotificationRequest {
    @InvocableVariable(label='Custom Var 1 Name' required=false)
    global String customVar1Name;
    @InvocableVariable(label='Custom Var 1 Value' required=false)
    global String customVar1Value;
    @InvocableVariable(label='Custom Var 2 Name' required=false)
    global String customVar2Name;
    @InvocableVariable(label='Custom Var 2 Value' required=false)
    global String customVar2Value;
    @InvocableVariable(label='Custom Var 3 Name' required=false)
    global String customVar3Name;
    @InvocableVariable(label='Custom Var 3 Value' required=false)
    global String customVar3Value;
    @InvocableVariable(label='Custom Var 4 Name' required=false)
    global String customVar4Name;
    @InvocableVariable(label='Custom Var 4 Value' required=false)
    global String customVar4Value;
    @InvocableVariable(label='Custom Var 5 Name' required=false)
    global String customVar5Name;
    @InvocableVariable(label='Custom Var 5 Value' required=false)
    global String customVar5Value;
    @InvocableVariable(label='Job Count' description='The number of jobs to be created' required=false)
    global Integer jobCount;
    @InvocableVariable(label='Record ID' required=true)
    global String recordId;
    @InvocableVariable(label='ReleaseKey' description='The Release Key for the Process that should be run' required=false)
    global String releaseKey;
    @InvocableVariable(label='Robot Ids' description='Comma separated ids for the Robot(s) selected to run this job' required=false)
    global String robotIds;
    @InvocableVariable(label='Connection Template Name' required=true)
    global String templateName;
    global Map<String,String> validCustomValues;
    global JobNotificationRequest() {

    }
}
