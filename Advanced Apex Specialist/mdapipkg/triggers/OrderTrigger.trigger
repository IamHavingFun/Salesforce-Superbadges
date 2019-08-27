/**
 * @name orderTrigger
 * @description
**/
trigger OrderTrigger on Order (after update) {
    
        if ( Trigger.New != null && Trigger.Old != null ){
            OrderHelper.AfterUpdate(Trigger.New, Trigger.Old);
        }
    
}