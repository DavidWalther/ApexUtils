# ApexUtils

In this repository I'm storing ideas in development and Snippets for later use.

1. ApexContext
2. DataContainer
3. GenericRecordBuilder
4. MockBase
5. Query Counter
6. SelectorFactory & Selector Base
7. [MapUtility](https://github.com/DavidWalther/ApexUtils/tree/master/force-app/main/MapUtility)

## Query Counter

This one is used for simple counting. Add a call to it at the beginning of a method and print the result in the end of the context. Voila you get the count how often each method is called.

## ApexContext

This one is as simple as it is mind blowing. Imagine having all your context data and variable at hand, always and everywhere without passing them. And as a small bonus you also get the known lists 'it

### Why would you share data all over?

Several reasons:
1. You can build your bussiness logic stateless.
2. You can set design data for automatic test as you please
3. If Something goes wrong you have every piece of data in a singe place.
