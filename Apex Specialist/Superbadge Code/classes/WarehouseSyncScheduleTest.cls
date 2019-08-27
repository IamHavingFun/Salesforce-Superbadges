@isTest
public class WarehouseSyncScheduleTest {
    @isTest static void testSyncSchedule(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('WarehouseSyncJob', '0 0 1 1/1 * ? *', new WarehouseSyncSchedule());
        Test.stopTest();
        
        System.assert([SELECT NextFireTime FROM CronTrigger WHERE Id = :jobId].size() == 1);
    }
}