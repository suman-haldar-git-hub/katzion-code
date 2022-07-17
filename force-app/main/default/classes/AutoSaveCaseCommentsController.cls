/**
 * @author : Sumit Banarji
 * @company : Cognizant
 * @description : This class is an Controller Class for AutoSaveCaseComments LWC
 */
@SuppressWarnings('PMD.ExcessiveParameterList')
public with sharing class AutoSaveCaseCommentsController {
    
    /**
     * @author : Sumit Banarji
     * @description : This method to get Data
     * @param commentId
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse getData(String commentId){
        return AutoSaveCaseCommentsAdapter.getData(commentId);
    }

    /**
     * @author : Sumit Banarji
     * @description : This method to save the data
     * @param commentId
     * @param caseId
     * @param comment
     * @param caseType
     * @param caseTitle
     * @return lightningResponse
     */
    @AuraEnabled
    public static lightningResponse saveData(String commentId, String caseId, String comment,String caseType,String caseTitle){
        return AutoSaveCaseCommentsAdapter.saveData(commentId, caseId, comment,caseType,caseTitle);
    }

        /**
     * @author : Aman Kumar
     * @description : This method to delete Chatter Feed adn Case comment.
     * @param commentId
     * @param chatterFeedId
     * ECICD- 828
     */
    @AuraEnabled
    public static void deleteChatter(string commentId, string chatterFeedId){
        try { 
             Database.Delete(chatterFeedId, true);
             Database.Delete(commentId, true);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}