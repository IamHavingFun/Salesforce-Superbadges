/**
* @name TeamsCalloutServiceOBFUSCATED
* @description Contains a set of static methods for working with the Microsoft Graph API.
**/
public class TeamsCalloutServiceOBFUSCATED {
    // Note that this callout ONLY WORKS for a registered app that is registered as a daemon. Authenticating without a user scenario. I.e. assumes that Graph API permissions
    // are set as "Application permissions" and the tenant admin has approved the permissions.
    private static String token {get;set;}
    /**
     * Obtains an OAuth token and sets the token property for inclusion in subsequent callouts.	
     **/
    public static void setGraphToken(){
        // graphAPIParams[0] should be tenant ID
        // graphAPIParams[1] should be Registered App Client ID
        Http http = new Http();
        HttpRequest authRequest = new HttpRequest();
        authRequest.setMethod('POST');
        // Client ID (ID of Azure AD Registered App) for O365 tenant: clientid
        // Tenant ID (ID of O365 Tenant) for O365 tenant: tenantid
        // For now, manually set the graphAPIParams
        List<String> graphAPIParams = new List<String>{'clientid', 'tenantid'};
            
        String endpoint = 'https://login.microsoftonline.com/' + graphAPIParams[0] + '/oauth2/v2.0/token';
        authRequest.setEndpoint(endpoint);
        authRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String clientId = 'client_id=' + graphAPIParams[1];
        // The scope that is always used for obtaining an OAuth token for daemons is the name of the resource followed by /.default i.e. the default OAuth scope. The daemon then inherits all scopes 
        // defined in the Azure AD app registration. 
        String scope = 'scope=' + EncodingUtil.urlEncode('https://graph.microsoft.com/.default', 'utf-8');
        String clientSecret = 'client_secret=' + EncodingUtil.urlEncode('clientsecret', 'UTF-8');
        String grantType = 'grant_type=' + 'client_credentials'; // Always 'client_credentials' for a daemon app
        authRequest.setBody(clientId + '&' + scope + '&' + clientSecret + '&' + grantType);
        
        HttpResponse authResponse = http.send(authRequest);
        Map<String, Object> responseBody = (Map<String, Object>)JSON.deserializeUntyped(authResponse.getBody());
        
        token = (String)responseBody.get('access_token'); 
    }
    
    /**
     * Gets the list of all Azure AD groups (consists of both O365 and security groups) for the tenant.
     * @return the callout response body
     **/
    public static String getGroups(){
        // Base Graph API endpoint: https://graph.microsoft.com/v1.0
        // Groups resource endpoint: /groups
        // Set header: Authorization: Bearer <token>
        // Set header: Accept: application/json
        
        // Only set the token if the token has not yet been obtained.
        if (token == null) setGraphToken();
        
        String baseGraphEndpoint = 'https://graph.microsoft.com/v1.0';
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(baseGraphEndpoint + '/groups');
        request.setHeader('Authorization', 'Bearer ' + token);
        // Salesforce requires the Accept header to be set explicitly in this case, otherwise it will fail to process the response
        request.setHeader('Accept', 'application/json');
        HttpResponse response = new Http().send(request);
        return response.getBody();
    }
    
    /**
     * Gets the Team based on associated Salesforce Account Name.
     * @return the callout response body
     **/
    public static String getTeam(){
        // Base Graph API endpoint: https://graph.microsoft.com/v1.0
        // Groups resource endpoint: /teams/:id
        // Set header: Authorization: Bearer <token>
        // Set header: Accept: application/json
        // Only set the token if the token has not yet been obtained.
        if (token == null) setGraphToken();
        
        String baseGraphEndpoint = 'https://graph.microsoft.com/v1.0';
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(baseGraphEndpoint + '/teams/teamid');
        request.setHeader('Authorization', 'Bearer ' + token);
        // Salesforce requires the Accept header to be set explicitly in this case, otherwise it will fail to process the response
        request.setHeader('Accept', 'application/json');
        HttpResponse response = new Http().send(request);
        return response.getBody();
    }
    
    /**
     * Gets the Channels for a given Team.
     * @return the callout response body
     **/
    public static String getTeamChannels(){
        // Base Graph API endpoint: https://graph.microsoft.com/v1.0
        // Channels resource endpoint: /teams/:id/channels
        // Set header: Authorization: Bearer <token>
        // Set header: Accept: application/json
        // Only set the token if the token has not yet been obtained.
        if (token == null) setGraphToken();
        
        String baseGraphEndpoint = 'https://graph.microsoft.com/v1.0';
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(baseGraphEndpoint + '/teams/teamid/channels');
        request.setHeader('Authorization', 'Bearer ' + token);
        // Salesforce requires the Accept header to be set explicitly in this case, otherwise it will fail to process the response
        request.setHeader('Accept', 'application/json');
        HttpResponse response = new Http().send(request);
        return response.getBody();
    }
    
