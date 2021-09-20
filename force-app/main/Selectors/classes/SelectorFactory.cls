public without sharing class SelectorFactory {

    private static final Map<String, System.Type> SELECTOR_TYPES = new Map<String, System.Type>{
        // add mapping of SelectorBase-childern mapped by SObjectTypenames
        // e.g.
        // 'Account' => AccountSelector.class,
        // 'Contact' => ContactSelector.class
        //
    };

    @TestVisible
    private static Map<Schema.SObjectType, Object> selectorInstances = new Map<Schema.SObjectType, Object>{};

    /**
     * This method streamlines the access to the selector map.
     * It creates instances for selectors which are not created yet.
     */
    public static Object getSelector(Schema.SObjectType type) {
        Object selector = selectorInstances.get(type);

        // Look for existing Selectors
        if( selector == NULL ) {
            String objectName = type.getDescribe().getName();
            System.Type typeForNewInstance= SELECTOR_TYPES.get(objectName);

            selector = typeForNewInstance.newInstance();
            selectorInstances.put(type, selector);
        }

        return selector;
    }
}