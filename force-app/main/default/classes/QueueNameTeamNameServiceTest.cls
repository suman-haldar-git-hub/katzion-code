/**
 * @author      Abhishek Setia
 * @description Test class for QueueNameTeamNameService.cls
 */
@isTest
private class QueueNameTeamNameServiceTest {

    @isTest
    static void testmappingCaseOwnerWithTeamName(){
        Set<String> setDevNames=new Set<String>{'Advisory_Admin','PS_Advisory_Payroll'};
        Map<String,String> mapping=QueueNameTeamNameService.mappingCaseOwnerWithTeamName(setDevNames);
        System.assert(!mapping.isEmpty());
    }
}