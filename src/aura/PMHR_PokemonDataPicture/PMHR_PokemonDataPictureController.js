({
    init : function(component, event, helper) {
        helper.initData(component);
    },

    toggleModal : function(component, event, helper) {
        helper.toggleModal(component);
    },

    saveRecord : function(component, event, helper) {
        let record = component.get("v.record");
        let pictureUrl = component.get("v.pictureUrl");
        let type = component.get("v.standardType");
        let hasAlolanForm = component.get("v.hasAlolanForm");
        let alolanPictireUrl = component.get("v.alolanPictireUrl");
        let alolanType = component.get("v.alolanType");

        let allFieldsGiven = true;
        if ($A.util.isEmpty(pictureUrl) || $A.util.isEmpty(type)) {
            allFieldsGiven = false;
        } else if (hasAlolanForm && ($A.util.isEmpty(alolanPictireUrl) || $A.util.isEmpty(alolanType))) {
            allFieldsGiven = false;
        }

        if (allFieldsGiven) {
            if (!hasAlolanForm) {
                alolanPictireUrl = "";
                alolanType = "";
            }
            helper.saveRecord(component, pictureUrl, type, hasAlolanForm, alolanPictireUrl, alolanType);
        } else {
            let toastEvent = $A.get("e.force:showToast");
            if (toastEvent) {
                toastEvent.setParams({
                    "message": $A.get("$Label.c.Toast_Error_Missing_Fields"),
                    "type": "error"
                });
                toastEvent.fire();
            }
        }
    }
})