/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Your Name
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        return [SELECT Id, LastName, Company, Phone, Email
                FROM Lead
                LIMIT 50000];
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName () {
        return [SELECT Id, Name
                FROM Contact
                WHERE FirstName = 'John'
                ];
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName () {
        List<Id> contactIds = new List<Id>();
        for(Contact contactRecord : [SELECT Id, Name FROM Contact WHERE LastName = 'Jones'OR LastName = 'Smith']){
            contactIds.add(contactRecord.Id);
        }

        return contactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunities (Id accountId) {
        return [SELECT Id, Name, StageName, CloseDate, Amount, AccountId FROM Opportunity WHERE AccountId = :accountId AND StageName = 'Closed Won'];
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount (List<Account> accountList) {
      return [SELECT COUNT() FROM Account WHERE Id IN: accountList];
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id,Task> getTasksDueNextWeek () {
      return new Map<Id,Task>([SELECT Id, Subject, ActivityDate FROM Task WHERE ActivityDate <= NEXT_N_DAYS:7]);
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain () {
      return [SELECT Id, Name, Email FROM Contact WHERE Email LIKE '%example.com'];
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        String soqlLikeStr = '%' + keyword + '%';
        return [SELECT Id, Name FROM Opportunity WHERE Name LIKE :soqlLikeStr]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        return [SELECT Id, Origin FROM Case WHERE Origin <> 'Web' AND Origin <> 'Email' AND Origin <> '']; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle (String leadSource, String title) {
        String soqlLikeStr = '%' + title + '%';
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :soqlLikeStr];
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactsLastNames = new List<String>();

        // Query the Contacts
        // Loop through each Contact and add the LastName to the list
        for(Contact contactRecord : [SELECT LastName FROM Contact WHERE AccountId = :accountId]) {
            contactsLastNames.add(contactRecord.LastName);
        }

        // Return the list of Contact LastNames
        return contactsLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue

        // Return the total revenue
        return (Decimal)[SELECT SUM(Amount) totalAmount FROM Opportunity WHERE StageName = :stage OR Amount > 10000][0].get('totalAmount'); // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [SELECT Id, Name FROM Account ORDER BY Name LIMIT 10 ]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return [SELECT Id, Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [SELECT Birthdate FROM Contact ORDER BY Birthdate DESC LIMIT 3]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [SELECT Id, CreatedDate FROM Case WHERE IsClosed = false ORDER BY CreatedDate LIMIT 10 OFFSET 5]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();
        // Query the Cases
        // Loop through each Case and add the Id to the set
        for (Case caseRecord : [SELECT Id FROM Case WHERE AccountId =: accountId]) {
            caseIds.add(caseRecord.Id);
        }

        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts

        // Loop through each Account and add the Id and Name to the map
        for (Account accountRecord : [SELECT Id, Name FROM Account WHERE BillingCountry <> :country]){
            accountIdsToNames.put(accountRecord.Id, accountRecord.Name);
        }
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        return [SELECT Account.Name FROM Contact WHERE Id = :contactId LIMIT 1].Account.Name; // Replace null with the variable you used to store the result
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        return [SELECT Id, Name, 
                    (SELECT Id, Name
                    FROM Opportunities)
                FROM Account
                WHERE Id = :accountId]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        // Store the Account's BillingState
        String billingState = [SELECT BillingState FROM Account WHERE Id = :accountId LIMIT 1].BillingState;

        // Query the Contacts
        return [SELECT Id, MailingState FROM Contact WHERE MailingState = :billingState]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        Set<String> emailDomains = new Set<String>();

        // Query the Leads
        List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds AND Email <> null];

        // Create a set of email domains from the Leads

        for(Lead leadRecord : leads)

        // Loop through each Lead
        {   
                emailDomains.add('www.'+leadRecord.Email.split('@')[1]);
        }


        
        // Query the Accounts
        return [SELECT Id, Website FROM Account WHERE Website  IN :emailDomains]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> existingOpportunityLineItems = [SELECT Quantity, PricebookEntryId, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :origOppId];

        // Create a list to hold the new line items
        List<OpportunityLineItem> newOpportunityLineItems = new List<OpportunityLineItem>();

        // Generate a random number between 1 and 3
        Integer quantity = (Integer)(Math.floor(Math.random()  * 3) + 1);

        // Loop through each cloned Opportunity Id
        for(Id cloneOppId : cloneOppIds){

            // Loop through each original line item
            for (OpportunityLineItem opportunityLineItemRecord : existingOpportunityLineItems) {
                
            
                // Clone the original line item and add the random number to the quantity
                OpportunityLineItem clonedOpportunityLineItemRecord = opportunityLineItemRecord.clone(false, false, false, false);
                clonedOpportunityLineItemRecord.OpportunityId = cloneOppId;
                clonedOpportunityLineItemRecord.Quantity = quantity;
                newOpportunityLineItems.add(clonedOpportunityLineItemRecord);

            }
        }

        // Insert the new line items
        insert newOpportunityLineItems;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return [SELECT Id, AccountId, Name, Account.Name, Owner.Name FROM Opportunity WHERE StageName = 'Closed Won']; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Contact> accountIdAndContactMap = new Map<Id, Contact>();
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> opportunitiesToUpdate = getOpportunityDetailsForClosedWon();

        // Create a set of Account Ids from the Opportunities
        for(Opportunity opportunityRecord : opportunitiesToUpdate){
            accountIds.add(opportunityRecord.AccountId);
        }

        // Query the Contacts
        List<Contact> contacts = [SELECT Id, AccountId, FirstName, LastName FROM Contact WHERE AccountId IN: accountIds ORDER BY AccountId, LastName];

        // Loop through each Contact and add the Account Id and Contact to the map
        for(Contact contactRecord : contacts){
            if(accountIdAndContactMap.containsKey(contactRecord.AccountId)){
                continue;
            }else{
                accountIdAndContactMap.put(contactRecord.AccountId, contactRecord);
            }
        }
        
        // Loop through each Opportunity
        for(Opportunity opportunityRecord : opportunitiesToUpdate){
            
                // Update the Opportunity primary contact from accountToContactMap
            opportunityRecord.Primary_Contact__c = accountIdAndContactMap.get(opportunityRecord.AccountId).Id;
        }
        // Update the Opportunities
        update opportunitiesToUpdate;
    }
}