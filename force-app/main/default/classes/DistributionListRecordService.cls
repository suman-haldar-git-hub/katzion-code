/** 
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This Service Class is used for Create/Edit action on Distribution List Object.
This class is used in DistributionRecordManage Lightninhg component.
*/
public with sharing class DistributionListRecordService {
    /** 
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This inner class will make the wrapper of requested data on load.
*/
    public class DistributionFormWrapper {
        List<DistributionList__c> distributionList;
        Map<String, string> mapOfCompany;
        Map<String, string> mapOfGroup;
        Map<String, string> mapOfGroupCode;        
        Map<String, string> mapOfBrand;
        Map<String, string> mapOfSupport;
        Map<String, string> mapOfRegion;
        Map<String, string> mapOfArea;        
        Map<String, string> mapOfCompanyCode;
        Map<String, string> mapOfCompanyToGroup;
        Map<String, string> mapOfGroupToBrand;
        Map<String, string> mapOfBrandToOpsSupport;
        Map<String, string> mapOfOpsSupportToRegion;
        Map<String, string> mapOfRegionToArea;
        Map<String, List<String>> mapOfCompanyToGroupList;
        Map<String, List<String>> mapOfGroupToBrandList;
        Map<String, List<String>> mapOfBrandToOpsSupportList;
        Map<String, List<String>> mapOfOpsSupportToRegionList;
        Map<String, List<String>> mapOfRegionToAreaList;
        String loggedinUserProfileName;
        Account objAccount; // get logged in User person Account data.
        List<String> employeeGroupList;
        Map<String,string> employeeGroupMap;
        List<String> employeeSubGroupList;
        Map<String,String> employeeSubGroupMap;
        List<String> careerLevelList;
        Map<String,String> careerLevelMap;
        List<String> lineManagerList;
        Map<String,String> lineManagerMap;
        List<String> doaFlagList;
        Map<String,String> doaFlagMap;
        List<String> locationList;
        Map<String,String> locationMap;
        List<String> tmIdentifierList;
        Map<String,String> tmIdentifierMap;
        List<String> countryList;
        Map<String,String> countryMap;
        Map<String,String> mapOfCodeToWeb;
    }
    /**
* @author : Ankit Singh
* @description : This method return DistributionFormWrapper data on component load
* @return : LightningResponse
*/
    @AuraEnabled
    public static LightningResponse getDistributionFormWrapperData() {
        LightningResponse response = new LightningResponse();
        try{
            Account accountRecd = new Account();
            User userDetail = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
            String userEmpId = userDetail.EmployeeID__c;
            if(String.isNotBlank(userEmpId)){
                accountRecd = AccountDomain.queryAccountBasedOnEmpId(userEmpId);
            }
            Profile profileRecd = 
                ProfileDomain.queryProfileBasedOnId(UserInfo.getProfileId());
            List<String> fieldApiList = (Label.FIELDAPIVALUESOFOBJECTFIELD).split(',');
            String webKeyValue = '';
            Map<String, List<String>> mapOfCompanyToGroupList = 
                new Map<String, List<String>>();
            Map<String, List<String>> mapOfGroupToBrandList = 
                new Map<String, List<String>>();
            Map<String,String> mapOfCodeToWeb = new Map<String,String>();
            Map<String,String> mapOfCompany = new Map<String,String>();
            Map<String,String> mapOfGroup = new Map<String,String>();
            Map<String,String> mapOfGroupCode = new Map<String,String>();
            Map<String,String> mapOfBrand = new Map<String,String>();
            Map<String,String> mapOfSupport = new Map<String,String>();
            Map<String,String> mapOfRegion = new Map<String,String>();
            Map<String,String> mapOfArea = new Map<String,String>();
            Map<String,String> mapOfCompanyCode = new Map<String,String>();
            Map<String,String> mapOfCompanyToGroup = new Map<String,String>();
            Map<String,String> mapOfGroupToBrand = new Map<String,String>();
            Map<String,String> mapOfBrandToOpsSupport = new Map<String,String>();
            Map<String,String> mapOfOpsSupportToRegion = new Map<String,String>();
            Map<String,String> mapOfRegionToArea = new Map<String,String>();
            Map<String, List<String>> mapOfBrandToOpsSupportList = 
                new Map<String, List<String>>();
            Map<String, List<String>> mapOfOpsSupportToRegionList = 
                new Map<String, List<String>>();
            Map<String, List<String>> mapOfRegionToAreaList = 
                new Map<String, List<String>>();
            List<String> employeeGroupList = new List<String>();
            Map<String,string> employeeGroupMap = new Map<string,string>();
            List<String> employeeSubGroupList = new List<String>();
            Map<String,String> employeeSubGroupMap = new Map<String,String>();
            List<String> careerLevelList = new List<String>();
            Map<String,String> careerLevelMap = new Map<String,String>();
            List<String> lineManagerList = new List<String>();
            Map<String,String> lineManagerMap = new Map<String,String>();
            List<String> doaFlagList = new List<String>();
            Map<String,String> doaFlagMap = new Map<String,String>();
            List<String> locationList = new List<String>();
            Map<String,String> locationMap = new Map<String,String>();
            List<String> tmIdentifierList = new List<String>();
            Map<String,String> tmIdentifierMap = new Map<String,String>();
            List<String> countryList = new List<String>();
            Map<String,String> countryMap = new Map<String,String>();
            //getting records of Object_Field__c object.
            Map<Id,Object_Field__c> objectFieldMap = 
                ObjectFieldDomain.getMapOfObjectFieldRecords(fieldApiList, 'DistributionList__c');
            //getting records of Picklist_Field_Value__c object.
            Map<Id, Picklist_Field_Value__c> picklistFieldValueMap = 
                PicklistFieldValueDomain.getMapOfPicklistFieldValueRecords(objectFieldMap.keySet());
            //getting records of Related_Value__c object.
            Map<Id, Related_Value__c> relatedValueMap = 
                RelatedValueDomain.getMapOfRelatedValueRecords(picklistFieldValueMap.keySet());
            for(Id relatedValueId : relatedValueMap.keySet()){
                //getting Picklist_Field_Value__c values
                Picklist_Field_Value__c topPickFieldValueRecd = 
                    picklistFieldValueMap.get(relatedValueMap.get(relatedValueId).Top_Field_Value__c);
                String topPicklistFieldUniqueKey =
                    topPickFieldValueRecd.PrimaryUniqueKey__c;
                String topPicklistFieldValueStr =
                    topPickFieldValueRecd.PrimaryUniqueKey__c;//Picklist_Field_Value__c;
                String topWebFieldValueStr = 
                    topPickFieldValueRecd.Web_Value__c;
                Picklist_Field_Value__c dependPickFieldValueRecd = 
                    picklistFieldValueMap.get(relatedValueMap.get(relatedValueId).Dependant_Field_Value__c);
                String dependPicklistFieldValueStr = 
                    dependPickFieldValueRecd.Picklist_Field_Value__c;
                String dependPrimaryUniqueValueStr = 
                    dependPickFieldValueRecd.PrimaryUniqueKey__c;
                String dependWebValueFieldValueStr = 
                    dependPickFieldValueRecd.Web_Value__c;
                //getting Object_Field__c values
                Object_Field__c topObjectFieldRecd = 
                    objectFieldMap.get(topPickFieldValueRecd.Object_Field__c);
                Object_Field__c dependObjectFieldRecd = 
                    objectFieldMap.get(dependPickFieldValueRecd.Object_Field__c);
                switch on topObjectFieldRecd.Field_API__c{
                    when 'Company__c'{
                        webKeyValue = topPicklistFieldUniqueKey;
                        if(mapOfCompanyToGroupList.containsKey(webKeyValue)){
                            mapOfCompanyToGroupList.get(webKeyValue).add
                                (dependPrimaryUniqueValueStr);
                        }
                        else{
                            mapOfCompanyToGroupList.put
                                (webKeyValue,
                                 new List<String>{dependPrimaryUniqueValueStr});
                        }
                        mapOfCompany.put(webKeyValue,topWebFieldValueStr);//group
                        mapOfCompanyCode.put(topWebFieldValueStr,topPicklistFieldValueStr);
                        mapOfCompanyToGroup.put(dependWebValueFieldValueStr,dependPrimaryUniqueValueStr);
                        mapOfCodeToWeb.put(topPicklistFieldValueStr,topWebFieldValueStr);
                    }
                    when 'Group__c'{
                        webKeyValue = topPicklistFieldUniqueKey;
                        if(mapOfGroupToBrandList.containsKey(webKeyValue)){
                            mapOfGroupToBrandList.get(webKeyValue).add
                                (dependPrimaryUniqueValueStr);
                        }
                        else{
                            mapOfGroupToBrandList.put
                                (webKeyValue,
                                 new List<String>{dependPrimaryUniqueValueStr});
                        }
                        mapOfGroup.put(webKeyValue,topWebFieldValueStr);//group
                        mapOfGroupCode.put(topWebFieldValueStr,topPicklistFieldValueStr);
                        mapOfGroupToBrand.put(dependWebValueFieldValueStr,dependPrimaryUniqueValueStr);
                        mapOfBrand.put(dependWebValueFieldValueStr, dependPicklistFieldValueStr);
                       mapOfCodeToWeb.put(topPicklistFieldValueStr,topWebFieldValueStr);
                    }
                    when 'Brand__c'{
                        webKeyValue = topPicklistFieldUniqueKey;
                        if(mapOfBrandToOpsSupportList.containsKey(webKeyValue)){
                            mapOfBrandToOpsSupportList.get(webKeyValue).add
                                (dependPrimaryUniqueValueStr);
                        }
                        else{
                            mapOfBrandToOpsSupportList.put
                                (webKeyValue,
                                 new List<String>{dependPrimaryUniqueValueStr});
                        }
                        mapOfBrandToOpsSupport.put(dependWebValueFieldValueStr,dependPrimaryUniqueValueStr);
                        mapOfSupport.put(dependWebValueFieldValueStr, dependPicklistFieldValueStr);
                        mapOfCodeToWeb.put(topPicklistFieldValueStr,topWebFieldValueStr);
                    }
                    when 'OpsSupport__c'{
                        webKeyValue = topPicklistFieldUniqueKey;
                        if(mapOfOpsSupportToRegionList.containsKey(webKeyValue)){
                            mapOfOpsSupportToRegionList.get(webKeyValue).add
                                (dependPrimaryUniqueValueStr);
                        }
                        else{
                            mapOfOpsSupportToRegionList.put
                                (webKeyValue,
                                 new List<String>{dependPrimaryUniqueValueStr});
                        }
                        mapOfOpsSupportToRegion.put(dependWebValueFieldValueStr,dependPrimaryUniqueValueStr);
                        mapOfRegion.put(dependWebValueFieldValueStr, dependPicklistFieldValueStr);
                        mapOfCodeToWeb.put(topPicklistFieldValueStr,topWebFieldValueStr);
                    }
                    when 'Region__c'{
                        webKeyValue = topPicklistFieldUniqueKey;
                        if(mapOfRegionToAreaList.containsKey(webKeyValue)){
                            mapOfRegionToAreaList.get(webKeyValue).add
                                (dependPrimaryUniqueValueStr);
                        }
                        else{
                            mapOfRegionToAreaList.put
                                (webKeyValue,
                                 new List<String>{dependPrimaryUniqueValueStr});
                        }
                        mapOfRegionToArea.put(dependWebValueFieldValueStr,dependPrimaryUniqueValueStr);
                        mapOfArea.put(dependWebValueFieldValueStr, dependPicklistFieldValueStr);
                        mapOfCodeToWeb.put(topPicklistFieldValueStr,topWebFieldValueStr);
                    }
                }
            }
            for(Id picklistFieldValueId : picklistFieldValueMap.keySet()){
                Picklist_Field_Value__c picklistFieldValueRecd = 
                    picklistFieldValueMap.get(picklistFieldValueId);
                String picklistFieldValueStr = picklistFieldValueRecd.Picklist_Field_Value__c; 
                String picklistWebValueStr = picklistFieldValueRecd.Web_Value__c; 
                string picklistFieldUniqueKey = picklistFieldValueRecd.PrimaryUniqueKey__c;
                Object_Field__c objectFieldRecd = 
                    objectFieldMap.get(picklistFieldValueRecd.Object_Field__c);
                switch on objectFieldRecd.Field_API__c{
                    when 'EmployeeGroup__c'{
                        employeeGroupList.add(picklistWebValueStr);
                        employeeGroupMap.put(picklistWebValueStr,picklistFieldValueStr);
                    }
                    when 'EmployeeSubgroup__c'{
                        employeeSubGroupList.add(picklistWebValueStr);
                        employeeSubGroupMap.put(picklistWebValueStr,picklistFieldValueStr);
                    }
                    when 'CareerLevel__c'{
                        careerLevelList.add(picklistFieldUniqueKey);
                        careerLevelMap.put(picklistWebValueStr,picklistFieldUniqueKey);
                        mapOfCodeToWeb.put(picklistFieldUniqueKey,picklistWebValueStr);
                    }
                    when 'HasDOA__c'{
                        doaFlagList.add(picklistWebValueStr);
                        doaFlagMap.put(picklistWebValueStr,picklistFieldValueStr);
                    }
                    when 'IsLineManager__c'{
                        lineManagerList.add(picklistWebValueStr);
                        lineManagerMap.put(picklistWebValueStr,picklistFieldValueStr);
                    }
                    when 'Country__c'{
                        countryList.add(picklistWebValueStr);
                        countryMap.put(picklistWebValueStr,picklistFieldValueStr);
                    }
                    when 'Location__c'{
                        locationList.add(picklistWebValueStr);
                        locationMap.put(picklistWebValueStr,picklistFieldValueStr);
                    }
                    when 'TeamMemberIdentifier__c'{
                        tmIdentifierList.add(picklistFieldValueStr);
                        tmIdentifierMap.put(picklistWebValueStr,picklistFieldValueStr);
                        mapOfCodeToWeb.put(picklistFieldUniqueKey,picklistWebValueStr);
                    }
                    when 'Area__c'{
                        mapOfCodeToWeb.put(picklistFieldUniqueKey,picklistWebValueStr);
                    }
                }
            }
            DistributionFormWrapper objWrapper = new DistributionFormWrapper();
            objWrapper.mapOfBrand = mapOfBrand;
            objWrapper.mapOfSupport = mapOfSupport;
            objWrapper.mapOfRegion = mapOfRegion;
            objWrapper.mapOfArea = mapOfArea;
            objWrapper.mapOfCompany = mapOfCompany;
            objWrapper.mapOfGroup = mapOfGroup;
            objWrapper.mapOfGroupCode = mapOfGroupCode;
            objWrapper.mapOfCompanyCode = mapOfCompanyCode;
            objWrapper.mapOfCompanyToGroup = mapOfCompanyToGroup;
            objWrapper.mapOfGroupToBrand = mapOfGroupToBrand;
            objWrapper.mapOfBrandToOpsSupport = mapOfBrandToOpsSupport;
            objWrapper.mapOfOpsSupportToRegion = mapOfOpsSupportToRegion;
            objWrapper.mapOfRegionToArea = mapOfRegionToArea;
            objWrapper.mapOfCompanyToGroupList = mapOfCompanyToGroupList;
            objWrapper.mapOfGroupToBrandList = mapOfGroupToBrandList;
            objWrapper.mapOfBrandToOpsSupportList = mapOfBrandToOpsSupportList;
            objWrapper.mapOfOpsSupportToRegionList = mapOfOpsSupportToRegionList;
            objWrapper.mapOfRegionToAreaList = mapOfRegionToAreaList;
            objWrapper.distributionList = new List<DistributionList__c>();
            objWrapper.objAccount = accountRecd;
            objWrapper.loggedinUserProfileName = profileRecd.Name;
            objWrapper.employeeGroupList = employeeGroupList;
            objWrapper.employeeGroupMap = employeeGroupMap;
            objWrapper.employeeSubGroupList = employeeSubGroupList;
            objWrapper.employeeSubGroupMap = employeeSubGroupMap;
            objWrapper.careerLevelList = careerLevelList;
            objWrapper.careerLevelMap = careerLevelMap;
            objWrapper.doaFlagList = doaFlagList;
            objWrapper.doaFlagMap = doaFlagMap;
            objWrapper.lineManagerList = lineManagerList;
            objWrapper.lineManagerMap = lineManagerMap;
            objWrapper.countryList = countryList;
            objWrapper.countryMap = countryMap;
            objWrapper.locationList = locationList;
            objWrapper.locationMap = locationMap;
            objWrapper.tmIdentifierList = tmIdentifierList;
            objWrapper.tmIdentifierMap = tmIdentifierMap;
            objWrapper.mapOfCodeToWeb = mapOfCodeToWeb ;
            response.payLoad = JSON.serialize(objWrapper);
        }
        catch (Exception ex) {
            //log exception
            response.isError=true;
            response.errorOrSuccessMessage = ex.getMessage();
            PublishLogEventService.publishExceptionEvent(
                'DistributionListRecordService.cls on load',
                ex
            );
        }
        return response;
    }
    /**
* @author : Monika Bisht
* @description : This method return owner Profile on component load
* @return : string
* @param  recordId
*/
    @AuraEnabled
    public static ReturnWrapper editDLForBuAdmin(string recordId) {
        ReturnWrapper objWrappper = new ReturnWrapper();
        try{
            profile objProfile =  ProfileDomain.queryProfileBasedOnId(UserInfo.getProfileId());
            objWrappper.currentLoginUserProfile = objProfile.Name;
            DistributionList__c objDistribution = DistributionDomain.getDistributionByRecordId(recordId);
            if(String.isNotBlank(objDistribution.ownerId))
            {
                objWrappper.currentUserCreatedById = objDistribution.ownerId;
            }
            if(!objDistribution.Audiences__r.isEmpty()){
                for(Audience__c objAud : objDistribution.Audiences__r){
                    if(objAud.Communication__c != null
                       && objAud.Communication__r.ScheduledDate__c != null
                       && objAud.Communication__r.ScheduledDate__c >= system.now()){
                           objWrappper.isValid = true;
                       }
                }
            }   
        }
        catch(Exception ex){
            //log exception
            PublishLogEventService.publishExceptionEvent(
                'DistributionListRecordService.cls on editDLForBuAdmin',
                ex
            );
        }
        return objWrappper;
    }
    /**
* @author : Monika Bisht
* @description : Wrapper class used to pass data 
*/
    Public class ReturnWrapper{
        @AuraEnabled
        Public string currentLoginUserProfile;
        @AuraEnabled
        Public string currentUserCreatedById;
        @AuraEnabled
        Public Boolean isValid;
        /**
* @author : Monika Bisht
* @description : constructor class of wrapper 
*/
        Public returnWrapper(){
            isValid = false;
        }
    }
}