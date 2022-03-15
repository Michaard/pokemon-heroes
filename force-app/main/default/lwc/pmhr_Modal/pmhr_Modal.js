import { LightningElement, api } from 'lwc';
import DEFAULT_TEMPLATE from './pmhr_Modal.html'

export default class Pmhr_Modal extends LightningElement {
    @api display;
    @api templateBody;

    constructor() {
        super();
        this.display = false;
        this.templateBody = DEFAULT_TEMPLATE;
    }

    @api showModal() {
        this.display = true;
    }

    @api hideModal() {
        this.display = false;
    }

    render() {
        return this.display ? this.templateBody : DEFAULT_TEMPLATE;
    }
}