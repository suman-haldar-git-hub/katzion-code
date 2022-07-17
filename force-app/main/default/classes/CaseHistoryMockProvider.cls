/**
 * @description Define the behavior of the stub class by implementing
 *              the System.StubProvider interface.
 *              Mock class for CaseHistory
 * @author      Abhishek Setia
 */
@isTest
public class CaseHistoryMockProvider implements System.StubProvider{
    
    /**
    * @author       Abhishek Setia
    * @description  This method is used to create mock.
    * @return       List<Object>
    * @param        stubbedObject
    * @param        stubbedMethodName
    * @param        returnType
    * @param        listOfParamTypes
    * @param        listOfParamNames
    * @param        listOfArgs
    */
    public List<Object> handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName, 
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames,
        List<Object> listOfArgs){     
            List<CaseHistory> listHistory=new List<CaseHistory>();
            if(stubbedMethodName=='getOwnerChangeHistory' || stubbedMethodName=='getCaseOwnerHistory'){
                List<Case> cases=[SELECT Id FROM Case LIMIT 1];
                listHistory.add(new CaseHistory(
                    Field='Owner',
                    CaseId=cases[0].Id,
                    DataType='EntityId'
                ));
                listHistory.add(new CaseHistory(
                    Field='Owner',
                    CaseId=cases[0].Id,
                    DataType='EntityId'
                ));                
            }
            return listHistory;
    }
}