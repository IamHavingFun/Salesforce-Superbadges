({
	onInit : function(component) {
		component.find("service").getNewRecord(
            "BoatReview__c",
            null,
            false,
            $A.getCallback(function(){
                var boatReviewRec = component.get("v.boatReview");
                if (!!boatReviewRec) {
                    component.set("v.boatReview.Boat__c", component.get("v.boat.Id"));
                } else {
                    console.log(component.get("v.recordError"));
                }
            })
        );
	}
})