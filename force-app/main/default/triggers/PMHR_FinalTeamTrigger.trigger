trigger PMHR_FinalTeamTrigger on Final_Team__c (before insert, after insert, before update, after delete) {
    TriggerHandler.execute(new PMHR_TriggerHandlerFinalTeam());
}