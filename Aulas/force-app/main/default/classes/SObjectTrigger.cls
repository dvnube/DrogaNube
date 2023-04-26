/**
 * A trigger framework which used by most trigger in this package.
 * It has 2 purposes
 * 1 Figure out which records should be processed when a list (or a single) record is passed
 * 2 Creates a batch runnable interface, which is mainly when a newly created trigges should be process
 *   already existing records
 *
 * It implements the TriggerHandler.IHandlerInterface interface, so it should be used in together with the
 * TriggerHandler class. The children classes of this class are all TriggerHandler runnable (as they inherit the interface)
 *
 * See for examples getIsToProcess() and executeTrigger() methods.
 */
public abstract with sharing class SObjectTrigger implements TriggerHandler.IHandlerInterface {
    protected TriggerHandlerControl__mdt settings = TriggerHandlerControl__mdt.getInstance(getRunningClassName());
    protected Boolean disableTriggerSettings {
        get {
            return settings != null ? settings.Disable__c : false;
        }
        set;
    }
    public abstract String getRunningClassName();
    
    public SObjectTrigger() {}

    /**
     * This is a set for the already processed records per trigger class instance, in this execution context.
     */
    private static Map<System.Type, Set<Id>> processedRecords = new Map<System.Type, Set<Id>>();

    /*
     * This might be a solution for re-evaluating triggers after an executed workflow rule.
     */
    public Boolean runOnlyOncePerRecord = false;

    /**
     * This method validates every record on the list which are processed by the currently running trigger.
     * If it returns 'true', the given record will be processed. Otherwise not.
     * If you want to process EVERY record regardless any other logic, simple return 'true'
     * @param oldRecord The state of the old version of the object. On insert events it is always an empty SObject, on delete context it is the object value before deleting. On update it is before the update value.
     * @param newRecord The state of the new version of the record. On insert events it is the value of the record, on update it is the updated version. On delete events it has no value (empty SObject).
     */
    public virtual Boolean getIsToProcess(SObject oldRecord, SObject newRecord) {
        return true;
    }

    /**
     * This method is called automatically by the handle() method which is called by the TriggerHandler class
     * @param sObjectList List of objects in the trigger context, filtered by getIsToProcess() method
     */
    public abstract void executeTrigger(SObject[] sObjectList);

    /**
     * This is the implementation of the handle() method on IHandlerInterface interface
     * If your trigger handler classes are children of SObjectTrigger, you don't need to create this class,
     * as they inherit it.
     */
    public void handle(Schema.SObjectType sObjectType) {
        Type triggerName = Type.forName(String.valueOf(this).split(':')[0]);
        if (!processedRecords.containsKey(triggerName)) {
            processedRecords.put(triggerName, new Set<Id>());
        }

        SObject[] toProcess = new List<SObject>{};
        if (Trigger.isInsert) {
            for (SObject rec : Trigger.new) {
                if (getIsToProcess(SObjectType.newSObject(), rec)) {
                    if (!processedRecords.get(triggerName).contains(rec.Id)) {
                        toProcess.add(rec);
                    }
                }
            }
        } else if (Trigger.isUpdate) {
            for (SObject rec : Trigger.new) {
                if (getIsToProcess(Trigger.oldMap.get(rec.Id), rec)) {
                    if (!processedRecords.get(triggerName).contains(rec.Id)) {
                        toProcess.add(rec);
                    }
                }
            }
        } else if (Trigger.isDelete) {
            for (SObject rec : Trigger.old) {
                if (getIsToProcess(rec, SObjectType.newSObject())) {
                    if (!processedRecords.get(triggerName).contains(rec.Id)) {
                        toProcess.add(rec);
                    }
                }
            }
        }

        // recording the record id's if the trigger should run only once
        if (this.runOnlyOncePerRecord == true) {
            processedRecords.get(triggerName).addAll(new Map<Id, SObject>(toProcess).keySet());
        }

        if (toProcess.size() > 0) {
            System.debug('Executing ' + toProcess);
            this.executeTrigger(toProcess);
        }
    }
}