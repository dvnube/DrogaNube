/**
 * @description All triggers are routed to this class. No trigger logic should be done bypassing it (without a very serious reason)
 * See an example of routing at manage() method
 */
public with sharing class TriggerHandler {
    public Schema.SObjectType sObjectType;
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    TriggerHandlerSettings__c settings = TriggerHandlerSettings__c.getOrgDefaults();

    /**
     * @description If you set this static property to true, NO trigger logic will be fired.
     */
    public static Boolean disableAll = false;

    /**
     * @description Creates an instance which immediately runs on a trigger. See example on manage()
     * @param sObjectType Type of the SObject which trigger is handled
     */
    public TriggerHandler(Schema.sObjectType sObjectType) {
        this.sObjectType = sObjectType;
        construct();
        if (selectiveEventHandlerMapping.size() > 0) {
            this.eventHandlerMapping = selectiveEventHandlerMapping;
        }
    }

    /*
     * Interface for classes which are called in trigger context.
     * On selected events the handle method is called
     */
    public interface IHandlerInterface {
        void handle(Schema.SObjectType sObjectType);
    }

    /**
     * Enum representing each of before/after CRUD events on Sobjects
     */
    public enum Evt {
        afterdelete,
        afterinsert,
        afterundelete,
        afterupdate,
        beforedelete,
        beforeinsert,
        beforeupdate
    }

    /*
     *   Simplistic handler to implement on any of the event. It doesn't require or enforces any pattern except the
     *   method name to be "handle()"
     */
    Map<Schema.SObjectType, Map<TriggerHandler.Evt, IHandlerInterface[]>> eventHandlerMapping = new Map<Schema.SObjectType, Map<TriggerHandler.Evt, IHandlerInterface[]>>();

    /*
     *   Simplistic handler to implement on any of the event. It doesn't require or enforces any pattern except the
     *   method name to be "handle()". - this is for firing selective triggers - called from webhooks usually
     */
    public static Map<Schema.SObjectType, Map<TriggerHandler.Evt, IHandlerInterface[]>> selectiveEventHandlerMapping = new Map<Schema.SObjectType, Map<TriggerHandler.Evt, IHandlerInterface[]>>();

    /**
     * @description This is the main method to bind your trigger classes to SOQL Object events
     * See examples at bind() method
     */
    private void construct() {
        if (settings.DisableAll__c || disableAll) {
            return;
        }

        if (this.sObjectType == ProdutoEstoque__c.getSObjectType()) {
            bind(this.sObjectType, evt.beforeinsert, new ProdutoEstoque_CheckQuantity());
            bind(this.sObjectType, evt.beforeinsert, new ProdutoEstoque_UpdateProductName());
            bind(this.sObjectType, evt.beforeupdate, new ProdutoEstoque_CheckQuantity());
        } else if (this.sObjectType == Pedido__c.getSObjectType()) {
            bind(this.sObjectType, evt.afterinsert, new Pedido_NotifyCustomer());
            bind(this.sObjectType, evt.beforedelete, new Pedido_CheckPending());
        } else if (this.sObjectType == Account.getSObjectType()) {
            bind(this.sObjectType, evt.afterupdate, new Account_NotifyCustomer());
        }
    }

    /**
     * @description Core API to bind handlers with events. You are using this method in the construct() method.
     * @param sObjectType Type of the object to bind the class
     * @param event The event -- see list of available 'Evt' types
     * @param eh An instance of event handler class. This can be any class which implements the
     * IHandlerInterface interface
     * @example
     * bind(Shipment__c.getSObjectType(), evt.afterupdate, new Shipment_ShipNotificationToAshley());
     * // This binds an instance of Shipment_ShipNotificationToAshley class
     * // to every 'after update' event on Shipment__c object
     */
    public void bind(Schema.SObjectType sObjectType, Evt event, IHandlerInterface eh) {
        if (!eventHandlerMapping.containsKey(sObjectType)) {
            eventHandlerMapping.put(sObjectType, new Map<TriggerHandler.Evt, IHandlerInterface[]>());
        }
        if (!eventHandlerMapping.get(sObjectType).containsKey(event)) {
            eventHandlerMapping.get(sObjectType).put(event, new List<IHandlerInterface>{});
        }
        // setting the sObjectType on the trigger instance
        eventHandlerMapping.get(sObjectType).get(event).add(eh);
    }

    /**
     * @description Invokes correct handlers as per the context of Trigger and available registered handlers.
     * This method should be called on the trigger.
     * @example trigger Shipment_bla on Shipment__c (.....) {
     * new TriggerHandler(Shipment__c.SObjectType).manage();
     * }
     * On your trigger you are creating a new instance of trigger handler (passing the object type), and immediately
     * starting the manage() method. It will automatically start the bound trigger classes to the given SOQL/event.
     * See: bind() method
     */
    public void manage() {
        Evt ev = null;
        if (Trigger.isInsert && Trigger.isBefore) {
            ev = Evt.beforeinsert;
        } else if (Trigger.isInsert && Trigger.isAfter) {
            ev = Evt.afterinsert;
        } else if (Trigger.isUpdate && Trigger.isBefore) {
            ev = Evt.beforeupdate;
        } else if (Trigger.isUpdate && Trigger.isAfter) {
            ev = Evt.afterupdate;
        } else if (Trigger.isDelete && Trigger.isBefore) {
            ev = Evt.beforedelete;
        } else if (Trigger.isDelete && Trigger.isAfter) {
            ev = Evt.afterdelete;
        } else if (Trigger.isUndelete) {
            ev = Evt.afterundelete;
        }

        if (eventHandlerMapping.get(sObjectType) != null) {
            IHandlerInterface[] handlers = eventHandlerMapping.get(sObjectType).get(ev);
            if (handlers != null && handlers.size() > 0) {
                for (IHandlerInterface h : handlers) {
                    System.debug('Executing ' + sObjectType + ' ' + ev + ' trigger class: ' + h);
                    h.handle(sObjectType);
                }
            }
        }
    }
}