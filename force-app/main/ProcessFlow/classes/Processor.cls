public class Processor {
  public final static String LOG_STRING_PATTERN = '[{datetime}] | {executingUnit} | {message}';

  private ProcessStepLibrary library;

  public Processor(ProcessStepLibrary library) {
    this.library = library;
  }
 
  public void executeProcess(String processKey, ProcessDto dto) {
    Map<String, ProcessStepInterface> steps = getAllDependencies(processKey);
    executeAllDependencies(steps, dto);
  }
  
  private Map<String, ProcessStepInterface> getAllDependencies(String processKey) {
    Set<String> processedKeys = new Set<String>();
    Map<String, ProcessStepInterface> steps = new Map<String, ProcessStepInterface>();
  
    // Create all required process steps and add them to the steps map
    Set<String> keysToProcess = new Set<String> { processKey };
    while (!keysToProcess.isEmpty()) {
      Set<String> newKeysToProcess = new Set<String>();
      for (String key : keysToProcess) {
        ProcessStepInterface step = library.getProcessStep(key);
        if (step != null && !steps.containsKey(key)) {
          steps.put(key, step);
          processedKeys.add(key);
          for (String requiredKey : step.getRequiredProcessKeys()) {
            if (!processedKeys.contains(requiredKey)) {
              newKeysToProcess.add(requiredKey);
            }
          }
        }
      }
      keysToProcess = newKeysToProcess;
    }
    
    return steps;
  }
  
  private void executeAllDependencies(Map<String, ProcessStepInterface> steps, ProcessDto dto) {
    Set<String> processedKeys = new Set<String>();
  
    // Execute all steps in the correct order
    while (!steps.isEmpty()) {
      Set<String> keysToRemove = new Set<String>();
      for (String key : steps.keySet()) {
        ProcessStepInterface step = steps.get(key);
        Set<String> requiredKeys = step.getRequiredProcessKeys();
        if (requiredKeys.isEmpty() || requiredKeys.removeAll(processedKeys).isEmpty()) {
          dto.logMessages.add(
            LOG_STRING_PATTERN
              .replace('{datetime}', json.serialize(datetime.now()))
              .replace('{executingUnit}', 'Processor')
              .replace('{message}', 'start: ' + step.getGeneratedProcessKey())
          );
  
          step.execute(dto);
  
          dto.logMessages.add(
            LOG_STRING_PATTERN
              .replace('{datetime}', json.serialize(datetime.now()))
              .replace('{executingUnit}', 'Processor')
              .replace('{message}', 'end: ' + step.getGeneratedProcessKey())
          );
  
          processedKeys.add(key);
          keysToRemove.add(key);
        }
      }
      steps.keySet().removeAll(keysToRemove);
    }
  }  
}
  