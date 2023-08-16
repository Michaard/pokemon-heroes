public with sharing class PMHR_PokemonQueryService {
    public static PMHR_Pokemon__c getPokemonById(Id pokemonId) {
        return [
                SELECT Id, Name, CaughtForm__c, Form__c, Gender__c, RegionalVariant__c, Nuzlocke__c, Trainer__c,
                        Location__c, CatchMethod__c, IsDeceased__c, DeathLevel__c, CauseOfDeath__c
                FROM PMHR_Pokemon__c
                WHERE Id = :pokemonId
                LIMIT 1
        ];
    }

    public static PMHR_Pokemon__c getPokemonWithFormById(Id pokemonId) {
        return [
                SELECT Name, IsDeceased__c, RegionalVariant__c, Form__c, Form__r.Family__c, Form__r.FamilyStage__c
                FROM PMHR_Pokemon__c
                WHERE Id = :pokemonId
                LIMIT 1
        ];
    }
}