    /**
     * Gets a specific Channel for a given Team.
     * @param  the Name of the Account related to the closed Opportunity
     * @return the callout response body
     **/
    public static String getTeamChannel(){
        // Base Graph API endpoint: https://graph.microsoft.com/v1.0
        // Channels resource endpoint: /teams/:id/channels
        // Set header: Authorization: Bearer <token>
        // Set header: Accept: application/json
        // Only set the token if the token has not yet been obtained.
        if (token == null) setGraphToken();
        
        String baseGraphEndpoint = 'https://graph.microsoft.com/v1.0';
        String oDataFilter = EncodingUtil.urlEncode('displayName eq \'General\'', 'utf-8');
        String fullEndpoint = baseGraphEndpoint + '/teams/teamid/channels?$filter=' + oDataFilter;
        System.debug(fullEndpoint);
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint(fullEndpoint);
        request.setHeader('Authorization', 'Bearer ' + token);
        // Salesforce requires the Accept header to be set explicitly in this case, otherwise it will fail to process the response
        request.setHeader('Accept', 'application/json');
        HttpResponse response = new Http().send(request);
        return response.getBody();
    }
    
    /**
     * Gets a specific Channel for a given Team, passing in the Name of the Account related to the closed Opportunity to use as the Channel filter. Called by Process Builder.
     * @param  the closed Opportunity
     **/
    @InvocableMethod
    public static void getInvocableTeamChannel(List<Opportunity> closedOpps){
        // Base Graph API endpoint: https://graph.microsoft.com/v1.0
        // Channels resource endpoint: /teams/:id/channels
        // Set header: Authorization: Bearer <token>
        // Set header: Accept: application/json
        // Only set the token if the token has not yet been obtained.
        if (token == null) setGraphToken();
        String baseGraphEndpoint = 'https://graph.microsoft.com/v1.0';
        String ce = 'utf-8';
        Map<String, String> commonHeaders = new Map<String, String>();
        commonHeaders.put('Accept', 'application/json');
        commonHeaders.put('Authorization', 'Bearer ' + token);
        Http http = new Http();

        // 1. Get the related Account from the passed-in Opportunity
        Opportunity closedOpp = [SELECT Account.Name FROM Opportunity WHERE Id = :closedOpps.get(0).Id];
        
        // 2. Use the /groups resource with OData filter to obtain the ID of the Team (teams resource doesn't support the OData $filter, but groups does and the ID of the group and team are the same).
        String oDataGroupsFilter = EncodingUtil.urlEncode('displayName eq \'Test O365 Group\'', ce);
        HttpRequest getGroup = new HttpRequest();
        getGroup.setMethod('GET');
        getGroup.setEndpoint(baseGraphEndpoint + '/groups?$filter=' + oDataGroupsFilter);
        getGroup.setHeader('Accept', commonHeaders.get('Accept'));
        getGroup.setHeader('Authorization', commonHeaders.get('Authorization'));
        HttpResponse getGroupResponse = http.send(getGroup);
        
        // 3. Use the /teams/:id/channels resource with OData filter to obtain the Channel associated to the Account
        if (getGroupResponse.getStatusCode() == 200 || getGroupResponse.getStatusCode() == 201) {
            Map<String, Object> getGroupResponseBody = (Map<String, Object>)JSON.deserializeUntyped(getGroupResponse.getBody());
            List<Object> groupValue = (List<Object>)getGroupResponseBody.get('value');
            String groupValueString = String.valueOf(groupValue.get(0));
            Pattern p = pattern.compile('id=([a-zA-Z0-9\\s-]+)');
            Matcher m = p.matcher(groupValueString);
            if (m.find()) {
                String groupId = m.group(1);
                String oDataChannelsFilter = EncodingUtil.urlEncode('displayName eq \'General\'', ce);
            	HttpRequest getChannel = new HttpRequest();
            	getChannel.setMethod('GET');
            	getChannel.setEndpoint(baseGraphEndpoint + '/teams/' + groupId + '/channels?$filter=' + oDataChannelsFilter);
                getChannel.setHeader('Accept', commonHeaders.get('Accept'));
                getChannel.setHeader('Authorization', commonHeaders.get('Authorization'));
                HttpResponse getChannelResponse = http.send(getChannel);
                
                if (getChannelResponse.getStatusCode() == 200 || getChannelResponse.getStatusCode() == 201) {
                    Map<String, Object> getChannelResponseBody = (Map<String, Object>)JSON.deserializeUntyped(getChannelResponse.getBody());
            		List<Object> channelValue = (List<Object>)getChannelResponseBody.get('value');
            		String channelValueString = String.valueOf(channelValue.get(0));
                    Pattern pp = pattern.compile('id=([a-zA-Z0-9\\s-:@\\.]+)');
            		Matcher mm = pp.matcher(channelValueString);
                    
                    // 4. Use the /teams/:id/channels/:id/messages resource to create a new chatMessage in the Channel
                    if(mm.find()) {
                        String channelId = mm.group(1);
                        String messageBody = '{"body":{"content": "Hello World"}}';
                        HttpRequest channelPost = new HttpRequest();
                        channelPost.setMethod('POST');
                        channelPost.setEndpoint(baseGraphEndpoint + '/teams/' + groupId + '/channels/' + channelId + '/messages');
                        channelPost.setHeader('Accept', commonHeaders.get('Accept'));
                        channelPost.setHeader('Authorization', commonHeaders.get('Authorization'));
                        channelPost.setHeader('Content-Type', 'application/json');
                        channelPost.setHeader('Content-Length', String.valueOf(messageBody.length()));
                        channelPost.setBody(messageBody);
                        
                        HttpResponse postMessageResponse = http.send(channelPost);
                        System.debug(postMessageResponse);
                    }
                }
            }
        }
    }
}