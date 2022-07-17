/**
* @author : Amit Sharma
* @company : Cognizant
* @description : This test class will cover the GroupDomain class
*/
@isTest(SeeAllData=false)
public class GroupDomainTest {
    
    /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the setup method to create test data
    */
    
    @testSetup
    static void setupData() {
        Group testGroup = new Group();
        testGroup.Name = 'testGroup';
        testGroup.DeveloperName = 'ABC';
        testGroup.Type='Queue';
        insert testGroup;
        
    }
     /**
    * @author : Amit Sharma
    * @company : Cognizant
    * @description : This is the test method to execute logic
    */
    @isTest
    static void testData(){
         Group groupDetail = [SELECT Id, Name, 
                     DeveloperName, Email, Type 
                 FROM Group 
              WHERE Type='Queue' LIMIT 1];
              
          System.assertEquals(groupDetail != null,true);
          
          GroupDomain.getGroupId(groupDetail.DeveloperName);
          GroupDomain.getGroups(new set<Id>{groupDetail.id});
    }
}