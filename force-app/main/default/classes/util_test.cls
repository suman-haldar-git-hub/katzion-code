/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class util_test {
    
    static testMethod void myUnitTest() {
        PageReference pageRef = Page.W2CNewCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ParentID', '123123123');
        
        list<Object_Field__C> Objtype = new list<Object_Field__C>{
        new Object_Field__C(Object__c = 'Case',Field_Name__c = 'AttachmentType'),
        new Object_Field__C(Object__c = 'Case',Field_Name__c = 'Category'),
        new Object_Field__C(Object__c = 'Case',Field_Name__c = 'Sub Category')};
       	insert Objtype;
        
        
        List<Object_Field__C> GetAttId = [select Id from Object_Field__C where Object__c = 'Case' and Field_Name__c = 'AttachmentType' limit 1];
        List<Object_Field__C> GetCattype = [select Id from Object_Field__C where Object__c = 'Case' and Field_Name__c = 'Category' limit 1];
        List<Object_Field__C> GetSubCattype = [select Id from Object_Field__C where Object__c = 'Case' and Field_Name__c = 'Sub Category' limit 1];
        
        list<Picklist_Field_Value__c> Filetype = new List<Picklist_Field_Value__c>();
       	filetype.add(new Picklist_Field_Value__c(Object_Field__c = GetAttId[0].id,Web_Display__c =true,Picklist_Field_Value__c ='csv',Web_Value__c = 'csv'));
        filetype.add(new Picklist_Field_Value__c(Object_Field__c = GetCattype[0].id,Web_Display__c =true,Picklist_Field_Value__c = 'Pay and the Basics',Web_Value__c = 'Pay and the Basics'));
        filetype.add(new Picklist_Field_Value__c(Object_Field__c = GetSubCattype[0].id,Web_Display__c =true,Picklist_Field_Value__c ='WOW People Discount Card',Web_Value__c = 'WOW People Discount Card'));
        Insert Filetype;  
        
        util controller = new util();
        controller.catItems = null;
        controller.subItems = null;
        controller.subcategoryValue = null;
        controller.attachment = null;
        controller.categoryValue = controller.obtainValue();
        
        controller.catItems = 'Leaving the Company';
        controller.testingsub();
        controller.subItems = 'Exit Survey';
        controller.cs = null;
        
        controller.attachmentID = null;
        controller.attachmentParentID = null;
        
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
   		insert caseRec;
   		List<Case> Caselist = TestUtility.createTrxCases(2,caseRec.Transaction_Case__c);
   		case tempcase = Caselist[0]; 
              
        
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        tempCase.RecordTypeID = caseRec.Transaction_Case__c;
        tempCase.Preferred_Contact_Method__c = 'Phone';//sekarchg
        tempCase.Preferred_Phone__c = '0401010101';//sekarchg
        tempCase.New_People_Query_or_Process_Request__c = 'Yes';//sekarchg

        
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
	    Insert tempCase;
        controller.cs = tempCase;
        PageReference thankyouPage = controller.save();
        
        tempCase.Web_Employee_Id__c = '90563';
        controller.cs = tempCase;
        PageReference attachDocumentPage = controller.attachDocument();
	    thankyouPage = controller.save();
        PageReference FinishPage = controller.finish();
        
        controller.cs.Web_Employee_Id__c = '905632';
        controller.catItems = null;
    	attachDocumentPage = controller.attachDocument();
	    thankyouPage = controller.save();
        
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = '';
//      attachDocumentPage = controller.attachDocument();
	    thankyouPage = controller.save();
      
        system.debug('xxxxthankyouPage: '+thankyouPage);        
        controller.ckeonbehalf = 'Yes';
        controller.cs.Web_On_Behalf_Of_First_Name__c = null;
        controller.cs.Web_On_Behalf_Of_Last_Name__c = null;
        controller.cs.Web_On_Behalf_Of_Last_Name__c = null;
//24.05.2016 Sally Montgomery added        
        controller.UpdateckeonbehalfValue();


        attachDocumentPage = controller.attachDocument();        
	    thankyouPage = controller.save();

        
        controller.ckeonbehalf = 'Yes';
        controller.cs.Web_On_Behalf_Of_First_Name__c = 'temp';
        controller.cs.Web_On_Behalf_Of_Last_Name__c = 'Hi';
        controller.cs.Web_On_Behalf_Of_Employee_Id__c = '123456';
//   attachDocumentPage = controller.attachDocument();        
        thankyouPage = controller.save();

        
        controller.ckeonbehalf = 'No';
        controller.cs.Web_On_Behalf_Of_First_Name__c = null;
//      attachDocumentPage = controller.attachDocument();
        thankyouPage = controller.save();      
        
        /*
        ======================================================
        ======================================================
        */
        controller.ckeonbehalf = 'Yes';
        tempCase.Web_On_Behalf_Of_First_Name__c = 'Test';
        tempCase.Web_On_Behalf_Of_Last_Name__c = 'lastname';
        tempCase.Web_On_Behalf_Of_Employee_Id__c = '';
        controller.cs = tempCase;
        attachDocumentPage = controller.attachDocument();
        thankyouPage = controller.save();
         
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'WOW People Discount Card';
        thankyouPage = controller.save();
        System.assertEquals(TempCase.Category__c,'Pay and the Basics');
        
        controller.catItems = 'Pay and the Basics';
 	    controller.subItems = 'Salary Sacrifice Forms';
        thankyouPage = controller.save();
        
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'WOW People Discount Card';
		attachDocumentPage = controller.attachDocument();
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'Salary Sacrifice Forms';
	    attachDocumentPage = controller.attachDocument();
        
        //26.05.2016 Sally Montgomery added to test errors for existing case number
        tempCase.New_People_Query_or_Process_Request__c = 'No';
        tempCase.Related_to_Existing_Case_Number__c = '';
        thankyouPage = controller.save();
        
        //25.05.2017 Sekar Krishnan Added for Reporting request
        controller.catitems = 'Report Requests';
        controller.getrequestfreq();
        controller.callTwoMethods();        
        thankyouPage = controller.save();
        
        tempCase.New_People_Query_or_Process_Request__c = 'No';
        tempCase.Related_to_Existing_Case_Number__c = '';
        attachDocumentPage = controller.attachDocument();
        

        /*
        ======================================================
        ======================================================
        */
        
        Account tmpAccount = new Account();
        tmpAccount.OwnerID = '00528000000T74uAAC';
        tmpAccount.RecordTypeID = '012280000008xNMAAY';
        tmpAccount.Employee_ID__c = '123456';
        tmpAccount.Active__c = 'Y';
        tmpAccount.Name = 'Mr. Joe Schmoe';
        try {
            insert tmpAccount;
            Contact contact = new Contact ( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', AccountId=tmpAccount.id );
            insert contact;
        } catch (Exception e) {
            system.debug('************* trying to insert account -'  + e + '****************');//sekarchg
        }
        
        controller.ckeonbehalf = 'Yes';
       	Case tempCase1 = new Case();
        tempCase1.Web_On_Behalf_Of_First_Name__c = 'Test';
        tempCase1.Web_On_Behalf_Of_Last_Name__c = 'lastname';
        tempCase1.Web_On_Behalf_Of_Employee_Id__c = '123456';
        tempCase1.Web_Employee_Id__c = '1234567';
        tempCase1.SuppliedName = 'Aaron Smith1';
        tempCase1.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase1.Subject = 'Testing - Util';
        tempCase1.Description = 'Testing - Description';
        tempCase1.RecordTypeID = caseRec.Transaction_Case__c;//'012280000008xsSAAQ';
        tempCase1.Preferred_Contact_Method__c = 'Phone';//sekarchg
        tempCase1.Preferred_Phone__c = '0401010101';//sekarchg
        tempCase1.New_People_Query_or_Process_Request__c = 'Yes';//sekarchg
       
        controller.cs = tempCase1;
        attachDocumentPage = controller.attachDocument();
        thankyouPage = controller.save();
        
        /*
        ======================================================
        ======================================================
        */
        
        
        
        try {
            insert tempCase1;
        } catch (Exception e) {
            system.debug('************* trying to insert case -'  + e + '****************');
        }
        
        ID tempCaseID = null;
        
        List<Case> lstCase = [select id from Case];
        for (Case cs : lstCase) {
            tempCaseID = cs.id;
        }
        
        PageReference attachPage = Page.attachmentPage; 
        Attachment testAtt = new Attachment();
        Test.setCurrentPage(attachPage);
        ApexPages.currentPage().getParameters().put('ParentID', tempCaseID);
        
        testAtt.name = 'Test.csv';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        testAtt.body=bodyBlob;
        testAtt.ParentId= tempCaseID;
        
        controller.attachment = testAtt;
        thankyouPage = controller.save();
	    thankyouPage = controller.upload();
//		attachDocumentPage = controller.attachDocument();
//		Test.setCurrentPage(attachPage);
	
        ApexPages.currentPage().getParameters().put('ParentID', tempCaseID);
        Attachment testAtt1 = new Attachment();
        testAtt1.name = 'Test1.csv';//it was csv
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        testAtt1.body=bodyBlob1;
        testAtt1.ParentId= tempCaseID;
        
        controller.attachment = testAtt1;
        thankyouPage = controller.UploadAndFinish();
        
  		test.starttest();
   /*     list<Attachment> lstatt = [select id from Attachment WHERE Parentid = :tempCaseID limit 1];
        System.debug('attdel'+lstatt.size());
        ID attachmentID = null;
        for (Attachment att :lstatt) {
            attachmentID = att.id;
        }
        
        attachPage = Page.attachmentPage; 
        //Attachment testAtt = new Attachment();
        Test.setCurrentPage(attachPage);
        ApexPages.currentPage().getParameters().put('ParentID', tempCaseID);
        controller.attachment = lstatt[0];*/
        Try{       
            
           thankyouPage = controller.deletecon();
        }
    	Catch (Exception e)
        {system.debug('************* trying to delcon -'  + e + '****************');}
       // insert testAtt;
       // controller.attachmentID = testAtt.id;
       // thankyouPage = controller.deleteCon();
        
        //
        
        /*========================
        ========================
        */
         test.StopTest();
       
    }
    
    /*static testMethod void myUnitTest2() {
        List<Case> lstcase = new List<Case>();
        Case tempCase = new Case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        tempCase.RecordTypeID = '012280000008xsSAAQ';
        tempCase.Origin = 'Web';
        tempCase.ownerID = '00G28000000RB6eEAG';
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
        tempCase.Category__c = 'Leaving the Company';
        tempCase.Sub_Category__c  = 'Exit Survey';
        tempCase.Web_Call_On_Behalf__c = true;
        tempCase.Log_a_case_for_someone_else__c = true;
        
        
        //lstcase.add(tempCase);
        //insert lstcase;
        //insert tempCase;
        
        //system.debug('**************** caseid -  tempCase---' + tempCase.id + '-********************');
    }*/
    
    /*static testMethod void testAttachmentTypeTrigger(){
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
   		insert caseRec;
         Case c = new Case(Subject = 'TEST_CASE_1');
         c.RecordTypeId = caseRec.Transaction_Case__c;   
        c.suppliedemail='abcd@gmail.com';
         insert c;
        
        EmailMessage em1=new Emailmessage(subject='testemailmesg');
        em1.ParentId=c.id;
        insert em1;
        Attachment att1 = new Attachment();
        att1.name = 'Test1.csv';//it was csv
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        att1.body=bodyBlob1;
        att1.ParentId= em1.Id;
        insert att1;
        
       /* 
        *  Attachment att1 = new Attachment();
        att1.name = 'Test1.csv';//it was csv
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        att1.body=bodyBlob1;
        att1.ParentId= c.Id;
        insert att1;
        *  List<Case> queryCaseList=TestUtility.createQueryCases(1,'0122800000094iF');
        insert queryCaseList;
          caseRec.Transaction_Case__c = '0122800000094iF';
        caseRec.ER_Case__c = '012280000008xsX';
        caseRec.Query_Case__c = '012280000008xsS';
       for(Case c:queryCaseList){
        Attachment testAtt1 = new Attachment();
        testAtt1.name = 'Test1.csv';//it was csv
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        testAtt1.body=bodyBlob1;
        testAtt1.ParentId= c.Id;
        }
 		
    }*/
    
    /*static testMethod void myUnitTest3() {
        PageReference pageRef = Page.W2CNewCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ParentID', '123123123');
        util controller = new util();
        controller.catItems = null;
        controller.subItems = null;
        controller.subcategoryValue = null;
        controller.categoryValue = controller.obtainValue();
        
        controller.catItems = 'Leaving the Company';
        controller.testingsub();
        controller.subItems = 'Exit Survey';
        controller.cs = null;
        
        controller.attachmentID = null;
        controller.attachmentParentID = null;
        controller.attachment = null;
        
        Case tempCase = new Case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        tempCase.RecordTypeID = '012280000008xsSAAQ';
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
        controller.cs = tempCase;
        
        controller.cs.Category__c = 'Pay and the Basics'; 
        controller.cs.Sub_Category__c = 'WOW People Discount Card';
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'WOW People Discount Card';
        //attachDocumentPage = controller.attachDocument();
    }*/
    
    /*
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        PageReference pageRef = Page.W2CNewCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ParentID', '123123123');
        
        Case tempCase = new Case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
        //
        //tmepCase.ownerID = '00G28000000RB6eEAG';
        //tempCase.Preferred_Contact_Method__c = 'Phone';
        //tmepCase.Preferred_Email__c = 'test@gmail.com';
       // tmepCase.Preferred_Phone__c = '040101010101';
        //tmepCase.Category__c = null;
        //tmepCase.Sub_Category__c = null;
        
        
        util controller = new util();
        
        controller.cs = tempCase;
        controller.catItems = 'Leaving the Company';
        controller.subItems = 'Exit Survey';
        
        String nextPage = controller.Save().getUrl();
        System.assertEquals('/apex/W2CThankyou', nextPage);
        
        
        //String nextPage = controller.save().getUrl();
        
        //system.debug('*****' + )
        //System.assertEquals('/apex/W2CNewCase?error=noParam', nextPage);
        
    }
    
    
    static testMethod void myUnitTest2() {
        PageReference pageRef = Page.W2CNewCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ParentID', '123123123');
        Case tempCase = new Case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
        
        util controller = new util();
        controller.cs = tempCase;
        controller.catItems = 'Leaving the Company';
        controller.subItems = 'Exit Survey';
        
        String nextPage = controller.finish().getUrl();
        System.assertEquals('/apex/W2CThankyou', nextPage);
    }
    
    
    static testMethod void myUnitTest3() {
        PageReference pageRef = Page.W2CNewCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ParentID', '123123123');
        Case tempCase = new Case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
        tempCase.Category__c = 'Leaving the Company';
        tempCase.Sub_Category__c = 'Exit Survey';
        
        //insert tempCase;
        
        
        util controller = new util();
        controller.cs = tempCase;
        controller.catItems = 'Leaving the Company';
        controller.subItems = 'Exit Survey';
        
        String nextPage = controller.attachDocument().getUrl();
        //System.assertEquals('/apex/attachmentPage', nextPage);
    }
    
    static testMethod void myUnitTest4() {
        Case tempCase = new Case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
        tempCase.Category__c = 'Leaving the Company';
        tempCase.Sub_Category__c = 'Exit Survey';
        tempCase.Origin = 'Web';
        tempCase.ownerID = '00G28000000RB6eEAG';
        
        try {
            insert tempCase;
        } catch (Exception e) {
            system.debug(e);
        }
        
        ID tempID;
        List<Case> lstCase = [select id from case];
        for (Case cs : lstCase) {
            tempID = cs.id;
        }
        
        Attachment tempattach = new Attachment();
        tempattach.name = 'Test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        tempattach.body=bodyBlob;
        tempattach.parentId= tempID;
        
        
        PageReference pageRef = Page.W2CNewCase;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ParentID', tempID);
        util controller = new util();
        controller.attachment = tempattach;
        controller.cs = tempCase;
        controller.catItems = 'Leaving the Company';
        controller.subItems = 'Exit Survey';
        
        String nextPage = controller.attachDocument().getUrl();
        nextPage = controller.upload().getUrl();
        //PageReference pageRef = Page.W2CNewCase;
        //Test.setCurrentPage(pageRef);
    }
    
    */
 
}