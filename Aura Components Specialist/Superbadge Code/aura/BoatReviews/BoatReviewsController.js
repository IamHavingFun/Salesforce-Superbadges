({
	doInit : function(component, event, helper) {
		helper.onInit(component);
	},
    
    onUserInfoClick : function(component, event, helper) {
        var datauserid = event.currentTarget.getAttribute("data-userid");
        var navigateEvt = $A.get("e.force:navigateToSObject");
        navigateEvt.setParams({
            "recordId" : datauserid
        });
        navigateEvt.fire();
    },
    
    refresh : function(component, event, helper) {
        helper.onInit(component);
    }
})