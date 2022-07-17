/*
@author : Praveen Tiwari
@company : Cognizant
@description : This test class is used to cover LightningDatatableController class.
*/
@isTest(SeeAllData=false)
public class LightningDatatableControllerTest {
    static testMethod void validate()
    {
        Integer count = 20;
        KnowledgeTestData objData = new KnowledgeTestData();
        list<Knowledge__kav> listKnowledge = objData.create(count,True);
        LightningDatatableController.getKnowledgeArticles();
        system.assertEquals(count, listKnowledge.size(), 'List of Articles is not equal to total number of articles created');  
    }
}