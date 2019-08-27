({
    onSearch : function(component, boatTypeId) {
        var action = component.get("c.getBoats");
        action.setParams({
            "boatTypeId" : boatTypeId
        });
        action.setCallback(this, function(response){
            console.log(response.getReturnValue());
            if (response.getState() === "SUCCESS" && response.getReturnValue().length > 0) {
                //component.set("v.areResults", true);
                component.set("v.boats", response.getReturnValue());
                /*var boats = component.get("v.boats");
                boats.forEach(function(boat){
                    switch (boat.BoatType__r.Name) {
                        case "Sailboat":
                        case "Ski Boat":
                        case "Pleasure Boat":
                        case "Yacht":
                            //component.set('v.imageUrl', $A.get("$Resource.Sailboats" + boat.Picture__c));
                            boat.Picture__c = $A.get("Resource.Sailboats") + boat.Picture__c;
                            break;
                        case "Fishing Boat":
                        case "House Boat":
                            //component.set('v.imageUrl', $A.get("$Resource.Houseboats" + boat.Picture__c));
                            boat.Picture__c = $A.get("Resource.Houseboats") + boat.Picture__c;
                            break;
                    }
                });*/
            } else {
                component.set("v.boats", []);
            }
        });
        $A.enqueueAction(action);
    }
})