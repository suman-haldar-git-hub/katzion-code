/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This test class is used to cover positive and negative scenarios of
 * OrgWideEmailAddressDomain class.
*/
@isTest(SeeAllData=false)
private class OrgWideEmailAddressDomainTest {
    /**
     * @author : Sumit Banarji 
     * @ccompany : Cognizant
     * @description : This test method is used to cover positive and negative scenarios of
     * getOrgWideAddress method.
    */
    @isTest
    static void testgetOrgWideAddress() {
        String fromAddress = [SELECT Id, Address  FROM OrgWideEmailAddress Limit 1].Address;
        Set<String> emails = new Set<String>();
        emails.add(fromAddress);

        list<OrgWideEmailAddress> orgWideAddress = OrgWideEmailAddressDomain.getOrgWideAddress(emails);
        System.assertEquals(orgWideAddress.size(), 1);
    }
}
