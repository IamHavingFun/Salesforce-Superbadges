global class WarehouseSyncSchedule implements Schedulable{
    // implement scheduled code here
    //System.schedule('WarehouseSyncJob', '0 0 1 1/1 * ? *', new WarehouseCalloutService());
    global void execute(SchedulableContext ctx) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}