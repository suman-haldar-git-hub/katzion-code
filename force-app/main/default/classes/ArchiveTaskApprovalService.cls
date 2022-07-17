/**
 * @author       Abhishek Setia
 * @description  Gets Tasks and Approvals data to be shown in 'Archive' tab.
*/
public with sharing class ArchiveTaskApprovalService {

    private static Map<String,String> customMetadataMap;
    private static Map<String,String> mapUniversalTaskListColumns=new Map<String,String>{
        'description' => 'Title__c',
        'status' => 'THStatus__c',
        'type' => 'RecordTypeName__c',
        'completionDate' => 'CompletedDate__c',
        'originSystem' => 'OriginatingSystem__c',
        'requestor' => 'SubmittedForAccount__r.Name'
    };

    /**
     * @author      Abhishek Setia
     * @description Get CustomMetadata mappings
     * @return      Map<String,String>
     */
    private static Map<String,String> getCustomMetadata(){
        Set<String> developerNames=new Set<String>{'UTLRECORDTYPEAPPROVAL','UTLRECORDTYPETASK',
        'REQUESTTYPEARCHIVE'};
        return CommunityContentInfoService.getCommunityContentInfoMapping(developerNames);
    }

    /**
     * @author      Abhishek Setia
     * @description Get UniversalTaskList__c records to be shown in 'Archive' tab.
     * @param       reqWrap - Value from JScript. Filter criteria for UniversalTaskList__c records
     * @return      ArchiveTaskApprovalWrapper
     */
    public static ArchiveTaskApprovalWrapper getRecords(ArchiveController.RequestWrapper reqWrap){
        customMetadataMap=getCustomMetadata();   
        ArchiveTaskApprovalWrapper taWrapper=new ArchiveTaskApprovalWrapper();     
        if(String.isNotBlank(reqWrap.types) && (
            reqWrap.types.contains(customMetadataMap.get('UTLRECORDTYPEAPPROVAL')) ||
            reqWrap.types.contains(customMetadataMap.get('UTLRECORDTYPETASK'))
            )
        ){
                String filterType=customMetadataMap.get('REQUESTTYPEARCHIVE');
                String utlColumn = mapUniversalTaskListColumns.containsKey(reqWrap.sortColumn)?
                    mapUniversalTaskListColumns.get(reqWrap.sortColumn):'';
                String sortingCriteria = (String.isNotBlank(utlColumn) && String.isNotBlank(reqWrap.sortDirection))?
                                                ' ORDER BY '+utlColumn+' '+reqWrap.sortDirection:'';
                Map<String, String> paramsMap = new Map<String, String>{
                    'initialRows' => String.valueOf(reqWrap.rowLimit/3),
                    'filterType' => filterType,
                    'columnSorting' => sortingCriteria,
                    'offset' => String.valueOf(reqWrap.utlRowOffSet),
                    'approvalRecordType' => String.valueOf(String.isNotBlank(reqWrap.types) &&
                            reqWrap.types.contains(customMetadataMap.get('UTLRECORDTYPEAPPROVAL'))
                        ),
                    'taskRecordType' => String.valueOf(String.isNotBlank(reqWrap.types) && 
                        reqWrap.types.contains(customMetadataMap.get('UTLRECORDTYPETASK'))
                        ),
                    'keyword' => reqWrap.keyword
                };            
                List<UniversalTaskList__c> lstUTL = UniversalTaskListFilterService.filterRecordsOnSearch(paramsMap,
                                                                        TaskApprovalDataTableController.getSetOfStatus(filterType));        
                fillArchiveWrapperForUTL(lstUTL,taWrapper);                
                taWrapper.recordCount=lstUTL.size();
                if(reqWrap.calculateTotalRecords){            
                    paramsMap.put('countTotal','true');
                    List<UniversalTaskList__c> totalUtlRec = UniversalTaskListFilterService.filterRecordsOnSearch(
                        paramsMap,TaskApprovalDataTableController.getSetOfStatus(filterType));
                    taWrapper.totalCount=totalUtlRec.size();
                }
                
        }
        return taWrapper;
    }

    /**
     * author       Abhishek Setia
     * @description Fill UniversalTaskList__c records in ArchiveController.ArchiveWrapper list
     * @param       lstUTL - List<UniversalTaskList__c>
     * @param       taWrapper
     */
    private static void fillArchiveWrapperForUTL(List<UniversalTaskList__c> lstUTL,
        ArchiveTaskApprovalWrapper taWrapper){
            for(UniversalTaskList__c utl:lstUTL){
                ArchiveController.ArchiveWrapper archiveWrap = new ArchiveController.ArchiveWrapper();
                archiveWrap.key=utl.Id;
                archiveWrap.description=utl.Title__c;
                archiveWrap.status=utl.THStatus__c;
                archiveWrap.type=utl.RecordTypeName__c;
                archiveWrap.completionDate=utl.CompletedDate__c;
                archiveWrap.originSystem=utl.OriginatingSystem__c;
                archiveWrap.requestor=utl.SubmittedForAccount__r.Name;
                archiveWrap.recordTypeName=utl.RecordType.Name;
                archiveWrap.imagename=getTaskApprovalImageName(archiveWrap);
                archiveWrap.actionUrl=utl.ActionUrl__c;
                taWrapper.records.add(archiveWrap);
            } 
    }

    /**
     * @author      Abhishek Setia
     * @description Get static image names based on conditions
     * @param       rec
     * @return      String
     */
    private static String getTaskApprovalImageName(ArchiveController.ArchiveWrapper rec){
        if(String.isNotBlank(rec.type) && rec.type==customMetadataMap.get('UTLRECORDTYPETASK')){
            return 'calicn.svg';
        }else if(String.isNotBlank(rec.type) && rec.type==customMetadataMap.get('UTLRECORDTYPEAPPROVAL')){
            return 'applargeicn.svg';
        }
        return null;
    }

    /**
     * @author       Abhishek Setia
     * @description  Response wrapper for this class
    */
    public class ArchiveTaskApprovalWrapper{
        public List<ArchiveController.ArchiveWrapper> records;
        public Integer recordCount;
        public Integer totalCount;

        /**
         * @author       Abhishek Setia
         * @description  Constructor to initialize variables
        */
        public ArchiveTaskApprovalWrapper(){
            records=new List<ArchiveController.ArchiveWrapper>();
            recordCount=0;
            totalCount=0;
        }
    }
}