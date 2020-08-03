public with sharing class PMHR_FinalTeamQueryService {
    public static Final_Team__c getFinalTeamById(Id finalTeamId) {
        return [
                SELECT Id, Name, Nuzlocke__c
                FROM Final_Team__c
                WHERE Id = :finalTeamId
                LIMIT 1
        ];
    }

    public static List<Final_Team__c> getFinalTeamsWithMembersByNuzlockeId(Id nuzlockeId) {
        return [
                SELECT Id, Name, Nuzlocke__c,
                    (SELECT Id, Name, Pokemon__c, Pokemon__r.Name, Form__c, Type__c, Level__c
                    FROM Final_Team_Members__r
                    ORDER BY Name)
                FROM Final_Team__c
                WHERE Nuzlocke__c = :nuzlockeId
                ORDER BY CreatedDate
        ];
    }

    public static Final_Team__c getFinalTeamByNuzlockeId(Id nuzlockeId) {
        return [
                SELECT Id, Name, Nuzlocke__c
                FROM Final_Team__c
                WHERE Nuzlocke__c = :nuzlockeId
                LIMIT 1
        ];
    }
}