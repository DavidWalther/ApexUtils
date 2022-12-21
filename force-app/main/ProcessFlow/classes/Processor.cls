public class Processor {
  public final static String LOG_STRING_PATTERN = '[{datetime}] | {executingUnit} | {message}';

  private ProcessStepLibrary library;

  public Processor(ProcessStepLibrary library) {
    this.library = library;
  }
 
  public void executeProcess(String processKey, ProcessDto dto) {
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
  
    // Execute all steps in the correct order
    for (ProcessStepInterface s : steps.values()) {
      dto.logMessages.add(
        LOG_STRING_PATTERN
          .replace('{datetime}', json.serialize(datetime.now()))
          .replace('{executingUnit}', 'Processor')
          .replace('{message}', 'start: ' + s.getGeneratedProcessKey())
      );
  
      s.execute(dto);
  
      dto.logMessages.add(
        LOG_STRING_PATTERN
          .replace('{datetime}', json.serialize(datetime.now()))
          .replace('{executingUnit}', 'Processor')
          .replace('{message}', 'end: ' + s.getGeneratedProcessKey())
      );
    }
  }
}
  
