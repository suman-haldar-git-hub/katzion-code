public without sharing class util {
    
    /*
Author - Najib Asif
Purpose - This is a custom controller built specifically for Visualforce page

Change History:
27/10/2016 Sally Montgomery - Modified to allow for Big W Enablement

*/
    
    /*
============================================================
Below public variables which are used and called by methods
in the class and VF Page
============================================================
*/
    public Case cs {get;set;}
    public String catItems{get;set;}                        // this is for selectlist
    public List<SelectOption> categoryValue{get;set;}       // this is for selectoption
    public String subItems{get;set;}                        // this is for selectlist
    public List<SelectOption> subcategoryValue{get;set;}    // this is for selectoption
    public boolean SubMandatory{get;set;}                   // this is for making Sub Category mandatory
    public String ckeonbehalfValue {get;set;} //19/05/2016 Added by Sally Montgomery to resolve On Behalf of Display issues
    public String ckeonbehalf {get; set; }
    public String getcatvalue {get;set;} //03/05/2017 Added by Sally Montgomery as part of reporting changes
    public String getrequestfreq {get;set;} //04/05/2017 Added by Sally Montgomery to capture Request Frequency selection
    public ID attachmentID {get; set;}
    public String attachmentParentID {get; set;}
    
    public list<String> subcatlist;
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    
    public List<Attachment> lstAttachments {get; set;}
    
    // changes done for  Problem# PRB00001449
    public String filetypes {get;set;}
    public Set<String> attachmentTypes{get;set;}
    public List<Picklist_Field_Value__c> picklistFiletypes{get;set;}
    
    /*
============================================================
Below public constructor and methods to extract category &
Sub-Category information
============================================================
*/
    //cons
    public util() {
        cs = new Case();
        subcatlist = new list<String>();
        categoryValue = new List<SelectOption>();
        categoryValue = obtainValue();
        //String value = ApexPages.currentPage().getParameters().get('ParentID');
        lstAttachments = [select id, name, Description, BodyLength, parentID from Attachment where parentID = :ApexPages.currentPage().getParameters().get('ParentID')];
        ckeonbehalf = 'No';
        // changes done for  Problem# PRB00001449
        picklistFiletypes=getFileTypes();
        attachmentTypes =getAttachmentType(picklistFiletypes);
        filetypes=getAttachmentTypeInString(picklistFiletypes);
        
    }
    
    
    // changes done for  Problem# PRB00001449
    public Set<String> getAttachmentType(List<Picklist_Field_Value__c> atchTypes){
        Set<String> attachmentTypes = new Set<String>();
        // List<Picklist_Field_Value__c> atchTypes=getFileTypes();
        if(!atchTypes.isEmpty()) {
            for (Picklist_Field_Value__c ps : atchTypes) {
                attachmentTypes.add(ps.Web_Value__c);
                
            }
        }
        return attachmentTypes;
    }
    // changes done for  Problem# PRB00001449
    
    public List<Picklist_Field_Value__c> getFileTypes(){
        List<Picklist_Field_Value__c> fileTypes = [select id
                                                   ,Name
                                                   ,Picklist_Field_Value__c
                                                   ,Web_Value__c
                                                   ,Object_Field__r.Object__c
                                                   ,Object_Field__r.Field_Name__c
                                                   ,Sequence_Number__c 
                                                   from Picklist_Field_Value__c
                                                   where Object_Field__r.Object__c = 'Case'
                                                   and Object_Field__r.Field_Name__c = 'AttachmentType'
                                                   and Web_Display__c = true
                                                   order by Sequence_Number__c];
        return fileTypes;
    }
    // changes done for  Problem# PRB00001449
    
    public String getAttachmentTypeInString(List<Picklist_Field_Value__c> atchTypes){
        
        List<String> attachmentTypes = new List<String>();
        if(!atchTypes.isEmpty()) {
            for (Picklist_Field_Value__c ps : atchTypes) {
                attachmentTypes.add(ps.Web_Value__c);
                
            }
        }
        return String.join(attachmentTypes, ', ');
    }
    
    // getting category value
    public List<SelectOption> obtainValue() {
        List<SelectOption> options = new List<SelectOption>();
        List<Picklist_Field_Value__c> plfVlaue = [select id
                                                  ,Name
                                                  ,Picklist_Field_Value__c
                                                  ,Web_Value__c
                                                  ,Object_Field__r.Object__c
                                                  ,Object_Field__r.Field_Name__c
                                                  ,Sequence_Number__c 
                                                  from Picklist_Field_Value__c
                                                  where Object_Field__r.Object__c = 'Case'
                                                  and Object_Field__r.Field_Name__c = 'Category'
                                                  and Web_Display__c = true
                                                  order by Sequence_Number__c];
        if(!plfVlaue.isEmpty()) {
            for (Picklist_Field_Value__c ps : plfVlaue) {
                this.categoryValue.add(new SelectOption(ps.Picklist_Field_Value__c, ps.Web_Value__c));
            }
        }
        return this.categoryValue;
    }
    
    //19/05/2016 Added by Sally Montgomery to resolve On Behalf of Display issues
    public void UpdateckeonbehalfValue() {
        ckeonbehalfValue = ckeonbehalf;  
        system.debug('xxxxxxckeonbehalfValue: ' + ckeonbehalfValue);
        system.debug('xxxxxxckeonbehalf: ' + ckeonbehalf);
    }
    
    //04/05/2017 Added by Sally Montgomery as part of reporting request enhancement
    //Passes the selected Request Frequency field value to a String to be used to conditionally make requirement mandatory
    public void getrequestfreq() {
        getrequestfreq = cs.Request_Frequency__c;
        system.debug('xxxxxgetrequestfreq: ' +cs.Request_Frequency__c);
    }
    
    //03/05/2017 Added by Sally Montgomery as part of reporting request enhancement
    //Passes the selected Category field value to a String to be used in rendered tabs in visualforce page
    public void getCatValue() {
        getcatvalue = this.catItems;
        system.debug('xxxxxxxgetcatvalue: ' +getcatvalue);
    }
    //03/05/2017 Added by Sally Montgomery as part of reporting request enhancement
    //Used in Category Action tag on Visualforce page to allow for multiple methods to be called in one action
    
    public PageReference callTwoMethods() {
        testingsub();
        getCatValue();
        return null;
    }
    
    public void testingsub() {
        subcategoryValue  = new List<SelectOption>();
        String st = this.catItems;
        List<Related_Value__c> plfVlaue = [select
                                           id
                                           ,Top_Field_Value__r.Name
                                           ,Top_Field_Value__r.Picklist_Field_Value__c
                                           ,Top_Field_Value__r.Web_Value__c
                                           ,Dependant_Field_Value__r.Name
                                           ,Dependant_Field_Value__r.Picklist_Field_Value__c
                                           ,Dependant_Field_Value__r.Web_Value__c
                                           from Related_Value__c
                                           where Top_Field_Value__r.Picklist_Field_Value__c = :catItems
                                           //27/10/2016 Added by Sally Montgomery to allow for Big W Enablement
                                           and Web_Display__c = True
                                           order by Sequence_Number__c];
        if(!plfVlaue.isEmpty()) {
            this.subcategoryValue.add(new SelectOption('--None--', '--None--'));
            for (Related_Value__c ps : plfVlaue) {
                this.subcategoryValue.add(new SelectOption(ps.Dependant_Field_Value__r.Picklist_Field_Value__c, ps.Dependant_Field_Value__r.Web_Value__c));
            }
        } else {
            this.subcategoryValue.add(new SelectOption('--None--', '--None--'));
        }                                        
    }
    
    /*
============================================================
Below Method are used by VisualForce Pages
These methods are bound by VF Page button
============================================================
*/
    
    // Save Case and redirect to Thank you page
    public PageReference Save() {
        
        cs.Category__c = this.catItems;
        cs.Sub_Category__c = this.subItems;
        cs.Origin = 'Web';
        cs.ownerID = Label.Case_Owner_Id; // this is pointing to Advisory by Default. This will stop Status changing to "inprogress"
        
        // 03.11.2016 Added to allow mandatory setting of Sub Category at Category level on Picklist Values object record
        // added this if check to avoid Too many SQL error durign Test coverage run Problem# PRB00001449
        if(cs.Sub_Category__c == '' || cs.Sub_Category__c == null || cs.Sub_Category__c == '--None--'){
            List<Picklist_Field_Value__c> MandatorySetting = [select Sub_Category_Mandatory_in_Webform__c from Picklist_Field_Value__c
                                                              where Picklist_Field_Value__c =: this.catItems
                                                              and Object_Field__r.Field_Name__c = 'Category'
                                                              and Web_Display__c = true limit 1];
            for(Picklist_Field_Value__c ps1 : MandatorySetting){
                SubMandatory = ps1.Sub_Category_Mandatory_in_Webform__c;}
            system.debug('xxxxxSubMandatory: '+SubMandatory);
        }
        if(cs.Web_Employee_Id__c.length() < 6) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Employee ID must be minimum 6 Characters'));
            return null;
        }
        
        // Make Category fields mandetatory
        if(this.catItems== '' || this.catItems == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Choose a value for Category'));
            return null;
        } 
        
        // 03.11.2016 Sub-category fields only mandatory if only certain Category fields are populated
        //  modified this if check to avoid Too many SQL error durign Test coverage run Problem# PRB00001449
        if((cs.Sub_Category__c == '' || cs.Sub_Category__c == null || cs.Sub_Category__c == '--None--') && SubMandatory == True){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Choose a value for Sub-Category'));
            return null;
        }
        
        // 26.05.2016 Sally Montgomery - Added to make Existing Case# field mandatory when Is this a New People Query or Process Request? = No
        if(cs.New_People_Query_or_Process_Request__c == 'No' && (cs.Related_to_Existing_Case_Number__c == null ||cs.Related_to_Existing_Case_Number__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Existing Case #'));
            return null;
        } 
        
        // 17.08.2016 Sally Montgomery - Added to make Preferred Phone field mandatory when Preferred Method of Contact is Phone
        if(cs.Preferred_Contact_Method__c == 'Phone' && (cs.Preferred_Phone__c == null || cs.Preferred_Phone__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Preferred Phone Number'));
            return null;
        } 
        
        // 17.08.2016 Sally Montgomery - Added to make Preferred Email field mandatory when Preferred Method of Contact is Email
        if(cs.Preferred_Contact_Method__c == 'Email' && (cs.Preferred_Email__c == null || cs.Preferred_Email__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Preferred Email Address'));
            return null;
        }
        
        // On-Behalf fields are required field if (ckeonbehalf) selected as yes
        if(ckeonbehalf == 'Yes' && 
           (    
               (cs.Web_On_Behalf_Of_First_Name__c == null || cs.Web_On_Behalf_Of_First_Name__c == '') || 
               (cs.Web_On_Behalf_Of_Last_Name__c == null || cs.Web_On_Behalf_Of_Last_Name__c == '') || 
               (cs.Web_On_Behalf_Of_Employee_Id__c == null || cs.Web_On_Behalf_Of_Employee_Id__c == '')
           )
          ){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Fill in On-Behalf Section - Their First Name, Their Last Name, Their Employee ID '));
              return null;
          }
        
        // If on-behalf is selected and 
        // Web_On_Behalf_Of_Employee_Id__c value is not null only then it will pick up the value from Person Account
        // Lot employee account are manually created
        // and some-time employee id is left blank. This new change will ensure it will pick-up employee ID which already exists in Database
        if( ckeonbehalf == 'Yes' && 
           (cs.Web_On_Behalf_Of_Employee_Id__c != null || cs.Web_On_Behalf_Of_Employee_Id__c != '')) {
               list<Account> lstbehalf = [select id from Account where Employee_ID__c = :cs.Web_On_Behalf_Of_Employee_Id__c limit 1];
               
               if(!lstbehalf.isEmpty()) {
                   for (Account act : lstbehalf) {
                       cs.On_Behalf_Of_Name__c = act.id;
                   }
               }
           }
        // get On-behalf of account information based employeed ID supplied
        
        
        // Static code for Case Category update
        if(cs.Category__c == 'Pay and the Basics' && cs.Sub_Category__c == 'WOW People Discount Card') {
            cs.Category__c = 'Benefits';
        } else if (cs.Category__c == 'Pay and the Basics' && cs.Sub_Category__c == 'Salary Sacrifice Forms') {
            cs.Category__c = 'Reward';
        } else {
            //
        }
        try {
            insert cs;
        } catch (Exception e) {
            System.debug('********** issue - ' + e + '******');
        }
        PageReference W2Case = new PageReference('/apex/W2CThankyou');
        return W2Case;
    }
    
    public PageReference finish() {
        //isreq = false;
        PageReference W2Case = new PageReference('/apex/W2CThankyou');
        return W2Case;
    }
    
    // Save Case and redirect to Attachment Page
    public PageReference attachDocument() {
        cs.Category__c = this.catItems;
        cs.Sub_Category__c= this.subItems;
        cs.Origin = 'Web';
        cs.ownerID = Label.Case_Owner_Id; // this is pointing to Advisory by Default. This will stop Status changing to "inprogress"
        
        //Added to allow mandatory setting of Sub Category at Category level on Picklist Values object record
        //added this if check to avoid Too many SQL error durign Test coverage run Problem# PRB00001449
        if(cs.Sub_Category__c == '' || cs.Sub_Category__c == null || cs.Sub_Category__c == '--None--'){
            List<Picklist_Field_Value__c> MandatorySetting = [select Sub_Category_Mandatory_in_Webform__c from Picklist_Field_Value__c
                                                              where Picklist_Field_Value__c =: this.catItems
                                                              and Object_Field__r.Field_Name__c = 'Category'
                                                              and Web_Display__c = true limit 1];
            for(Picklist_Field_Value__c ps1 : MandatorySetting){
                SubMandatory = ps1.Sub_Category_Mandatory_in_Webform__c;}
            system.debug('xxxxxSubMandatory: '+SubMandatory);
        }
        
        if(cs.Web_Employee_Id__c.length() < 6) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Employee ID must be 6 Character'));
            return null;
        }
        
        // Make Category fields mandetatory
        if(this.catItems== '' || this.catItems == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Choose a value for Category'));
            return null;
        } 
        
        // 03.11.2016 Sub-category fields only mandatory if only certain Category fields are populated
        //  modified this if check to avoid Too many SQL error durign Test coverage run Problem# PRB00001449
        if((cs.Sub_Category__c == '' || cs.Sub_Category__c == null || cs.Sub_Category__c == '--None--') &&SubMandatory == True ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Choose a value for Sub-Category'));
            return null;
        }
        
        // 26.05.2016 Sally Montgomery - Added to make Existing Case# field mandatory when Is this a New People Query or Process Request? = No
        if(cs.New_People_Query_or_Process_Request__c == 'No' && (cs.Related_to_Existing_Case_Number__c == null ||cs.Related_to_Existing_Case_Number__c == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Existing Case #'));
            return null;
        } 
        
        // On-Behalf fields are required field if (ckeonbehalf) selected as yes
        if(ckeonbehalf == 'Yes' && 
           (    
               (cs.Web_On_Behalf_Of_First_Name__c == null || cs.Web_On_Behalf_Of_First_Name__c == '') || 
               (cs.Web_On_Behalf_Of_Last_Name__c == null || cs.Web_On_Behalf_Of_Last_Name__c == '') || 
               (cs.Web_On_Behalf_Of_Employee_Id__c == null || cs.Web_On_Behalf_Of_Employee_Id__c == '')
           )
          ){
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Fill in On-Behalf Section - Their First Name, Their Last Name, Their Employee ID '));
              return null;
          }
        //20.05.2016 Sally Montgomery - Updated on behalf of behaviour to match Save method - now considers where employee id is blank on records
        // If on-behalf is selected and 
        // Web_On_Behalf_Of_Employee_Id__c value is not null only then it will pick up the value from Person Account
        // Lot employee account are manually created
        // and some-time employee id is left blank. This new change will ensure it will pick-up employee ID which already exists in Database
        if( ckeonbehalf == 'Yes' && 
           (cs.Web_On_Behalf_Of_Employee_Id__c != null || cs.Web_On_Behalf_Of_Employee_Id__c != '')) {
               list<Account> lstbehalf = [select id from Account where Employee_ID__c = :cs.Web_On_Behalf_Of_Employee_Id__c limit 1];
               
               if(!lstbehalf.isEmpty()) {
                   for (Account act : lstbehalf) {
                       cs.On_Behalf_Of_Name__c = act.id;
                   }
               }
           }
        
        if(cs.Category__c == 'Pay and the Basics' && cs.Sub_Category__c == 'WOW People Discount Card') {
            cs.Category__c = 'Benefits';
        } else if (cs.Category__c == 'Pay and the Basics' && cs.Sub_Category__c == 'Salary Sacrifice Forms') {
            cs.Category__c = 'Reward';
        } else {
            //
        }
        if(Schema.sObjectType.Case.fields.category__c.isCreateable() && 
           Schema.sObjectType.Case.fields.origin.isCreateable() &&
           Schema.sObjectType.Case.fields.ownerid.isCreateable() && 
           Schema.sObjectType.Case.fields.sub_category__c.isCreateable() &&
           Schema.sObjectType.Case.fields.on_behalf_of_name__c.isCreateable()){
        	insert cs;
        }
        
        PageReference attachpage = new PageReference('/apex/attachmentPage');
        attachpage.getParameters().put('ParentID',cs.ID);
        //attachpage.getParameters().put('geturlvale', ApexPages.currentPage().getUrl() );
        attachpage.setRedirect(true);
        return attachpage; 
    }
    //Problem# PRB00001449
    public boolean isValidFileType(Attachment atch){
        
        List<String> fileNameExtension = atch.Description.split('\\.');
        String fileExtension = fileNameExtension[fileNameExtension.size() - 1];
        // attachmentTypes =getAttachmentType();
        // Fix INC01536913 11/8/17 (agarg2@woolworths.com.au) Start
        //if(attachmentTypes.contains(fileExtension))
        if(attachmentTypes.contains(fileExtension.toLowerCase()))
        // Fix INC01536913 11/8/17 (agarg2@woolworths.com.au) End
            return true;
        else
            return false;
        
        
    }
    
    // Attachment upload Page
    // This will allow to upload multiple of Attachment and render back to same page
    public PageReference upload() {
        //Problem# PRB00001449
        if( attachment!=null && attachment.name!=null &&  attachment.name !=''){
            attachment.OwnerId =  '00528000000S3f1AAC';
            attachment.ParentId = ApexPages.currentPage().getParameters().get('ParentID');
            attachment.IsPrivate = false;
            attachment.Description = attachment.name;
            // changes done for  Problem# PRB00001449 start 
            if(!isValidFileType(attachment))
            {
                attachment=null;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.accepted_case_file_types +' '+ getAttachmentTypeInString(picklistFiletypes)));
                return null;
            }
            
            // changes done for  Problem# PRB00001449 end 
            PageReference attachpage = new PageReference('/apex/attachmentPage');
            attachpage.getParameters().put('ParentID',attachment.ParentId);
            attachpage.setRedirect(true);
            
            try {
                insert attachment;
                return attachpage;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                return null;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.attachment_empty));
            return null;
        }
        
    }
    
    public PageReference UploadAndFinish() {
        //Problem# PRB00001449
        if( attachment!=null && attachment.name!=null &&  attachment.name !=''){
            attachment.OwnerId =  '00528000000S3f1AAC';
            attachment.ParentId = ApexPages.currentPage().getParameters().get('ParentID');
            attachment.IsPrivate = false;
            attachment.Description = attachment.name;
            
            
            // changes done for  Problem# PRB00001449 start 
            
            if(!isValidFileType(attachment))
            {
                attachment=null;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.accepted_case_file_types +' '+ getAttachmentTypeInString(picklistFiletypes)));
                return null;
            }
            
            
            // changes done for  Problem# PRB00001449 end  
            ApexPages.currentPage().getParameters().clear();
            PageReference NewCasePage = new PageReference('/apex/W2CThankyou');
            NewCasePage.setRedirect(true);
            try {
                insert attachment;
                return NewCasePage;
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
                return null;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.attachment_empty));
            return null;
        }
        
        
    }
    
    //delete attachment for custom controller
    public PageReference deleteCon() {
        list<Attachment> lstatt = [select id from Attachment where id = :attachmentID];
        if(!lstatt.isEmpty()) {
            try {
                delete lstatt;
            } catch (Exception e) {
                
            }
        }
        
        attachment.OwnerId =  '00528000000S3f1AAC';
        attachment.ParentId = ApexPages.currentPage().getParameters().get('ParentID');
        attachment.IsPrivate = false;
        
        PageReference attachpage = new PageReference('/apex/attachmentPage');
        attachpage.getParameters().put('ParentID',attachment.ParentId);
        attachpage.setRedirect(true);
        return attachpage;
        
    }
    
    /*
============================================================
Below are not required but inserted for maybe in future use
============================================================
*/
    
    /*
// Save Case and return the newinstance of the Page
public PageReference SaveCaseRtNewPage() {
insert cs;
PageReference CasePage = new PageReference('/apex/testPage');
return CasePage;
}

Save Case and return the Same Page Again
public PageReference SaveCase() {
insert cs;
return null;
}

*/
}