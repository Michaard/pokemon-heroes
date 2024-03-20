trigger PMHR_PokemonDataTrigger on PMHR_PokemonData__c (before insert, after insert, after update, before update, after delete) {
    TriggerHandler.execute(new PMHR_TriggerHandlerPokemonData());
}