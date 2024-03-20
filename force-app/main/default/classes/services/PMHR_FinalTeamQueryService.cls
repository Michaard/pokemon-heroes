public with sharing class PMHR_FinalTeamQueryService {
    public static PMHR_FinalTeam__c getFinalTeamById(Id finalTeamId) {
        return [
                SELECT Id, Name, Nuzlocke__c
                FROM PMHR_FinalTeam__c
                WHERE Id = :finalTeamId
                LIMIT 1
        ];
    }

    public static List<PMHR_FinalTeam__c> getFinalTeamsWithMembersByNuzlockeId(Id nuzlockeId) {
        return [
                SELECT Id, Name, Nuzlocke__c,
                    (SELECT Id, Name, Pokemon__c, Pokemon__r.Name, Form__c, Type__c, Level__c
                    FROM FinalTeamMembers__r
                    ORDER BY Name)
                FROM PMHR_FinalTeam__c
                WHERE Nuzlocke__c = :nuzlockeId
                ORDER BY CreatedDate
        ];
    }

    public static PMHR_FinalTeam__c getFinalTeamByNuzlockeId(Id nuzlockeId) {
        return [
                SELECT Id, Name, Nuzlocke__c
                FROM PMHR_FinalTeam__c
                WHERE Nuzlocke__c = :nuzlockeId
                LIMIT 1
        ];
    }
}