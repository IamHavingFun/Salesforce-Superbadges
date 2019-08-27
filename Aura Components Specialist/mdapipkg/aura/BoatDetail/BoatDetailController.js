({
    doInit : function(component, event, helper) {
    	var navigationEvent = $A.get("e.force:navigateToSObject");
        if (navigationEvent) {
            component.set("v.supportsNavigateToSObject", true);
        }  
    },
    
	onFullDetails : function(component, event, helper) {
        var navigationEvent = $A.get("e.force:navigateToSObject");
        if (navigationEvent) {
            component.set("v.supportsNavigateToSObject", true);
            navigationEvent.setParams({
                "recordId" : component.get("v.boat.Id")
            });
        }
        navigationEvent.fire();
	}
})