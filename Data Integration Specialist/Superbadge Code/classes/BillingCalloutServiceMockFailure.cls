@isTest
public class BillingCalloutServiceMockFailure implements WebServiceMock {
    //Implement http mock callout failure here
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType
    ) {
        // Provide a mock SOAP response. For the BillingServiceProxy class, the response is of type Map<String, BillingServiceProxy.billProjectResponse_element>
        BillingServiceProxy.billProjectResponse_element response_x = new BillingServiceProxy.billProjectResponse_element();
        response_x.status = 'ERROR';
        response.put('response_x', response_x);
    } 
}