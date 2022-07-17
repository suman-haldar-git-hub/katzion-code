/**
* @author : Sunil Kumar
* @company : Cognizant
* @description : This test class is used to cover positive and negative scenarios of
*                StateTimezoneMappingDomain class.
*/
@isTest(SeeAllData=false)
public with sharing class StateTimezoneMappingDomainTest {
     /**
    @Author : Sunil Kumar
    @Company : Cognizant
    @description : Test all method
    */
    @isTest
    static void testAllMethods() {
        StateTimezoneMappingDomain.queryData();
        System.assert(StateTimezoneMappingDomain.queryData()!=null);
    }
}