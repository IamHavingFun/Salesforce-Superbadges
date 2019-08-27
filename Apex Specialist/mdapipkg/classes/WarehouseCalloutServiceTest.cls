@isTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @isTest static void testCallout(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> equipments = [SELECT Id, Name, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, 
                                     Warehouse_SKU__c FROM Product2 WHERE Warehouse_SKU__c IN ('100003', '100004')];
        
        //System.assert(equipments.size() == 2);
        System.debug(equipments);
        System.assertEquals('Generator 1000 kW', equipments[0].Name);
        System.assertEquals(true, equipments[0].Replacement_Part__c);
        System.assertEquals(5000, equipments[0].Cost__c);
        System.assertEquals(5, equipments[0].Current_Inventory__c);
        System.assertEquals(120, equipments[0].Lifespan_Months__c);
        System.assertEquals(365, equipments[0].Maintenance_Cycle__c);
        System.assertEquals('100003', equipments[0].Warehouse_SKU__c);
        
        System.assertEquals('Cooling Fan', equipments[1].Name);
        System.assertEquals(true, equipments[1].Replacement_Part__c);
        System.assertEquals(300, equipments[1].Cost__c);
        System.assertEquals(183, equipments[1].Current_Inventory__c);
        System.assertEquals(0, equipments[1].Lifespan_Months__c);
        System.assertEquals(0, equipments[1].Maintenance_Cycle__c);
        System.assertEquals('100004', equipments[1].Warehouse_SKU__c);
        
    }
}