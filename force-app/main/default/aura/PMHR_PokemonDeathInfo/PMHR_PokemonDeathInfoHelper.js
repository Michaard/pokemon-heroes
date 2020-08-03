({
    initData : function(component) {
        let pokemon = component.get("v.record");
        if (pokemon) {
            let isDead = pokemon.Death__c;
            let deathLevel = pokemon.Death_Level__c;
            let deathReason = pokemon.Cause_of_Death__c;

            component.set("v.isAlive", !isDead);
            component.set("v.deathLevel", deathLevel);
            component.set("v.deathReason", deathReason);
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

        this.hideErrorMessage(component);
        this.initData(component);
    },

    saveRecord : function(component, isDead, deathLevel, deathReason) {
        let recordLoader = component.find("recordLoader");
        let helper = this;
        if (recordLoader) {
            let record = component.get("v.record");
            record.Death__c = isDead;
            record.Death_Level__c = deathLevel;
            record.Cause_of_Death__c = deathReason;
            recordLoader.saveRecord($A.getCallback(function(saveResult) {
                let state = saveResult.state;
                if (state === "SUCCESS") {
                    let toastEvent = $A.get("e.force:showToast");
                    if (toastEvent) {
                        toastEvent.setParams({
                            "message": $A.get("$Label.c.Toast_Success_Death_Info_Update"),
                            "type": "success"
                        });
                        toastEvent.fire();
                    }
                    helper.toggleModal(component);
                    component.set("v.record", record);
                } else if (state === "ERROR") {
                    let errors = saveResult.error;
                    let auraUtility = component.find("auraUtility");
                    helper.showErrorMessage(component, auraUtility.parseErrorFromAction(errors));
                }
            }));
        }
    },

    showErrorMessage : function(component, errorMessage) {
        let componentErrorMessage = component.find("componentErrorMessage");
        if (componentErrorMessage) {
            componentErrorMessage.showErrorMessage(true, errorMessage);
        }
    },

    hideErrorMessage : function(component) {
        let componentErrorMessage = component.find("componentErrorMessage");
        if (componentErrorMessage) {
            componentErrorMessage.showErrorMessage(false, null);
        }
    },

    showErrorOnFieldIfInvalid : function(component, field, fieldValue) {
        let auraUtility = component.find("auraUtility");
        return auraUtility.showErrorOnFieldIfEmpty(field, fieldValue);
    }
})