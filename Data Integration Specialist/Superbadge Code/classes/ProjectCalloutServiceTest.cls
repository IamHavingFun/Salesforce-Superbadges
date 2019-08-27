@isTest
public class ProjectCalloutServiceTest {
    @isTest static void successfulCallout(){
        ServiceTokens__c token = new ServiceTokens__c(Name='ProjectServiceToken', Token__c='c7698c36-037e-4be7-9e9a-563b98cadb26');
        insert token;
        Account acc = new Account(Name='TestAccountOne');
        insert acc;
        Opportunity opp = new Opportunity(Name='TestOne', AccountId=acc.Id, CloseDate=Date.newInstance(2019, 4, 22), StageName='Closed Won', Type='New Project', Amount=5000);
        insert opp;
        List<ID> oppIds = new List<ID>();
        oppIds.add(opp.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        Test.stopTest();
        System.assertEquals('Submitted Project', [SELECT Id, Name, StageName FROM Opportunity WHERE Id = :opp.Id].StageName);
    }
    
    @isTest static void unsuccessfulCallout(){
        ServiceTokens__c token = new ServiceTokens__c(Name='ProjectServiceToken', Token__c='c7698c36-037e-4be7-9e9a-563b98cadb26');
        insert token;
        Account acc = new Account(Name='TestAccountTwo');
        insert acc;
        Opportunity opp = new Opportunity(Name='TestTwo', AccountId=acc.Id, CloseDate=Date.newInstance(2019, 4, 25), StageName='Closed Won', Type='New Project', Amount=4000);
        insert opp;
        List<ID> oppIds = new List<ID>();
        oppIds.add(opp.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        ProjectCalloutService.postOpportunityToPMS(oppIds);
        Test.stopTest();
        System.assertEquals('Resubmit Project',[SELECT Id, Name, StageName FROM Opportunity WHERE Id = :opp.Id].StageName);
    }
}