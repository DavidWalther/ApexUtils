# MapUtility
## Purpose
This utility is designed releave developers from the repetitive and error-prone task of creating maps of objects. This is done by generalized logic of how to build a map and which accepts parameters for tailoring the right way of mapping.

## Concept
Creating a map based on a list of objects is always done by the same steps:

* Decide whether to keep
  * a collection of items
  * only the first item
  * only the last item
* Loop over the list
* for each item
  * read a 'mapping key'
  * depending on which items to keep
    * simply put item into map for this mapping key (keeps last item)
    * only insert into map if mapping key ist not present yet (keeps first item)
    * add item to the collection / create a new collection for this mapping key

This reduces mapping of objects down to two core questions on how to map items. Also there is a third one on how to act an certain keys:
1. Which items of my list I want to retain?
2. What is the key i want to map my items by?
3. What should i do on key 'XYZ'?

### 1. Different ways to retain objects

Enter the Enum `MAP_RETAIN_MODE`

    public enum MAP_RETAIN_MODE {RETAIN_FIRST, RETAIN_LAST, RETAIN_ALL}

### 2. Reading object keys

Enter the Interfact `IValueReader`

    public interface IValueReader {
        String getValue(Object objectToGetValueFrom);
    }

This interface is an abstract way of accessing a certain attribute of a given object.  Here are two different Examples:

Reading a certain field of an sObject:

    
### Behavior based on specific keys
