/*
@Author : Sunil
@Company : Cognizant
@Description : This test class is used to cover positive and negative scenarios of
@               KnowledgeArchiveBatch class.
*/
@isTest(SeeAllData=false)
public class KnowledgeArchiveBatchTest {
    static testMethod void validate()
    {
        KnowledgeTestData objData = new KnowledgeTestData();
        list<Knowledge__kav> listKnow = objData.create(1,True);
        
        KnowledgeArchiveBatch objKnowledge = new KnowledgeArchiveBatch();
        
        Test.startTest();
        Database.executeBatch(objKnowledge,100);
        system.assert(objKnowledge != null);
        String sch = '20 30 8 10 2 ?';
        String jobID = System.schedule('Remind Opp Owners', sch, objKnowledge);
        Test.stopTest();
    }
}