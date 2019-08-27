trigger MaintenanceRequest on Case (after update) {
    // call MaintenanceRequestHelper.updateWorkOrders
    Set<ID> caseIds = new Set<ID>();
    List<Case> cases = new List<Case>();
    
    for (Case c : Trigger.new) {
        caseIds.add(c.Id);
    }
    for (ID i : caseIds) {
        Case ca = Trigger.newMap.get(i);
        if (ca.Status == 'Closed' && ca.Type == 'Routine Maintenance' || ca.Type == 'Repair') {
            cases.add(ca);
        }
        
    }
    MaintenanceRequestHelper.updateWorkOrders(cases);  
}