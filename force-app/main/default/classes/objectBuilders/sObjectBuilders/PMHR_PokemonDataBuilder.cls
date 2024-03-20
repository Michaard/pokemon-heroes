public abstract class PMHR_PokemonDataBuilder {
    public static final String RT_FORM = 'Form';
    public static final String RT_ADDITIONAL_VARIANT = 'Additional Variant';

    public static final String TYPE_NORMAL = 'Normal';
    public static final String TYPE_DARK = 'Dark';

    protected PMHR_PokemonData__c record;

    protected abstract PMHR_PokemonData__c defaultData();

    public PMHR_PokemonDataBuilder() {
        this.record = this.defaultData();
    }

    public PMHR_PokemonDataBuilder(PMHR_PokemonData__c pokemonDataRecord) {
        this.record = pokemonDataRecord;
    }

    public PMHR_PokemonDataBuilder reset() {
        this.record = this.defaultData();
        return this;
    }

    public PMHR_PokemonData__c build() {
        PMHR_PokemonData__c record = this.record;
        this.reset();
        return record;
    }

    public PMHR_PokemonData__c save() {
        PMHR_PokemonData__c record = this.build();
        upsert record;
        return record;
    }

    public PMHR_PokemonDataBuilder setPrimaryType(String pokemonType) {
        this.record.PrimaryType__c = pokemonType;
        return this;
    }

    public PMHR_PokemonDataBuilder setSecondaryType(String pokemonType) {
        this.record.SecondaryType__c = pokemonType;
        return this;
    }

    public PMHR_PokemonDataBuilder setPictureUrl(String pictureUrl) {
        this.record.PictureUrl__c = pictureUrl;
        return this;
    }

    public PMHR_PokemonDataBuilder setPokedexNumber(String pokedexNumber) {
        this.record.PokedexNumber__c = pokedexNumber;
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
        this.record.FamilyStage__c = Decimal.valueOf(familyStage);
        return this;
    }

    public PMHR_PokemonDataBuilder setVariantOf(Id pokemonDataId) {
        this.record.VariantOf__c = pokemonDataId;
        return this;
    }

    public PMHR_PokemonDataBuilder setRegionSpecificVariant(String variant) {
        this.record.RegionalVariant__c = variant;
        return this;
    }

    public PMHR_PokemonDataBuilder setEvolvesFromVariant(String variant) {
        this.record.EvolvesFromVariant__c = variant;
        return this;
    }
}