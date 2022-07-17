/**
 * @description Instantiate a stub version of the class
 * @author      Abhishek Setia
 */
public class FavoriteMockUtil {
        
    /**
     * @author      Abhishek Setia
     * @description Returns a stub object
     * @return      FavoriteMockProvider object  
     */
    public static FavoriteMockProvider getInstance() {
        return new FavoriteMockProvider();
    }
    
    /**
     * @author      Abhishek Setia
     * @description Invoke the stub API and pass it our mock provider to create a 
                    mock class of typeToMock.
     * @param       typeToMock
     * @return      Object
     */
    public static Object createMock(Type typeToMock) {        
        return Test.createStub(typeToMock, FavoriteMockUtil.getInstance());
    }
}