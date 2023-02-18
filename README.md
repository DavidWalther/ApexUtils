# ApexUtils

In this repository I'm storing ideas in development and Snippets for later use.

1. ApexContext
1. DataContainer
1. GenericRecordBuilder
1. MockBase
1. Query Counter
1. SelectorFactory & Selector Base
1. [MapUtility](https://github.com/DavidWalther/ApexUtils/tree/master/force-app/main/MapUtility)

    * Let's 'user' define criteria and then handles the building.
    * Can map 'anything by everything'

1. [ProcessFlow](https://github.com/DavidWalther/ApexUtils/tree/master/force-app/main/ProcessFlow) *might by renamed*
    
    * Works with stateless logic and a DTO 
    * Figures out the order by it's self


## Query Counter

This one is used for simple counting. Add a call to it at the beginning of a method and print the result in the end of the context. Voila you get the count how often each method is called.

## ApexContext

This one is as simple as it is mind blowing. Imagine having all your context data and variable at hand, always and everywhere without passing them. And as a small bonus you also get the known lists 'it

### Why would you share data all over?

Several reasons:
1. You can build your bussiness logic stateless.
2. You can set design data for automatic test as you please
3. If Something goes wrong you have every piece of data in a singe place.
