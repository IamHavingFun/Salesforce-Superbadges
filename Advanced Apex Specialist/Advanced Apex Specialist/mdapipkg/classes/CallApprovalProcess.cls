public class CallApprovalProcess {
    static Integer testOppNameCount = 0;
    public static void callApprovalProcess(){
        //Opportunity opp = [SELECT Id, Name, Account.Name, Amount FROM Opportunity WHERE Id = '0062E00001Ew5WxQAJ'];
        List<Account> accounts = [SELECT Id, Name FROM Account];
        User submitter = [SELECT Id, Name FROM User WHERE Id = '0052E00000JjpepQAB'];
        Opportunity opp = new Opportunity(Name='TEST APPROVAL' + testOppNameCount,
                                          AccountId=accounts.get(0).Id,
                                          StageName='Negotiation/Review',
                                          CloseDate=Date.newInstance(2019, 7, 4),
                                         OwnerId=submitter.Id);
        insert opp;
        testOppNameCount++;
        
        User approver = [SELECT Id, Name FROM User WHERE Id = '0052E00000JAJKpQAP'];
        Approval.ProcessSubmitRequest newApprvl = new Approval.ProcessSubmitRequest();
        newApprvl.setSubmitterId(submitter.Id);
        newApprvl.setProcessDefinitionNameOrId('ApproveOpp');
        newApprvl.setSkipEntryCriteria(true);
        newApprvl.setObjectId(opp.Id);
        Approval.ProcessResult pr = Approval.process(newApprvl);
        //System.debug(pr.isSuccess());
        ID[] workItemIds = pr.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest wir = new Approval.ProcessWorkitemRequest();
        wir.setAction('Approve');
        wir.setWorkitemId(workItemIds[0]);
        wir.setNextApproverIds(new List<Id>{approver.Id});
        Approval.ProcessResult pr2 = Approval.process(wir);
        System.debug(pr2.isSuccess());
    }
}