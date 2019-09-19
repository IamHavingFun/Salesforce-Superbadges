/**
* @name GenericDataFactory
* @description Contains a set of methods for generating test records.
**/
@IsTest
public class GenericDataFactory {
    /**
     * Helper method to dynamically create an sObject record.
     * @param  sObjectName the API name of an sObject type
     * @return generic sObject record
     **/
    private static SObject createRecordHelper(String sObjectName) {
        Schema.DescribeSObjectResult objectDescribe = Schema.describeSObjects(new List<String>{sObjectName}).get(0);
        Schema.SObjectType objectToken = objectDescribe.getSObjectType();
        SObject sobj = objectToken.newSObject();
        Map<String, Schema.SObjectField> allFields = objectDescribe.fields.getMap();
        List<String> requiredFields = new List<String>();
        // Compound field types:
        // Geolocation: LOCATION
        // Address: ADDRESS
        // Name: String. Check by field name as Name compound field does not register as a different data type
        List<Schema.SoapType> compoundTypes = new List<Schema.SoapType>{Schema.SoapType.ADDRESS, Schema.SoapType.LOCATION};
            for (String fieldName : allFields.keySet()) {
                // NOTE: Compound type fields such as Name are not writeable. Name fields must instead be created as FirstName, LastName. Individual compound field components are stored on the object,
                // so simply ignore compound types including Name, Address, Geolocation.
                Schema.DescribeFieldResult fieldTypeDesc = allFields.get(fieldName).getDescribe();
                if (fieldTypeDesc.isNillable() == false && fieldTypeDesc.isCreateable() == true) {
                    // Filter out compound fields
                    if (fieldName != 'Name' && fieldTypeDesc.getSoapType() != Schema.SoapType.ADDRESS && fieldTypeDesc.getSoapType() != Schema.SoapType.LOCATION) {
                        requiredFields.add(fieldName);
                    }
                }
            }
        Integer count = 0;
        for (String f : requiredFields) {
            Schema.SoapType currentFieldType = allFields.get(f).getDescribe().getSoapType();
            switch on currentFieldType {
                when STRING {
                    String s = 'TEST ' + count;
                    sobj.put(f, s);
                }
                when INTEGER {
                    Integer i = count;
                    sobj.put(f, i);
                }
                when DECIMAL {
                    Decimal d = Decimal.valueOf(String.valueOf(count));
                    sobj.put(f, d);
                }
                when DOUBLE {
                    // Geolocation field components are stored as DOUBLE, and must be between Latitude -90.00000 and 90.00000, and Longitude -180.00000 and 180.00000
                    Double dub;
                    if (f.contains('latitude__s')) {
                        dub = 90;
                    } else if (f.contains('longitude__s')) {
                        dub = 180;
                    } else {
                        dub = Math.random() * 100;
                    }
                }
                when DATE {
                    Date t = Date.today();
                    Date dat = Date.newInstance(t.year(), t.month(), t.day());
                    sobj.put(f, dat);
                }
                when DATETIME {
                    Time ti = Datetime.now().time();
                    Date td = Date.today();
                    Datetime dt = Datetime.newInstance(td, ti);
                    sobj.put(f, dt);
                }
            }
            count++;
        }
        return sObj;
    }
    
    /**
     * A method that takes an SObject by name and generates a single record, handles populating all required fields for the specified object.
     * @param   sObjectName the name of a Salesforce object to create a test record for
     * @returns the Id of the created record
     **/
    @IsTest
    public static ID createRecord (String sObjectName) {
        SObject record = createRecordHelper(sObjectName);
        try {
            insert record;
        } catch (DmlException de) {
            System.debug(de.getCause());
            return null;
        }
        return record.Id;
    }
    
    /**
     * Creates a given number of records for the specified sObject and returns the IDs of the records.
     * @param  sObjectName the name of an sObject type
     * @param  numRecords the number of test records to create  
     * @return an array of Ids of the created test records
     **/ 
    @IsTest
    public static ID[] createRecords(String sObjectName, Integer numRecords) {
        List<SObject> records = new List<SObject>();
        
        for (Integer i = 0; i < numRecords; i++) {
            records.add(createRecordHelper(sObjectName));
        }
        
        try {
            insert records;
        } catch (DmlException de) {
            System.debug(de.getCause());
            return null;
        }
        
        ID[] recordIDs = new ID[records.size()];
        
        for (Integer ii = 0; ii < recordIDs.size(); ii++) {
            recordIDs[ii] = records.get(ii).Id;
        }
        
        return recordIDs;
    }
}