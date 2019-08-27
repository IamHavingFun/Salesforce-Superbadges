public class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }
        RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<ID> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<ID, Product2> productMap = new Map<Id, Product2>{};
        
        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value

		List<OrderItem> lstOrderItems = [SELECT Product2Id FROM OrderItem WHERE OrderId IN :activatedOrderIds];
        List<Product2> lstProducts = [SELECT Id, Quantity_Ordered__c FROM Product2 WHERE Id IN (SELECT Product2Id FROM OrderItem WHERE OrderId IN :activatedOrderIds)];
        for (OrderItem oi : lstOrderItems) {
            for (Product2 op : lstProducts) {
                if (op.Id == oi.Product2Id) {
                    productMap.put(oi.Product2Id, op);
                    break;
                }
            }
        }
        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        for (AggregateResult res : [SELECT Product2Id, SUM(Quantity) qty FROM OrderItem WHERE Product2Id IN :productMap.keySet() GROUP BY ROLLUP(Product2Id)]) {
            if (res.get('Product2Id') != null) productMap.get((ID)res.get('Product2Id')).Quantity_Ordered__c += (Decimal)res.get('qty');
        }
       
        //ToDo: Perform an update on the records in the productMap
        update new List<Product2>(productMap.values());
    }
}