public with sharing class PMHR_FinalTeamMemberBuilder {
    private static final String MOVE_API_NAME_FORMAT = 'Move{0}__c';
    private PMHR_FinalTeamMember__c record;

    private PMHR_FinalTeamMember__c defaultData() {
        return new PMHR_FinalTeamMember__c();
    }

    public PMHR_FinalTeamMemberBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_FinalTeamMemberBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public PMHR_FinalTeamMember__c build() {
        PMHR_FinalTeamMember__c record = this.record;
        this.reset();
        return record;
    }

    public PMHR_FinalTeamMember__c save() {
        PMHR_FinalTeamMember__c record = this.build();
        upsert record;
        return record;
    }

    public PMHR_FinalTeamMemberBuilder setFinalTeam(Id finalTeam) {
        this.record.FinalTeam__c = finalTeam;
        return this;
    }

    public PMHR_FinalTeamMemberBuilder setPokemon(Id pokemonId) {
        this.record.Pokemon__c = pokemonId;
        return this;
    }

    public PMHR_FinalTeamMemberBuilder setAbility(String ability) {
        this.record.Ability__c = ability;
        return this;
    }

    public PMHR_FinalTeamMemberBuilder setHeldItem(String heldItem) {
        this.record.HeldItem__c = heldItem;
        return this;
    }

    public PMHR_FinalTeamMemberBuilder setLevel(Integer level) {
        this.record.Level__c = Decimal.valueOf(level);
        return this;
    }

    public PMHR_FinalTeamMemberBuilder setMoves(Map<Integer, String> moves) {
        if (moves == null || moves.size() > 4) {
            throw new InvalidNumberOfMovesException();
        }
        for (Integer moveNumber : moves.keySet()) {
            if (moveNumber <= 0 || moveNumber > 4) {
                throw new InvalidMoveNumberException();
            }
            this.record.put(String.format(MOVE_API_NAME_FORMAT, new List<String>{String.valueOf(moveNumber)}), moves.get(moveNumber));
        }
        return this;
    }

    public PMHR_FinalTeamMemberBuilder setNature(String nature) {
        this.record.Nature__c = nature;
        return this;
    }

    public class InvalidNumberOfMovesException extends Exception{}
    public class InvalidMoveNumberException extends Exception {}
}