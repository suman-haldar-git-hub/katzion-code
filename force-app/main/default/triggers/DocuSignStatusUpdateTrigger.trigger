/**
 * @Author		:		Suman Nandy
 * @Date		:		17-Dec-2020
 * @Desc		:		Trigger to delete original file and kept the signed version of the document
 * */

/**
 * @description DocuSignStatusUpdateTrigger
 * Call helper class to process data : DeleteOriginalDocument
 * Test Class Name : DocuSignTriggerHelperTest
 */

trigger DocuSignStatusUpdateTrigger on dsfs__DocuSign_Status__c (After Update) {
	DocuSignTriggerHelper.DeleteOriginalDocument(Trigger.New);
}