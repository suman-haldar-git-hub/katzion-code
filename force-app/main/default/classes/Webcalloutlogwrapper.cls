/** 
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This Class is used to hold the values of the webcallout.
*/
public inherited sharing class Webcalloutlogwrapper {
    public String debugMessage;  //required
    public String debugLevel ; //required 
    public String logCode; //required
    public String referenceId; 
    public string source;   //required 
    public string sourceFunction; 
    public string httpRequestBody; 
    public string httpRequestEndpoint; 
    public string httpRequestHeader; 
    public string httpRequestMethod; 
    public string httpResponseBody; 
    public string httpResponseStatusCode; 
    public string httpResponseStatusMessage; 
    public string logType; 
    public string httpResponseHeader; 
  /** 
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This is constructor of this class which is used to intialise the values
*/  
    public Webcalloutlogwrapper() { 
        debugMessage = '';
        debugLevel = '' ; 
        logCode = ''; 
        referenceId = ''; 
        source='';   
        sourceFunction=''; 
        httpRequestBody=''; 
        httpRequestEndpoint='';
        httpRequestHeader=''; 
        httpRequestMethod=''; 
        httpResponseBody=''; 
        httpResponseStatusCode=''; 
        httpResponseStatusMessage=''; 
        logType=''; 
        httpResponseHeader='';
    }

}