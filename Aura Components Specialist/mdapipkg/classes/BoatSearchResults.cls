public with sharing class BoatSearchResults {
	@AuraEnabled
    public static List<Boat__c> getBoats(String boatTypeId) {
        String query = 'SELECT Name, Contact__r.Name, BoatType__c, BoatType__r.Name, Picture__c, Geolocation__longitude__s, Geolocation__latitude__s FROM Boat__c';
        if (boatTypeId == '') {
            return Database.query(query);
        } else {
            query = query + ' WHERE BoatType__c = :boatTypeId';
            return Database.query(query);
        }
    }
}