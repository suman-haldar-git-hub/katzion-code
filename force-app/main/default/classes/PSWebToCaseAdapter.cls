/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-25-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   03-25-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

/**
 *@author : Shubham shukla
 * @description This class is used to write the business logic for PSWebtoCaseForm 
 */ 
public inherited sharing class PSWebToCaseAdapter {
/** 
    *@description This method returns the picklist data on the form of label and value based on the provided object and field...
    *@return List<DropDown>
    *@param objectName
    *@param fieldName
    */
    public static List<DropDown> getPicklistValues(String objectName, String fieldName){
        List<DropDown> data = new List<DropDown>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            DropDown dd = new DropDown();
            dd.value = pickListVal.getValue();
            dd.label = pickListVal.getLabel();
            data.add(dd);
        }
        return data;
    }
    
    /** 
    *@author : Saurabh Bisht
    *@description : This method returns the sub category data based on category...
    *@return List<DropDown>
    */
    public static List<DropDown> getSubCategoryData(){
        List<Related_Value__c> picklistData = RelatedValueDomain.getDataForPS();
        List<DropDown> data = new List<DropDown>();
        if(picklistData!=null){
            for(Related_Value__c p : picklistData){
                DropDown dd = new DropDown();
                dd.label = p.Dependant_Field_Value__r.Picklist_Field_Value__c;
                dd.value = p.Dependant_Field_Value__r.Web_Value__c;
                dd.otherValue = p.Top_Field_Value__r.Picklist_Field_Value__c;
                data.add(dd);
            }
        }
        return data;
    }
    
    /**
    *@author : Saurabh Bisht
    *@description : This method returns the category data...
    *@return : List<DropDown>
    *@param objectName
    *@param fieldName
    */
    public static List<DropDown> getCategoryData(String objectName, String fieldName){
        List<DropDown> data = new List<DropDown>();
        List<Picklist_Field_Value__c> picklistData = PicklistFieldValueDomain.getValues(objectName,fieldName);
        if(picklistData!=null){
            for(Picklist_Field_Value__c p : picklistData){
                DropDown dd = new DropDown();
                dd.label = p.Web_Value__c;
                dd.value = p.Picklist_Field_Value__c;
                if(p.Sub_Category_Mandatory_in_Webform__c){
                    dd.otherValue = 'true';
                }else{
                    dd.otherValue = 'false';
                }
                data.add(dd);
            }
        }
        return data;
    }
    /** 
    *@author : Shubham Shukla
    *@description : This method return the all picklist values
    *@param objempwrapper
    */
    public static void getAllPicklistData(EmployeeRelatedWrapper objempwrapper){
        objempwrapper.categoryData = getCategoryData('Case','Category');
        objempwrapper.subCategoryData = getSubCategoryData();
        objempwrapper.requestFrequencyData = 
            getPicklistValues('Case','Request_Frequency__c');
        objempwrapper.fileFormatData = 
            getPicklistValues('Case','Report_Format__c');
        objempwrapper.contactMethodsData = 
            getPicklistValues('Case','Preferred_Contact_Method__c');
        objempwrapper.audienceData = 
            getPicklistValues('Case','Audience__c');
        objempwrapper.processRequestData = 
            getPicklistValues('Case','New_People_Query_or_Process_Request__c'); 
        objempwrapper.roleData = 
            getCategoryData('Case','What is your role?'); 
    }

    /**
    *@author : Shubham Shukla
    *@description : This method returns getEmployeeRelationdata..
    *@return ListningResponse
    */
    public static LightningResponse getpswebtocase(){
        
        Id level1recordTypeId =
        Schema.SObjectType.Employee_Relation_Master__c.getRecordTypeInfosByDeveloperName().get('Level1').getRecordTypeId();
    
        Id level2recordTypeId =
        Schema.SObjectType.Employee_Relation_Master__c.getRecordTypeInfosByDeveloperName().get('Level2').getRecordTypeId();
    
        Id level3recordTypeId =
        Schema.SObjectType.Employee_Relation_Master__c.getRecordTypeInfosByDeveloperName().get('Level3').getRecordTypeId();
    
        LightningResponse ltngResp = new LightningResponse();
        map<string,list<DropDown>> level2bylevel1 = new 
        map<string,list<DropDown>>(); 
        map<string,list<DropDown>> level3bylevel2 = new 
        map<string,list<DropDown>>();
        map<string,string> furtherInfobylevel2 = new map<string,string>();
        map<string,string> furtherInfobylevel3 = new map<string,string>();
        list<DropDown> level1Values = new 
        list<DropDown>();
        try{
            for (Employee_Relation_Master__c emp: 
                EmployeeRealtionMasterDomain.getEmployeeRelationMaster())   
            {   
                if (emp.Parent_value__c != null 
                    && emp.Parent_value__r.recordtypeid.equals(level1recordTypeId))
                {
                    level2bylevel1 = getlevel2bylevel1(level2bylevel1,emp);
                }
                
                if (emp.Parent_value__c != null 
                    && emp.Parent_value__r.recordtypeid.equals(level2recordTypeId)){
                    level3bylevel2 = getlevel2bylevel1(level3bylevel2,emp);
                }
                getlevel1(level1Values,level1recordTypeId,emp);
                
                if (emp.recordtypeid.equals(level2recordTypeId) &&
                emp.Further_Information__c != null)
                {
                    furtherInfobylevel2.put(
                        emp.Selection_value__c,emp.Further_Information__c);
                    
                }else if (emp.recordtypeid.equals(level3recordTypeId) &&
                emp.Further_Information__c != null){
                    furtherInfobylevel3.put(
                        emp.Selection_value__c,emp.Further_Information__c);
                }
            }

            EmployeeRelatedWrapper objempwrapper = new EmployeeRelatedWrapper();
            objempwrapper.level2bylevel1 = level2bylevel1;
            objempwrapper.level3bylevel2 = level3bylevel2;
            objempwrapper.level1Values = level1Values;
            objempwrapper.furtherInfobylevel2 = furtherInfobylevel2;
            objempwrapper.furtherInfobylevel3 = furtherInfobylevel3;
            getAllPicklistData(objempwrapper);
            ltngResp.payLoad = json.serialize(objempwrapper);
            ltngResp.errorOrSuccessMessage = '';
            ltngResp.isError = false;
        }
        catch (exception ex){
            ltngResp.errorOrSuccessMessage = ex.getMessage();
            ltngResp.isError = True;
        }
        return ltngResp;
    }
    /**
    *@author : Shubham shukla
    *@description : This method is used to create the map for level2 values by level1 
    *@param  level2bylevel1
    *@param  emp 
    *@return level2bylevel1
    */
    private static map<string,list<DropDown>> getlevel2bylevel1(
        map<string,list<DropDown>> level2bylevel1,Employee_Relation_Master__c emp){
    
        if(!level2bylevel1.containskey(emp.Parent_value__r.Selection_value__c)){
            level2bylevel1.put(emp.Parent_value__r.Selection_value__c, 
            new list<DropDown>());
        }
        DropDown obj = new DropDown();
        obj.value = emp.Selection_value__c;
        obj.label = emp.Selection_value__c;
        level2bylevel1.get(emp.Parent_value__r.Selection_value__c).add(obj);
        return level2bylevel1;
    }


    
