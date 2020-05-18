public with sharing class PMHR_HeroQueryService {
    public static Hero__c getHeroById(Id heroId) {
        return [
                SELECT Id, Name, Nickname__c, Rival_Name__c, Game_Version__c, Gender__c, Region__c
                FROM Hero__c
                WHERE Id = :heroId
                LIMIT 1
        ];
    }
}