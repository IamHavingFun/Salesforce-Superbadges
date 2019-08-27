({
    onInit : function(component) {
        var boat = component.get("v.boat");
        var remoteAction = component.get("c.getAll");
        remoteAction.setParams({
            "boatId" : boat.Id
        });
        remoteAction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.boatReviews", response.getReturnValue());
            } else {
                console.log(response.getError());
                alert(response.getError());
            }
        });
        
        $A.enqueueAction(remoteAction);
    }
})