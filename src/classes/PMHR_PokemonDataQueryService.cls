public with sharing class PMHR_PokemonDataQueryService {
    public static Pokemon_Data__c getPokemonDataById(Id pokemonDataId) {
        return [
                SELECT Id, Name, Pokedex_Number__c, Family__c, Family_Stage__c, Type__c, Primary_Type__c, Secondary_Type__c, Picture_Url__c, Region_Specific_Variants__c
                FROM Pokemon_Data__c
                WHERE Id = :pokemonDataId
                LIMIT 1
        ];
    }

    public static List<Pokemon_Data__c> getAvailableNextPokemonForms(Pokemon__c pokemon) {
        return [
                SELECT Id, Name, Pokedex_Number__c, Family_Stage__c, Region_Specific_Variants__c
                FROM Pokemon_Data__c
                WHERE Family__c = :pokemon.Form__r.Family__c
                AND Family_Stage__c = :pokemon.Form__r.Family_Stage__c + 1
                ORDER BY Pokedex_Number__c ASC
                LIMIT 20
        ];
    }
}