public without sharing class PMHR_TriggerHandlerNuzlocke implements ITrigger {
    private Map<Id, PMHR_Nuzlocke__c> oldNuzlockesWithFinalTeams;

    public void bulkBefore() {
        if (Trigger.isUpdate) {
            oldNuzlockesWithFinalTeams = PMHR_TriggerHandlerNuzlocke_Helper.getNuzlockesWithFinalTeamsList(Trigger.newMap.keySet());
        }
    }

    public void bulkAfter() {}

    public void beforeInsert(SObject so) {}

    public void afterInsert(SObject so) {}

    public void beforeUpdate(SObject oldSo, SObject so) {
        PMHR_Nuzlocke__c oldNuzlocke = (PMHR_Nuzlocke__c) oldSo;
        PMHR_Nuzlocke__c newNuzlocke = (PMHR_Nuzlocke__c) so;

        if (oldNuzlockesWithFinalTeams != null && !oldNuzlockesWithFinalTeams.isEmpty()) {
            PMHR_TriggerHandlerNuzlocke_Helper.validateFinishingNuzlocke(oldNuzlockesWithFinalTeams.get(oldNuzlocke.Id), newNuzlocke);
        }
    }

    public void afterUpdate(SObject oldSo, SObject so) {}

    public void afterDelete(SObject so) {}

    public void andFinally() {}
}