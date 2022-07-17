/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This is a Invocable class of ArticleCreateOrUpdate process builder.
*/
public with sharing class AutomaticDataCategoryAssignmentService {
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @author : Ankit Singh
    * @description : This invocable method which check if user is BU Admin user,
    * then system should automatically assign Org Hierarchical Data Category mapped to the
    * Ops Support value of the BU Admin user as per SuccessFactor data
    * e.g. if the User has “Finance” as Ops Support value, then Data Category mapped to
    * “Finance” under Org Hierarchy should be automatically mapped to the Article automatically.
    * @param  knowledgeList
    */
    @InvocableMethod(label='assignDefaultDataCategory')
    public static void assignDefaultDataCategoryToArticle(
        List<Knowledge__kav> knowledgeList)
    {
        try {
            Set<String> permissionSetApiName = new Set<String>();
            Map<String, DataCategoryPermissionSetMapping__mdt> permissionSetApiNameToDataCategoryName =
                new Map<String, DataCategoryPermissionSetMapping__mdt>();
            if(knowledgeList != null && !knowledgeList.isEmpty()) {
                for(PermissionSetAssignment eachPermissionSetAss :
                        PermissionSetAssignmentDomain.getKnowledgeDetailsForPublishController()) {
                    permissionSetApiName.add(eachPermissionSetAss.PermissionSet.Name);
                }
            }
            for(DataCategoryPermissionSetMapping__mdt eachMapping :
                        DataCategoryPermissionSetMappingDomain.queryDataCategoryNameMapping()) {
                permissionSetApiNameToDataCategoryName.put(
                        eachMapping.PermissionSetApiName__c,
                        eachMapping
                );
            }
            insertKnowledgeDataCategorySelection(
                    permissionSetApiName,
                    permissionSetApiNameToDataCategoryName,
                    knowledgeList
            );
        }
        catch(Exception ex){
            PublishLogEventService.publishExceptionEvent(
                'AutomaticDataCategoryAssignmentService.cls',
                ex
            );
        }
    }

    /**
    * @author :Ankit Singh
    * @description :This method will insert Knowledge DataCategory Selection
    * @param permissionSetApiName
    * @param permissionSetApiNameToDataCategoryName
    * @param knowledgeList
    */
    public static void insertKnowledgeDataCategorySelection(
        Set<String> permissionSetApiName,
        Map<String, DataCategoryPermissionSetMapping__mdt> permissionSetApiNameToDataCategoryName,
        List<Knowledge__kav> knowledgeList
    ) {
        List<Knowledge__DataCategorySelection> insertDataCategorySelection = new
                List<Knowledge__DataCategorySelection>();
        if(hasAllDataForInsert(permissionSetApiName, permissionSetApiNameToDataCategoryName)) {
            for(String eachPermissionSetApiName : permissionSetApiName) {
                if(
                        permissionSetApiNameToDataCategoryName.containsKey(
                                eachPermissionSetApiName
                        )
                        &&
                        permissionSetApiNameToDataCategoryName.get(
                                eachPermissionSetApiName
                        ) != null
                ) {
                    Knowledge__DataCategorySelection dataCategoryObj = new
                            Knowledge__DataCategorySelection();
                    dataCategoryObj.ParentId = knowledgeList[0].Id;
                    dataCategoryObj.DataCategoryName = permissionSetApiNameToDataCategoryName.get(
                            eachPermissionSetApiName
                    ).DataCategoryName__c;
                    dataCategoryObj.DataCategoryGroupName = permissionSetApiNameToDataCategoryName.get(
                            eachPermissionSetApiName
                    ).DataCategoryGroupName__c;
                    insertDataCategorySelection.add(dataCategoryObj);
                }
            }
        }
        if(insertDataCategorySelection != null && !insertDataCategorySelection.isEmpty()) {
            Database.insert(insertDataCategorySelection);
        }
    }

    /**
    * @author :Ankit Singh
    * @description :This method will check if all data is available for inserting
    * Knowledge__DataCategorySelection
    * @param permissionSetApiName
    * @param permissionSetApiNameToDataCategoryName
    * @return isValid
    */
    private static Boolean hasAllDataForInsert(
        Set<String> permissionSetApiName,
        Map<String, DataCategoryPermissionSetMapping__mdt> permissionSetApiNameToDataCategoryName
    ) {
        Boolean isValid = false;
        if(
                permissionSetApiName != null
                &&
                !permissionSetApiName.isEmpty()
                &&
                permissionSetApiNameToDataCategoryName != null
                &&
                !permissionSetApiNameToDataCategoryName.isEmpty()
        ) {
            isValid = true;
        }
        return isValid;
    }
}