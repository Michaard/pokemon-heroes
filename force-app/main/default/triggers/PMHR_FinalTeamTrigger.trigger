trigger PMHR_FinalTeamTrigger on PMHR_FinalTeam__c (before insert, after insert, before update, after delete) {
    TriggerHandler.execute(new PMHR_TriggerHandlerFinalTeam());
}