/**
 * @author : Sunil
 * @company : SaaSFocus
 * @description : This test class is used to cover positive and negative scenarios of
*/
@isTest(SeeAllData=false)
public class RecordTypeDomainTest {
    /**
 * @author : Sunil
 * @ccompany : Cognizant
 * @description : This test method is used to cover positive and negative scenarios of
 * RecordTypeDomain class.
*/
    @isTest
    static void getRecordTypetest() {
        User admin = [
            SELECT id, UserName
            FROM User
            WHERE Profile.Name = 'System Administrator' and isActive= True LIMIT 1
        ];
        System.runAs(admin) {
            String objectAPIName='Account'; 
            String developerName='PersonAccount';
            Test.startTest();
            String idToAssert = RecordTypeDomain.getRecordTypeId(objectAPIName, developerName);
            Map<String, Id> queryRecordTypesToAssert = 
                RecordTypeDomain.queryRecordTypes(objectAPIName, developerName);
            System.assert(queryRecordTypesToAssert != null);
            Test.stopTest();
        }
    } 
}