@isTest
public class ProjectRESTServiceTest {
    //Implement Apex REST service tests here
    @isTest public static void sPostProjectData(){
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = 'curious-goat-netxm6-dev-ed.my.salesforce.com/services/apexrest/project';
        
        Opportunity opp = new Opportunity(Name='Test opp 1', CloseDate=Date.newInstance(2019, 4, 25), StageName='Closed Won', Amount=5000.00);
        insert opp;
        //String body1 = '{\n"ProjectRef" : "ABC123456789123AA123123",\n"ProjectName" : "Test project",\n"OpportunityId" : "0062E00001DmnJQQAZ",\n"StartDate" : "2019-04-25",\n';
        //String body2 = '"EndDate" : "2019-05-25",\n"Amount" : 500000.00,\n"Status" : "Billable"\n}';
        //request.requestBody = Blob.valueOf(body1 + body2);
        
        String msg = ProjectRestService.postProjectData('ABC123456789123AA123123', 'Test project 1', (String)opp.Id, Date.newInstance(2019, 4, 25), Date.newInstance(2019, 5, 25), Double.valueOf(5000.00), 'Billable');
    	Project__c proj = [SELECT ProjectRef__c, Opportunity__r.DeliveryInstallationStatus__c FROM Project__c WHERE ProjectRef__c = 'ABC123456789123AA123123'];
        System.assertEquals('In progress', proj.Opportunity__r.DeliveryInstallationStatus__c);
    }
    
    @isTest public static void uPostProjectData() {
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestURI = 'curious-goat-netxm6-dev-ed.my.salesforce.com/services/apexrest/project';
        //String body1 = '{\n"ProjectRef" : "ABC123456789123AA123123",\n"ProjectName" : "Test project",\n"OpportunityId" : "0062E00001DmnJQQAZ",\n"StartDate" : "2019-04-25",\n';
        //String body2 = '"EndDate" : "2019-05-25",\n"Amount" : 500000.00,\n"Status" : "BEING AWESOME"\n}';
        //request.requestBody = Blob.valueOf(body1 + body2);
        Opportunity opp = new Opportunity(Name='Test opp 2', CloseDate=Date.newInstance(2019, 4, 27), StageName='Closed Won', Amount=5000.00);
        insert opp;
        
        String msg = ProjectRestService.postProjectData('ABC123456789123AA123124', 'Test project 2', (String)opp.Id, Date.newInstance(2019, 4, 27), Date.newInstance(2019, 5, 27), Double.valueOf(500.00), 'BEING AWESOME');
        System.assert(msg == 'Upsert failed. First exception on row 0; first error: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, Status: bad value for restricted picklist field: BEING AWESOME: [Status__c]');
    }
}