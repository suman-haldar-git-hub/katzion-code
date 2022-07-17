//DGC:  Check ContactWrapper compareTo functionality

@isTest

private class g_ContactWrapper_Test {

    static testMethod void compareTo_Test() {
    
        List<Account> personAccounts = TestUtility.createPersonAccount(2);
        insert personAccounts;
        
        Account acct1 = personAccounts.get(0);
        Contact con1 = [Select Id from Contact where AccountId =: acct1.id];
        con1.putSObject('Account',acct1);
        
        Account acct2 = personAccounts.get(1);
        Contact con2 = [Select Id from Contact where AccountId =: acct2.id];
        con2.putSObject('Account',acct2);
    
        g_ContactWrapper cw1 = new g_ContactWrapper(con1);
        g_ContactWrapper cw2 = new g_ContactWrapper(con2);
        System.assert(cw1.getContact() != null );        
        System.assert(cw1.compareTo(cw1) == 0);
        System.assert(cw1.compareTo(cw2) == 0);
       
        // Check one Account is null
        con2.putSObject('Account',null);
        System.assert(cw1.compareTo(cw2) != 0);
        
        // Check both Accounts are null
        con1.putSObject('Account',null);
        System.assert(cw1.compareTo(cw2) == 0);   
    }
    
}