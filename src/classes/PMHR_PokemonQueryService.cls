public with sharing class PMHR_PokemonQueryService {
    public static Pokemon__c getPokemonById(Id pokemonId) {
        return [
                SELECT Id, Name, Caught_Form__c, Form__c, Gender__c, Region_Specific_Variant__c, Nuzlocke__c, Trainer__c,
                        Location__c, Catch_Method__c, Death__c, Death_Level__c, Cause_of_Death__c
                FROM Pokemon__c
                WHERE Id = :pokemonId
                LIMIT 1
        ];
    }

    public static Pokemon__c getPokemonWithFormById(Id pokemonId) {
        return [
                SELECT Name, Region_Specific_Variant__c, Form__r.Family__c, Form__r.Family_Stage__c, Form__r.Region_Specific_Variants__c,
                        Form__r.Picture_Url__c, Form__r.Type__c,
                        Form__r.Alolan_Picture_Url__c, Form__r.Alolan_Type__c,
                        Form__r.Galarian_Picture_Url__c, Form__r.Galarian_Type__c
                FROM Pokemon__c
                WHERE Id = :pokemonId
                LIMIT 1
        ];
    }
}