import { LightningElement, api } from 'lwc';

export default class pmhrEvolvePokemonItem extends LightningElement {
    @api formData;

    handleItemClick() {
        let event = new CustomEvent('itemclick', {
            detail: this.formData
        });
        this.dispatchEvent(event);
    }
}