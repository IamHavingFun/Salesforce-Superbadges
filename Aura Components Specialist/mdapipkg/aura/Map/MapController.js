({
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    },
    
    onPlotMapMarker : function(component, event, helper) {
        //console.log("logging from handleMarker");
        var obj = {};
        obj.lat = event.getParam("lat");
        obj.long = event.getParam("long");
        
        component.set("v.location", obj);
    }
})