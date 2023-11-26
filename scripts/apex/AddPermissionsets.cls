public class PermissionSetAssignment {

    public static void assignPermissionSets(Set<String> permissionSetNames, String username) {
        // Query for the Permission Sets based on their names
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name IN :permissionSetNames];
        
        // Query for the User based on the username (you can modify this as needed)
        User userToAssign = [SELECT Id FROM User WHERE Username = :username LIMIT 1];

        // Delete existing PermissionSetAssignment records for the user and permission sets
        List<PermissionSetAssignment> existingAssignments = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :userToAssign.Id AND PermissionSetId IN :permissionSets];
        if (!existingAssignments.isEmpty()) {
            delete existingAssignments;
            System.debug('Existing permission set assignments deleted successfully.');
        }

        // Create a list of PermissionSetAssignment objects to assign the permission sets to the user
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();

        // Create PermissionSetAssignment records for each Permission Set
        for (PermissionSet permissionSet : permissionSets) {
            PermissionSetAssignment assignment = new PermissionSetAssignment();
            assignment.AssigneeId = userToAssign.Id; // Id of the user to assign the permission set to
            assignment.PermissionSetId = permissionSet.Id; // Id of the permission set
            assignments.add(assignment);
        }

        // Insert the PermissionSetAssignment records to assign permission sets to the user
        if (!assignments.isEmpty()) {
            insert assignments;
            System.debug('Permission sets assigned successfully.');
        }
    }
}
