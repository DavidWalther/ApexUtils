@isTest
private class ProcessorTest {
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
        return 'process_step_1';
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
        return 'process_step_2';
      }
      
      public Set<String> getRequiredProcessKeys() {
        return new Set<String>{'process_step_1'};
      }
    }


  @isTest
  static void testExecuteProcess() {
    ProcessStepLibrary library = new ProcessStepLibrary();
    library.processStepMap.put('process_step_1', ProcessStep1.class);
    library.processStepMap.put('process_step_2', ProcessStep2.class);

    Processor processor = new Processor(library);
    ProcessDto dto = new ProcessDto();

    Test.startTest();
    processor.executeProcess('process_key_2', dto);
    Test.stopTest();


    // Verify that the steps were executed in the correct order
    List<String> logMessages = dto.logMessages;
    System.assertEquals(6, logMessages.size());

    System.assert(logMessages[0].contains('Prozessor'));
    System.assert(logMessages[0].contains('start: process_step_1'));
    
    System.assert(logMessages[1].contains('ProcessStep1'));
    System.assert(logMessages[1].contains('processing'));
    
    System.assert(logMessages[2].contains('Prozessor'));
    System.assert(logMessages[2].contains('end: process_step_1'));
    

    System.assert(logMessages[3].contains('Prozessor'));
    System.assert(logMessages[3].contains('start: process_step_2'));
    
    System.assert(logMessages[4].contains('ProcessStep2'));
    System.assert(logMessages[4].contains('processing'));
    
    System.assert(logMessages[5].contains('Prozessor'));
    System.assert(logMessages[5].contains('end: process_step_2'));
  }
}
