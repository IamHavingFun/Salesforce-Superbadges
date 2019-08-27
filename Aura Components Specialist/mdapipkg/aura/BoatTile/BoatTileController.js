({
	onBoatClick: function(component, event, helper) {
        //console.log(component.get("v.boat").Id);
        var boatId = component.get("v.boat").Id;
        var boatClickEvent = component.getEvent("BoatSelect");
        boatClickEvent.setParams({
            "boatId" : boatId
        });
        boatClickEvent.fire();
        
        var boat = component.get("v.boat");
        var boatSelectedEvent = $A.get("e.c:BoatSelected");
        boatSelectedEvent.setParams({
            "boat" : boat
        });
        boatSelectedEvent.fire();
        
        var plotMapEvent = $A.get("e.c:PlotMapMarker");
        plotMapEvent.setParams({
            "sObjectId" : boat.Id,
            "lat" : boat.Geolocation__Latitude__s,
            "long" : boat.Geolocation__Longitude__s,
            "label" : boat.Name
        });
        plotMapEvent.fire();
	}
})