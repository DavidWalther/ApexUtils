public class Processor {
  public final static String LOG_STRING_PATTERN = '[{datetime}] | {executingUnit} | {message}';

  private ProcessStepLibrary library;

  public Processor(ProcessStepLibrary library) {
    this.library = library;
  }
 
  public void executeProcess(String processKey, ProcessDto dto) {
    Map<String, ProcessStepInterface> steps = getAllDependencies(processKey);

    (new Executor(steps, dto)).execute(processKey);
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
  
  public class ExecutorException extends Exception {
    public ProcessDto dto;
    public ExecutorException(ProcessDto dto) {
      this.dto = dto;
    }
  }

  public class Executor {
    private Map<String, ProcessStepInterface> steps;
    private Set<String> processedSteps;
    private ProcessDto dto;
  
    public Executor(Map<String, ProcessStepInterface> steps, ProcessDto dto) {
      this.steps = steps;
      this.dto = dto;
      this.processedSteps = new Set<String>();
    }
  
    public void execute(String stepToExecute) {
      ProcessStepInterface stepInstance = this.steps.get(stepToExecute);
      if(stepInstance == NULL) {
        this.dto.logMessages.add(
          LOG_STRING_PATTERN
            .replace('{datetime}', json.serialize(datetime.now()))
            .replace('{executingUnit}', 'Executor')
            .replace('{message}', 'No instance defined for ' + step.getGeneratedProcessKey())
        );
        throw new ExecutorException(this.dto);
      }

      // Don't execute a step twice
      if(this.processedSteps.contains(stepToExecute)) {
        return;
      }
      
      // Execute if all dependencies were executed
      Set<String> requiredKeys = stepInstance.getRequiredProcessKeys();
      for(String requiredStepKey : requiredKeys) {
        // this is where recursion happens
        this.execute(requiredStepKey);
      }
      
      // after all required keys are executed also execute the requested one
      this.executeStep(stepInstance);
    }

    private void executeStep(ProcessStepInterface step) {
      this.dto.logMessages.add(
        LOG_STRING_PATTERN
          .replace('{datetime}', json.serialize(datetime.now()))
          .replace('{executingUnit}', 'Prozessor')
          .replace('{message}', 'start: ' + step.getGeneratedProcessKey())
      );

      step.execute(this.dto);
      this.processedSteps.add(step.getGeneratedProcessKey());

      this.dto.logMessages.add(
        LOG_STRING_PATTERN
          .replace('{datetime}', json.serialize(datetime.now()))
          .replace('{executingUnit}', 'Prozessor')
          .replace('{message}', 'end: ' + step.getGeneratedProcessKey())
      );
    }
  }
}
  