/**
 * This interface is used to have a generic reader for SObject, classes or primitives
 */
public interface IValueReader {
    String getValue(Object objectToGetValueFrom);
}