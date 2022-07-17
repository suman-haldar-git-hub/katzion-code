/**
* @author : Praveen Tiwari
* @company : Cognizant
* @description : This is a Controler Class for all the lightning components where we need to embed GenericLightningDatatable
*/
public with sharing class LightningDatatableController {
    /**
    @author : Praveen Tiwari
    @description : This method returns list of latest version of published Knowledge article version
    @return : List<Knowledge__kav>
    @params none
    */
    @AuraEnabled 
    public static  List<Knowledge__kav> getKnowledgeArticles() {
        List<Knowledge__kav> returnArticleList = new List<Knowledge__kav>();
        try{
            List<Knowledge__kav> articleRecordList = KnowledgeDomain.getAllKnowledgeArticleList();
            if(articleRecordList != null && articleRecordList.size()>0 ){
                returnArticleList = articleRecordList;
            }
        }
        catch(exception e) {throw new AuraHandledException(e.getMessage());}
        return returnArticleList;
    }
}