public class ProcessDto {
  public Map<String, Object> processData;
  public List<String> logMessages;

  public ProcessDto() {
    this.processData = new Map<String, Object>();
    this.logMessages = new List<String>();
  }
}