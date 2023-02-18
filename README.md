# ApexUtils

In this repository I'm storing ideas in development and Snippets for later use.


1. [MapUtility](https://github.com/DavidWalther/ApexUtils/tree/master/force-app/main/MapUtility)

    * Let's 'user' define criteria and then handles the building.
    * Can map 'anything by everything'

1. [ProcessFlow](https://github.com/DavidWalther/ApexUtils/tree/master/force-app/main/ProcessFlow) *(might be renamed)*
    
    * Works with stateless, reusable and interdependent steps of logic.
    * Uses a DTO for comunication between steps.
    * Figures out the order of steps by it's self. (Especially useful for comlex dependencies)
    * Provides log of executed steps.

1. ApexContext *(will be removed / become a part of 'ProcessFlow')*

      * A prebuild DTO class with build-in 'commit' (DML at the end)


1. DataContainer

     * helps to keep the queries inside a test class non-repetetive
     * helps to compare multiple set of data returned by the same queries. Like before and after an action under test.

1. Query Counter *(will be removed)*
1. GenericRecordBuilder
1. SelectorFactory & Selector Base
1. MockBase
