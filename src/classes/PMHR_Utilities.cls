public class PMHR_Utilities {
    public static final String REGION_VARIANT_STANDARD = 'Standard';
    public static final String REGION_VARIANT_ALOLAN = 'Alolan';
    public static final String REGION_VARIANT_GALARIAN = 'Galarian';

    public static final String GENDER_MALE = 'Male';

    public static final List<PicklistEntry> POKEMON_REGIONAL_VARIANT = Pokemon__c.Region_Specific_Variant__c.getDescribe().getPicklistValues();

    public static List<String> getPokemonRegionalVariantsValues() {
        List<String> regionSpecificVariants = new List<String>();
        for (PicklistEntry variant : PMHR_Utilities.POKEMON_REGIONAL_VARIANT) {
            regionSpecificVariants.add(variant.getValue());
        }
        return regionSpecificVariants;
    }

    public static Set<Id> fetchSObjectListToIdSet(List<SObject> sObjectList, SObjectField field, Boolean includeNulls) {
        String fieldName = field.getDescribe().getName();
        Set<Id> result = new Set<Id>();
        for (SObject so : sObjectList) {
            Id val = (Id) so.get(fieldName);
            if (val != null || includeNulls) {
                result.add(val);
            }
        }
        return result;
    }

    public static Set<String> fetchSObjectListToStringSet(List<SObject> sObjectList, SObjectField field, Boolean includeNulls) {
        String fieldName = field.getDescribe().getName();
        Set<String> result = new Set<String>();
        for (SObject so : sObjectList) {
            String val = String.valueOf(so.get(fieldName));
            if (val != null || includeNulls) {
                result.add(val);
            }
        }
        return result;
    }

    public static Id getRecordTypeIdByName(Schema.DescribeSObjectResult sObjectDescribe, String recordTypeName) {
        return sObjectDescribe.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
}