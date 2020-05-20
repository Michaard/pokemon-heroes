public with sharing class PMHR_PokemonDataQueryService {
    public static Pokemon_Data__c getPokemonFormById(Id pokemonDataId) {
        return getPokemonFormsByIds(new Set<Id>{pokemonDataId}).get(0);
    }

    public static List<Pokemon_Data__c> getPokemonFormsByIds(Set<Id> pokemonDataIds) {
        return [
                SELECT Id, Name, Pokedex_Number__c, Family__c, Family_Stage__c, Type__c, Primary_Type__c, Secondary_Type__c, Picture_Url__c,
                    (SELECT Id, Variant_Name__c, Region_Specific_Variant__c, Type__c, Picture_Url__c
                    FROM Additional_Variants__r)
                FROM Pokemon_Data__c
                WHERE Id IN :pokemonDataIds
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_FORM)
        ];
    }

    public static List<Pokemon_Data__c> getAvailableNextPokemonForms(Pokemon__c pokemon) {
        return [
                SELECT Id, Name, Pokedex_Number__c, Family_Stage__c,
                    (SELECT Id, Variant_Name__c, Region_Specific_Variant__c
                    FROM Additional_Variants__r)
                FROM Pokemon_Data__c
                WHERE Family__c = :pokemon.Form__r.Family__c
                AND Family_Stage__c = :pokemon.Form__r.Family_Stage__c + 1
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_FORM)
                ORDER BY Pokedex_Number__c ASC
                LIMIT 20
        ];
    }

    public static Pokemon_Data__c getAdditionalVariantById(Id additionalVariantId) {
        return [
                SELECT Id, Name, Variant_Name__c, Variant_Of__c, Primary_Type__c, Secondary_Type__c, Type__c,
                        Picture_Url__c, Region_Specific_Variant__c
                FROM Pokemon_Data__c
                WHERE Id = :additionalVariantId
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)
                LIMIT 1
        ];
    }

    public static List<Pokemon_Data__c> getAdditionalVariantByFormIds(Set<Id> formIds) {
        return [
                SELECT Id, Name, Variant_Name__c, Variant_Of__c, Primary_Type__c, Secondary_Type__c, Type__c,
                        Picture_Url__c, Region_Specific_Variant__c
                FROM Pokemon_Data__c
                WHERE Variant_Of__c IN :formIds
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)
        ];
    }

    public static List<Pokemon_Data__c> getPokemonFormByIdsOrPokedexNumbers(Set<Id> ids, Set<String> pokedexNumbers) {
        return [
                SELECT Id, Name, Pokedex_Number__c, Family__c, Family_Stage__c, Type__c, Primary_Type__c, Secondary_Type__c, Picture_Url__c,
                    (SELECT Id, Name, Variant_Name__c, Variant_Of__c, Primary_Type__c, Secondary_Type__c, Type__c,
                            Picture_Url__c, Region_Specific_Variant__c
                    FROM Additional_Variants__r)
                FROM Pokemon_Data__c
                WHERE (Id IN :ids
                OR Pokedex_Number__c IN :pokedexNumbers)
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_FORM)
        ];
    }
}