/**
 * <p>This class is the starting point of Mocking. It's implementing the System.StubProvider interface of Salesforce and provides a logging of method calls.</p>
 *
 * @author David Walther
 */
public abstract with sharing class MockBase implements System.StubProvider {

  /**
   * implement this method in MockBase child classes.
   */
  public abstract Object processMethodCall(MethodCall methodCall);

  private List<MethodCall> methodCallLog = new List<MethodCall>();

  /**
   * <p>Implementation of System.StubProvider interface</p>
   *
   * @author David Walther
   */
  public Object handleMethodCall(Object stubbedObject, String stubbedMethodName,
    Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames,
    List<Object> listOfArgs) {

    MethodCall methodCall = new MethodCall(stubbedObject, stubbedMethodName, returnType, listOfParamTypes, listOfParamNames, listOfArgs);
    this.addMethodCall(methodCall);
    return processMethodCall(methodCall);
  }

  /**
   * <p>Provides a clone of the internal call log.</p>
   *
   * @author David Walther
   */
  public virtual List<MethodCall> getMethodCallLogList() {
    return this.getMethodCallLog().clone();
  }

  /**
   * <p>Provides a map which maps MethodCallLogs by their stored stubbedMethodName</p>
   *
   * @author David Walther
   */
  public virtual Map<String, List<MethodCall>> getMethodCallLogsByName() {
    Map<String, List<MethodCall>> result = new Map<String, List<MethodCall>>();
    for(MethodCall methodCallLog : this.methodCallLog) {
      String methodName = methodCallLog.stubbedMethodName;
      List<MethodCall> mappedCalls = result.get(methodName);
      if(mappedCalls == null) {
        mappedCalls = new List<MethodCall>();
        result.put(methodName, mappedCalls);
      }
      mappedCalls.add(methodCallLog);
    }
    return result;
  }

  private List<MethodCall> getMethodCallLog() {
    return this.methodCallLog;
  }

  private void addMethodCall(MethodCall callLog) {
    this.methodCallLog.add(callLog);
  }

  /**
   * <p>This class wraps all parameters of a single System.StubProvider.handleMethodCall call into one instance. This creates en easy way of logging and passing method calls. All it's attributes are public but not changable.</p>
   *
   * @author David Walther
   */
  public class MethodCall {
    public final Object stubbedObject;
    public final String stubbedMethodName;
    public final Type returnType;
    private final List<Type> listOfParamTypes;
    private final List<String> listOfParamNames;
    private final List<Object> listOfArgs;

    // use this map for checking parameter values
    public final Map<String, MethodParameter> parameters = new Map<String, MethodParameter>();

    private MethodCall(Object stubbedObject, String stubbedMethodName,
      Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames,
      List<Object> listOfArgs) {
      this.stubbedObject = stubbedObject;
      this.stubbedMethodName = stubbedMethodName;
      this.returnType = returnType;
      this.listOfParamTypes = listOfParamTypes;
      this.listOfParamNames = listOfParamNames;
      this.listOfArgs = listOfArgs;

      for(Integer i = 0; i < listOfParamNames.size() ; i++) {
        MethodParameter parameter = new MethodParameter(listOfParamTypes[i], listOfParamNames[i], listOfArgs[i]);
        parameters.put(parameter.paramName, parameter);
      }
    }
  }

  /**
   * <p>This class bundels the type, name and value of a single parameter into a single instance. All it's attributes are public but not changable.</p>
   *
   * @author David Walther
   */
  public class MethodParameter {
    public final String paramName = null;
    public final Object paramValue = null;
    public final Type paramType = null;

    private MethodParameter(Type paramType, String paramName, Object paramValue) {
      this.paramType = paramType;
      this.paramName = paramName;
      this.paramValue = paramValue;
    }
  }
}