/**
    *@author : Shubham shukla
    *@description : This method is used to create the map for level2 values by level1 
    *@return level3bylevel2
    *@param level3bylevel2
    *@param emp 
    */
    private static map<string,list<DropDown>> getlevel3bylevel2(
        map<string,list<DropDown>> level3bylevel2,Employee_Relation_Master__c emp){
    
        if(!level3bylevel2.containskey(emp.Parent_value__r.Selection_value__c)){
            level3bylevel2.put(emp.Parent_value__r.Selection_value__c, 
            new list<DropDown>());
        }
        DropDown obj = new DropDown();
        obj.value = emp.Selection_value__c;
        obj.label = emp.Selection_value__c;
        level3bylevel2.get(emp.Parent_value__r.Selection_value__c).add(obj);
        return level3bylevel2;
    }
/**
    *@author : Shubham shukla
    *@description : This method is used to create a list of level1 
    *@param level1Values
    *@param level1recordTypeId
    *@param emp
    */
    private static void getlevel1(list<DropDown> level1Values,
    id level1recordTypeId,Employee_Relation_Master__c emp){
        if (emp.recordtypeid.equals(level1recordTypeId))
        {
            DropDown obj = new DropDown();
            obj.value = emp.Selection_value__c;
            obj.label = emp.Selection_value__c;
            level1Values.add(obj);
        }
    }


/**
    *@author : Shubham shukla
    *@description : This wrapper class is used to EmployeeRelatedmaster
    */
    public class EmployeeRelatedWrapper{
        public map<string,list<DropDown>> level2bylevel1;
        public map<string,list<DropDown>> level3bylevel2;
        public list<DropDown> level1Values;
        public map<string,string> furtherInfobylevel2;
        public map<string,string> furtherInfobylevel3;
        public List<DropDown> categoryData;
        public List<DropDown> subCategoryData;
        public List<DropDown> attachmentData;
        public List<DropDown> requestFrequencyData;
        public List<DropDown> fileFormatData;
        public List<DropDown> contactMethodsData;
        public List<DropDown> audienceData;
        public List<DropDown> processRequestData;
        public List<DropDown> roleData;
        public DropDown userData;        
    }
    
       /** 
    *@author : Shubham shukla
    *@description : This wrapper class is used to store picklist's data...
    */
    public class DropDown{
        public String value;
        public String label;
        public string otherValue;
    }
    
}