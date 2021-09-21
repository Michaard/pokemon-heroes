({
    init : function(component, event, helper) {
        helper.initData(component);
    },

    toggleModal : function(component, event, helper) {
        helper.toggleModal(component);
    },

    saveRecord : function(component, event, helper) {
        let record = component.get("v.record");
        let isDead = !component.get("v.isAlive");

        let deathLevel = component.get("v.deathLevel");
        let deathLevelInput = component.find("deathLevelInput");
        let isDeathLevelInputFilled
        if (deathLevelInput) {
            isDeathLevelInputFilled = !helper.showErrorOnFieldIfInvalid(component, deathLevelInput, deathLevel);
        } else {
            isDeathLevelInputFilled = true;
        }

        let deathReason = component.get("v.deathReason");
        let deathReasonInput = component.find("deathReasonInput");
        let isDeathReasonInputFilled;
        if (deathReasonInput) {
            isDeathReasonInputFilled = !helper.showErrorOnFieldIfInvalid(component, deathReasonInput, deathReason);
        } else {
            isDeathReasonInputFilled = true;
        }

        if (isDeathLevelInputFilled && isDeathReasonInputFilled) {
            if (isDead) {
                helper.saveRecord(component, isDead, deathLevel, deathReason);
            } else if (!isDead) {
                helper.saveRecord(component, isDead, "", "");
            }
        }
    }
})