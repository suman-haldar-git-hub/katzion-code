/**
 * @author       Abhishek Setia
 * @description  Gets Cases data to be shown in 'Archive' tab.
*/
public with sharing class ArchiveCaseService {
    
    private static Map<String,String> customMetadataMap;

    // This map is particularly used for sorting.
    private static Map<String,String> mapCasesColumns=new Map<String,String>{
        'description' => 'Subject',
        'type' => 'TeamHubApplicationType__c',
        'completionDate' => 'ClosedDate'        
    };

    /**
     * @author      Abhishek Setia
     * @description Maps case columns based on request type selection
     *              from ui
     * @param       reqWrap
     * @param       customMetadataMap
     */
    private static void mapCasesColumnsConditional(
        ArchiveController.RequestWrapper reqWrap,
        Map<String,String> customMetadataMap){
            if(reqWrap.types.contains(customMetadataMap.get('SALARYSACRIFICEREQUESTTYPE'))){
                mapCasesColumns.put('status','CaseApproved__c');
            }else{
                mapCasesColumns.put('status','Status');
            }
    }

    /**
     * @author      Abhishek Setia
     * @description Get CustomMetadata mappings
     * @return      Map<String,String>
     */
    private static Map<String,String> getCustomMetadata(){
        Set<String> developerNames=new Set<String>{'MYAPPLICATIONS','SALARYSACRIFICEREQUESTTYPE',
        'LEAVEREQUESTTYPE','REQUESTSTYPE','CASESTATUSCLOSED','ARCHIVE','CASEORIGINTEAMSPACE','CASEORIGINTEAMHUB',
        'LAPTOPDEVICE','MOBILEPHONEDEVICE','TABLETDEVICE','SMARTWATCHDEVICE','CASESUBCATSALARYSACRIFICE',
        'CASERECORDTYPENAMEQUERYCASE','CASEAPPROVED','CASEREJECTED','CASEPROCESSED',
        'TEAMHUBAPPLICATIONTYPELEAVE','TEAMHUBAPPLICATIONTYPESALARYSACRIFICE','REQUESTS',
        'TEAMHUBAPPLICATIONTYPEWPS','WPSREQUESTTYPE','CASESTATUSOPEN'};
        return CommunityContentInfoService.getCommunityContentInfoMapping(developerNames);
    }

    /**
     * @author      Abhishek Setia
     * @description Get UniversalTaskList__c records to be shown in 'Archive' tab.
     * @param       reqWrap - Value from JScript. Filter criteria for UniversalTaskList__c records
     * @return      ArchiveCaseWrapper
     */
    public static ArchiveCaseWrapper getRecords(ArchiveController.RequestWrapper reqWrap){
        customMetadataMap=getCustomMetadata();  
        ArchiveCaseWrapper acWrapper=new ArchiveCaseWrapper();        
        if(String.isNotBlank(reqWrap.types) && (
            reqWrap.types.contains(customMetadataMap.get('LEAVEREQUESTTYPE')) || 
            reqWrap.types.contains(customMetadataMap.get('SALARYSACRIFICEREQUESTTYPE')) || 
            reqWrap.types.contains(customMetadataMap.get('REQUESTSTYPE')) ||
            reqWrap.types.contains(customMetadataMap.get('TEAMHUBAPPLICATIONTYPEWPS')))
        ){                
            mapCasesColumnsConditional(reqWrap,customMetadataMap);
            ParameterWrapper pw = getParameterWrapper(reqWrap);
            if(pw.strList3!=null && !pw.strList3.isEmpty()){
                List<Case> listCases = CaseDomain.salarySacrificeCasesOnAccount(pw,customMetadataMap);
                acWrapper.recordCount=listCases.size();
                if(reqWrap.calculateTotalRecords){
                    acWrapper.totalCount=CaseDomain.countCases(pw,customMetadataMap);
                }
                fillArchiveWrapperForCase(listCases,acWrapper,pw);
            }                            
        }
        return acWrapper;     
    }

    /**
     * @author      Abhishek Setia
     * @description Initialize values in ParameterWrapper object
     * @param       reqWrap - Type 'ArchiveController.RequestWrapper'
     * @return      ParameterWrapper object  
     */
    private static ParameterWrapper getParameterWrapper(ArchiveController.RequestWrapper reqWrap){
        ParameterWrapper pw=new ParameterWrapper();
        User usr = UserDomain.queryUserBasedOnId(UserInfo.getUserId());
        if(usr != null && String.isNotBlank(usr.EmployeeID__c)){
            for(Account acc:AccountDomain.getAccounts(usr.EmployeeID__c)){
                pw.idSet1.add(acc.Id);//Set of Account id's
            }
        }
        if(!pw.idSet1.isEmpty()){
            pw.str1 = mapCasesColumns.containsKey(reqWrap.sortColumn)?mapCasesColumns.get(reqWrap.sortColumn):'';
            pw.str2 = reqWrap.sortDirection;    
            pw.str3 = reqWrap.keyword; 
            pw.str4 = customMetadataMap.get('ARCHIVE');
            //Used to compare CaseApproved__c field
            pw.strList2.add(customMetadataMap.get('CASEAPPROVED'));
            pw.strList2.add(customMetadataMap.get('CASEREJECTED'));
            pw.int1 = reqWrap.rowLimit/3;
            pw.int2 = reqWrap.caseRowOffSet;
            //Used to compare Sub_Category__c field
            pw.strList3 = String.isNotBlank(reqWrap.types)?reqWrap.types.split(','):new List<String>(); 
            pw.mapString1 = DescribeSObjectCall.picklistValueToLabelMap('Case','TeamHubApplicationType__c');
            pw.strSet1=CommunityContentInfoService.communityContents(
                new Set<String>{'REQUESTS'},
                ','
            );
        }
        return pw;
    }

    /**
     * author       Abhishek Setia
     * @description Fill case records in ArchiveController.ArchiveWrapper list
     * @param       listCases - List<Case>
     * @param       acWrapper
     * @param       pw - ParameterWrapper
     */
    private static void fillArchiveWrapperForCase(List<Case> listCases, ArchiveCaseWrapper acWrapper,
                            ParameterWrapper pw){
        Map<String,List<ArchiveController.ArchiveWrapper>> mCasecategoryRec=
            new Map<String,List<ArchiveController.ArchiveWrapper>>();                                
        for(Case cs:listCases){
            ArchiveController.ArchiveWrapper archiveWrap = new ArchiveController.ArchiveWrapper();            
            archiveWrap.key=cs.Id;
            archiveWrap.description=(cs.Subject__c!=null)?cs.Subject__c:cs.Subject;            
            archiveWrap.completionDate=cs.ClosedDate;
            archiveWrap.type=getDisplayType(cs.TeamHubApplicationType__c,pw);
            archiveWrap.status=getStatus(archiveWrap.type, cs);
            if(archiveWrap.type == customMetadataMap.get('WPSREQUESTTYPE')){
                archiveWrap.status= customMetadataMap.get('CASESTATUSCLOSED');
            }
            archiveWrap.requestor=cs.Account.Name;
            archiveWrap.typeOfDevice=cs.TypeofDevice__c;
            archiveWrap.recordTypeName=cs.RecordType.Name;
            archiveWrap.originSystem=cs.Origin;
            archiveWrap.imagename=getCaseImageName(archiveWrap);
            if(archiveWrap.imagename==null && String.isNotBlank(cs.Category__c)){
                if(mCasecategoryRec.containsKey(cs.Category__c)){
                    mCasecategoryRec.get(cs.Category__c).add(archiveWrap);
                }else{
                    mCasecategoryRec.put(cs.Category__c,new List<ArchiveController.ArchiveWrapper>{archiveWrap});
                }                
            }
            acWrapper.records.add(archiveWrap);
        } 
        if(!mCasecategoryRec.isEmpty()){
            assignImageNameDynamically(mCasecategoryRec);            
        }  
    }

    /**
     * @author      Akshansh Jain
     * @description Assign Case record status
     * @param       type
     * @param       cs
     * @return      String
     */
    private static String getStatus(String type, Case cs) {
        String strStatus = 
            (type==customMetadataMap.get('CASESUBCATSALARYSACRIFICE')?
            cs.CaseApproved__c:(type==customMetadataMap.get('REQUESTSTYPE')?
            customMetadataMap.get('CASESTATUSCLOSED'):customMetadataMap.get('CASEPROCESSED')));
        
        if( cs.CaseApproved__c == customMetadataMap.get('CASEREJECTED') && 
            cs.TeamHubApplicationType__c == customMetadataMap.get('TEAMHUBAPPLICATIONTYPELEAVE') && 
            cs.Status == customMetadataMap.get('CASESTATUSCLOSED'))
        {
            strStatus = customMetadataMap.get('CASESTATUSCLOSED');
        }
        return strStatus;
    }

    /**
     * @author      Abhishek Setia
     * @description Assign dynamic image names from Form__c object
     * @param       mCasecategoryRec
     */
    private static void assignImageNameDynamically(
            Map<String,List<ArchiveController.ArchiveWrapper>> mCasecategoryRec
        ){

            Set<String> caseCategories = new Set<String>(mCasecategoryRec.keySet());
            caseCategories.add('DEFAULT');
            Map<String,String> mapCasecategoryActioncentreIcon=
                FormService.casecategoryActioncentreIconMapping(caseCategories);  
            for(String casecategory:mCasecategoryRec.keySet()){
                for(ArchiveController.ArchiveWrapper rec:mCasecategoryRec.get(casecategory)){
                    rec.imagename=(mapCasecategoryActioncentreIcon.containsKey(casecategory.toUpperCase()))?
                        mapCasecategoryActioncentreIcon.get(casecategory.toUpperCase()):
                        mapCasecategoryActioncentreIcon.get('DEFAULT');
                }
            }                           
        } 


    /**
     * @author      Abhishek Setia
     * @description Get static image names based on conditions
     * @param       rec
     * @return      String
     */
    private static String getCaseImageName(ArchiveController.ArchiveWrapper rec){
        if(String.isNotBlank(rec.typeOfDevice)){
            switch on rec.typeOfDevice{
                when 'Laptop'{
                    return 'newcomputing.svg';
                }
                when 'Mobile Phone'{
                    return 'mobile.svg';
                }
                when 'Tablet'{
                    return 'tablet.svg';
                }
                when 'Smartwatch'{
                    return 'smartwatch.svg';
                }
            }            
        }else if(rec.type==customMetadataMap.get('CASESUBCATSALARYSACRIFICE') &&
            rec.recordTypeName==customMetadataMap.get('CASERECORDTYPENAMEQUERYCASE') && 
            rec.originSystem==customMetadataMap.get('CASEORIGINTEAMSPACE')){
                return 'Superannuation.svg';
        }else if(rec.type==customMetadataMap.get('LEAVEREQUESTTYPE') &&
            rec.recordTypeName==customMetadataMap.get('CASERECORDTYPENAMEQUERYCASE') &&
            rec.originSystem==customMetadataMap.get('CASEORIGINTEAMSPACE')) {
                return 'purchase-app.svg';
        }        
        else if(rec.type==customMetadataMap.get('WPSREQUESTTYPE') &&
                rec.originSystem==customMetadataMap.get('CASEORIGINTEAMHUB')) { //Condition under WPS implimentation
                    return 'workplace-app.svg';
                }
        return null;
    }

    /**
     * @author      Abhishek Setia
     * @description Get Type to be displayed in Action Centre
     * @param       teamHubApplicationType
     * @param       pw
     * @return      String
     */
    private static String getDisplayType(String teamHubApplicationType,ParameterWrapper pw){
        if(pw.strSet1!=null && pw.strSet1.contains(teamHubApplicationType)){
            return customMetadataMap.get('REQUESTSTYPE');
        }else if(pw.mapString1.containsKey(teamHubApplicationType)){
                return pw.mapString1.get(teamHubApplicationType);
            }
        return '';    
    }
    
    /**
     * @author       Abhishek Setia
     * @description  Response wrapper for this class
    */
    public class ArchiveCaseWrapper{
        public List<ArchiveController.ArchiveWrapper> records;
        public Integer recordCount;
        public Integer totalCount;

        /**
         * @author       Abhishek Setia
         * @description  Constructor to initialize variables
        */
        public ArchiveCaseWrapper(){
            records=new List<ArchiveController.ArchiveWrapper>();
            recordCount=0;
            totalCount=0;
        }
    }
}
