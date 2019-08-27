public class Policy_ManagedSharing {
    public static void addNewPolicyShareRule(ID recordId, ID userOrGroup, String accessLevel){
        Policy__Share policySharingRule = new Policy__Share();
        policySharingRule.ParentId = recordId;
        policySharingRule.UserOrGroupId = userOrGroup;
        policySharingRule.AccessLevel = accessLevel;
        policySharingRule.RowCause = Schema.Policy__Share.RowCause.Manual;
        try {
            insert policySharingRule;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }   
}