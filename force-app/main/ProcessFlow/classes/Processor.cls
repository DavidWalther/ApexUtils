public class Processor {
  public final static String LOG_STRING_PATTERN = '[{datetime}] | {executingUnit} | {message}';

  private ProcessStepLibrary library;

  public Processor(ProcessStepLibrary library) {
    this.library = library;
  }

  public ProcessDto executeProcess(String processKey, Object record) {
    ProcessDto dto = new ProcessDto();
    dto.processData.put('record', record);
    return executeProcess(processKey, dto);
  }
 
  public ProcessDto executeProcess(String processKey, ProcessDto dto) {
    Set<String> processedKeys = new Set<String>();
    Map<String, ProcessStepInterface> steps = new Map<String, ProcessStepInterface>();

    // Create all required process steps and add them to the steps map
    ProcessStepInterface step = library.getProcessStep(processKey);
    while (step != null) {
      steps.put(step.getGeneratedProcessKey(), step);
      processedKeys.add(step.getGeneratedProcessKey());
      for (String requiredKey : step.getRequiredProcessKeys()) {
        if (!processedKeys.contains(requiredKey)) {
          step = library.getProcessStep(requiredKey);
          break;
        }
      }
      step = null;
    }

    // Execute all steps in the correct order
    for (ProcessStepInterface s : steps.values()) {
      dto.logMessages.add(
        LOG_STRING_PATTERN
          .replace('{datetime}', json.serialize(datetime.now()))
          .replace('{executingUnit}', 'Prozessor')
          .replace('{message}', 'start: ' + s.getGeneratedProcessKey())
      );

      s.execute(dto);

      dto.logMessages.add(
        LOG_STRING_PATTERN
          .replace('{datetime}', json.serialize(datetime.now()))
          .replace('{executingUnit}', 'Prozessor')
          .replace('{message}', 'end: ' + s.getGeneratedProcessKey())
      );
    }

    return dto;
  }
}
  