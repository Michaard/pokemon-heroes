public class PMHR_TriggerHandlerPokemon implements ITrigger {
    public void bulkBefore() {
    }

    public void bulkAfter() {
    }

    public void beforeInsert(SObject so) {
        Pokemon__c pokemon = (Pokemon__c) so;
        PMHR_TriggerHandlerPokemon_Helper.copyCaughtFormToForm(pokemon);
    }

    public void afterInsert(SObject so) {
    }

    public void beforeUpdate(SObject oldSo, SObject so) {
    }

    public void afterDelete(SObject so) {
    }

    public void andFinally() {
    }
}