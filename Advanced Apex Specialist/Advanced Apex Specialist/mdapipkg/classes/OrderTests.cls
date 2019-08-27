@isTest
public with sharing class OrderTests {
    @testSetup
    private static void SetupTestData() {
        // Need to find the right place to put the Test.getStandardPricebookId() call, right now because SetupTestData() is called in a test method, it can't get the Id from 
        // the Constants class. Normally the TestDataFactory would simply be marked @isTest and the method could be called there, but now allowed to do that for this challenge...
        TestDataFactory.InsertTestData(1);       
    }
    
    @isTest
    private static void OrderUpdate_UnitTest(){
        Test.startTest();
        List<Order> ordList = [SELECT Id, Status, EffectiveDate FROM Order ORDER BY CreatedDate DESC LIMIT 1];
        List<Product2> prodListOld = [SELECT Quantity_Ordered__c FROM Product2 ORDER BY CreatedDate DESC LIMIT 1];
        
        List<OrderItem> ordItemList = [SELECT Quantity FROM OrderItem ORDER BY CreatedDate DESC LIMIT 1];
		// Force an exception by trying to update the OrderList while it is still in a draft status
        
        for (Order ord : ordList) {
            ord.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        
        update ordList;
        Test.stopTest();
        List<Product2> prodListUpdated = [SELECT Quantity_Ordered__c FROM Product2 ORDER BY CreatedDate DESC LIMIT 1];
                
        TestDataFactory.VerifyQuantityOrdered(prodListOld[0], prodListUpdated[0], Integer.valueOf(ordItemList[0].Quantity));

        
    }
    
    @isTest
    private static void OrderExtension_UnitTest(){
        // Set the current page reference
        Test.setCurrentPage(Page.OrderEdit);
        // Store the order created by the TestDataFactor to use for testing the case where it is an existing order (update operation)
        OrderExtension oeUpdate = new OrderExtension(new ApexPages.StandardController([SELECT Id FROM Order][0]));
        // Test the case where it is a new Order
        // Get the Account created by the TestDataFactory
        Account acc = [SELECT Id FROM Account][0];
        Date t = Date.today();
        Order ord = new Order(AccountId=acc.Id,
                             EffectiveDate=Date.newInstance(t.year(), t.month(), t.day()),
                             Status='Draft');
        OrderExtension oe = new OrderExtension(new ApexPages.StandardController(ord));
        //oe.standardSetController = new ApexPages.StandardSetController();
        // Assert that total is initially 0
        System.assertEquals(0, oe.total);
        // Assert that pieData is initially null
        System.assertEquals(null, oe.pieData);
        // Assert that orderItemList contains 1 OrderItems (test data)
        System.assertEquals(1, oe.orderItemList.size());
        // Assert that orderItemMap contains 1 item (test data)
        System.assertEquals(1, oe.orderItemMap.size());
        // Assert that count of Order is initially 1 (owing to the Order record created in the testSetup method above)
        System.assertEquals(1, [SELECT Id FROM Order].size());
        // Simulate a field update by updating the OrderItem in orderItemList, then calling OnFieldChange()
        oe.orderItemList[0].Quantity = 1;
        oe.OnFieldChange();
        System.assertEquals(1, oe.orderItemMap.get(oe.orderItemList[0].Product2Id).Quantity);
        System.assert(oe.pieData != null);
        System.assert(oe.total > 0);
        // Update selectedFamily and run SelectFamily() to simulate the user filtering on a Product Family
        oe.selectedFamily = Constants.PRODUCT_FAMILY[0].getValue();
        System.assertEquals('Entree', oe.selectedFamily);
        oe.SelectFamily();
        System.assertEquals(1, oe.orderItemList.size()); // Filtered list of OrderItem should only contain 1 record
        // Test the Save() method. Ensure that after calling, there are now 2 Orders in the DB, and 2 OrderItems
        Test.startTest();
        oe.Save();
        Test.stopTest();
        System.assertEquals(2, [SELECT Id FROM Order].size());
        System.assertEquals(2, [SELECT Id FROM OrderItem].size());
        
        // Now, test the case where it is an Order to update rather than a new Order
        System.assertEquals(1, oeUpdate.orderItemList.size());
        System.assert(oeUpdate.pieData != null);
        System.assert(oeUpdate.total > 0);
        System.assert(Constants.PRODUCT_FAMILY.size() == oeUpdate.GetFamilyOptions().size() - 1);
        System.assertEquals(false, oeUpdate.GetHasNext());
        System.assertEquals(false, oeUpdate.GetHasPrevious());
        System.assertEquals(1, oeUpdate.GetPageNumber());
        System.assertEquals(1, oeUpdate.GetTotalPages());
    }
    @isTest
    private static void product2Trigger_UnitTest(){}
}