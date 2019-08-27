public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = Test.isRunningTest()
        ? [SELECT Id FROM CollaborationGroup WHERE Name = :('TEST' + Constants.INVENTORY_ANNOUNCEMENTS)]
        : [SELECT Id FROM CollaborationGroup WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS]; 
	
    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList){
        //ToDo: Declare a List of Product2 records named needsAnnouncement
		List<Product2> needsAnnouncement = new List<Product2>();
        //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
		Map<String, Inventory_Setting__mdt> isList = new Map<String, Inventory_Setting__mdt>();
        //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        for (Inventory_Setting__mdt iSet : [SELECT DeveloperName, Label, Low_Quantity_Alert__C FROM Inventory_Setting__mdt]) {
            isList.put(iSet.DeveloperName, iSet);
        }
        System.debug(isList);
        //ToDo: Loop through the Products in newList
        // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
        // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
        //      add it to the needsAnnouncement list
        for (Product2 prod : newList) {
            if (isList.get(prod.Family).Low_Quantity_Alert__c > prod.Quantity_Remaining__c) {
                needsAnnouncement.add(prod);
        }
        }
        System.debug(needsAnnouncement);
        //ToDo: Pass records to the postAlerts method
        PostAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            ConnectApi.AnnouncementInput ai = new ConnectApi.AnnouncementInput();
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            ai.parentId = COLLABORATION_GROUP[0].Id;
            ai.expirationDate = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day() + 1);
            ai.sendEmails = false;
            ConnectApi.MessageBodyInput mbi = new ConnectApi.MessageBodyInput();
            mbi.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            ConnectApi.TextSegmentInput tsi = new ConnectApi.TextSegmentInput();
            tsi.text = p.Name + ' ' + Constants.INVENTORY_LEVEL_LOW;
            mbi.messageSegments.add(tsi);
            ai.body = mbi;
            System.debug(ai);
            toPost.add(ai);
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
        AnnouncementQueueable aq = new AnnouncementQueueable();
        aq.toPost = toPost;
        
        System.enqueueJob(aq);
    }
}