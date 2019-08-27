({
	onFormSubmit : function(component, event, helper) {
		var formSubmitData = event.getParam("formData").boatTypeId;
        var childCmp = component.find("boatsearchresults");
        childCmp.search(formSubmitData);
	}
})