/**
* @Author : Ankit Singh
* @Company : Cognizant
* @description : This Domain Class is used to query data for PermissionSetAssignment object
*/
public inherited sharing class PermissionSetAssignmentDomain {
    /**
    * @Author : Ankit Singh
    * @description :This method returns the Knowledge__kav details for PublishKnowledgeController
    * @return assignedPermissionSet
    */
    public static List<PermissionSetAssignment> getKnowledgeDetailsForPublishController() {
        List<PermissionSetAssignment> assignedPermissionSet = new List<PermissionSetAssignment>();
        assignedPermissionSet = [
                SELECT Id, AssigneeId, PermissionSetId, PermissionSet.Name
                FROM PermissionSetAssignment
                WHERE AssigneeId =: UserInfo.getUserId()
        ];
        return assignedPermissionSet;
    }
}