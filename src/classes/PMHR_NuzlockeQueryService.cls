public with sharing class PMHR_NuzlockeQueryService {
    public static Nuzlocke__c getNuzlockeById(Id nuzlockeId) {
        return [
                SELECT Id, Name, Start_Date__c, End_Date__c, End_Status__c, Hero__c, Rival_Name__c,
                        Allowed_Catching_Methods_Per_Area__c, Legendaries_Rule__c, Safari_Zone_Rule__c,
                        Game_Version__c, Is_Finished__c, Multiple_Elite_Four_Fights__c, Pokemons_Caught__c, Pokemons_Deceased__c
                FROM Nuzlocke__c
                WHERE Id = :nuzlockeId
                LIMIT 1
        ];
    }

    public static List<Nuzlocke__c> getNuzlockesWithFinalTeamsByIds(Set<Id> nuzlockeIds) {
        return [
                SELECT Id, Name, Start_Date__c, End_Date__c, End_Status__c, Hero__c, Rival_Name__c,
                        Allowed_Catching_Methods_Per_Area__c, Legendaries_Rule__c, Safari_Zone_Rule__c,
                        Game_Version__c, Is_Finished__c, Multiple_Elite_Four_Fights__c, Pokemons_Caught__c, Pokemons_Deceased__c,
                    (SELECT Name FROM Final_Teams__r)
                FROM Nuzlocke__c
                WHERE Id IN :nuzlockeIds
        ];
    }

    public static Nuzlocke__c getNuzlockeWithFinalTeamsById(Id nuzlockeId) {
        return getNuzlockesWithFinalTeamsByIds(new Set<Id>{nuzlockeId}).get(0);
    }
}