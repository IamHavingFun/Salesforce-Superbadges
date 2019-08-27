/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        // Create new CollaborationGroup instance (class name for Chatter group). Group should have the following properties:
        // - Group Access = Public | API Name: CollaborationType
        // - Group Name = 'TEST ' + Constants.INVENTORY_ANNOUNCEMENTS | API Name: Name
        CollaborationGroup cg = new CollaborationGroup(Name='TEST' + Constants.INVENTORY_ANNOUNCEMENTS, CollaborationType='Public');
        return cg;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        //  Family=Constants.PRODUCT_FAMILY[Math.round((Math.random() * Constants.PRODUCT_FAMILY.size())) - 1].getValue()));
        List<Product2> lstProducts = new List<Product2>();
        Integer fI = 0;
        for (Integer i = 0; i < cnt; i++) {
            if (fI >= Constants.PRODUCT_FAMILY.size()) fI = 0;
            lstProducts.add(new Product2(Name='TEST' + i, 
                                         IsActive=true, 
                                         Initial_Inventory__c=30, 
                                         Family=Constants.PRODUCT_FAMILY[fI].getValue()));
            fI++;
        }
		
        return lstProducts;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        // Create one PricebookEntry instance per Product2 in prods. Set the values as follows:
        // - IsActive = true
        // - Product2Id = corresponding Product2.Id
        // - Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID
        // - UnitPrice = ??? Use Math.random()
        List<PricebookEntry> entries = new List<PricebookEntry>();
        for (Product2 prod : prods) {
            entries.add(new PricebookEntry(Product2Id=prod.Id,
                                          Pricebook2Id=Constants.STANDARD_PRICEBOOK_ID,
                                          IsActive=true,
                                          UnitPrice=Decimal.valueOf(Math.random()*1000).setScale(2)));
        }
        return entries;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> acctList = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            acctList.add(new Account(Name='TestAccount' + i));
        }
        return acctList;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contact records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        // Technically, only LastName (of Name compound field) is required, but do FirstName and LastName, plus AccountId
        // Since cnt is unrelated to accts.size(), just keep looping through accts and assign each respective Id to AccountId, creating a number of Contact records equal to cnt
        Boolean b = cnt <= accts.size();
        ID conId;
        List<Contact> conList = new List<Contact>();
        Integer ii = 0;
        for (Integer i = 0; i < cnt; i++) {
            if (b) {
                conId = accts[i].Id;
            } else if (!b && ii <= accts.size()) {
                conId = accts[i].Id;
            } else {
                ii = 0;
                conId = accts[ii].Id;
            }
            conList.add(new Contact(FirstName='First Name' + i,
                                    LastName='Last Name' + i,
                                    AccountId = conId));
            ii++;
        }
        return conList;
    }
    
    /**
* @name CreateOrders
* @description Constructs a list of Order records for unit tests
**/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        //  Required fields for order: 
        Boolean b = cnt <= accts.size();
        ID ordId;
        List<Order> ordList = new List<Order>();
        Date t = Date.today();
        Integer ii = 0;
        for (Integer i = 0; i < cnt; i++) {
            if (b) {
                ordId = accts[i].Id;
            } else if (!b && ii <= accts.size()) {
                ordId = accts[i].Id;
            } else {
                ii = 0;
                ordId = accts[ii].Id;
            }
            
            ordList.add(new Order(AccountId=ordId,
                                 Status = 'Draft',
                                 EffectiveDate = Date.newInstance(t.year(), t.month(), t.day()),
                                 Pricebook2Id=Constants.STANDARD_PRICEBOOK_ID));
            ii++;
        }
        return ordList;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> itemList = new List<OrderItem>();
        ID ordId, pbeId;
        Integer ordI = 0, pbeI = 0;
        for (Integer i = 0; i < cnt; i++) {
            if (ordI > ords.size()) ordI = 0;
            if (pbeI > pbes.size()) pbeI = 0;
            itemList.add(new OrderItem(OrderId=ords[ordI].Id,
                                       PricebookEntryId=pbes[pbeI].Id,
                                       Quantity=Constants.DEFAULT_ROWS,
                                      UnitPrice=pbes[pbeI].UnitPrice));
            ordI++;
            pbeI++;
        }
        return itemList;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
		CollaborationGroup cg = ConstructCollaborationGroup();
        insert cg;
        
        List<Product2> prods = ConstructProducts(cnt);
        insert prods;
        
        List<PricebookEntry> entries = ConstructPricebookEntries(prods);
        insert entries;
        
        List<Account> accts = ConstructAccounts(cnt);
        insert accts;
        
        List<Contact> cons = ConstructContacts(cnt, accts);
        insert cons;
        
        List<Order> ords = ConstructOrders(cnt, accts);
        insert ords;
        
        List<OrderItem> ordItems = ConstructOrderItems(cnt, entries, ords);
        insert ordItems;
    }
	
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals(originalProduct.Quantity_Ordered__c + qtyOrdered, updatedProduct.Quantity_Ordered__c);
    }

}