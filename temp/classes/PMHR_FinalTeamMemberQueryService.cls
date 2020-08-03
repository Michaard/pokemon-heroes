public with sharing class PMHR_FinalTeamMemberQueryService {
    public static Final_Team_Member__c getFinalTeamMemberById(Id finalTeamMemberId) {
        return [
                SELECT Id, Form__c, Ability__c, Nature__c, Held_Item__c, Final_Team__c, Pokemon__c, Level__c, Type__c,
                        Move_1__c, Move_2__c, Move_3__c, Move_4__c
                FROM Final_Team_Member__c
                WHERE Id = :finalTeamMemberId
                LIMIT 1];
    }
}