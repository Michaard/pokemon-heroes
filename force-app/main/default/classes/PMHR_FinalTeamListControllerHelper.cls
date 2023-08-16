public with sharing class PMHR_FinalTeamListControllerHelper {
    private static PMHR_FinalTeamListControllerHelper instance;

    private PMHR_FinalTeamListControllerHelper() {}

    public static PMHR_FinalTeamListControllerHelper getInstance() {
        if (instance == null) {
            instance = new PMHR_FinalTeamListControllerHelper();
        }
        return instance;
    }

    public List<FinalTeam> parseFinalTeams(List<PMHR_FinalTeam__c> finalTeamsToParse) {
        List<FinalTeam> result = new List<FinalTeam>();

        for (PMHR_FinalTeam__c finalTeam : finalTeamsToParse) {
            List<FinalTeamMember> finalTeamMembers = new List<FinalTeamMember>();
            for (PMHR_FinalTeamMember__c member : finalTeam.FinalTeamMembers__r) {
                finalTeamMembers.add(new FinalTeamMember(member));
            }

            result.add(new FinalTeam(finalTeam, finalTeamMembers));
        }

        return result.isEmpty() ? null : result;
    }

    public class FinalTeam {
        @AuraEnabled public Id id { get; private set; }
        @AuraEnabled public String name { get; private set; }
        @AuraEnabled public List<FinalTeamMember> members { get; private set; }

        public FinalTeam(PMHR_FinalTeam__c finalTeam, List<FinalTeamMember> members) {
            this.id = finalTeam.Id;
            this.name = finalTeam.Name;
            this.members = members;
        }
    }

    public class FinalTeamMember {
        @AuraEnabled public Id id { get; private set; }
        @AuraEnabled public String nr { get; private set; }
        @AuraEnabled public String pokemonName { get; private set; }
        @AuraEnabled public Id pokemonId { get; private set; }
        @AuraEnabled public String form { get; private set; }
        @AuraEnabled public String type { get; private set; }
        @AuraEnabled public Integer level { get; private set; }

        public FinalTeamMember(PMHR_FinalTeamMember__c member) {
            this.id = member.Id;
            this.nr = member.Name;
            this.pokemonName = member.Pokemon__r.Name;
            this.pokemonId = member.Pokemon__c;
            this.form = member.Form__c;
            this.type = member.Type__c;
            this.level = Integer.valueOf(member.Level__c);
        }
    }
}