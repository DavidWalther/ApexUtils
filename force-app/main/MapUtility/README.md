# **MapUtility**

## **Purpose**
This utility is designed releave developers from the repetitive and error-prone task of creating maps of objects. This is done over and over again with only slight changes. By generalized by providing a basic logic and ways to options to define certain criteria.

## **Concept**
Creating a map from a list of objects is always done by the same steps:

1. **Decide whether to keep**
    * a collection of items
    * only the first item
    * only the last item
2. Loop over the list
    * for each item
      * **check whether the item should be inserted**
      * **read a 'mapping key'**
      * **evaluate the read value**
      * depending on which items to keep
        * simply put item into map for this 'mapping key' (keeps last item)
        * only insert into map if 'mapping key' ist not present yet (keeps first item)
        * add item to the collection for this 'mapping key' OR create a new collection for this 'mapping key' and add item

The four highlighted elements are the parts that are special for each map:
  * Decide 'how' to keep entries
    
    This is achieved via the enum `MAP_RETAIN_MODE`
  * Decide whether to keep item
  
    This is achieved via the interface `MapUtility_MappingMain.IncludeItemInMapInterface`  
  * Reading 'a value' form each entry 

    This is achieved via the interface `IValueReader`
  * 'Skip/add' each entry after evaluation

    This is achieved via the interface `MapUtility_MappingMain.IncludeItemKeyInMapInterface`

## **Use of the Map Util**

### **Call to the mapping method: `MapUtility_MappingMain.generateMapFromObjectList`**

      Map<String, Object> result = MapUtility_MappingMain.generateMapFromObjectList(
        List<Object> objects,
        IValueReader valueReader,
        MAP_RETAIN_MODE retainingMode,
        List<MapUtility_MappingMain.IncludeItemKeyInMapInterface> keyEvaluators
        List<MapUtility_MappingMain.IncludeItemInMapInterface> itemFilters
      )

**Parameters**
* `objects`: List of objects to create the map of. This can be SObjects or Objects
* `valueReader`: the ValueReader **instance** to use for getting mapping keys for each entry in `objects`
* `retainingMode`: an enum value to specify which items to keep
* `keyEvaluators`: a List of `MapUtility_MappingMain.IncludeItemKeyInMapInterface` to define criteria for the evaluation of every item key
* `itemFilters`: A list `MapUtility_MappingMain.IncludeItemInMapInterface` to define criteria for the evaluation of every item

# Examples: Mapping sObjects

## 1. Map by field values retaining all entries 

**Using**
* `MAP_RETAIN_MODE.RETAIN_ALL`

**Records to map**

    List<Lead> leadToCreateMapFrom;

**Create map**

    Map<Object, List<Object>> mappedEntries = new MapUtility_MappingMain().generateMapFromObjectList(
      sObjectsToCreateMapFrom, 
      new FieldValueReader(Lead.Company),
      MAP_RETAIN_MODE.RETAIN_ALL,
      new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
      new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
    );

## 2. Map by field values retaining last entry 

**Using**
* `MAP_RETAIN_MODE.RETAIN_LAST`

**Records to map**

    List<Lead> leadToCreateMapFrom;

**Create map**

    Map<Object, SObject> mappedEntries = new MapUtility_MappingMain().generateMapFromObjectList(
      sObjectsToCreateMapFrom, 
      new FieldValueReader(Lead.Company),
      MAP_RETAIN_MODE.RETAIN_LAST,
      new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>(),
      new List<MapUtility_MappingMain.IncludeItemInMapInterface>());

## 3. Map by field values retaining all entries AND keep only some mapping keys

**Using**
  * `MAP_RETAIN_MODE.RETAIN_ALL`
  * `MapUtility_MappingMain.IncludeItemKeyInMapInterface`

**Records to map**

    List<Lead> leadToCreateMapFrom;
    Set<Object> companiesToKeep = new Set<Object>{'ACME Inc.', 'Universal Containers'};

**Create map**

    Map<Object, List<Object>> mappedEntries = new MapUtility_MappingMain().generateMapFromObjectList(
      sObjectsToCreateMapFrom, 
      new FieldValueReader(Lead.Company),
      MAP_RETAIN_MODE.RETAIN_ALL,
      new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
        new MapUtility_ItemEvalImplementations.IncludeOnly(companiesToKeep);
        
      },
      new List<MapUtility_MappingMain.IncludeItemInMapInterface>());

## 4. Map by field values retaining all entries **AND** keep only some mapping keys **AND** exclude leads of inactive users (owners)

**Using**
 * `MAP_RETAIN_MODE.RETAIN_ALL`
 * `MapUtility_MappingMain.IncludeItemKeyInMapInterface`
 * `MapUtility_MappingMain.IncludeItemInMapInterface`

