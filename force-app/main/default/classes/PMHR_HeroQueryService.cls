public with sharing class PMHR_HeroQueryService {
    public static PMHR_Hero__c getHeroById(Id heroId) {
        return [
                SELECT Id, Name, Nickname__c, RivalName__c, GameVersion__c, Gender__c, Region__c
                FROM PMHR_Hero__c
                WHERE Id = :heroId
                LIMIT 1
        ];
    }
}