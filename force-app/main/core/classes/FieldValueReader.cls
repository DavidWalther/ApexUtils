public with sharing virtual class FieldValueReader implements IValueReader {
  private SObjectField field;

  public FieldValueReader(SObjectField field) {
    this.field = field;
  }

  public String getValue(Object objectToGetValueFrom) {
    SObject recordToRead = (SObject)objectToGetValueFrom;
    return String.valueOf(recordToRead.get(String.valueOf(field)));
  }
}