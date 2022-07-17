/**
 * @author      Abhishek Setia
 * @description Handle queries related to SObject 'CaseHistory'
 */
public inherited sharing class CaseHistoryDomain {
    
    /**
     * author       Abhishek Setia
     * @description Get case owners history
     * @param       caseids
     * @return      List<CaseHistory>
     */
    public List<CaseHistory> getOwnerChangeHistory(Set<Id> caseids){
        return [SELECT Id, OldValue, NewValue, CreatedDate 
                FROM CaseHistory where Field='Owner' AND CaseId IN :caseids 
                AND DataType='EntityId' ORDER BY CreatedDate asc];
    }
    
    /**
     * author       Amit Sharma
     * @description Get case owners history
     * @return      List<CaseHistory>
     * @param       caseids
     */
    public List<CaseHistory> getCaseOwnerHistory(Set<Id> caseids){
        return [SELECT Id, OldValue, NewValue, CreatedDate 
                FROM CaseHistory where Field='Owner' AND CaseId IN :caseids 
                AND DataType='EntityId' ORDER BY CreatedDate DESC];
    }
}