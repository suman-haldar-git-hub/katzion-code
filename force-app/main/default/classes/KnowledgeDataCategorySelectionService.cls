/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This Domain Class is used to query  for Knowledge__DataCategorySelection object
*/
public with sharing class KnowledgeDataCategorySelectionService {
    private static Map<String, String> labelToContentMap =
         CommunityContentInfoService.getMappingFromMetadeta();
    /**
    * @Author : Ankit Singh
    * @description :This method returns the Knowledge__DataCategorySelection details
    * for PublishKnowledgeController
    * @return hasOpsSupportDataCategory
    * @param recordId
    * @param setOfOpsSupportDataCategory
    */
    public static Boolean getKnowledgeDetailsForPublishController(
        Id recordId,
        Set<String> setOfOpsSupportDataCategory
    ) {
        Boolean hasOpsSupportDataCategory = false;
        List<Knowledge__DataCategorySelection> assignedDataCategory = new
            List<Knowledge__DataCategorySelection>();
        assignedDataCategory =
                KnowledgeDataCategorySelectionDomain.getKnowledgeDetailsForPublishController(
                        recordId
        );
        String[] excludeDataCategory = labelToContentMap.get('EXCLUDEDATACATEGORY').split(',');
        if(assignedDataCategory != null && !assignedDataCategory.isEmpty()) {
            for(Knowledge__DataCategorySelection eachDataCategory : assignedDataCategory) {
                if(
                        setOfOpsSupportDataCategory.contains(eachDataCategory.DataCategoryName)
                        ||
                        excludeDataCategory.contains(eachDataCategory.DataCategoryName)
                ) {
                    hasOpsSupportDataCategory = true;
                    break;
                }
            }
        }
        return hasOpsSupportDataCategory;
    }
}