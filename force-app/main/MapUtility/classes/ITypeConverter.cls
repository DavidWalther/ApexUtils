/**
 * Directly casting Objects into SObjects or lists of SObjects causes exceptions.
 * For that reason a special casting logic is needed for these cases
 */
public interface ITypeConverter {
    Map<String, Object> convertMappingResult(Map<String, Object> tempMap);
}