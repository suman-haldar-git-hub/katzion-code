/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This Class is used to hold the values of the exception.
*/
public inherited sharing class Exceptionlogwrapper {
    public Exception ex;
    public String debugMessage; //required
    public String debugLevel ; //required
    public String logCode; //required
    public String objectName; 
    public String referenceId; 
    public string source;   //required
    public string sourceFunction; //required
/**
 * @author : Shubham Shukla
 * @company : Cognizant
 * @description : This Class is Constructor to intialise the values 
*/
    public Exceptionlogwrapper(){
        debugMessage ='' ; 
        debugLevel='' ; 
        logCode='';
        objectName=''; 
        referenceId=''; 
        source=''; 
        sourceFunction=''; 
    }

}