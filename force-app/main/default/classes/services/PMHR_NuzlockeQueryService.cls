public with sharing class PMHR_NuzlockeQueryService {
    public static PMHR_Nuzlocke__c getNuzlockeById(Id nuzlockeId) {
        return [
                SELECT Id, Name, StartDate__c, EndDate__c, Status__c, Hero__c, RivalName__c,
                        AllowedCatchingMethodsPerArea__c, LegendariesRule__c, SafariZoneRule__c,
                        GameVersion__c, IsFinished__c, Multiple_Elite_Four_Fights__c, PokemonsCaught__c, PokemonsDeceased__c
                FROM PMHR_Nuzlocke__c
                WHERE Id = :nuzlockeId
                LIMIT 1
        ];
    }

    public static List<PMHR_Nuzlocke__c> getNuzlockesWithFinalTeamsByIds(Set<Id> nuzlockeIds) {
        return [
                SELECT Id, Name, StartDate__c, EndDate__c, Status__c, Hero__c, RivalName__c,
                        AllowedCatchingMethodsPerArea__c, LegendariesRule__c, SafariZoneRule__c,
                        GameVersion__c, IsFinished__c, Multiple_Elite_Four_Fights__c, PokemonsCaught__c, PokemonsDeceased__c,
                    (SELECT Name FROM FinalTeams__r)
                FROM PMHR_Nuzlocke__c
                WHERE Id IN :nuzlockeIds
        ];
    }

    public static PMHR_Nuzlocke__c getNuzlockeWithFinalTeamsById(Id nuzlockeId) {
        return getNuzlockesWithFinalTeamsByIds(new Set<Id>{nuzlockeId}).get(0);
    }
}