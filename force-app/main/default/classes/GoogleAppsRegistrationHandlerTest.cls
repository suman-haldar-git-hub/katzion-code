/*
Purpose    : Test class for the GoogleAppsRegistrationHandler
Created by : Gayani Devapriya (Cloud Sherpas)
Created on : 17th July 2015
*/
@isTest
public with sharing class GoogleAppsRegistrationHandlerTest {

    
    @isTest
    public static void createUserPositiveTest(){
        User oUser1 = [select Id, username, email from User where isActive = true limit 1];
        
        Auth.UserData oMockAuthData = new Auth.UserData('testId', 'testFirst', 'testLast',
        'testFirst testLast', oUser1.email, null, 'testuserlong', 'en_US', 'facebook',
        null, new Map<String, String>{'language' => 'en_US'});
        
        GoogleAppsRegistrationHandler oHandler = new GoogleAppsRegistrationHandler();
        User authUser1 = oHandler.createUser(null, oMockAuthData);
        System.assertEquals(oUser1.email, authUser1.email);
    }
    
    @isTest
    public static void createUserNegativeTest(){
        Auth.UserData oMockAuthData = new Auth.UserData('testId', 'testFirst', 'testLast',
        'testFirst testLast', 'thedoggyemail@unknown.com', null, 'testuserlong', 'en_US', 'google',
        null, new Map<String, String>{'language' => 'en_US'});
        
        GoogleAppsRegistrationHandler oHandler = new GoogleAppsRegistrationHandler();
        User authUser2 = oHandler.createUser(null, oMockAuthData);
        System.assertEquals(null, authUser2);
    }
    
    @isTest
    public static void updateUserTest(){
        Auth.UserData oMockAuthData = new Auth.UserData('testId', 'testFirst', 'testLast',
        'testFirst testLast', 'realuser@woolies.com.au', null, 'testuserlong', 'en_US', 'google',
        null, new Map<String, String>{'language' => 'en_US'});
        
        GoogleAppsRegistrationHandler oHandler = new GoogleAppsRegistrationHandler();
        oHandler.updateUser(null, null, oMockAuthData);
        
    }
}