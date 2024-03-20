public with sharing class PMHR_PokemonFormBuilder extends PMHR_PokemonDataBuilder {
    protected override PMHR_PokemonData__c defaultData() {
        return new PMHR_PokemonData__c(
                PokedexNumber__c = '001',
                Name = 'Default Pokemon',
                PrimaryType__c = TYPE_NORMAL,
                Family__c = 'Default Pokemon',
                FamilyStage__c = 1,
                RecordTypeId = PMHR_Utilities.getRecordTypeIdByName(SObjectType.PMHR_PokemonData__c, PMHR_PokemonDataBuilder.RT_FORM),
                EvolvesFromVariant__c = PMHR_Utilities.REGION_VARIANT_STANDARD
        );
    }

    public PMHR_PokemonFormBuilder() {
        super();
    }

    public PMHR_PokemonFormBuilder(PMHR_PokemonData__c pokemonDataRecord) {
        super(pokemonDataRecord);
    }
}