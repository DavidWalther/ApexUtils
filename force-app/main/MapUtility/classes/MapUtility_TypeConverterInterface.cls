/**
 * Directly casting Objects into SObjects or lists of SObjects causes exceptions.
 * For that reason a special casting logic is needed for these cases
 */
public interface MapUtility_TypeConverterInterface {
    Map<Object, Object> convertMappingResult(Map<Object, Object> tempMap);
}