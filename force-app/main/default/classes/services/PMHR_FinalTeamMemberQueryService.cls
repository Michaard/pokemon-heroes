public with sharing class PMHR_FinalTeamMemberQueryService {
    public static PMHR_FinalTeamMember__c getFinalTeamMemberById(Id finalTeamMemberId) {
        return [
                SELECT Id, Form__c, Ability__c, Nature__c, HeldItem__c, FinalTeam__c, Pokemon__c, Level__c, Type__c,
                        Move1__c, Move2__c, Move3__c, Move4__c
                FROM PMHR_FinalTeamMember__c
                WHERE Id = :finalTeamMemberId
                LIMIT 1
        ];
    }
}