# DataContainerBase

## What is a DataContainer?
A Datacontainer is designed an utility for apex tests. It helps by keeping all queried records inside a single variable. This way multiple states of all data can be stored in a simple way.

This enables keeping multiple sets of data of 

In gerneral a test is set up in mutiple three steps 
1. Write test data to database
2. Retrieve inserted data 
3. Execute logic to test
4. Checking changes made to database



A DataContainer can help in step 2 and 4 
