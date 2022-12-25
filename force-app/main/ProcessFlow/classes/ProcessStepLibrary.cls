public virtual class ProcessStepLibrary {
  @TestVisible
  private Map<String, Type> processStepMap;
  
  public ProcessStepLibrary() {
    processStepMap = new Map<String, Type>();
  }
  
  public Set<String> getAllKeys() {
    return this.processStepMap.keySet();
  }
  
  public ProcessStepInterface getProcessStep(String processKey) {
    Type stepType = processStepMap.get(processKey);
    if (stepType == null) {
      return null;
    }
    return (ProcessStepInterface)stepType.newInstance();
  }
}