**Records to map**

    List<Lead> leadToCreateMapFrom;

**`MapUtility_MappingMain.IncludeItemInMapInterface`**

    public class ExcluceIfOwnerIsInactive implements MapUtility_MappingMain.IncludeItemInMapInterface {
        Boolean isIncludeItem(Object itemToCheckForInclusion) {
          Lead leadToCheck = (Lead)itemToCheckForInclusion;
          return leadToCheck?.Owner?.isActive == true;
        }
    }

**Create map**
    
    Set<Object> companiesToKeep = new Set<Object>{'ACME Inc.', 'Universal Containers'};

    Map<Object, List<Object>> mappedEntries = new MapUtility_MappingMain().generateMapFromObjectList(
      sObjectsToCreateMapFrom, 
      new FieldValueReader(Lead.Company),
      MAP_RETAIN_MODE.RETAIN_ALL,
      new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
        new MapUtility_ItemEvalImplementations.IncludeOnly(companiesToKeep);
        
      },
      new List<MapUtility_MappingMain.IncludeItemInMapInterface>{
        new ExcluceIfOwnerIsInactive();
    });


# Examples: Mapping class instances

**Using**
 * `MAP_RETAIN_MODE.RETAIN_ALL`
 * `MapUtility_MappingMain.IncludeItemKeyInMapInterface`

**Records to map**

    public class CompanyWrapper {
      Account company;
      Decimal anualTurnover;

      public CompanyWrapper(Account company, Decimal anualTurnover) {
        this.company = company;
        this.anualTurnover
      }
    }

    List<CompanyWrapper>  listCompanyWrappers = new List<CompanyWrapper>();
    ...

