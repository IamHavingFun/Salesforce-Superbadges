({
    onBoatSelected : function(component, event, helper) {
        var boatParam = event.getParam("boat");
        component.set("v.boat", boatParam);
        component.set("v.id", boatParam.Id);
        component.find("service").reloadRecord();
    },
    
    onRecordUpdated : function(component, event, helper) {
        var boatReviews = component.find("boatreviews");
        if (boatReviews) boatReviews.refresh();
        //boatReviews.refresh();
    },
    
    onBoatReviewAdded : function(component, event, helper) {
        var tabs = component.find("tabs");
        tabs.set("v.selectedTabId", "boatreviewtab");
        var boatReviews = component.find("boatreviews");
        if (boatReviews) boatReviews.refresh();
        //boatReviews.refresh();
    },
    
    handleChange : function(component, event, helper) {
        var selectedTabId = component.get("v.tabId");
        component.find("tabs").set("v.selectedTabId", selectedTabId);
        $A.util.removeClass(component.find("addreviewtab"), "slds-is-active");
        $A.util.removeClass(component.find("addreviewtab"), "slds-tabs_default__item");
        $A.util.removeClass(component.find("addreviewtab"), "slds-has-focus");
        $A.util.addClass(component.find("boatreviewtab"), "slds-is-active");
        $A.util.addClass(component.find("boatreviewtab"), "slds-tabs_default__item");
        $A.util.addClass(component.find("boatreviewtab"), "slds-has-focus");
    }
})