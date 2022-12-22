# Purpose
This Utility is meant to provide a way to make spliting logic easier. All information calculated is stored in a unit of work which will be passed along from step to step. 

**it will be generated with ChatGPT**

# Code generation
## ProcessDto

Every complex APEX logic must be split into multiple small stateless steps. Each of those steps only recieves an instance of ProcessDto as input and executes it's logic in place. It must contain a map from String to Object to store process data. Also it must contain a list of strings for log messages.

## ProcessStepInterface

Every step must implement the interface ProcessStepInterface. It must contain
  - a method execute(ProcessDto dto) to execute small business logic and modify accordingly.
  - a method getGeneratedProcessKey() to return the key the step is named with
  - a method getRequiredProcessKeys() to return a Set of keys that are required for the step

## ProcessStepLibrary

There must be a class ProcessStepLibrary which has a method getProcessStep(String processKey) which returns an instance of ProcessStepInterface for the given key. The mapping must be stored in a private map from string to System.Type

## Processor

A Processor class must have a method executeProcess(String processKey, Object record). Using the library it must create all required implementations of ProcessStepInterface. The same must be done for all dependencies. After creating all required steps an instance of the dto class must be created and all steps must be executed in the correct order.

## Controller

A Controller class must identify changes of SObject record from oldRecord to newRecord and call the processor class accordingly using the new record

