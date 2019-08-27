public without sharing class ChartHelper {
	@AuraEnabled
    public static List<chartData> GetInventory(){
        List<ChartData> cht = new List<ChartData>();
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        //Integer qtyRemaining
        List<AggregateResult> results = [SELECT Family, SUM(Quantity_Remaining__c) quantity FROM Product2 WHERE IsActive = true GROUP BY Family];
        for (AggregateResult res : results) {
            cht.add(new ChartData((String)res.get('Family'), (Decimal)res.get('quantity')));
        }
        return cht;
    }
    
    @AuraEnabled
    public static List<ChartData> GetOrderItems(List<OrderItem> currentOrderItems){
        List<ChartData> cht = new List<ChartData>();
        /*
        for (OrderItem oi : [SELECT Product2.Name, Quantity FROM OrderItem WHERE OrderId = :orderId]) {
            cht.add(new ChartData(oi.Product2.Name, oi.Quantity));
        }*/
        for (OrderItem oi : currentOrderItems) {
            if (oi.Quantity > 0) cht.add(new ChartData(oi.Product2.Name, oi.Quantity * oi.UnitPrice));
        }
        
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }
}