@isTest
public class BillingCalloutServiceTest {
    //Implement mock callout tests here
    @isTest static void successfulCallout() {
        // Data setup area
        // Create a custom setting
        ServiceCredentials__c sc = new ServiceCredentials__c(Name='BillingServiceCredential', Username__c='bsUser1', Password__c='bsPass1');
        insert sc;
        
        // Create an Opportunity
        Opportunity opp = new Opportunity(Name='Opportunity One', CloseDate=Date.newInstance(2019, 5, 5), StageName='Closed Won', Amount=5000.00);
        insert opp;
        
        // Create a Project__c
        Project__c proj = new Project__c(Name='Project One', Opportunity__c=opp.Id, ProjectRef__c = 'ABCEASYAS123', Billable_Amount__c=5000.00, Status__c='Billable');
        
        // Test run area
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        insert proj;
        BillingCalloutService.callBillingService(proj.ProjectRef__c, proj.Billable_Amount__c);
        Test.stopTest();
        Project__c updatedProj = [SELECT Id, ProjectRef__c, Status__c FROM Project__c WHERE ProjectRef__c = :proj.ProjectRef__c];
        System.assertEquals('Billed', updatedProj.Status__c);
    }
    
        @isTest static void unsuccessfulCallout() {
        // Data setup area
        // Create a custom setting
        ServiceCredentials__c sc = new ServiceCredentials__c(Name='BillingServiceCredential', Username__c='bsUser1', Password__c='bsPass1');
        insert sc;
        
        // Create an Opportunity
        Opportunity opp = new Opportunity(Name='Opportunity Two', CloseDate=Date.newInstance(2019, 5, 5), StageName='Closed Won', Amount=4000.00);
        insert opp;
        
        // Create a Project__c
        Project__c proj = new Project__c(Name='Project Two', Opportunity__c=opp.Id, ProjectRef__c = 'ABCNOTASEASYAS123', Billable_Amount__c=4000.00, Status__c='Billable');
        
        // Test run area
        Test.startTest();
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        insert proj;
        BillingCalloutService.callBillingService(proj.ProjectRef__c, proj.Billable_Amount__c);
        Test.stopTest();
            
        Project__c updatedProj = [SELECT Id, ProjectRef__c, Status__c FROM Project__c WHERE ProjectRef__c = :proj.ProjectRef__c];
        System.assertEquals('Billable', updatedProj.Status__c);
    }
}