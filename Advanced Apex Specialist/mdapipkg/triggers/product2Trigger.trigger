/**
 * @name product2Trigger
 * @description Trigger to notify staff of low levels of inventory
**/
trigger product2Trigger on Product2 (after update) {
   if (Trigger.new != null) Product2Helper.AfterUpdate(Trigger.new, Trigger.old);
        
     
}