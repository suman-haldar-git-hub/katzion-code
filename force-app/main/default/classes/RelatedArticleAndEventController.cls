/**
* @author : Ankit Singh
* @company : SaaSFocus A Cognizant Company
* @description : This class is used to for lazy loading of article in home page
*/
public with sharing class RelatedArticleAndEventController {
    /**
* @author : Ankit Singh
* @description : This method is used to fetch KNowledge__kav.
* @param urlname
* @param preview
* @return : ArticleWrapper
*/
    @AuraEnabled
    public static ArticleWrapper fetchArticleOrEventData(string urlname,boolean preview){
        ArticleWrapper objWrapper = new ArticleWrapper();
        try{
            List<Knowledge__kav> knowledgeDetail = new List<Knowledge__kav>();
            Map<String, String> mapImageKeyToUrl = new Map<String, String>();
            knowledgeDetail = KnowledgeDomain.getKnowledgeDetailsForArticledetail(urlname,preview);
            String recordTypeName = '';
            String articleUrlname = '';
            String calenderDate = '';
            String bannerImage = '';
            String mobBannerImage = '';
            if(
                knowledgeDetail != null
                &&
                !knowledgeDetail.isEmpty()
            ) {
                //Added by sunil to dynamically fetch ContentDocumentList and ContentDistribution
                mapImageKeyToUrl = ContentDistributionService.fetchPublicUrl(new set<Id>{knowledgeDetail[0].Id});
                recordTypeName = knowledgeDetail[0].RecordType.Name;
                articleUrlname = knowledgeDetail[0].UrlName;
                bannerImage = mapImageKeyToUrl.containsKey(knowledgeDetail[0].Id+'-Banner')?
                                       mapImageKeyToUrl.get(knowledgeDetail[0].Id+'-Banner'):'';
                mobBannerImage = mapImageKeyToUrl.containsKey(knowledgeDetail[0].Id+'-Mobile Banner')?
                                       mapImageKeyToUrl.get(knowledgeDetail[0].Id+'-Mobile Banner'):'';
                calenderDate = getCalendarDate(knowledgeDetail[0], recordTypeName);
            }
            if(
                String.isNotBlank(recordTypeName)
                &&
                recordTypeName == Label.ARTICLE
            ) {
                knowledgeDetail = fetchArticleData(KnowledgeDetail, articleUrlname);
            }
            objWrapper.knowledgeDetail = knowledgeDetail;
            objWrapper.calenderDate = calenderDate;
            objWrapper.bannerImage = bannerImage;
            objWrapper.mobileBannerImage = mobBannerImage;
        }
        catch(Exception ex){PublishLogEventService.publishExceptionEvent
                ('RelatedArticleAndEventController.cls on load',ex);}
        return objWrapper;
    }
    /**
* @author : Ankit Singh
* @description : This method is used to fetch article recordtype data.
* @param knowledgeDetail
* @param recordTypeName
* @return : String
*/
    public static String getCalendarDate(
        Knowledge__kav knowledgeDetail,
        String recordTypeName
    ) {
        String calenderDate = '';
        if(recordTypeName == Label.EVENT) {
            Timezone tz = Timezone.getTimeZone('Australia/Sydney');
            Datetime strtDate = knowledgeDetail.StartDate__c.addHours(-tz.getOffset(knowledgeDetail.StartDate__c)/(60*60*1000));
            Datetime endDate = knowledgeDetail.EndDate__c.addHours(-tz.getOffset(knowledgeDetail.EndDate__c)/(60*60*1000));
            calenderDate = string.valueof(
                strtDate.format('yyyyMMdd\'T\'HHmmSS\'Z\'')
            );
            calenderDate +=  string.valueof(
                endDate.format('\'/\'yyyyMMdd\'T\'HHmmSS\'Z\'')
            );
        }
        return calenderDate;
    }

    
    /**
    * @author       Ankit Singh
    * @description  This method is used to fetch article recordtype data.
    * @param        knowledgeDetail
    * @param        articleUrlname
    * @return       List<Knowledge__kav>
    */
    public static List<Knowledge__kav> fetchArticleData(
        List<Knowledge__kav> knowledgeDetail,
        String articleUrlname
    ) {
        String searchTerms = '';
        searchTerms = getSearchKeyword(knowledgeDetail, searchTerms);
        searchTerms = searchTerms.removeEnd(' OR ');
        List<Knowledge__kav> searchedArticle = getSearchedArticle(searchTerms, knowledgeDetail,articleUrlname);
        map<String, String> mapImageKeyToUrl = new map<String, String>(); //Added by sunil to fetch dynamic image 
        Set<Id> articleIdSet = new Set<Id>(); //Added by sunil to fetch dynamic image 
        if(searchedArticle != null && !searchedArticle.isEmpty()) {
            //Added by sunil to dynamically fetch ContentDocumentList and ContentDistribution
            for(Knowledge__kav eachArticle: searchedArticle){
                articleIdSet.add(eachArticle.Id);
            }
            mapImageKeyToUrl = ContentDistributionService.fetchPublicUrl(articleIdSet);
            //Added by sunil to dynamically fetch ContentDocumentList and ContentDistribution
            knowledgeDetail.clear();
            for(Knowledge__kav objArticle : searchedArticle) {                
                objArticle.ThumbnailURL__c = mapImageKeyToUrl.containsKey(objArticle.Id+'-Thumbnail')?
                                            mapImageKeyToUrl.get(objArticle.Id+'-Thumbnail'):'';
                knowledgeDetail.add(objArticle);                
            }
        }
        return KnowledgeDetail;
    }
    
    /**
* @author : Ankit Singh
* @description : This method is get search keyword
* @param knowledgeDetail
* @param searchTerms
* @return String
*/
    private static String getSearchKeyword(
        List<Knowledge__kav> knowledgeDetail,
        String searchTerms
    ) {
        String[] title = (KnowledgeDetail[0].Title).split(' ');
        String[] rejectedWord = Label.REJECTEDRELATEDARTICLESEARCHWORD.split(',');
        if(rejectedWord != null && !rejectedWord.isEmpty()) {
            for(String strkeyword : title) {
                if(!rejectedWord.contains(strkeyword)) {
                    searchTerms+= '("' + strkeyword + '")' + ' OR ';
                }
            }
        }
        return searchTerms;
    }
    
    /**
    * @author       Ankit Singh
    * @description  This method return Searched Article
    * @param        searchTerms
    * @param        knowledgeDetail
    * @param        articleUrlname
    * @return       searchedArticle
    */
    private static List<Knowledge__kav> getSearchedArticle(        
        String searchTerms,
        List<Knowledge__kav> knowledgeDetail,
        String articleUrlname
    ) {
        return Test.isRunningTest() ? knowledgeDetail :
        KnowledgeDomain.getRelatedArticle(searchTerms,articleUrlname);        
    }
    
    /**
* @author :Ankit Singh
* @description : wrapper class
*/
    public class ArticleWrapper{
        @AuraEnabled
        public List<Knowledge__kav> knowledgeDetail = new List<Knowledge__kav>();
        @AuraEnabled
        public String calenderDate;
        @AuraEnabled
        public String bannerImage;
        @AuraEnabled
        public String mobileBannerImage;
    }
}