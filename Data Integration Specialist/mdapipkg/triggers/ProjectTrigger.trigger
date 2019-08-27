trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    for (Project__c project : Trigger.new) {
        if (project.Status__c == 'Billable') {
            BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
        }
    }
}