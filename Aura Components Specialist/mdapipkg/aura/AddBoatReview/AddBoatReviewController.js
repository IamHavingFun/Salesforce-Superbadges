({
    doInit : function(component, event, helper) {
    	helper.onInit(component);    
    },
    
	onSave : function(component, event, helper) {
        component.find("service").saveRecord(function(saveResult){
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                var successToast = $A.get("e.force:showToast");
                if (!!successToast) {
                    successToast.setParams({
                        "title" : "Record saved",
                        "message" : "Review saved successfully"
                    }).fire();    
                } else {
                    alert("Your browser sucks and doesn't support toasts. Who doesn't like toast?");
                }
                helper.onInit(component);
                component.getEvent("BoatReviewAdded").fire();
            } 
        });
	},
    
    onRecordUpdated : function(component, event, helper) {
        var instantiatedToast = $A.get("e.force:showToast");
                if (!!instantiatedToast) {
                    instantiatedToast.setParams({
                        "title" : "Instantiated new review record",
                        "message" : "Review record ready"
                    }).fire();    
                } else {
                    alert("Your browser sucks and doesn't support toasts. Who doesn't like toast?");
                }
    }
})