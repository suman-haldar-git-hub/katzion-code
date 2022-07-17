/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This Domain Class is used to query  for Knowledge__DataCategorySelection object
*/
public inherited sharing class KnowledgeDataCategorySelectionDomain {
    /**
    * @Author : Ankit Singh
    * @description :This method returns the Knowledge__DataCategorySelection details
    * for PublishKnowledgeController
    * @return assignedDataCategory
    * @param recordId
    */
    public static List<Knowledge__DataCategorySelection> getKnowledgeDetailsForPublishController(
        Id recordId
    ) {
        List<Knowledge__DataCategorySelection> assignedDataCategory = new
            List<Knowledge__DataCategorySelection>();
        assignedDataCategory = [
                SELECT Id, DataCategoryGroupName, DataCategoryName, ParentId
                FROM Knowledge__DataCategorySelection
                WHERE ParentId =: recordId
        ];
        return assignedDataCategory;
    }
}