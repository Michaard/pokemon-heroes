public with sharing class PMHR_PokemonDataQueryService {
    public static PMHR_PokemonData__c getPokemonFormById(Id pokemonDataId) {
        return getPokemonFormsByIds(new Set<Id>{pokemonDataId}).get(0);
    }

    public static List<PMHR_PokemonData__c> getPokemonFormsByIds(Set<Id> pokemonDataIds) {
        return [
                SELECT Id, Name, PokedexNumber__c, Family__c, FamilyStage__c, Type__c, PrimaryType__c, SecondaryType__c, PictureUrl__c, EvolvesFromVariant__c, (
                        SELECT Id, VariantName__c, RegionalVariant__c, Type__c, PictureUrl__c, EvolvesFromVariant__c
                        FROM Variants__r
                )
                FROM PMHR_PokemonData__c
                WHERE Id IN :pokemonDataIds
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_FORM)
        ];
    }

    public static List<PMHR_PokemonData__c> getAvailableNextPokemonForms(PMHR_Pokemon__c pokemon) {
        return [
                SELECT Id, Name, PokedexNumber__c, FamilyStage__c, EvolvesFromVariant__c, Type__c, PictureUrl__c,
                (
                        SELECT Id, VariantName__c, RegionalVariant__c, EvolvesFromVariant__c, Type__c, PictureUrl__c
                        FROM Variants__r
                )
                FROM PMHR_PokemonData__c
                WHERE Family__c = :pokemon.Form__r.Family__c
                AND FamilyStage__c = :pokemon.Form__r.FamilyStage__c + 1
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_FORM)
                ORDER BY PokedexNumber__c ASC
                LIMIT 20
        ];
    }

    public static PMHR_PokemonData__c getAdditionalVariantById(Id additionalVariantId) {
        return [
                SELECT Id, Name, VariantName__c, VariantOf__c, PrimaryType__c, SecondaryType__c, Type__c,
                        PictureUrl__c, RegionalVariant__c
                FROM PMHR_PokemonData__c
                WHERE Id = :additionalVariantId
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)
                LIMIT 1
        ];
    }

    public static List<PMHR_PokemonData__c> getAdditionalVariantByFormIds(Set<Id> formIds) {
        return [
                SELECT Id, Name, VariantName__c, VariantOf__c, PrimaryType__c, SecondaryType__c, Type__c,
                        PictureUrl__c, RegionalVariant__c
                FROM PMHR_PokemonData__c
                WHERE VariantOf__c IN :formIds
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_ADDITIONAL_VARIANT)
        ];
    }

    public static List<PMHR_PokemonData__c> getPokemonFormByIdsOrPokedexNumbers(Set<Id> ids, Set<String> pokedexNumbers) {
        return [
                SELECT Id, Name, PokedexNumber__c, Family__c, FamilyStage__c, Type__c, PrimaryType__c, SecondaryType__c, PictureUrl__c, (
                        SELECT Id, Name, VariantName__c, VariantOf__c, PrimaryType__c, SecondaryType__c, Type__c,
                                PictureUrl__c, RegionalVariant__c
                        FROM Variants__r
                )
                FROM PMHR_PokemonData__c
                WHERE (Id IN :ids OR PokedexNumber__c IN :pokedexNumbers)
                AND RecordTypeId = :PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_FORM)
        ];
    }
}