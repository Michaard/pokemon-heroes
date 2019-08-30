public class PMHR_FinalTeamListController {

    @AuraEnabled
    public static List<FinalTeam> getFinalTeamInfo(Id nuzlockeId) {
        List<FinalTeam> result = new List<FinalTeam>();
        List<Final_Team__c> finalTeams = [SELECT Id, Name, (SELECT Id, Name, Pokemon__c, Pokemon__r.Name, Form__c, Type__c, Level__c FROM Final_Team_Members__r ORDER BY Name) FROM Final_Team__c WHERE Nuzlocke__c = :nuzlockeId ORDER BY CreatedDate];
        for (Final_Team__c finalTeam : finalTeams) {
            List<FinalTeamMember> finalTeamMembers = new List<FinalTeamMember>();
            for (Final_Team_Member__c member : finalTeam.Final_Team_Members__r) {
                finalTeamMembers.add(new FinalTeamMember(member));
            }

            result.add(new FinalTeam(finalTeam, finalTeamMembers));
        }

        return result;
    }

    @TestVisible
    private class FinalTeam {
        @AuraEnabled public Id id { get; private set; }
        @AuraEnabled public String name { get; private set; }
        @AuraEnabled public List<FinalTeamMember> members { get; private set; }

        public FinalTeam(Final_Team__c finalTeam, List<FinalTeamMember> members) {
            this.id = finalTeam.Id;
            this.name = finalTeam.Name;
            this.members = members;
        }
    }

    @TestVisible
    private class FinalTeamMember {
        @AuraEnabled public Id id { get; private set; }
        @AuraEnabled public String nr { get; private set; }
        @AuraEnabled public String pokemonName { get; private set; }
        @AuraEnabled public Id pokemonId { get; private set; }
        @AuraEnabled public String form { get; private set; }
        @AuraEnabled public String type { get; private set; }
        @AuraEnabled public Integer level { get; private set; }

        public FinalTeamMember(Final_Team_Member__c member) {
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