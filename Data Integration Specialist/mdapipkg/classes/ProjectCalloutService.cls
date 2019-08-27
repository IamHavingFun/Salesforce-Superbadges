public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(List<ID> opportunityIds){
        Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id = :opportunityIds[0]];
        String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        String body1 = '{\n"opportunityId": "' + opp.Id + '",\n"opportunityName": "' + opp.Name + '",\n"accountName": "' + opp.Account.Name + '",\n';
        String body2 = '"closeDate": "' + String.valueOf(opp.CloseDate )+ '",\n"amount": ' + Integer.valueOf(opp.Amount) + '\n}';
        ID jobId = System.enqueueJob(new QueueablePMSCall(serviceToken, body1 + body2, opp.Id));
        System.debug(jobId);
	}
    
    //@future(callout=true)
    public static void postToPMS(String serviceToken, String jsonInput, Id opportunityId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ProjectService');
        System.debug(request.getEndpoint());
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('token', serviceToken);

        request.setBody(jsonInput);
        HttpResponse response = http.send(request);
        System.debug(response);
		Opportunity opp = new Opportunity(Id=opportunityId);   
        if (response.getStatusCode() == 201) {
            opp.StageName = 'Submitted Project';
        } else {
            opp.StageName = 'Resubmit Project';
        }
        update opp;
    }
    
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private String serviceToken;
        private String jsonInput;
        private Id oppId;
        
        public QueueablePMSCall(String serviceToken, String jsonInput, ID oppId) {
            this.serviceToken = serviceToken;
            this.jsonInput = jsonInput;
            this.oppId = oppId;
        }
        
        public void execute(QueueableContext context) {
            ProjectCalloutService.postToPMS(this.serviceToken, this.jsonInput, this.oppId);
        }
    }
}