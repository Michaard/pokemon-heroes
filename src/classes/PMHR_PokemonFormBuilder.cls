public with sharing class PMHR_PokemonFormBuilder extends PMHR_PokemonDataBuilder {
    protected override Pokemon_Data__c defaultData() {
        return new Pokemon_Data__c(
                Pokedex_Number__c = '001',
                Name = 'Default Pokemon',
                Primary_Type__c = TYPE_NORMAL,
                Family__c = 'Default Pokemon',
                Family_Stage__c = 1,
                RecordTypeId = PMHR_Utilities.getRecordTypeIdByName(SObjectType.Pokemon_Data__c, PMHR_PokemonDataBuilder.RT_FORM),
                Evolves_from_Variant__c = PMHR_Utilities.REGION_VARIANT_STANDARD
        );
    }

    public PMHR_PokemonFormBuilder() {
        super();
    }

    public PMHR_PokemonFormBuilder(Pokemon_Data__c pokemonDataRecord) {
        super(pokemonDataRecord);
    }
}