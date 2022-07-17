/**
 * @author      Abhishek Setia
 * @description Handle logic detail for controller class 'AppLauncherController'
 */
public with sharing class AppLauncherService {
    
    private static Integer uniqueKey = 0;


    /**
     * @author      Abhishek Setia
     * @description Gets unique key when called each time     
     * @return      Integer
     */
    private static Integer getUniqueKey(){
        return uniqueKey++;
    }


    /**
     * @author      Abhishek Setia
     * @description Implementation of AppLauncherController.getResponse() method.
     *              Categories Applications and Portals and stores in response wrapper variables.    
     * @param       keyword - User input search keyword      
     * @return      LightningResponse wrapper object  
     */
    public static LightningResponse getResponse(String keyword){
        LightningResponse lResp=new LightningResponse();
        try{
            Map<String,List<ApplicationAndPortal__c>> mapCategoryApps=new Map<String,List<ApplicationAndPortal__c>>();
            Map<String,List<ApplicationAndPortal__c>> mapCategoryPortal=new Map<String,List<ApplicationAndPortal__c>>();
            Profile pr=ProfileDomain.queryProfileBasedOnId(UserInfo.getProfileId());
            for(ApplicationAndPortal__c appPortal:ApplicationAndPortalDomain.dataCriteriaAvailableInLauncher(true,keyword,pr.Name)){                
                if(appPortal.Category__c=='Application'){
                    categorizeMapOnSubCategory(mapCategoryApps,appPortal);
                }else if(appPortal.Category__c=='Portal'){
                    categorizeMapOnSubCategory(mapCategoryPortal,appPortal);
                }                                    
            }
            AppLauncherController.ResponseWrapper respWrap=new AppLauncherController.ResponseWrapper();
            respWrap.apps=getWrapper(mapCategoryApps);
            respWrap.portals=getWrapper(mapCategoryPortal);            
            if(!Test.isRunningTest()){                
                List<LightningDataWrapper.LightningDataRow> listLDW = getSortedFavorites(new FavoriteDomain());
                respWrap.favEmpty = listLDW.isEmpty();                 
                respWrap.favorites = getFavorites(keyword,listLDW,pr.Name);
            }                                   
            lResp.payLoad = JSON.serialize(respWrap,true);
        }catch (Exception e){
            lResp.payLoad = e.getMessage();
            lResp.isError = true;
        }        
        return lResp;
    }


    /**
     * @author      Abhishek Setia
     * @description Get favorites list of ApplicationAndPortal__c
     * @param       keyword - user input
     * @param       listLDW - List<LightningDataWrapper.LightningDataRow>
     * @param       loggedinProfileName     
     * @return      Map<Id,ApplicationAndPortal__c> 
     */
    @TestVisible
    private static List<ApplicationAndPortal__c> getFavorites(String keyword, List<LightningDataWrapper.LightningDataRow> listLDW,
        String loggedinProfileName){
            List<ApplicationAndPortal__c> returnList=new List<ApplicationAndPortal__c>();                
            Set<Id> setAppPortalId=new Set<Id>();
            for(LightningDataWrapper.LightningDataRow ldw:listLDW){            
                setAppPortalId.add(ldw.stringA);
            }
            Map<Id,ApplicationAndPortal__c> mIdAppPortal = new Map<Id,ApplicationAndPortal__c>(
                ApplicationAndPortalDomain.criteriaAvailableInLauncherRecIdKeyword(true,setAppPortalId,keyword,loggedinProfileName));  
            for(LightningDataWrapper.LightningDataRow ldw:listLDW){
                if(mIdAppPortal.containsKey(ldw.stringA)){
                    returnList.add(mIdAppPortal.get(ldw.stringA));
                }            
            }
            return returnList;
    }
    

    /**
     * @author      Abhishek Setia
     * @description Fill Favorite__b into wrapper LightningDataWrapper and sort list of LightningDataWrapper.LightningDataRow.
     * @param       fd - FavoriteDomain
     * @return      List<LightningDataWrapper.LightningDataRow>
     */
    @TestVisible
    private static List<LightningDataWrapper.LightningDataRow> getSortedFavorites(FavoriteDomain fd){ 
        List<Favorite__b> listFav = fd.queryFavBasedOnLoggedInUser(UserInfo.getUserId());
        List<LightningDataWrapper.LightningDataRow> listLDW=new List<LightningDataWrapper.LightningDataRow>();        
        for(Favorite__b fav:listFav){
            if(String.isNotBlank(fav.FavoriteType__c) && fav.FavoriteType__c=='ApplicationAndPortal__c'){
                LightningDataWrapper.LightningDataRow ldw=new LightningDataWrapper.LightningDataRow();
                ldw.stringA = fav.FavoriteRecordId__c;
                ldw.datetimeA = fav.CreatedDate;
                listLDW.add(ldw);
            }            
        }
        if(!listLDW.isEmpty()){
            LightningDataWrapper.setSortingOrder('datetimeA', 'desc');
            listLDW.sort();
        }
        return listLDW;
    }


    /**
     * @author      Abhishek Setia
     * @description Checks for unique key 'SubCategory__c' and stores record as a list pointing
     *              to this key.     
     * @param       mapSubCategory
     * @param       appAndPortal     
     */
    private static void categorizeMapOnSubCategory(
        Map<String,List<ApplicationAndPortal__c>> mapSubCategory, ApplicationAndPortal__c appAndPortal){
            if(mapSubCategory.containsKey(appAndPortal.SubCategory__c)){
                mapSubCategory.get(appAndPortal.SubCategory__c).add(appAndPortal);
            }else{
                mapSubCategory.put(appAndPortal.SubCategory__c,new List<ApplicationAndPortal__c>{appAndPortal});
            }
    }


    /**
     * @author      Abhishek Setia
     * @description Fills list of wrapper objects by iterating map     
     * @param       mCategoryAppAndPortal
     * @return      List<AppLauncherController.ApplicationAndPortalCategory>
     */
    private static List<AppLauncherController.ApplicationAndPortalCategory> getWrapper
        (Map<String,List<ApplicationAndPortal__c>> mCategoryAppAndPortal){
            List<AppLauncherController.ApplicationAndPortalCategory> lst=new List<AppLauncherController.ApplicationAndPortalCategory>();            
            for(String cat:mCategoryAppAndPortal.keySet()){
                AppLauncherController.ApplicationAndPortalCategory obj=new AppLauncherController.ApplicationAndPortalCategory();
                obj.key=String.valueOf(getUniqueKey());
                obj.category=cat;
                obj.appsAndPortals=mCategoryAppAndPortal.get(cat); 
                lst.add(obj);                           
            }            
            return lst;
    }


    /**
     * @author      Abhishek Setia
     * @description Inserts record in Favorite__b object to bookmark 'ApplicationAndPortal__c' sobject
     * @param       recordId
     * @return      LightningResponse
     */
    public static LightningResponse bookmarkRecordService(String recordId){
        LightningResponse lResp=new LightningResponse();
        try{
            Profile pr=ProfileDomain.queryProfileBasedOnId(UserInfo.getProfileId());
            List<ApplicationAndPortal__c> lstAP=ApplicationAndPortalDomain.criteriaAvailableInLauncherRecIdKeyword(
                true,
                new Set<Id>{recordId},
                null,
                pr.Name);
            if(!lstAP.isEmpty()){
                List<Favorite__b> listFav=new List<Favorite__b>();
                for(ApplicationAndPortal__c ap:lstAP){
                    Favorite__b fav=new Favorite__b();
                    fav.Title__c=ap.Name;
                    fav.Description__c=ap.Description__c;
                    fav.FavoriteRecordId__c=recordId;
                    fav.FavoriteType__c='ApplicationAndPortal__c';
                    fav.UserId__c=UserInfo.getUserId();
                    listFav.add(fav);                    
                }
                lResp.isError = FavoriteDomain.insertFavoriteList(listFav)?false:true;
            }
        }catch (Exception e){
            lResp.payLoad = e.getMessage();
            lResp.isError = true;
        }        
        return lResp;
    }


    /**
     * @author      Abhishek Setia
     * @description Delete Favorite__b record to unbookmark 'ApplicationAndPortal__c' record
     * @param       recordId
     * @return      LightningResponse
     */
    public static LightningResponse unbookmarkRecordService(String recordId){
        LightningResponse lResp=new LightningResponse();
        try{
            FavoriteDomain fd=new FavoriteDomain();
            List<Favorite__b> listFav = fd.queryFavBasedOnLoggedInUserAndFavRec(recordId,UserInfo.getUserId());
            if(!listFav.isEmpty()){
                lResp.isError = FavoriteDomain.deleteFavorite(listFav)?false:true;
            }            
        }catch (Exception e){
            lResp.payLoad = e.getMessage();
            lResp.isError = true;
        }        
        return lResp;
    }

}