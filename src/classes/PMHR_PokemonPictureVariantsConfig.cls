public class PMHR_PokemonPictureVariantsConfig {
    private static PMHR_PokemonPictureVariantsConfig instance;
    private static Map<String, List<String>> regionVariantToFieldsApiNamesMap;

    private PMHR_PokemonPictureVariantsConfig() {
        String pictureUrlFieldApiName = Pokemon_Data__c.Picture_Url__c.getDescribe().getName();
        String typeFieldApiName = Pokemon_Data__c.Type__c.getDescribe().getName();
        regionVariantToFieldsApiNamesMap = new Map<String, List<String>>();
        regionVariantToFieldsApiNamesMap.put(null, new List<String> {pictureUrlFieldApiName, typeFieldApiName});
        for (PicklistEntry variant : PMHR_Utilities.POKEMON_REGIONAL_VARIANT) {
            String variantName = variant.getValue();
            String pictureApiName = String.join(new List<String>{variantName, pictureUrlFieldApiName}, '_');
            String typeApiName = String.join(new List<String>{variantName, typeFieldApiName}, '_');
            regionVariantToFieldsApiNamesMap.put(variantName, new List<String>{pictureApiName, typeApiName});
        }
    }

    public static PMHR_PokemonPictureVariantsConfig getInstance() {
        if (instance == null) {
            instance = new PMHR_PokemonPictureVariantsConfig();
        }
        return instance;
    }

    public String getPictureFieldApiName(String variant) {
        return regionVariantToFieldsApiNamesMap.get(variant).get(0);
    }

    public String getTypeFieldApiName(String variant) {
        return regionVariantToFieldsApiNamesMap.get(variant).get(1);
    }
}