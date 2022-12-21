@isTest
private class ProcessStepLibraryTest {
  public class ProcessStep1 implements ProcessStepInterface {
    public void execute(ProcessDto dto) {
      // Perform processing using data in dto.processData
      // Update dto.processData and dto.logMessages as needed
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
      // Perform processing using data in dto.processData
      // Update dto.processData and dto.logMessages as needed
    }
    
    public String getGeneratedProcessKey() {
      return 'process_step_2';
    }
    
    public Set<String> getRequiredProcessKeys() {
      return new Set<String>{'process_step_1'};
    }
  }
  
  
  @isTest
  static void testGetProcessStep() {
    ProcessStepLibrary library = new ProcessStepLibrary();
    library.processStepMap.put('process_step_1', ProcessStep1.class);
    library.processStepMap.put('process_step_2', ProcessStep2.class);
    
    Test.startTest();
    ProcessStepInterface step1 = library.getProcessStep('process_step_1');
    ProcessStepInterface step2 = library.getProcessStep('process_step_2');
    ProcessStepInterface step3 = library.getProcessStep('invalid_key');
    Test.stopTest();
    
    System.assertNotEquals(null, step1);
    System.assertEquals('process_step_1', step1.getGeneratedProcessKey());
    
    System.assertNotEquals(null, step2);
    System.assertEquals('process_step_2', step2.getGeneratedProcessKey());
    
    System.assertEquals(null, step3);
  }
}
