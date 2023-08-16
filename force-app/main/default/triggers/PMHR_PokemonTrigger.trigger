trigger PMHR_PokemonTrigger on PMHR_Pokemon__c (before insert, after insert, before update, after delete) {
    TriggerHandler.execute(new PMHR_TriggerHandlerPokemon());
}