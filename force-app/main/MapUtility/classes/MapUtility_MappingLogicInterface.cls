
public interface MapUtility_MappingLogicInterface {
    Object execute(List<Object> objects, IValueReader valueReader, List<MapUtility_ValidKeyInterface> keyEvaluators);
    
    // Depricated
    Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<Object> keySet);
}