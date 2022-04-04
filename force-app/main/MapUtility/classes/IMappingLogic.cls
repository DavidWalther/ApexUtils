
public interface IMappingLogic {
    Object execute(List<Object> objects, IValueReader valueReader, Set<MAP_OPTIONS> mapOptions, Set<String> keySet);
}