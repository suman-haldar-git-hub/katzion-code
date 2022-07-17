/**
 * @author      Abhishek Setia
 * @description Test class for QueueNameTeamNameDomain.cls
 */
@isTest
private class QueueNameTeamNameDomainTest {

    @isTest
    static void testgetSetofRecords(){
        Set<String> setDevNames=new Set<String>{'Advisory_Admin','PS_Advisory_Payroll'};
        List<QueueNameTeamName__mdt> lst=QueueNameTeamNameDomain.getSetofRecords(setDevNames);
        System.assert(lst.size()==2);
    }
}