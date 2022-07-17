/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This Class is used for publish the platform Events.
*/
public with sharing class PublishLogEventService {

    /**
     * @author : Sunil
     * @description : This method is used to create LogException Event object by passing the debug message
     *                and exception as an input parameter,this is old method of framework. 
     * @return : objectLogExceptionEvent
     * @param  debugMessage
     * @param  ex
    */
    public static LogExceptionEvent__e getLogExceptionEvent(
        string debugMessage,
        Exception ex
    ) {
        LogExceptionEvent__e objectLogExceptionEvent = New LogExceptionEvent__e(
            DebugMessage__c = debugMessage,
            ExceptionLineNumber__c = ex.getLineNumber(),
            ExceptionMessage__c = ex.getMessage(),
            ExceptionStackTrace__c = ex.getStackTraceString(),
            ExceptionTypeName__c = ex.getTypeName(),
            User__c = UserInfo.getUserId()
        );
        return objectLogExceptionEvent;
    }
    /** 
    * @author : Sunil
    * @description : isBypassed Trigger Handler,this is old method of framework.
    * @param  debugMessage
    * @param  ex 
    */
    public static void publishExceptionEvent(
        string debugMessage,
        Exception ex
    ) {
            LogExceptionEvent__e objectLogExceptionEvent = New LogExceptionEvent__e(
            DebugMessage__c = debugMessage,
            ExceptionLineNumber__c = ex.getLineNumber(),
            ExceptionMessage__c = ex.getMessage(),
            ExceptionStackTrace__c = ex.getStackTraceString(),
            ExceptionTypeName__c = ex.getTypeName(),
            User__c = UserInfo.getUserId()
        );
        LogExceptionDomain.publishLogExceptionEvent(objectLogExceptionEvent);
    }   
    /** 
    * @author : Sunil
    * @description : This method is used to publish LogWebCallout Platform Event,this is old method of framework.
    * @param  debugMessage
    * @param  req
    * @param  res
    */
    public static void publishWebCalloutEvent(
        String debugMessage,
        HTTPRequest req,
        HTTPResponse res
    ) {
        LogWebCalloutEvent__e objectLogWebCalloutEvent = New LogWebCalloutEvent__e();
        objectLogWebCalloutEvent.DebugMessage__c = debugMessage;
        objectLogWebCalloutEvent.HTTPRequestBody__c = req.getBody();
        objectLogWebCalloutEvent.HTTPRequestEndpoint__c = req.getEndpoint();
        objectLogWebCalloutEvent.HTTPRequestMethod__c = req.getMethod();
        objectLogWebCalloutEvent.HTTPResponseStatusCode__c = string.valueof(res.getStatusCode());
        objectLogWebCalloutEvent.User__c = UserInfo.getUserId();
        objectLogWebCalloutEvent.HTTPResponseStatusMessage__c = res.getStatus();
        /*objectLogWebCalloutEvent.HTTPRequestHeader__c = string.valueof(
            Label.AGENT_ID+'-'+req.getHeader(Label.AGENT_ID)+','+
            Label.LOCATION_ID+'-'+req.getHeader(Label.LOCATION_ID)+','+
            Label.CORRELATIONID+'-'+req.getHeader(Label.CORRELATIONID)
        );*/
        objectLogWebCalloutEvent.HTTPResponseBody__c = res.getBody();
        objectLogWebCalloutEvent.HTTPResponseHeader__c = string.valueof(res.getHeaderKeys());
        LogWebCalloutDomain.publishLogWebCalloutEventEvent(objectLogWebCalloutEvent);

    }
    /** 
    @author : Rishi
    @company : SaaSFocus
    @description : This method is used to publish LogWebCallout Platform Event for Rest Services,this is old method of framework.
    @param debugMessage
    @param req
    @param res
    @param resBody
    */
    public static void publishWebCalloutEventForRestServices(
        String debugMessage,
        RestRequest req,
        RestResponse res,
        string resBody
    ) {
        LogWebCalloutEvent__e objectLogWebCalloutEvent = New LogWebCalloutEvent__e();
        objectLogWebCalloutEvent.DebugMessage__c = debugMessage;
        objectLogWebCalloutEvent.HTTPRequestBody__c = (
            req.requestBody != null ? req.requestBody.toString() : ''
        );
        objectLogWebCalloutEvent.HTTPRequestEndpoint__c = req.resourcePath;
        objectLogWebCalloutEvent.HTTPRequestMethod__c = req.httpMethod;
        objectLogWebCalloutEvent.HTTPResponseStatusCode__c = (
            res.statusCode != null ? String.valueof(res.statusCode) : ''
        );
        objectLogWebCalloutEvent.User__c = UserInfo.getUserId();
        objectLogWebCalloutEvent.HTTPRequestHeader__c = JSON.serialize(req.headers);
        objectLogWebCalloutEvent.HTTPResponseBody__c = resBody;
        objectLogWebCalloutEvent.HTTPResponseHeader__c = JSON.serialize(res.headers);
        LogWebCalloutDomain.publishLogWebCalloutEventEvent(objectLogWebCalloutEvent);
    }
    /** 
    @author : sunil
    @company : SaaSFocus
    @description : This method is used to publish Platform Event Log for Rest Services,this is old method of framework.
    @param debugMessage
    @param body
    */
    public static void publishPlatformEventLogs(String debugMessage, string body){
        LogWebCalloutEvent__e objectLogWebCalloutEvent = New LogWebCalloutEvent__e();
        objectLogWebCalloutEvent.DebugMessage__c = debugMessage;
        objectLogWebCalloutEvent.User__c = UserInfo.getUserId();
        objectLogWebCalloutEvent.HTTPResponseBody__c = body;
        LogWebCalloutDomain.publishLogWebCalloutEventEvent(objectLogWebCalloutEvent);
    }

    /**
     * @author: Prashant Kumar
     * @company: SaaSfocus
     * @description : This method used to publish web callout async.
     * @param debugMessage
     * @param reqBody
     * @param reqEndPoint
     * @param reqMethod
     * @param resHeaders
     * @param resBody
     * @param resStatus
     * @param resCode
     * @param reqHeaders
     */
    @future
    public static void publishWebCalloutEventAsync(
            String debugMessage,
            String reqBody,
            String reqEndPoint,
            String reqMethod,
            String resHeaders,
            String resBody,
            String resStatus,
            Integer resCode,
            String reqHeaders
    ) {
        LogWebCalloutEvent__e eventObj = New LogWebCalloutEvent__e();
        eventObj.DebugMessage__c = debugMessage;
        eventObj.HTTPRequestBody__c = reqBody;
        eventObj.HTTPRequestEndpoint__c = reqEndPoint;
        eventObj.HTTPRequestMethod__c = reqMethod;
        eventObj.HTTPResponseStatusCode__c = String.valueof(resCode);
        eventObj.User__c = UserInfo.getUserId();
        eventObj.HTTPResponseStatusMessage__c = resStatus;
        eventObj.HTTPResponseBody__c = resBody;
        eventObj.HTTPResponseHeader__c = resHeaders;
        eventObj.HTTPRequestHeader__c = reqHeaders;
        LogWebCalloutDomain.publishLogWebCalloutEventEvent(eventObj);
    }
    /**
     * @author : Shubham Shukla
     * @description : This method is used to create LogException Event object by passing the debug message
     *                and exception as an input parameter.
     * @param exceptionwrapp
     * @param objectLogExceptionEvent
    */
    private static void getLogExceptionEvent(ExceptionLogwrapper exceptionwrapp
        ,LogExceptionEvent__e objectLogExceptionEvent){
        getlogforexecution(exceptionwrapp,objectLogExceptionEvent);
    }
    /**
     * @author : Shubham Shukla
     * @description : This method is used to get log debug for execution.
     * @param exceptionwrapp
     * @param objectLogExceptionEvent 
    */
        
    private static void getlogforexecution(ExceptionLogwrapper exceptionwrapp,
        LogExceptionEvent__e objectLogExceptionEvent){
        objectLogExceptionEvent.DebugMessage__c = exceptionwrapp.debugMessage;
        if (exceptionwrapp.ex != null){
            objectLogExceptionEvent.ExceptionLineNumber__c = exceptionwrapp.ex.getLineNumber();
            objectLogExceptionEvent.ExceptionMessage__c = exceptionwrapp.ex.getMessage();
            objectLogExceptionEvent.ExceptionStackTrace__c = exceptionwrapp.ex.getStackTraceString();
            objectLogExceptionEvent.ExceptionTypeName__c = exceptionwrapp.ex.getTypeName();
        }
        objectLogExceptionEvent.LogCode__c =   exceptionwrapp.logCode;
        objectLogExceptionEvent.ObjectName__c = exceptionwrapp.objectName;
        objectLogExceptionEvent.DebugLevel__c = exceptionwrapp.debugLevel;
        objectLogExceptionEvent.ReferenceId__c = exceptionwrapp.referenceId;
        objectLogExceptionEvent.Source__c = exceptionwrapp.Source;
        objectLogExceptionEvent.Sourcefunction__c = exceptionwrapp.sourceFunction;
        objectLogExceptionEvent.User__c = userinfo.getuserid();
    }
    
    /** 
    * @author : Shubham Shukla
    * @description : isBypassed Trigger Handler.
    * @param  exceptionwrapp
    */
    public static void publishExceptionEvent(ExceptionLogwrapper exceptionwrapp
    ) {
        LogExceptionEvent__e objectLogExceptionEvent = new LogExceptionEvent__e();
        getLogExceptionEvent(exceptionwrapp,objectLogExceptionEvent);
        LogExceptionDomain.publishLogExceptionEvent(objectLogExceptionEvent);
    }

/** 
    * @author : Shubham Shukla
    * @description : isBypassed Trigger Handler.
    * @param  webservicewrapp
    */
    public static void publishWebCalloutEvent(
        webcalloutLogwrapper webservicewrapp
    ) {
        LogWebCalloutEvent__e objectLogWebCalloutEvent = new LogWebCalloutEvent__e();
        getLogWebCallEvent(webservicewrapp,objectLogWebCalloutEvent);
        LogWebCalloutDomain.publishLogWebCalloutEventEvent(objectLogWebCalloutEvent);
    }

    /**
     * @author : Shubham Shukla
     * @description : This method is used to create LogException Event object by passing the debug message
     *                and exception as an input parameter.
     * @param  webservicewrapp
     * @param  objectLogWebCalloutEvent
    */
    private static void getLogWebCallEvent(webcalloutLogwrapper webservicewrapp,
    LogWebCalloutEvent__e objectLogWebCalloutEvent){
        getlogforwebcall(webservicewrapp,objectLogWebCalloutEvent);
    }

/**
     * @author : Shubham Shukla
     * @description : This method is used to get log for webcall.
     * @param  webservicewrapp
     * @param  objectLogWebCalloutEvent
    */
        
    private static void getlogforwebcall(webcalloutLogwrapper webservicewrapp,
    LogWebCalloutEvent__e objectLogWebCalloutEvent){
        objectLogWebCalloutEvent.DebugMessage__c = webservicewrapp.debugMessage;
        objectLogWebCalloutEvent.HTTPRequestBody__c = webservicewrapp.HTTPRequestBody;
        objectLogWebCalloutEvent.HTTPRequestEndpoint__c = webservicewrapp.httpRequestEndpoint;
        objectLogWebCalloutEvent.HTTPRequestMethod__c = webservicewrapp.httpRequestMethod;
        objectLogWebCalloutEvent.HTTPResponseStatusCode__c = webservicewrapp.HTTPResponseStatusCode;
        objectLogWebCalloutEvent.HTTPResponseStatusMessage__c = webservicewrapp.HTTPResponseStatusMessage;
        objectLogWebCalloutEvent.HTTPResponseBody__c = webservicewrapp.HTTPResponseBody;
        objectLogWebCalloutEvent.HTTPResponseHeader__c = webservicewrapp.HTTPResponseHeader;
        objectLogWebCalloutEvent.debugLevel__c = webservicewrapp.debugLevel;
        objectLogWebCalloutEvent.logCode__c = webservicewrapp.logCode;
        objectLogWebCalloutEvent.referenceId__c = webservicewrapp.referenceId;
        objectLogWebCalloutEvent.Source__c = webservicewrapp.source;
        objectLogWebCalloutEvent.logType__c = webservicewrapp.logType;
        objectLogWebCalloutEvent.User__c = userinfo.getuserid();
    }   
}