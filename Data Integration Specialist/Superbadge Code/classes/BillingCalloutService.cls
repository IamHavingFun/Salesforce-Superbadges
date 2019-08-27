public class BillingCalloutService {
    //Implement business and callout logic methods here
    @future(callout=true)
    public static void callBillingService(String projectRef, Decimal billableAmount) {
        BillingServiceProxy.InvoicesPortSoap11 billService = new BillingServiceProxy.InvoicesPortSoap11();
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.username = ServiceCredentials__c.getValues('BillingServiceCredential').Username__c;
        project.password = ServiceCredentials__c.getValues('BillingServiceCredential').Password__c;
        project.billAmount = billableAmount;
        project.projectid = projectRef;
        String response = billService.billProject(project);
        if (response == 'ok') {
            Project__c proj = [SELECT Id, ProjectRef__c, Status__c FROM Project__c WHERE ProjectRef__c = :projectRef];
            proj.Status__c = 'Billed';
            update proj;
        }
    }
}