import { LightningElement, api } from 'lwc';

export default class PmhrEvolvePokemonItem extends LightningElement {
    @api formData;

    handleFormClick() {
        let event = new CustomEvent('formclick', {
            detail: this.formData
        });
        this.dispatchEvent(event);
    }
}