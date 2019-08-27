public class PolicySharingRecalculator implements Database.Batchable<sObject> {
    public Database.QueryLocator start (Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Policy__c]); // Create the QueryLocator for the execute method to reference
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> recordScope){
        // recordScope automatically populated with query scope from start method
        Map<ID, Policy__c> currentPolicyRecordsMap = new Map<ID, Policy__c>((List<Policy__c>)recordScope);
        Map<ID, Policy__Share> currentPolicyShareRecordsMap = new Map<ID, Policy__Share>([SELECT Id,
                                                                                          ParentId,
                                                                                          AccessLevel,
                                                                                          RowCause,
                                                                                          UserOrGroupId FROM Policy__Share WHERE ParentId IN :currentPolicyRecordsMap.keySet()
                                                                                          AND RowCause = 'Policy_Managed_Share__c']);
        List<Policy__Share> newPolShareRecs = new List<Policy__Share>();
        for (Policy__Share ps : currentPolicyShareRecordsMap.values()) {
            Policy__Share newPolShare = new Policy__Share(ParentId = ps.ParentId,
                                                         AccessLevel = ps.AccessLevel,
                                                         RowCause = 'Policy_Managed_Share__c',
                                                         UserOrGroupId = ps.UserOrGroupId);
            newPolShareRecs.add(newPolShare);
        }
        
        try {
            insert newPolShareRecs;
        } catch (DmlException de) {
            AsyncApexJob thisJob = [SELECT CreatedById FROM AsyncApexJob WHERE Id = :bc.getJobId()];
            User jobSubmitter = [SELECT Email FROM User WHERE Id = :thisJob.CreatedById];
            Messaging.SingleEmailMessage errorMailMsg = new Messaging.SingleEmailMessage();
            errorMailMsg.setToAddresses(new String[]{jobSubmitter.Email});
            errorMailMsg.setSubject('Batch Apex job failed: ' + thisJob.Id);
            errorMailMsg.setPlainTextBody('Job failed due to DmlException: ' + de.getCause());
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{errorMailMsg});
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        AsyncApexJob thisJob = [SELECT CreatedById FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        User jobSubmitter = [SELECT Email FROM User WHERE Id = :thisJob.CreatedById];
        Messaging.SingleEmailMessage successMailMsg = new Messaging.SingleEmailMessage();
        successMailMsg.setToAddresses(new String[]{jobSubmitter.Email});
        successMailMsg.setSubject('Apex managed sharing job completed: ' + thisJob.Id);
        successMailMsg.setPlainTextBody('Apex managed sharing recalculation completed');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{successMailMsg});
    }
}