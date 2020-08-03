trigger PMHR_NuzlockeTrigger on Nuzlocke__c (before insert, before update, after insert, after delete) {
    TriggerHandler.execute(new PMHR_TriggerHandlerNuzlocke());
}