public with sharing class PMHR_PokemonDataBuilder {
    public static final String TYPE_NORMAL = 'Normal';
    public static final String TYPE_DARK = 'Dark';

    private Pokemon_Data__c record;

    private Pokemon_Data__c defaultData() {
        return new Pokemon_Data__c(
                Pokedex_Number__c = '000',
                Name = 'Default Pokemon',
                Primary_Type__c = TYPE_NORMAL,
                Family__c = 'Default Pokemon',
                Family_Stage__c = 1
        );
    }

    public PMHR_PokemonDataBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_PokemonDataBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public Pokemon_Data__c build() {
        Pokemon_Data__c record = this.record;
        this.reset();
        return record;
    }

    public Pokemon_Data__c save() {
        Pokemon_Data__c record = this.build();
        upsert record;
        return record;
    }

    public PMHR_PokemonDataBuilder setPokedexNumber(String pokedexNumber) {
        this.record.Pokedex_Number__c = pokedexNumber;
        return this;
    }

    public PMHR_PokemonDataBuilder setForm(String form) {
        this.record.Name = form;
        return this;
    }

    public PMHR_PokemonDataBuilder setFamily(String family) {
        this.record.Family__c = family;
        return this;
    }

    public PMHR_PokemonDataBuilder setFamilyStage(Integer familyStage) {
        this.record.Family_Stage__c = Decimal.valueOf(familyStage);
        return this;
    }

    public PMHR_PokemonDataBuilder setPrimaryType(String pokemonType) {
        this.record.Primary_Type__c = pokemonType;
        return this;
    }

    public PMHR_PokemonDataBuilder setSecondaryType(String pokemonType) {
        this.record.Secondary_Type__c = pokemonType;
        return this;
    }

    public PMHR_PokemonDataBuilder setPictureUrl(String pictureUrl) {
        this.record.Picture_Url__c = pictureUrl;
        return this;
    }

    public PMHR_PokemonDataBuilder setRegionSpecificVariants(List<String> variants) {
        if (variants == null) {
            throw new NullRegionSpecificVariantsException();
        }
        this.record.Region_Specific_Variants__c = String.join(variants, ';');
        return this;
    }

    public class NullRegionSpecificVariantsException extends Exception{}
}