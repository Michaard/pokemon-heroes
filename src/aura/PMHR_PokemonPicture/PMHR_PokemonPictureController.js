({
    refreshPicture : function(component, event, helper) {
        let recordLoader = component.find("recordLoader");
        if (recordLoader) {
            recordLoader.reloadRecord();
        }
    }
})