//----------------------------
// Have a rollback by default
//----------------------------

Boolean DO_ROLLBACK = true;

System.debug('Execute Anonymous');
System.debug('---- Do rollback: ' + DO_ROLLBACK + ' ----');

System.SavePoint sp;
if(DO_ROLLBACK) {
  System.debug('---- setSavePoint Start ----');
  sp = Database.setSavePoint();
  System.debug('---- setSavePoint End ----');
}

System.debug('---- Execute Start ----');
new ExecutionHandler().execute();
System.debug('---- Execute End ----');

if(DO_ROLLBACK) {
  System.debug('---- rollback Start ----');
  Database.rollback(sp);
  System.debug('---- rollback End ----');
}

//----------------------------
// Logic
//----------------------------

public class ExecutionHandler_Exception extends System.Exception{}

public class ExecutionHandler {

  public ExecutionHandler execute() {
    return this;
  }
}
