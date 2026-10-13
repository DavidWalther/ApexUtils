# ErrorLogger

Strukturierte Protokollierung von Exceptions als `ErrorLog__c`-Datensätze – nutzbar aus Apex und Flows.

## Schnellstart

```apex
try {
    // Business-Logik
} catch(Exception exc) {
    ErrorLog__c log = ErrorLogService.createErrorLog(exc);
    insert log;
}
```

> **Wichtig:** `createErrorLog` erstellt nur den Record – der Insert liegt beim Aufrufer.

### Mit Kategorie

```apex
ErrorLog__c log = ErrorLogService.createErrorLog(exc, 'API');
insert log;
```

Kategorien sind frei wählbare Strings zur Gruppierung (z.B. `'API'`, `'Batch'`, `'Trigger'`).

## Flow-Integration (ErrorLogInvocable)

Die Invocable-Action **Create Error Log** ermöglicht es, Fehler direkt aus Flows zu protokollieren. Im Gegensatz zum Apex-Aufruf übernimmt die Action den Insert selbst.

### Parameter

| Parameter             | Beschreibung                                      |
|-----------------------|---------------------------------------------------|
| `Flow Name`           | Name des Flows, in dem der Fehler aufgetreten ist |
| `Message`             | Einfache Fehlermeldung                            |
| `Message List`        | Liste von Nachrichten (werden zeilenweise gespeichert) |
| `Record ID`           | ID des betroffenen Datensatzes                    |
| `Exception Category`  | Kategorie (Standard: `FLOW`)                      |

## REST-Kontext

Wird `createErrorLog` innerhalb eines REST-Kontexts aufgerufen, werden automatisch erfasst:

- Request-URI
- URL-Parameter
- Request-Body

Außerhalb eines REST-Kontexts bleiben diese Felder `null`.

## Duplikat-Behandlung

Dieselbe Exception wird pro Transaktion nur einmal geloggt (Erkennung über Hash aus TypeName + StackTrace). Bei einem Duplikat gibt `createErrorLog` `null` zurück:

```apex
ErrorLog__c log = ErrorLogService.createErrorLog(exc);
if(log != null) {
    insert log;
}
```

## Anpassung: Eigene LogReader

Jeder `LogReader` implementiert `execute(ErrorLogBuilder builder)` und bestimmt selbst, welche Felder er am Builder setzt.

### Generische API

Für volle Kontrolle kann ein eigenes Set von `LogReader`-Implementierungen übergeben werden:

```apex
Set<ErrorLogService.LogReader> readers = new Set<ErrorLogService.LogReader>();
readers.add(new MyCustomReader());
readers.add(new ErrorLogService.CategoryReader().setCategory('Custom'));

ErrorLog__c log = ErrorLogService.createErrorLog(readers);
insert log;
```

### Request-Body vorverarbeiten

Sensible Daten entfernen oder Payload kürzen durch Erweitern des `DefaultRestContextReader`:

```apex
public class SanitizedRestReader extends ErrorLogService.DefaultRestContextReader {
    public override String getRestRequestBody() {
        String body = super.getRestRequestBody();
        if(body == null) return null;

        Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(body);
        parsed.remove('password');
        return JSON.serialize(parsed);
    }
}
```

Aufruf:

```apex
ErrorLog__c log = ErrorLogService.createErrorLog(
    exc,
    new ErrorLogService.DefaultExceptionReader(),
    new SanitizedRestReader(),
    'API'
);
```

### Verfügbare Builder-Methoden

| Builder-Methode             | Feld am ErrorLog__c               |
|-----------------------------|-----------------------------------|
| `setExceptionType`          | `ExceptionType__c`                |
| `setExceptionCategory`      | `ExceptionCategory__c`            |
| `setExceptionMessage`       | `ExceptionMessage__c`             |
| `setStacktraceString`       | `ExceptionStacktraceString__c`    |
| `setRequestUrl`             | `RequestUrl__c`                   |
| `setRequestUrlParameters`   | `UrlParameters__c`                |
| `setJsonRequest`            | `JsonRequest__c`                  |
| `setMessage`                | `Message__c`                      |
| `setMessageList`            | `MessageList__c`                  |
| `setRecordId`               | `RecordId__c`                     |
| `setFlowName`               | `FlowName__c`                     |
| `setFlowFaultMessage`       | `FlowFaultMessage__c`             |

## Automatische Löschung

`ErrorLogDeleteBatch` löscht Logs die älter als 30 Tage sind. Die Checkbox `KeepLog__c` verhindert die Löschung einzelner Einträge.

### Batch schedulen

```apex
System.schedule('ErrorLog Cleanup', '0 0 2 * * ?', new ErrorLogDeleteBatch());
```

## Berechtigungen

Das PermissionSet **ErrorLogs_Read** gewährt Lesezugriff auf `ErrorLog__c` und seine Felder.

## Paketinhalt

- `ErrorLogService` – Service zur Erstellung von Log-Records
- `ErrorLogDeleteBatch` – Schedulable Batch zur automatischen Löschung
- `ErrorLog__c` – Custom Object mit Feldern für Exception-Daten und REST-Kontext
- `ErrorLogs_Read` – PermissionSet für Lesezugriff
