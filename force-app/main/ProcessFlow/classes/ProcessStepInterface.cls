public interface ProcessStepInterface {
  void execute(ProcessDto dto);
  String getGeneratedProcessKey();
  Set<String> getRequiredProcessKeys();
}