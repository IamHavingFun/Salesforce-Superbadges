public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    public System.HttpResponse respond(System.HttpRequest request) {
        String bodyPart1 = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},';
        String bodyPart2 = '{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"}]';
        String body = bodyPart1 + bodyPart2;
        System.debug(body);
        System.HttpResponse response = new System.HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(body);
        response.setStatusCode(200);
        
        return response;
    }
}