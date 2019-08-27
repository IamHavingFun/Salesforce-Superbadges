@isTest
public class MaintenanceRequestTest {
    
    // (c.Status == 'Closed' && c.Type == 'Repair' || c.Type == 'Routine Maintenance')
        
    @isTest static void testSuccessfulCreate() {
        // Data setup area
        // Required fields for Vehicle__c: Name
        Vehicle__c vehicle = new Vehicle__c(Name='RVOne');
        insert vehicle;
        
        // Required fields for Product2: Name
        Product2 equipment = new Product2(Name='PartOne', Maintenance_Cycle__c=180, Replacement_Part__c=true);
        insert equipment;
        
        List<Case> maintenanceRequests1 = new List<Case>();
        maintenanceRequests1.add(new Case(
            Vehicle__c=vehicle.Id,
            Equipment__c=equipment.Id,
            Type='Routine Maintenance',
            Status='Working',
            Subject='Subject'
        ));
		insert maintenanceRequests1;
        Test.startTest();
        maintenanceRequests1[0].Status = 'Closed';
        update maintenanceRequests1;
        Test.stopTest();
        Case c = [SELECT Id, Date_Due__c FROM Case WHERE Status='New'];
		System.assertEquals(Date.today().addDays(180), c.Date_Due__c);        
    }
    
        @isTest static void testUnsuccessfulCreate() {
        // Data setup area
        // Required fields for Vehicle__c: Name
        Vehicle__c vehicle = new Vehicle__c(Name='RVTwo');
        insert vehicle;
        
        // Required fields for Product2: Name
        Product2 equipment = new Product2(Name='PartTwo', Maintenance_Cycle__c=190);
        insert equipment;
        
        List<Case> maintenanceRequests2 = new List<Case>();
        maintenanceRequests2.add(new Case(
            Vehicle__c=vehicle.Id,
            Equipment__c=equipment.Id,
            Type='Routine Maintenance',
            Status='New',
            Subject='Subject'
        ));
		
        Test.startTest();
        insert maintenanceRequests2;
        maintenanceRequests2[0].Status = 'Working';
        upsert maintenanceRequests2;
        Test.stopTest();
        
		System.assert([SELECT Id FROM Case WHERE Status = 'New'].size() == 0);        
    }
    
     @isTest static void testOnePartNoCycle() {
        // Data setup area
        // Required fields for Vehicle__c: Name
        Vehicle__c vehicle = new Vehicle__c(Name='RVThree');
        insert vehicle;
        
        // Required fields for Product2: Name
        Product2 equipment = new Product2(Name='PartThree', Maintenance_Cycle__c=365, Replacement_Part__c=true);
        insert equipment;
        
        
        List<Case> maintenanceRequests3 = new List<Case>();
        maintenanceRequests3.add(new Case(
            Vehicle__c=vehicle.Id,
            Equipment__c=equipment.Id,
            Type='Routine Maintenance',
            Status='New',
            Subject='Subject'
        ));
		
        Test.startTest();
        insert maintenanceRequests3;
        Work_Part__c part = new Work_Part__c(Maintenance_Request__c=maintenanceRequests3[0].Id, Equipment__c=equipment.Id);
        insert part;
        maintenanceRequests3[0].Status = 'Closed';
        update maintenanceRequests3;
        Test.stopTest();
        
        Case c = [SELECT Id, Date_Due__c FROM Case WHERE Status = 'New'];
		System.assertEquals(Date.today().addDays(365), c.Date_Due__c);        
    }
    
    @isTest static void testMultipleParts() {
        // Data setup area
        // Required fields for Vehicle__c: Name
        Vehicle__c vehicle = new Vehicle__c(Name='RVFour');
        insert vehicle;
        
        // Required fields for Product2: Name
        Product2 equipment1 = new Product2(Name='PartFour', Maintenance_Cycle__c=365, Replacement_Part__c=true);
        insert equipment1;
        
        Product2 equipment2 = new Product2(Name='PartFive', Maintenance_Cycle__c=205, Replacement_Part__c=true);
        insert equipment2;
        
        List<Case> maintenanceRequests4 = new List<Case>();
        maintenanceRequests4.add(new Case(
            Vehicle__c=vehicle.Id,
            Equipment__c=equipment1.Id,
            Type='Routine Maintenance',
            Status='New',
            Subject='Subject'
        ));
        
        insert maintenanceRequests4;
        Work_Part__c part1 = new Work_Part__c(Maintenance_Request__c=maintenanceRequests4[0].Id, Equipment__c=equipment1.Id);
        Work_Part__c part2 = new Work_Part__c(Maintenance_Request__c=maintenanceRequests4[0].Id, Equipment__c=equipment2.Id);
        insert part1;
        insert part2;
        
        Test.startTest();
        maintenanceRequests4[0].Status = 'Closed';
        update maintenanceRequests4;
        Test.stopTest();
        
        Case c = [SELECT Id, Date_Due__c FROM Case WHERE Status = 'New'];
        System.assertEquals(Date.today().addDays(205), c.Date_Due__c);        
    }
    
    @isTest static void testMultipleParts2() {
        // Data setup area
        // Required fields for Vehicle__c: Name
        Vehicle__c vehicle = new Vehicle__c(Name='RVFour');
        insert vehicle;
        
        // Required fields for Product2: Name
        Product2 equipment1 = new Product2(Name='PartFour', Maintenance_Cycle__c=200, Replacement_Part__c=true);
        insert equipment1;
        
        Product2 equipment2 = new Product2(Name='PartFive', Maintenance_Cycle__c=205, Replacement_Part__c=true);
        insert equipment2;
        
        List<Case> maintenanceRequests4 = new List<Case>();
        maintenanceRequests4.add(new Case(
            Vehicle__c=vehicle.Id,
            Equipment__c=equipment1.Id,
            Type='Routine Maintenance',
            Status='New',
            Subject='Subject'
        ));
        
        insert maintenanceRequests4;
        Work_Part__c part1 = new Work_Part__c(Maintenance_Request__c=maintenanceRequests4[0].Id, Equipment__c=equipment1.Id);
        Work_Part__c part2 = new Work_Part__c(Maintenance_Request__c=maintenanceRequests4[0].Id, Equipment__c=equipment2.Id);
        insert part1;
        insert part2;
        
        Test.startTest();
        maintenanceRequests4[0].Status = 'Closed';
        update maintenanceRequests4;
        Test.stopTest();
        
        Case c = [SELECT Id, Date_Due__c FROM Case WHERE Status = 'New'];
        System.assertEquals(Date.today().addDays(200), c.Date_Due__c);        
    }
    
    @isTest static void testDefaultDate() {
        // Data setup area
        // Required fields for Vehicle__c: Name
        Vehicle__c vehicle = new Vehicle__c(Name='RVOne');
        insert vehicle;
        
        // Required fields for Product2: Name
        Product2 equipment = new Product2(Name='PartOne', Replacement_Part__c=true);
        insert equipment;
        
        List<Case> maintenanceRequests1 = new List<Case>();
        maintenanceRequests1.add(new Case(
            Vehicle__c=vehicle.Id,
            Equipment__c=equipment.Id,
            Type='Routine Maintenance',
            Status='Working',
            Subject='Subject'
        ));
		insert maintenanceRequests1;
        Test.startTest();
        maintenanceRequests1[0].Status = 'Closed';
        update maintenanceRequests1;
        Test.stopTest();
        Case c = [SELECT Id, Date_Due__c FROM Case WHERE Status='New'];
		System.assertEquals(Date.today().addDays(365), c.Date_Due__c);        
    }
}