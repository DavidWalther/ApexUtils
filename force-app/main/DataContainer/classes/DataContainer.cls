public with sharing virtual class DataContainer {
  protected List<Account> accounts;
  protected List<Contact> contacts;

  public virtual DataContainer queryAllRecords() {
    this.queryAccounts();
    this.queryContacts();
    
    // ...
    
    return this;
  }
  
  public virtual DataContainer queryAccounts() {
    this.accounts = [SELECT Id, Name FROM Account ORDER BY Name];
    return this;
  }
  
  public virtual DataContainer queryContacts() {
    this.contacts = [SELECT Id, Name FROM Contact ORDER BY Name];
    return this;
  }
  
  // ...
}