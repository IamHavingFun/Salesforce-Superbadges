@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock {
   //Implement http mock callout here
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(201);
        response.setStatus('OK');
        return response;
    }
}