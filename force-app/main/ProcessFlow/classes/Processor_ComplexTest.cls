@IsTest
public with sharing class Processor_ComplexTest {
  
  /**
  * 
  request for ChatGPT:
  
  create a test class for Processor. create seven child-classes implementing ProcessStepInterface. the execute method of every step must use Processor.LOG_STRING_PATTERN to enter it's name into the dto.logMessages. The Dependencies are as following:
  - process_1: -
  - process_2: -
  - process_3: process_7
  - process_4: process_1, process_2, process_3
  - process_5: process_4, process_6
  - process_6: process_1, process_4
  - process_7: -
  
  The Test should only request process_5 to be calculated. every dependency must be considered implicitly
  
  -------------
  
  Expected order of steps: 1, 2, 7, 3, 4, 6, 5
  
  -------------
  result was 'not correct'

  
  */

  //----------------------------
  // Manual Implementation
  //----------------------------
  
  @isTest
  static void testExecuteProcess() {
    /**
     * Description by ChatGPT:
     * 
     * The testExecuteProcess method is a test method for the Processor class. It creates an instance of the Processor class and an instance of the ProcessDto class. Then it calls the executeProcess method on the Processor instance, passing in the string "process_5" and the ProcessDto instance as arguments. The executeProcess method will create all required implementations of ProcessStepInterface and execute them in the correct order for the given process key.

     * After calling the executeProcess method, the test method checks the size of the logMessages list in the ProcessDto instance and then performs a series of assertions to check the order of the steps in the list. It checks that the correct start and end messages for each step are present in the list and that the steps are executed in the correct order.

     * Finally, the test method calls the System.debug method to log the logMessages list to the debug log and the System.assertEquals method to check that the size of the logMessages list is 21.
    */

    ProcessStepLibrary library = new ComplexTestLibrary();
    
    Processor processor = new Processor(library);
    ProcessDto dto = new ProcessDto();
    
    Test.startTest();
    processor.executeProcess('process_5', dto);
    Test.stopTest();
    
    List<String> logMessages = dto.logMessages;
    System.debug(System.LoggingLevel.Info, logMessages);
    System.assertEquals(21, logMessages.size());
    

    // check order of steps
    System.assert(logMessages[0].contains('start: process_1'));
    System.assert(logMessages[1].contains('ProcessStep1'));
    System.assert(logMessages[2].contains('end: process_1'));

    System.assert(logMessages[3].contains('start: process_2'));
    System.assert(logMessages[4].contains('ProcessStep2'));
    System.assert(logMessages[5].contains('end: process_2'));

    System.assert(logMessages[6].contains('start: process_7'));
    System.assert(logMessages[7].contains('ProcessStep7'));
    System.assert(logMessages[8].contains('end: process_7'));

    System.assert(logMessages[9].contains('start: process_3'));
    System.assert(logMessages[10].contains('ProcessStep3'));
    System.assert(logMessages[11].contains('end: process_3'));

    System.assert(logMessages[12].contains('start: process_4'));
    System.assert(logMessages[13].contains('ProcessStep4'));
    System.assert(logMessages[14].contains('end: process_4'));

    System.assert(logMessages[15].contains('start: process_6'));
    System.assert(logMessages[16].contains('ProcessStep6'));
    System.assert(logMessages[17].contains('end: process_6'));

    System.assert(logMessages[18].contains('start: process_5'));
    System.assert(logMessages[19].contains('ProcessStep5'));
    System.assert(logMessages[20].contains('end: process_5'));
  }
  
  
  public class ComplexTestLibrary extends ProcessStepLibrary {
    
    public ComplexTestLibrary() {
      super();
      this.processStepMap.put('process_1', ProcessStep1.class);
      this.processStepMap.put('process_2', ProcessStep2.class);
      this.processStepMap.put('process_3', ProcessStep3.class);
      this.processStepMap.put('process_4', ProcessStep4.class);
      this.processStepMap.put('process_5', ProcessStep5.class);
      this.processStepMap.put('process_6', ProcessStep6.class);
      this.processStepMap.put('process_7', ProcessStep7.class);
    }
  }
  
  public class ProcessStep1 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      dto.logMessages.add(
      Processor.LOG_STRING_PATTERN
      .replace('{datetime}', json.serialize(datetime.now()))
      .replace('{executingUnit}', 'ProcessStep1')
      .replace('{message}', 'processing ')
      );
    }
    
    public String getGeneratedProcessKey() {
      return 'process_1';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>();
    }
  }
  
  public class ProcessStep2 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      dto.logMessages.add(
      Processor.LOG_STRING_PATTERN
      .replace('{datetime}', json.serialize(datetime.now()))
      .replace('{executingUnit}', 'ProcessStep2')
      .replace('{message}', 'processing ')
      );
    }
    
    public String getGeneratedProcessKey() {
      return 'process_2';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>();
    }
  }
  
  public class ProcessStep3 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      dto.logMessages.add(
      Processor.LOG_STRING_PATTERN
      .replace('{datetime}', json.serialize(datetime.now()))
      .replace('{executingUnit}', 'ProcessStep3')
      .replace('{message}', 'processing ')
      );
    }
    
    public String getGeneratedProcessKey() {
      return 'process_3';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>{'process_7'};
    }
  }
  
  public class ProcessStep4 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      dto.logMessages.add(
      Processor.LOG_STRING_PATTERN
      .replace('{datetime}', json.serialize(datetime.now()))
      .replace('{executingUnit}', 'ProcessStep4')
      .replace('{message}', 'processing ')
      );
    }
    
    public String getGeneratedProcessKey() {
      return 'process_4';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>{'process_1', 'process_2', 'process_3'};
    }
  }
  
  public class ProcessStep5 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      dto.logMessages.add(
      Processor.LOG_STRING_PATTERN
      .replace('{datetime}', json.serialize(datetime.now()))
      .replace('{executingUnit}', 'ProcessStep5')
      .replace('{message}', 'processing ')
      );
    }
    
    public String getGeneratedProcessKey() {
      return 'process_5';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>{'process_4', 'process_6'};
    }
  }
  
  public class ProcessStep6 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      dto.logMessages.add(
      Processor.LOG_STRING_PATTERN
      .replace('{datetime}', json.serialize(datetime.now()))
      .replace('{executingUnit}', 'ProcessStep6')
      .replace('{message}', 'processing ')
      );
    }
    
    public String getGeneratedProcessKey() {
      return 'process_6';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>{'process_1', 'process_4'};
    }
  }
  
  public class ProcessStep7 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      dto.logMessages.add(
      Processor.LOG_STRING_PATTERN
      .replace('{datetime}', json.serialize(datetime.now()))
      .replace('{executingUnit}', 'ProcessStep7')
      .replace('{message}', 'processing ')
      );
    }
    
    public String getGeneratedProcessKey() {
      return 'process_7';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>();
    }
  }
  
  @IsTest
  static void complexDependenciesAreResolved(){
    ProcessStepLibrary library = new Processor_ComplexTest.ComplexTestLibrary();
    Processor.DependencyResolver resolver = new Processor.DependencyResolver(library);

    Test.startTest();
    Map<String, ProcessStepInterface> allDependencies = resolver.getAllDependencies('process_5');
    Test.stopTest();

    System.assertNotEquals(null, allDependencies);
  }

  @IsTest
  static void exceptionOnUndefinedProcessKey(){
    ProcessStepLibrary library = new Processor_ComplexTest.ComplexTestLibrary();
    Processor.DependencyResolver resolver = new Processor.DependencyResolver(library);
  
    try {
      Test.startTest();
      Map<String, ProcessStepInterface> allDependencies = resolver.getAllDependencies('process_8');
      Test.stopTest();

      System.assert(false, 'An exception is supposed to be thrown on an invalid key');
    } catch (Processor.DependencyResolverException exc) {
      System.assert(true);
    }
  }
}
