/**
 * @author      Abhishek Setia
 * @description Used in Test Classes.
 *              Creates a stub object implementation of System.StubProvider.
 *              Uses this object to invoke stub api.
 */
@isTest
public class MockRequestFactory {

    /**
     * Define constants which are used in Mock Framework
     */
    public enum MockConstants {
        FAVORITEOBJECT,
        CASEHISTORYOBJECT
    }

    /**
     * @author      Abhishek Setia
     * @description Returns a stub object implementation of System.StubProvider
     *              interface
     * @param       mockConst - Constants defined of type MockConstants
     * @return      System.StubProvider
     */
    private static System.StubProvider getInstance(MockConstants mockConst){
        System.StubProvider stubinstance;
        if(mockConst==MockConstants.FAVORITEOBJECT){
            stubinstance=new FavoriteMockProvider();
        }else if(mockConst==MockConstants.CASEHISTORYOBJECT){
            stubinstance=new CaseHistoryMockProvider();
        }
        return stubinstance;
    }

    /**
     * @author      Abhishek Setia
     * @description Invoke the stub API and pass it our mock provider to create a 
                    mock class of typeToMock.
     * @param       typeToMock
     * @param       mockConst
     * @return      Object
     */
    public static Object createMock(Type typeToMock, MockConstants mockConst) {        
        return Test.createStub(typeToMock, MockRequestFactory.getInstance(mockConst));
    }

}