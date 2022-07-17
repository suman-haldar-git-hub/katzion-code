/**     
    * @Name CustomToolTipsController
    * @description Generic Class to get Configuration custom Metadata Values
    * @author Aman Kumar | 01-18-2022 
    **/

public class CustomToolTipsController {
    
    
    /**     
    * @description Generic Class to get Configuration custom Metadata Values
    * @author Aman Kumar | 01-18-2022 
    * @param formName
    * @return mdtObj
    **/
    @AuraEnabled
    public static Configuration_Settings__mdt customToolTipsMdt(string formName){
        try {
            List<Configuration_Settings__mdt> mdtList = Configuration_Settings__mdt.getall().values();
            Configuration_Settings__mdt mdtObj = new Configuration_Settings__mdt();
            
            if( mdtList.size()> 0){
                for(Configuration_Settings__mdt mdt : mdtList){
                    if(mdt.DeveloperName == formName){
                        mdtObj = mdt;
                        break;
                    }
                }
                return mdtObj;
            }
            else{
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}