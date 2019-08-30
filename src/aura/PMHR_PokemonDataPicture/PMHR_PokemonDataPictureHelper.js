({
    initData : function(component) {
        let pokemonData = component.get("v.record");
        if (pokemonData) {
            let pictureUrl = pokemonData.Picture_Url__c;
            let type = pokemonData.Type__c;
            let alolanPictireUrl = pokemonData.Alolan_Picture_Url__c;
            let alolanType = pokemonData.Alolan_Type__c;
            let hasAlolanForm = pokemonData.Has_Alolan_Variant__c;

            component.set("v.pictureUrl", pictureUrl);
            component.set("v.standardType", type);
            component.set("v.alolanPictireUrl", alolanPictireUrl);
            component.set("v.alolanType", alolanType);
            component.set("v.hasAlolanForm", hasAlolanForm);
        }
    },

    toggleModal : function(component) {
        let modal = component.find("editModal");
        let backdrop = component.find("editModalBackdrop");

        if (modal) {
            $A.util.toggleClass(modal, 'slds-fade-in-open');
        }
        if (backdrop) {
            $A.util.toggleClass(backdrop, 'slds-backdrop_open');
        }

        this.initData(component);
    },

    saveRecord : function(component, pictureUrl, type, hasAlolanForm, alolanPictireUrl, alolanType) {
        let recordLoader = component.find("recordLoader");
        if (recordLoader) {
            let record = component.get("v.record");
            record.Picture_Url__c = pictureUrl;
            record.Type__c = type;
            record.Has_Alolan_Variant__c = hasAlolanForm;
            record.Alolan_Picture_Url__c = alolanPictireUrl;
            record.Alolan_Type__c = alolanType;
            recordLoader.saveRecord($A.getCallback(function(saveResult) {
                if (saveResult.state === "SUCCESS") {
                    let toastEvent = $A.get("e.force:showToast");
                    if (toastEvent) {
                        toastEvent.setParams({
                            "message": $A.get("$Label.c.Toast_Success_Picture_Update"),
                            "type": "success"
                        });
                        toastEvent.fire();
                    }
                } else if (saveResult.state === "ERROR") {
                    let toastEvent = $A.get("e.force:showToast");
                    if (toastEvent) {
                        toastEvent.setParams({
                            "message": $A.get("$Label.c.Toast_Error_Record_Update"),
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                }
            }));
            component.set("v.record", record);
            this.toggleModal(component);
        }
    }
})