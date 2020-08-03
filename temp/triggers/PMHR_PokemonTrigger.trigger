trigger PMHR_PokemonTrigger on Pokemon__c (before insert, after insert, before update, after delete) {
    TriggerHandler.execute(new PMHR_TriggerHandlerPokemon());
}