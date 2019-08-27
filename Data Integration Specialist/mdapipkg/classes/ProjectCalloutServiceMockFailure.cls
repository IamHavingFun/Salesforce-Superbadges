@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
    global HttpResponse respond (HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        response.setStatus('An error message');
        return response;
    }
}