**`IValueReader`**
        
        public class CompanyClassifier implements IValueReader {
          public Object getValue(Object objectToGetValueFrom) {
            if(objectToGetValueFrom instanceOf CompanyWrapper) {
              CompanyWrapper wrapperInstance = (CompanyWrapper)objectToGetValueFrom;

              if(wrapperInstance.anualTurnover > 10000000) {
                return 'blue';
              }
              if(wrapperInstance.anualTurnover > 5000000) {
                return 'green';
              }
              if(wrapperInstance.anualTurnover > 1000000) {
                return 'yellow';
              }
              return 'red';
            }
          return NULL;
        }

**Create map**

    Set<Object> turnoverClassesToKeep = 
      new Set<Object>{'green', 'yellow'};

    Map<Object, List<Object>> mappedEntries = new MapUtility_MappingMain().generateMapFromObjectList(
      listCompanyWrappers, 
      new CompanyClassifier(),
      MAP_RETAIN_MODE.RETAIN_ALL,
      new List<MapUtility_MappingMain.IncludeItemKeyInMapInterface>{
        new MapUtility_ItemEvalImplementations.IncludeOnly(turnoverClassesToKeep),
        new MapUtility_ItemEvalImplementations.IgnoreKeyNull()
      },
      new List<MapUtility_MappingMain.IncludeItemInMapInterface>()
    );

---

#### **`enum: MAP_RETAIN_MODE`**

There are three mutual exclusive ways to store data inside a map. Each of these ways is represented by a member of the enum `MAP_RETAIN_MODE`:

    public enum MAP_RETAIN_MODE {RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL}

* `RETAIN_FIRST`: specifies to keep the first item for a specific 'mapping key'
* `RETAIN_LAST`: specifies to keep the last item for a specific 'mapping key'
* `RETAIN_ALL`: specifies to keep the all items for a specific 'mapping key' in a collection for each one

#### **`interface: IValueReader`**

The complexity of reading the 'mapping key' of an object can variy from object to object. It can be as simple as reading the value of a certain sObjectField or it can be the the result of a function call based on multiple values.
But regardless of the way a 'mapping key' is read it is always the result of an action specific to an individual item. This abstraction is taken into account by the `IValueReader` interface:

    public interface IValueReader {
        Object getValue(Object objectToGetValueFrom);
    }

This simple interface provides the neccessary abstraction for a generic way to read a 'mapping key' from an object.

#### **`interface: MapUtility_MappingMain.IncludeItemKeyInMapInterface`**

This interface is used to identify whether to include a calculated key in the mapping or not.

    public Interface MapUtility_MappingMain.IncludeItemKeyInMapInterface {
      Boolean isIncludeItemKey(Object keyToEvaluate);
    }


#### **`interface: MapUtility_MappingMain.IncludeItemInMapInterface`**

This interface is used to evaluate whether an item should even be considered to be added to the map.

   
    public interface IncludeItemInMapInterface {
        Boolean isIncludeItem(Object itemToCheckForInclusion);
    }

## Examples: Use of IValueReader interface

### 1. Reading the Company field of a lead object

    public class LeadCompanyReader implements IValueReader{
      public Object getValue(Object objectToGetValueFrom) {
        return ((Lead)objectToGetValueFrom)
          .Company;
      }
    }

    final String COMPANY_NAME = 'My Company';
    Lead testLead = new Lead(Company = COMPANY_NAME);
    System.assertEquals(COMPANY_NAME, new LeadCompanyReader().getValue(testLead));
---
### 2. Reading the company field depending on object type 

  This implementation of the IValueReader interface uses `instanceOf` to read a different field of the entry based on it's sObject type

    public class CompanyReader implements IValueReader{
      public Object getValue(Object objectToGetValueFrom) {
        if(objectToGetValueFrom instanceOf Lead) {
          return ((Lead)objectToGetValueFrom)
            .Company;
        }

        if(objectToGetValueFrom instanceOf Account) {
          return ((Account)objectToGetValueFrom)
            .Name;
        }

        if(objectToGetValueFrom instanceOf Contact) {
          return ((Contact)objectToGetValueFrom)
            .Account.Name;
        }

        return NULL;
      }
    }

Now the reader is able to access:

a leads `Company`-field:

    final String COMPANY_NAME_LEAD = 'My Lead Company';
    Lead testLead = new Lead(Company = COMPANY_NAME_LEAD);
    System.assertEquals(COMPANY_NAME_LEAD, new CompanyReader().getValue(testLead),
      'getValue(Lead) must return is\'s Company field.');

an accounts `Name`-field:

    final String COMPANY_NAME_ACCOUNT = 'My Account Company';
    Account testAccount = new Account(Name = COMPANY_NAME_ACCOUNT);
    System.assertEquals(COMPANY_NAME_ACCOUNT, new CompanyReader().getValue(testAccount),
      'getValue(Account) must return an its\'s Name field.');

a Contacts `Account.Name`-field

    final String COMPANY_NAME_CONTACT = 'My Contact Company';
    Account accountOfContact = new Account(Name = COMPANY_NAME_CONTACT);
    Contact testContact = new Contact(Account = accountOfContact);
    System.assertEquals(COMPANY_NAME_CONTACT, new CompanyReader().getValue(testContact),
      'getValue(Contact) must return its\'s Account\'s Name field.');

---
For further examples see class `MapUtility_MappingMainTest`.


## **Packages**

### Installation order
  1. Core
  1. Mapping

### **Latest**

| Sandbox | Production | 
| --- | --- |
| [Core](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t2o000000yUX6AAM) | [Core](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2o000000yUX6AAM) |
| [Mapping](https://test.salesforce.com/packaging/installPackage.apexp?p0=04t2o000000yUWwAAM) | [Mapping](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2o000000yUWwAAM) |

### **Package versions**
| Packagen | Version | Id| Promoted | Highlight |
| --- | --- | --- | --- | --- |
| Core | 1.0.0-2 | 04t2o000000yUVjAAM |yes | Original logic |
| Core | 1.1.0-1 | 04t2o000000yUVyAAM |yes | make value reader return 'Object' instead of 'String' |
| Core | 1.3.0-1 | 04t2o000000yUX6AAM |yes | remove fflib items   |
| Mapping | 1.0.0-2 | 04t2o000000yUVeAAM |yes| Original logic |
| Mapping | 1.1.0-2 | 04t2o000000yUW3AAM |yes | create map with 'Object' key instead of 'String' |
| Mapping | 2.0.0-1 | 04t2o000000yUWSAA2 |yes | replace map options |
| Mapping | 2.1.0-2 | 04t2o000000yUWcAAM |no | move interfaces into main class |
| Mapping | 3.0.0-1 | 04t2o000000yUWmAAM |yes | Create an interface to evaluate entries |
| Mapping | 3.1.0-2 | 04t2o000000yUXGAA2 |no | Create an interface to evaluate entries |
| Mapping | 3.2.0-1 | 04t2o000000yUXLAA2 |yes | Create an interface to evaluate entries |
| Mapping | 4.0.0-1 | 04t2o000000yUWwAAM |yes | Remove enum MAP_OPTION |

### Installation via SFDX

    sfdx force:package:install --targetusername="<username> " --package="<version Id>" --wait 60

### Installation via URL

#### Sandbox 

    https:/test.salesforce.com/packaging/installPackage.apexp?p0=<version Id>
    
#### Production 

Note: only promoted versions can be installed into a production org

    https:/login.salesforce.com/packaging/installPackage.apexp?p0=<version Id>
