public with sharing class BoatSearchController {
	@AuraEnabled
    public static List<BoatType__c> getBoatTypes() {
        try {
            List<BoatType__c> boatTypes = [SELECT Id, Name FROM BoatType__c];
            return boatTypes;
        } catch (Exception e) {
            throw new AuraHandledException('Unable to get the requested records: ' + e.getMessage());
        }
    }
}