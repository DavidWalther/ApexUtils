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
  
  
  result was 'not correct'
  
  */
  
  
  
  //----------------------------
  // Manual Implementation
  //----------------------------
  
  @isTest
  static void testExecuteProcess() {
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
    System.assert(logMessages[1].contains('ProcessStep1'));
    System.assert(logMessages[1].contains('processing'));

    System.assert(logMessages[4].contains('ProcessStep2'));
    System.assert(logMessages[4].contains('processing'));

    System.assert(logMessages[7].contains('ProcessStep7'));
    System.assert(logMessages[7].contains('processing'));
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
  
}
