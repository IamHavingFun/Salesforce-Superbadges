global with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(WAREHOUSE_URL);
        HttpResponse response = http.send(request);
        List<Object> responseBody = (List<Object>)JSON.deserializeUntyped(response.getBody());
        
        Map<String, Object> currentObj;
        List<Product2> equipmentsToUpdate = new List<Product2>();
        
        for (Object obj : responseBody) {
            // System.debug(obj);
            currentObj = (Map<String, Object>)obj;
            //equipment.ExternalId = (String)currentObj.get('_id');
            Product2 equipment = new Product2(
                Name = (String)currentObj.get('name'),
                Replacement_Part__c = true, 
                Cost__c = (Decimal)currentObj.get('cost'), 
                Current_Inventory__c = (Decimal)currentObj.get('quantity'), 
                Lifespan_Months__c = (Decimal)currentObj.get('lifespan'),
                Maintenance_Cycle__c = (Decimal)currentObj.get('maintenanceperiod'),
                Warehouse_SKU__c = (String)currentObj.get('sku'));
            equipmentsToUpdate.add(equipment);
        }
        upsert equipmentsToUpdate Warehouse_SKU__c;
        // System.debug([SELECT Name FROM Product2]);
    }
	
}