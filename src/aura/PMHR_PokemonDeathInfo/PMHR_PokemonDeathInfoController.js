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
        let deathReason = component.get("v.deathReason");
        if ($A.util.isEmpty(deathLevel) || $A.util.isEmpty(deathReason)) {
            helper.showErrorMessage(component, $A.get("$Label.c.Toast_Error_Missing_Fields"));
        } else if (isDead && (deathLevel < 1 || deathLevel > 100)) {
            helper.showErrorMessage(component, $A.get("$Label.c.Toast_Error_Death_Level"));
        } else if (isDead && !($A.util.isEmpty(deathLevel) || $A.util.isEmpty(deathReason))) {
            helper.saveRecord(component, isDead, deathLevel, deathReason);
        } else if (!isDead) {
            helper.saveRecord(component, isDead, "", "");
        }
    }
})