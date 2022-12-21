public class ProcessStepLibrary {
  private Map<String, Type> processStepMap;
  
  public ProcessStepLibrary() {
    processStepMap = new Map<String, Type>{
      'process_step_1' => ProcessStep1.class,
      'process_step_2' => ProcessStep2.class
    };
  }
  
  public ProcessStepInterface getProcessStep(String processKey) {
    Type stepType = processStepMap.get(processKey);
    if (stepType == null) {
      return null;
    }
    return (ProcessStepInterface)stepType.newInstance();
  }
}
