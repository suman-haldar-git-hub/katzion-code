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
private class util_BigW_test {
    
    static testMethod void myUnitTest() {
        PageReference pageRef = Page.W2CNewCase_BigW;
        Test.setCurrentPage(pageRef);
         
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
        
        Case_Record_Types__c caseRec = TestUtility.getCaseRecordTypesCustomSettings();
   		insert caseRec;
   		List<Case> Caselist = TestUtility.createTrxCases(2,caseRec.Query_Case__c);
   		case tempcase = Caselist[0]; 
              
        
        ApexPages.currentPage().getParameters().put('ParentID', '123123124');
        util_BigW controller = new util_BigW();
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
        
        
//        Case tempCase = new Case();
        tempCase.Web_Employee_Id__c = '905632';
        tempCase.SuppliedName = 'Aaron Smith';
        tempCase.WOW_Web_Email_Address__c = 'abcd@gmail.com';
        tempCase.Subject = 'Testing - Util';
        tempCase.Description = 'Testing - Description';
        tempCase.RecordTypeID = '012280000008xsSAAQ';

        
        Date myDate = Date.newInstance(1960, 2, 17);
        tempCase.Web_Birth_Date__c = myDate;
        controller.cs = tempCase;
        PageReference thankyouPage_BigW = controller.save();
        
        tempCase.Web_Employee_Id__c = '90563';
        controller.cs = tempCase;
        thankyouPage_BigW = controller.save();
        //PageReference attachDocumentPage = controller.attachDocument();
        PageReference FinishPage = controller.finish();
        
        controller.cs.Web_Employee_Id__c = '905632';
        controller.catItems = null;
        thankyouPage_BigW = controller.save();
        PageReference attachDocumentPage = controller.attachDocument();
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = '';
        thankyouPage_BigW = controller.save();
 //       attachDocumentPage = controller.attachDocument();
        
        controller.ckeonbehalf = 'Yes';
        controller.cs.Web_On_Behalf_Of_First_Name__c = null;
        controller.cs.Web_On_Behalf_Of_Last_Name__c = null;
        controller.cs.Web_On_Behalf_Of_Last_Name__c = null;
//24.05.2016 Sally Montgomery added        
        controller.UpdateckeonbehalfValue();


        
        thankyouPage_BigW = controller.save();
        attachDocumentPage = controller.attachDocument();
        
        controller.ckeonbehalf = 'Yes';
        controller.cs.Web_On_Behalf_Of_First_Name__c = 'temp';
        controller.cs.Web_On_Behalf_Of_Last_Name__c = 'Hi';
	    controller.cs.Web_On_Behalf_Of_Employee_Id__c = '123456';
        thankyouPage_BigW = controller.save();
//	    attachDocumentPage = controller.attachDocument();
        
        controller.ckeonbehalf = 'No';
        controller.cs.Web_On_Behalf_Of_First_Name__c = null;
        thankyouPage_BigW = controller.save();
//        attachDocumentPage = controller.attachDocument();
        
        /*
        ======================================================
        ======================================================
        */
        controller.ckeonbehalf = 'Yes';
        tempCase.Web_On_Behalf_Of_First_Name__c = 'Test';
        tempCase.Web_On_Behalf_Of_Last_Name__c = 'lastname';
        tempCase.Web_On_Behalf_Of_Employee_Id__c = '';
        controller.cs = tempCase;
        thankyouPage_BigW = controller.save();
   // 	attachDocumentPage = controller.attachDocument();
   
    
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'WOW People Discount Card';
        thankyouPage_BigW = controller.save();
        System.assertEquals(TempCase.Category__c,'Pay and the Basics');
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'Salary Sacrifice Forms';
        thankyouPage_BigW = controller.save();
        
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'WOW People Discount Card';
        attachDocumentPage = controller.attachDocument();
        
        controller.catItems = 'Pay and the Basics';
        controller.subItems = 'Salary Sacrifice Forms';
        attachDocumentPage = controller.attachDocument();
        
        //26.05.2016 Sally Montgomery added to test errors for existing case number
        tempCase.New_People_Query_or_Process_Request__c = 'No';
        tempCase.Related_to_Existing_Case_Number__c = '';
        thankyouPage_BigW = controller.save();
        
        //25.05.2017 Sekar Krishnan Added for Reporting request
        controller.catitems = 'Report Requests';
        controller.getrequestfreq();
        controller.callTwoMethods();        
        thankyouPage_BigW = controller.save();
        
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
            //
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
        thankyouPage_BigW = controller.save();
        
        /*
        ======================================================
        ======================================================
        */
        
        
        
        try {
            insert tempCase;
        } catch (Exception e) {
            system.debug('************* trying to insert case -'  + e + '****************');
        }
        
        ID tempCaseID = null;
        
        List<Case> lstCase = [select id from Case];
        for (Case cs : lstCase) {
            tempCaseID = cs.id;
        }
        
        PageReference attachPage = Page.attachmentPage_BigW; 
        Attachment testAtt = new Attachment();
        Test.setCurrentPage(attachPage);
        ApexPages.currentPage().getParameters().put('ParentID', tempCaseID);
        
        testAtt.name = 'Test.csv';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        testAtt.body=bodyBlob;
        testAtt.ParentId= tempCaseID;
        
        controller.attachment = testAtt;
        thankyouPage_BigW = controller.upload();
        
        ApexPages.currentPage().getParameters().put('ParentID', tempCaseID);
        Attachment testAtt1 = new Attachment();
        testAtt1.name = 'Test1.csv';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        testAtt1.body=bodyBlob1;
        testAtt1.ParentId= tempCaseID;
        controller.attachment = testAtt1;
        thankyouPage_BigW = controller.UploadAndFinish();
        
        list<Attachment> lstatt = [select id from Attachment limit 1];
        ID attachmentID = null;
        for (Attachment att :lstatt) {
            attachmentID = att.id;
        }
        
        attachPage = Page.attachmentPage_BigW; 
        //Attachment testAtt = new Attachment();
        Test.setCurrentPage(attachPage);
        ApexPages.currentPage().getParameters().put('ParentID', tempCaseID);
        controller.attachmentID = attachmentID;
          Try{       
           thankyouPage_BigW = controller.deletecon();
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
    }
    
    static testMethod void myUnitTest3() {
        PageReference pageRef = Page.W2CNewCase_BigW;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ParentID', '123123123');
        util_BigW controller = new util_BigW();
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
    
 
}