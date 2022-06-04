# MapUtility

## Purpose
This utility is designed releave developers from the repetitive and error-prone task of creating maps of objects. This is done over and over again with only slight changes. By generalized by providing a basic logic and ways to options to define certain criteria.

## Concept
Creating a map from a list of objects is always done by the same steps:

1. **Decide whether to keep**
    * a collection of items
    * only the first item
    * only the last item
2. Loop over the list
    * for each item
      * **read a 'mapping key'**
      * **evaluate the read value**
      * depending on which items to keep
        * simply put item into map for this 'mapping key' (keeps last item)
        * only insert into map if 'mapping key' ist not present yet (keeps first item)
        * add item to the collection for this 'mapping key' OR create a new collection for this 'mapping key' and add item

The three highlighted elements are the parts that are special for each map:
  * Decide 'how' to keep entries
    
    This is achieved via the enum `MAP_RETAIN_MODE`
  * Reading 'a value' form each entry 

    This is achieved via the interface `IValueReader`
  * 'Skip/add' each entry after evaluation

    This is achieved via the interface `MAP_OPTIONS`

## Use of the Map Util

### Call to the mapping method

    Map<String, Object> result = MapUtility_MappingMain.generateMapFromObjectList(
      List<Object> objects,
      IValueReader valueReader,
      MAP_RETAIN_MODE retainingMode,
      Set<MAP_OPTIONS> mapOptions,
      Set<String> keySet
    )
**Parameters**
* `objects`: List of objects to create the map of. This can be SObjects or Objects
* `valueReader`: the ValueReader **instance** to use for getting mapping keys for each entry in `objects`
* `retainingMode`: an enum value to specify which items to keep
* `mapOptions`: a Set of `MAP_OPTIONS` to define more key-specific behavior
* `keySet`: a Set of value to use for on `MAP_OPTIONS.KEY_INCLUDE_ONLY`

For further informations on use see in class `MapUtility_MappingMainTest`.

### How to keep entries: `Enum MAP_RETAIN_MODE`

There are three mutual exclusive ways to store data inside a map. Each of these ways is represented by a member of the enum `MAP_RETAIN_MODE`:

    public enum MAP_RETAIN_MODE {RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL}

* `RETAIN_FIRST`: specifies to keep the first item for a specific 'mapping key'
* `RETAIN_LAST`: specifies to keep the last item for a specific 'mapping key'
* `RETAIN_ALL`: specifies to keep the all items for a specific 'mapping key' in a collection for each one

#### Reading object keys: `IValueReader`

The complexity of reading the 'mapping key' of an object can variy from object to object. It can be as simple as reading the value of a certain sObjectField or it can be the the result of a function call based on multiple values.
But regardless of the way a 'mapping key' is read it is always the result of an action specific to an individual item. This abstraction is taken into account by the `IValueReader` interface:

    public interface IValueReader {
        Object getValue(Object objectToGetValueFrom);
    }

This simple interface provides the neccessary abstraction for a generic way to read a 'mapping key' from an object.

#### Behavior based on specific keys `Enum MAP_OPTIONS`

Sometimes a special behavior is required on specific 'mapping keys'. This can be defined by using specific values of the enum `MAP_OPTIONS`. These Options can be combined if required.

    public enum MAP_OPTIONS {KEY_IGNORE_NULL, KEY_INCLUDE_ONLY}

* `KEY_IGNORE_NULL`: option to ignore an item if `IValueReader.getValue` returns `NULL`
* `KEY_INCLUDE_ONLY`: option to only add an item to map if the result of `IValueReader.getValue` is in a predefined set

**_Note:_**
There is currently no option to _exclude_ specific keys. Yet there is a Workaround:
* set `MAP_OPTIONS.KEY_IGNORE_NULL`  
* define a custom `IValueReader` with `getValue` returning `NULL` on undesired keys

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

## Package versions
| Packagen | Version | Id| Promoted |
| --- | --- | --- | --- |
| Core | 1.0.0-2 | 04t2o000000yUVjAAM |yes |
| Core | 1.1.0-1 | 04t2o000000yUVyAAM |yes |
| Mapping | 1.0.0-2 | 04t2o000000yUVeAAM |yes| 
| Mapping | 1.1.0-2 | 04t2o000000yUW3AAM |no |

### installation order
 1. Core
 1. Mapping

### Installation via SFDX

    sfdx force:package:install --targetusername="<username> " --package="<version Id>" --wait 60

### Installation via URL

#### Sandbox 

    https:/test.salesforce.com/packaging/installPackage.apexp?p0=<version Id>
    
#### Production 

Note: only promoted versions can be installed into a production org

    https:/login.salesforce.com/packaging/installPackage.apexp?p0=<version Id>
