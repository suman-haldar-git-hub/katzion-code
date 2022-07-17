/**
* @Author : Praveen Tiwari
* @Company : Cognizant
* @description : This utility class returns a stub object that you can use as a mock.
*/
public class MockUtil {
    /**
* @author : Praveen Tiwari
* @description : This method is used to create instance of MockProvider.
* @return : MockProvider
*/
    public static MockProvider getInstance() {
        return new MockProvider();
    }
    /**
* @author : Praveen Tiwari
* @description : This method is used to create mock.
* @return : Object
* @param typeToMock
*/
     public static Object createMock(Type typeToMock) {
        // Invoke the stub API and pass it our mock provider to create a
        // mock class of typeToMock.
        return Test.createStub(typeToMock, MockUtil.getInstance());
    }
}