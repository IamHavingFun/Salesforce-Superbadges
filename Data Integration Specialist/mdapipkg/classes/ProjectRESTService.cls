@RestResource(urlMapping='/project')
global with sharing class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Project__c project = new Project__c(
            ProjectRef__c = ProjectRef,
            Name = ProjectName,
            Opportunity__c = OpportunityId,
            Start_Date__c = StartDate,
            End_Date__c = EndDate,
            Billable_Amount__c = Amount,
            Status__c = Status
        );
        
        Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :OpportunityId];
        opp.DeliveryInstallationStatus__c = 'In progress';
        Savepoint sp = Database.setSavepoint();
        try {
            Database.UpsertResult projectResult = Database.upsert(project, Schema.SObjectType.Project__c.fields.ProjectRef__c.getSObjectField());
            Database.SaveResult oppResult = Database.update(opp);
            return 'OK';
        } catch (Exception e) {
            Database.rollback(sp);
            return e.getMessage();
        }
        
    }
}