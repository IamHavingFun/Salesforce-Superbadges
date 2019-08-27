public class CallEmailFlow {
    public static List<Object> doAutoFlow(String flowName){
        Map<String, List<Object>> flowVars = new Map<String, List<Object>>();
        List<Opportunity> oppList = [SELECT Id, AccountId, Amount, OwnerId FROM Opportunity WHERE Amount >= 1000000];
        flowVars.put('HighValueOpportunities', oppList);
        Flow.Interview newFlowInterview = Flow.Interview.createInterview(flowName, flowVars);
        newFlowInterview.start();
        return (List<Object>)newFlowInterview.getVariableValue('HighValueOpportunities');
    }
}