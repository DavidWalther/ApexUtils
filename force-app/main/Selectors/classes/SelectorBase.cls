public abstract with sharing class SelectorBase {
    public final static String BASE_QUERY = 'SELECT {0} FROM {1}';

//----------------------------
// abstracts
//----------------------------

    public abstract List<Schema.SObjectField> getFieldList();

    public abstract Schema.SObjectType getSObjectType();

//----------------------------
// publics
//----------------------------

    public List<String> getFieldNames() {
        List<String> result = new List<String>();
        for(Schema.SObjectField fieldToken : this.getFieldList()) {
            result.add(fieldToken.getDescribe().getName());
        }
        return result;
    }

    public String getFieldsString() {
        return String.join(this.getFieldNames(), ', ');
    }


    public String getObjectName() {
        return this.getSObjectType().getDescribe().getName();
    }

    public String getSimpleQuery() {
        String fieldsString = this.getFieldsString();
        String objectName = this.getObjectName();

        return BASE_QUERY.replace('{0}', fieldsString).replace('{1}', objectName);
    }

    public String getSimpleQuery(final Set<String> fields) {
        return getSimpleQuery(new List<String>(fields));
    }

    public String getSimpleQuery(final List<String> fields) {
        String fieldsString = String.join(fields, ', ');
        String objectName = this.getObjectName();
        return BASE_QUERY.replace('{0}', fieldsString).replace('{1}', objectName);
    }

   
}
