/**
* @Author : Sunil
* @Company : Cognizant
* @description : This Domain Class is used to query and insert data for Knowledge__kav object
*/
public inherited sharing class KnowledgeDomain {
    /**
    * @Author : Sunil
    * @description :This method returns the Knowledge__kav details for PublishKnowledgeController
    * @return Knowledge__kav
    * @param recordId
    */
    public static Knowledge__kav getKnowledgeDetailsForPublishController(Id recordId) {
        return [
            SELECT Id,DateOfExpiry__c,PublishStatus,KnowledgeArticleId, StartDate__c,
            ScheduledPublicationDate__c,ArticleAuthorName__c,Title,
            RecordType.Name, BannerImageURL__c,ThumbnailURL__c,Summary,
            PublisherTeamName__c, PublishAs__c
            FROM Knowledge__kav WHERE Id=:recordId
        ];
    }
    /**
    * @Author : Sunil
    * @description :This method update the Knowledge__kav details for PublishKnowledgeController
    * @return : Boolean
    * @param lstKnowledge
    */
    public static Boolean updateKnowledge(List<Knowledge__kav> lstKnowledge){
        Boolean isUpdated = false;
        if(Schema.sObjectType.Knowledge__kav.isUpdateable()){
            update lstKnowledge;
            isUpdated = true;
        }
        return isUpdated;
    }
    /**
    * @Author : Sunil
    * @description : This method will get the list of published Knowledge__kav for TeamHubMainContainerController
    * @return List<Knowledge__kav>
    */
    public static List<Knowledge__kav> getKnowledgeArticleList(){
        final String publishStatus = 'Online';
        final String dynamicQuery = 'Select Title,UrlName,Public_Article_Description2__c,Id,ArticleTotalViewCount,PublisherName__c,LastPublishedDate,PublisherName__r.Name From Knowledge__kav WHERE PublishStatus = \''+ String.escapeSingleQuotes(publishStatus)+'\' ORDER By LastModifiedDate DESC Limit 5';
        return Database.query(dynamicQuery);
    }
    /**
    * @author : Praveen Tiwari
    * @description : This method is to get the list of all the knowledge articles
    * @return : List<Knowledge__kav>
    * @params : none
    */
  public static List<Knowledge__kav> getAllKnowledgeArticleList(){
        final String publishStatus = 'Online';
        final String dynamicQuery = 'Select Title,ArticleNumber,UrlName,Public_Article_Description2__c,Id,ArticleTotalViewCount,PublisherName__c,LastPublishedDate,PublisherName__r.Name,IsLatestVersion From Knowledge__kav WHERE PublishStatus = \''+ String.escapeSingleQuotes(publishStatus)+'\' ORDER By LastModifiedDate DESC';
        return Database.query(dynamicQuery);
    }
    /**
    * @author : Sunil
    * @description : This method returns the Knowledge__kav details for TeamHubArticleDetailController
    * @return List<Knowledge__kav>
    * @param urlname
    * @param preview
    */
    public static List<Knowledge__kav> getKnowledgeDetailsForArticledetail(string urlname,boolean preview){
        String publishStatus = 'Online';
        if(preview){
            publishStatus = 'Draft';
    }
        List<Knowledge__kav> lstArticle = new List<Knowledge__kav>();
        lstArticle = [
                    SELECT Id, DateOfExpiry__c,PublishStatus,KnowledgeArticleId,
                    UrlName,PublisherName__r.FirstName, RecordType.Name, LastPublishedDate,
                    PublisherName__c,PublisherName__r.Name,PublisherName__r.LastName,Title,
                    Public_Article_Description2__c,ArticleTotalViewCount,MobileBannerImageURL__c,
                    StartDate__c, EndDate__c, LocationOfEvent__c, DurationInMinutesF__c,
                    PublisherName__r.SmallPhotoUrl, BannerImageURL__c, ThumbnailURL__c,
                    IsShareable__c, PublicURL__c, ConfidentialityLevel__c,
                    PublisherTeamName__c, PublishAs__c
                    FROM Knowledge__kav
                    WHERE UrlName=:urlname AND PublishStatus=:publishStatus LIMIT 1
            ];
         return lstArticle;  
    }
    /**
    * @author : Praveen Tiwari
    * @description :This method returns the list of Knowledge__kav details based on Set of Ids
    * @return : List<Knowledge__kav>
    * @param setArticleId
    */
    public static List<Knowledge__kav> getLatestPublishedArticles(Set<String> setArticleId) {
        return [SELECT Id, KnowledgeArticleId, VersionNumber,PublisherName__r.Name,
                  FirstPublishedDate, LastPublishedDate, Title,
                  Summary, ArchivedDate
                FROM Knowledge__kav
                WHERE PublishStatus='Online'
                AND IsLatestVersion = true
                AND Id IN :setArticleId
               ];

    }

    /**
    * @author : Ankit Singh
    * @description :This method returns the list of Knowledge__kav details based on initialRows
    * @return : List<Knowledge__kav>
    * @param initialRows
    */
    public static List<Knowledge__kav> getinitialArticle(Integer initialRows) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        allArticle = [
                SELECT Title, UrlName, Summary, ArticleBody__c, Id,
                ArticleTotalViewCount, PublisherName__c,LastPublishedDate, BannerImageURL__c,
                PublisherName__r.Name, ThumbnailURL__c, IsShareable__c, PublicURL__c,
                ConfidentialityLevel__c, PublishedDate__c, PublisherTeamName__c, PublishAs__c
                FROM Knowledge__kav
                WHERE PublishStatus='Online'
                AND IsLatestVersion = true
                AND Recordtype.Name =: Label.ARTICLE
                ORDER BY PublishedDate__c DESC, PriorityFormula__c ASC, 
                LastPublishedDate DESC
                LIMIT :initialRows OFFSET 0
        ];
        return allArticle;
    }

    /**
    * @author : Ankit Singh
    * @description :This method returns total record count of article.
    * @return : List<Knowledge__kav>
    * @param articleRecordType
    */
    public static Integer getTotalCountOfArticle(String articleRecordType) {
        Integer totalRecord = [
                SELECT COUNT()
                FROM Knowledge__kav
                WHERE PublishStatus='Online'
                AND IsLatestVersion = true
                AND Recordtype.Name =: articleRecordType
        ];
        return totalRecord;
    }

    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @param rowLimit
    * @param rowOffset
    * @return List<Knowledge__kav>
    */
    public static List<Knowledge__kav> getNextArticleUsingOffset(
        Integer rowLimit,
        Integer rowOffset
    ) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        allArticle = [
                SELECT Title, UrlName, Summary,ArticleBody__c, Id,
                ArticleTotalViewCount, PublisherName__c, LastPublishedDate, PublisherName__r.Name,
                BannerImageURL__c, ThumbnailURL__c, IsShareable__c, PublicURL__c,
                ConfidentialityLevel__c, PublishedDate__c, PublisherTeamName__c, PublishAs__c
                FROM Knowledge__kav
                WHERE PublishStatus='Online'
                AND IsLatestVersion = true
                AND Recordtype.Name =: Label.ARTICLE
                ORDER BY PublishedDate__c DESC, PriorityFormula__c ASC, 
                LastPublishedDate DESC
                LIMIT :rowLimit OFFSET :rowOffset
        ];
        return allArticle;
    }

    /**
    * @author :Ankit Singh
    * @description : This method return top five events of future date
    * @return List<Knowledge__kav>
    */
    public static List<Knowledge__kav> getfutureEvents() {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        allArticle = [
                SELECT Title, UrlName, StartDate__c, LocationOfEvent__c, Summary
                FROM Knowledge__kav
                WHERE PublishStatus='Online'
                AND IsLatestVersion = true
                AND Recordtype.Name =: Label.EVENT
                AND StartDate__c >: System.now()
                ORDER BY StartDate__c  ASC
                Limit: Integer.valueOf(Label.HOMEPAGEEVENTSDEFAULTCOUNT)
        ];
        return allArticle;
    }

    /**
    * @author : Ankit Singh
    * @description :This method returns the list of Knowledge__kav details based on initialRows
    * based on Record Types
    * @return : List<Knowledge__kav>
    * @param initialRows
    * @param recordtype
    * @param columnSorting
    */
    public static List<Knowledge__kav> getinitialArticleByRecordtype(
        Integer initialRows,
        String recordtype,
        String columnSorting) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        String strquery = 'SELECT Title, UrlName, Id, PublisherName__r.Name, ';
        strquery+= 'ArticleTotalViewCount, PublisherName__c,LastPublishedDate, ';
        strquery+= 'PublisherTeamName__c, PublishAs__c ';
        strquery+= 'FROM Knowledge__kav ';
        strquery+= 'WHERE PublishStatus=\'Online\' ';
        strquery+= 'AND IsLatestVersion = true ';
        strquery+= 'AND Recordtype.Name =: recordtype';
        if(String.isNotBlank(columnSorting)) {
            strquery+= columnSorting;
        }
        else {
            strquery+= ' ORDER BY LastPublishedDate DESC';
        }
        strquery+= ' LIMIT :initialRows OFFSET 0';
        allArticle = Database.query(strquery);
        return allArticle;
    }

    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @param rowLimit
    * @param rowOffset
    * @return List<Knowledge__kav>
    * @param columnSorting
    */
    public static List<Knowledge__kav> getNextArticleUsingOffsetByRecordType(
        Integer rowLimit,
        Integer rowOffset,
        String columnSorting
    ) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        String articleRecordType = Label.ARTICLE;
        String strquery = 'SELECT Title, UrlName, Id, ArticleTotalViewCount, PublisherName__c, ';
        strquery+= 'LastPublishedDate, PublisherName__r.Name,';
        strquery+= 'PublisherTeamName__c, PublishAs__c ';
        strquery+= 'FROM Knowledge__kav ';
        strquery+= 'WHERE PublishStatus=\'Online\' ';
        strquery+= 'AND IsLatestVersion = true ';
        strquery+= 'AND Recordtype.Name =: articleRecordType';
        if(String.isNotBlank(columnSorting)) {
            strquery+= columnSorting;
        }
        else {
            strquery+= ' ORDER BY LastPublishedDate DESC';
        }
        strquery+= ' LIMIT :rowLimit OFFSET :rowOffset';
        allArticle = Database.query(strquery);
        return allArticle;
    }
    /**
    * @author : Ankit Singh
    * @description :This method returns the list of Knowledge__kav details based on initialRows
    * based on Record Types
    * @return : List<Knowledge__kav>
    * @param initialRows
    * @param recordtype
    * @param columnSorting
    */
    public static List<Knowledge__kav> getinitialEventforFutureFromNow(
        Integer initialRows,
        String recordtype,
        String columnSorting) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        DateTime currentTime = System.now();
        String strquery = 'SELECT Title, UrlName, Id, PublisherName__r.Name, StartDate__c, ';
        strquery+= 'PublisherName__c, EndDate__c, LocationOfEvent__c,';
        strquery+= 'PublisherTeamName__c, PublishAs__c ';
        strquery+= 'FROM Knowledge__kav ';
        strquery+= 'WHERE PublishStatus=\'Online\' ';
        strquery+= 'AND IsLatestVersion = true ';
        strquery+= 'AND Recordtype.Name =: recordtype ';
        if(String.isNotBlank(columnSorting)) {
            strquery+= columnSorting;
        } else {
            strquery+= 'AND StartDate__c >: currentTime ';
            strquery+= 'ORDER BY StartDate__c  ASC';
        }
        strquery+= ' LIMIT :initialRows OFFSET 0';
        allArticle = Database.query(strquery);
        return allArticle;
    }

    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @param rowLimit
    * @param rowOffset
    * @param columnSorting
    * @return List<Knowledge__kav>
    */
    public static List<Knowledge__kav> getNextEventUsingOffsetForFutureFromNow(
        Integer rowLimit,
        Integer rowOffset,
        String columnSorting
    ) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        String recordtype = Label.EVENT;
        DateTime currentTime = System.now();
        String strquery = 'SELECT Title, UrlName, Id,StartDate__c, PublisherName__r.Name, ';
        strquery+= 'PublisherName__c, EndDate__c, LocationOfEvent__c,';
        strquery+= 'PublisherTeamName__c, PublishAs__c ';
        strquery+= 'FROM Knowledge__kav ';
        strquery+= 'WHERE PublishStatus=\'Online\' ';
        strquery+= 'AND IsLatestVersion = true ';
        strquery+= 'AND Recordtype.Name =: recordtype ';

        if(String.isNotBlank(columnSorting)) {
            strquery+= columnSorting;
        } else {
            strquery+= 'AND StartDate__c >: currentTime ';
            strquery+= 'ORDER BY StartDate__c  ASC';
        }
        strquery+= ' LIMIT :rowLimit OFFSET :rowOffset';
        allArticle = Database.query(strquery);
        return allArticle;
    }

    /**
    * @author :Ankit Singh
    * @description : This method To return additional records based on offset
    * @param rowLimit
    * @param rowOffset
    * @param columnSorting
    * @return List<Knowledge__kav>
    */
    public static List<Knowledge__kav> getNextEventUsingOffsetForPastFromNow(
        Integer rowLimit,
        Integer rowOffset,
        String columnSorting
    ) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        String recordtype = Label.EVENT;
        DateTime currentTime = System.now();
        String strquery = 'SELECT Title, UrlName, Id,StartDate__c, PublisherName__r.Name, ';
        strquery+= 'PublisherName__c, EndDate__c, LocationOfEvent__c,';
        strquery+= 'PublisherTeamName__c, PublishAs__c ';
        strquery+= 'FROM Knowledge__kav ';
        strquery+= 'WHERE PublishStatus=\'Online\' ';
        strquery+= 'AND IsLatestVersion = true ';
        strquery+= 'AND Recordtype.Name =: recordtype ';

        if(String.isNotBlank(columnSorting)) {
            strquery+= columnSorting;
        } else {
            strquery+= 'AND StartDate__c <: currentTime ';
            strquery+= 'ORDER BY StartDate__c  DESC';
        }
        strquery+= ' LIMIT :rowLimit OFFSET :rowOffset';
        allArticle = Database.query(strquery);
        return allArticle;
    }

    /**
    * @author       Ankit Singh
    * @description  This method returns the list of Knowledge__kav details based on initialRows
    * @return       List<Knowledge__kav>
    * @param        searchTerms
    * @param        articleUrlname
    */
    public static List<Knowledge__kav> getRelatedArticle(String searchTerms, String articleUrlname) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        List<List<SObject>> searchquery = new List<List<SObject>>();
        String strquery = 'FIND :searchTerms';
        strquery+= ' IN All Fields RETURNING Knowledge__kav(Title, UrlName,LastPublishedDate,';
        strquery+= ' PublisherName__r.Name, Recordtype.Name, IsLatestVersion, BannerImageURL__c, ThumbnailURL__c ';
        strquery+= ' WHERE PublishStatus=\'Online\' AND Language = \'en_US\' AND IsLatestVersion=true';
        strquery += ' AND Recordtype.Name = \'' +Label.ARTICLE+ '\' AND UrlName<>:articleUrlname) LIMIT 5';
        searchquery = search.query(strquery);
        if(searchquery != null && !searchquery.isEmpty()) {
            allArticle = (List<Knowledge__kav>) searchquery[0];
        }
        return allArticle;
    }
    /**
    * @author :Sunil Kumar
    * @description : This method To return Knowledge records for preview
    * @return List<Knowledge__kav>
    * @param setRecId
    */
    public static List<Knowledge__kav> getArticlesForPreview(
        Set<String> setRecId
    ) {
        List<Knowledge__kav> allArticle = new List<Knowledge__kav>();
        allArticle = [
                SELECT Id, ThumbnailURL__c, EmailHeaderImageURL__c
                FROM Knowledge__kav
                WHERE id  IN:  setRecId
                ORDER BY PublishedDate__c DESC, PriorityFormula__c ASC, 
                LastPublishedDate DESC
        ];
        return allArticle;
    }
}