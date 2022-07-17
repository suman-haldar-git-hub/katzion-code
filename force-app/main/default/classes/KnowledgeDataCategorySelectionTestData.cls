/**
* @author : Daksh Madan
* @company : Cognizant
* @description : This is test data builder class for Contact object.
*/
@isTest
public without sharing class KnowledgeDataCategorySelectionTestData {
    /**
* @author : Daksh Madan
* @company : Cognizant
* @description : This will create the Knowledge__DataCategorySelection records.
* @return : List<Knowledge__DataCategorySelection>
* @param count
* @param dataCategoryGroupNameStr
* @param knowledgeArticleId
*/
    public static List<Knowledge__DataCategorySelection> createKnowledgeDataCategorySelectionRecds
        (Integer count,String dataCategoryGroupNameStr,String knowledgeArticleId){
            List<Knowledge__DataCategorySelection> knowledgeDataCategorySelectionRecdList = 
                new List<Knowledge__DataCategorySelection>();
            for (Integer i = 0; i < count; i++) {
                Knowledge__DataCategorySelection knowledgeDataCategorySelectionRecd
                    = new Knowledge__DataCategorySelection();
                knowledgeDataCategorySelectionRecd.ParentId = knowledgeArticleId;
                knowledgeDataCategorySelectionRecd.DataCategoryGroupName = dataCategoryGroupNameStr;
                knowledgeDataCategorySelectionRecd.DataCategoryName = 'SupportFunctions';
                knowledgeDataCategorySelectionRecdList.add(knowledgeDataCategorySelectionRecd);
            }
            return knowledgeDataCategorySelectionRecdList;
        }
}