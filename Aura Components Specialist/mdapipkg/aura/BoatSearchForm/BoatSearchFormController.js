({
    doInit : function(component, event, helper) {
        var getBoatTypesAction = component.get("c.getBoatTypes");
        getBoatTypesAction.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.boatTypes", response.getReturnValue()); 
            }
        });
        $A.enqueueAction(getBoatTypesAction);
        
        // Check for force:createRecord event support. If the $A.get call returns undefined, event is not supported in the current context
        if ($A.get("e.force:createRecord")) {
            component.set("v.createRecordSupport", true);
        }
    },
    
    onFormSubmit : function(component, event, helper) {
        var boatTypeId = component.get("v.selectedBoatType");
        var formSubmitEvent = component.getEvent("formsubmit");
        formSubmitEvent.setParams({"formData" : {
            "boatTypeId" : boatTypeId
        }});
        formSubmitEvent.fire();
    },
    
    handleNew : function(component, event, helper) {
        var createBoatEvent = $A.get("e.force:createRecord");	
        var selectedBoatType = component.get("v.selectedBoatType");
       	
        if (selectedBoatType === "") {
            createBoatEvent.setParams({
                "entityApiName" : "Boat__c"
            });
        } else {
            createBoatEvent.setParams({
                "entityApiName" : "Boat__c",
                "defaultFieldValues" : {
                    'BoatType__c' : selectedBoatType
                }
            });
        }
        createBoatEvent.fire();
    }
})