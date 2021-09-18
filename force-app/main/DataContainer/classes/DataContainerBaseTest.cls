@IsTest
public with sharing class DataContainerBaseTest {

    @TestSetup
    static void makeData(){
        Account acc01 = new Account( Name = 'Acc 01');
        Account acc02 = new Account( Name = 'Acc 02');
        Account acc03 = new Account( Name = 'Acc 03');
        insert new List<Account>{acc01, acc02, acc03};

        Lead lead01 = new Lead( LastName = 'Lead 01', Company = 'Acc 01');
        Lead lead02 = new Lead( LastName = 'Lead 02', Company = 'Acc 02');
        Lead lead03 = new Lead( LastName = 'Lead 03', Company = 'Acc 03');
        Lead lead04 = new Lead( LastName = 'Lead 04', Company = 'Acc 01');
        Lead lead05 = new Lead( LastName = 'Lead 05', Company = 'Acc 02');
        Lead lead06 = new Lead( LastName = 'Lead 06', Company = 'Acc 03');
        insert new List<Lead>{lead01, lead02, lead03, lead04, lead05, lead06};
    }


    @IsTest
    static void addRecordToMap_CreatesMapForEachObjectType() {
        Map<Id, Lead> queriedLeads = new Map<Id, Lead>([SELECT Id, Name FROM Lead ORDER BY Name]);
        Integer expectedSizeOfLeadMap = queriedLeads.size();
        
        Map<Id, Account> queriedAccounts = new Map<Id, Account>([SELECT Id, Name FROM Account ORDER BY Name]);
        Integer expectedSizeOfAccountMap = queriedAccounts.size();

        Test.startTest();
        DataContainer dataContainer2Check = new DataContainer().queryAccounts().queryLeads();
        Test.stopTest();

        System.assert(dataContainer2Check.records.containsKey(Lead.getSObjectType()), 'Lead records were not added');
        System.assertEquals(expectedSizeOfLeadMap, dataContainer2Check.records.get(Lead.getSObjectType()).size(), 'Not all Leads were added');

        System.assert(dataContainer2Check.records.containsKey(Account.getSObjectType()), 'Account records were not added');
        System.assertEquals(expectedSizeOfAccountMap, dataContainer2Check.records.get(Account.getSObjectType()).size(), 'Not all Account were added');

        // check: every lead is mapped by it's id
        for(Lead lead : queriedLeads.values()) {
            Id recordId = lead.Id;
            System.assert(dataContainer2Check.records.get(Lead.getSObjectType()).containsKey(recordId), 'The lead ' + lead.Name + 'was not mapped.');
        }
    
        // check: every Account is mapped by it's id
        for(Account acc : queriedAccounts.values()) {
            Id recordId = acc.Id;
            System.assert(dataContainer2Check.records.get(Account.getSObjectType()).containsKey(recordId), 'The lead ' + acc.Name + 'was not mapped.');
        }    
    }

    @IsTest
    static void getObjectRecords_ReturnsListOfMappedRecordsOfSobjectType() {
        Map<Id, Lead> queriedLeads = new Map<Id, Lead>([SELECT Id, Name FROM Lead ORDER BY Name]);

        Test.startTest();
        DataContainer dataContainer2Check = new DataContainer().queryLeads();
        Test.stopTest();
        List<Lead> mappedLeads = dataContainer2Check.getObjectRecords(Lead.getSObjectType());
        Map<Id, Lead> mappedLeadsMap = new Map<Id, Lead>(mappedLeads);

        System.assert(mappedLeadsMap.keySet().containsAll(queriedLeads.keySet()));
        System.assert(queriedLeads.keySet().containsAll(mappedLeadsMap.keySet()));
    }

    @IsTest
    static void hasObjectRecords_ReturnsTrueIfRecordsOfThisTypeAreMapped() {
        
        DataContainer dataContainer2Check = new DataContainer().queryLeads();

        Test.startTest();
        Boolean containerHasLead = dataContainer2Check.hasObjectRecords(Lead.getSObjectType());
        Boolean containerHasContacts = dataContainer2Check.hasObjectRecords(Contact.getSObjectType());
        Boolean containerHasNULL = dataContainer2Check.hasObjectRecords(NULL);
        Test.stopTest();

        System.assert(containerHasLead);
        System.assert(!containerHasContacts);
        System.assert(!containerHasNULL);
    }

    /**
     * This class is an example for the use of DataContainerBase
     */
    private with sharing virtual class DataContainer extends DataContainerBase {
        public List<Account> accounts {get{return this.getObjectRecords(Account.getSObjectType());} private set;}
        public List<Lead> leads {get{return this.getObjectRecords(Lead.getSObjectType());} private set;}
      
        public virtual DataContainer queryAllRecords() {
          this.queryAccounts().queryLeads();
          
          return this;
        }
        
        public virtual DataContainer queryAccounts() {
          this.addRecordToMap([SELECT Id, Name FROM Account ORDER BY Name]);
          return this;
        }
        
        public virtual DataContainer queryLeads() {
          this.addRecordToMap([SELECT Id, Name FROM Lead ORDER BY Name]);
          return this;
        }
    }
}
