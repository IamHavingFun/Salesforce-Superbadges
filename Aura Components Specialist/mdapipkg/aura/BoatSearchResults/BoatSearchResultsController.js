({
	/*doInit : function(component, event, helper) {
		helper.onSearch(component, "");
	},*/
    
    doSearch : function(component, event, helper) {
        var params = event.getParam("arguments");
        if (params) {
            var boatType = params.selectedBoatType;
            component.set("v.boatTypeId", boatType);
            helper.onSearch(component, component.get("v.boatTypeId"));
        }
    },
    
    onBoatSelect : function(component, event, helper) {
        component.set("v.selectedBoatId", event.getParam("boatId"));
    }
})