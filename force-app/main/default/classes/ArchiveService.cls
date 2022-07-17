/**
 * @author      Abhishek Setia
 * @description Handles logic for Apex class - ArchiveController
 */
public with sharing class ArchiveService {
    
    /**
     * author       Abhishek Setia
     * @description Get LightningResponse object which contains records to be shown in 'Archive' tab.                   
     * @param       requestParameters - Value from JScript. Records to pick from database.
     * @return      LightningResponse wrapper object    
     */
    public static LightningResponse getArchiveRecordsService(String requestParameters){        
        LightningResponse resp=new LightningResponse();
        try{  
            ArchiveController.RequestWrapper reqWrap = 
                (ArchiveController.RequestWrapper)JSON.deserialize(
                    requestParameters,ArchiveController.RequestWrapper.class);
            List<ArchiveController.ArchiveWrapper> listAW=new List<ArchiveController.ArchiveWrapper>();
            ArchiveController.ResponseWrapper respWrap=new ArchiveController.ResponseWrapper();
            //Gets Tasks & Approvals archived data
            ArchiveTaskApprovalService.ArchiveTaskApprovalWrapper taWrapper = ArchiveTaskApprovalService.getRecords(reqWrap);
            respWrap.utlDataSize=taWrapper.recordCount;
            listAW.addAll(taWrapper.records);
            //Gets Cases archived data
            ArchiveCaseService.ArchiveCaseWrapper acWrapper=ArchiveCaseService.getRecords(reqWrap);
            respWrap.caseDataSize=acWrapper.recordCount;
            listAW.addAll(acWrapper.records);
            //Get Reservation data
            ArchiveReservationService.ArchiveReservationWrapper arWrapper=ArchiveReservationService.getRecords(reqWrap, respWrap);
            respWrap.reservationDataSize=arWrapper.recordCount;
            listAW.addAll(arWrapper.records);
            
            respWrap.dataSize=taWrapper.totalCount+acWrapper.totalCount+arWrapper.totalCount;
            respWrap.dataSet=listAW;
            resp.payLoad = JSON.serialize(respWrap,true);
        } catch (Exception e) {
            resp.payLoad = e.getMessage();
            resp.isError = true;
        }
        return resp;
    }

}