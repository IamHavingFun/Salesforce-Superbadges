//@isTest(seeAllData=false)
@isTest (seeAllData=false)
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    @isTest private static void Product2Extension_UnitTest(){
        // To simulate a user's interaction with a Visualforce page, you need to use the Test.setCurrentPage() method to set the test method's page context, for the page that
        // uses the custom controller or extension. The Page namespace is not well documented in the Salesforce references, but automatically allows you to reference any Visualforce 
        // page already compiled in your org by name. E.g. in the below method call, Product2New is the name of the Visualforce page (based on file name).
        Test.setCurrentPage(Page.Product2New); // Page.Product2New is actually a way to construct a PageReference object, which is the PageReference for the Product2New page
        Product2Extension ext = new Product2Extension(new ApexPages.StandardController(new Product2()));
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        ext.AddRows();
        System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());
        Test.startTest();
        ext.Save();
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        // Once the test method's page is set using Test.setCurrentPage(), you can use the normal ApexPages namespace types and methods; for instance, in the below assertion,
        // you can use ApexPages.getMessages() to get the messages of the page set with Test.setCurrentPage()
        System.assertEquals(1, ApexPages.getMessages().size());
        Test.clearApexPageMessages();
        System.assertEquals(0, ApexPages.getMessages().size());
        
        Integer ii = 0;
        for (Integer i = 0; i < 5; i++) {
            // Populate the following fields:
            // - Name (Product2)
            // - Family (Product2)
            // - IsActive (Product2)
            // - Initial_Inventory__c (Product2)
            // - UnitPrice (PricebookEntry)
            ii = ii < Constants.PRODUCT_FAMILY.size() ? ii : 0;
            ext.productsToInsert[i].productRecord.Name = 'Test' + i;
            ext.productsToInsert[i].productRecord.Family = Constants.PRODUCT_FAMILY[ii].getValue();
            ext.productsToInsert[i].productRecord.IsActive = true;
            ext.productsToInsert[i].productRecord.Initial_Inventory__c = 10;
            ext.productsToInsert[i].pricebookEntryRecord.UnitPrice = Decimal.valueOf(Math.random()*1000).setScale(2);
            ii++;
        }
        ext.Save();
        System.assertEquals(5, [SELECT Name FROM Product2 WHERE Name LIKE '%Test%'].size());
        System.assertEquals(1, ApexPages.getMessages().size());
        Test.stopTest();
        
        System.assertEquals(Constants.PRODUCT_FAMILY.size() + 1, ext.GetFamilyOptions().size());
        
        System.assertEquals([SELECT Family, SUM(Quantity_Remaining__c) quantity FROM Product2 WHERE IsActive = true GROUP BY Family].size(), ext.GetInventory().size());
    }
	@isTest private static void Product2Trigger_UnitTest(){
        Test.startTest();
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cg.Description = 'test';
        cg.CollaborationType = 'Public';
        Product2 prod = new Product2(Name='TEST PRODUCT',
                                    Family=Constants.PRODUCT_FAMILY[0].getValue(),
                                    IsActive=true,
                                    Initial_Inventory__c=21,
                                    Quantity_Ordered__c=0);
        
        insert prod;
        insert cg;
        // Query for the collaboration group, and ensure that it currently does not have any announcements
        //cg = [SELECT Id, AnnouncementId FROM CollaborationGroup WHERE Name = :('TEST' + Constants.INVENTORY_ANNOUNCEMENTS)][0];
        //System.assert(cg.AnnouncementId == null); // No Announcement tied to the group yet
        
        prod.Quantity_Ordered__c = 2;
        update prod;
        Test.stopTest();
        //cg = [SELECT Id, AnnouncementId FROM CollaborationGroup WHERE Name = :('TEST' + Constants.INVENTORY_ANNOUNCEMENTS)][0];
        //System.assert(cg.AnnouncementId != null);
        //System.debug(cg);
		
  }
    
}