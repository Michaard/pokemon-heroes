import { api, LightningElement } from 'lwc';
import Pmhr_Modal from 'c/pmhr_Modal';
import TEMPLATE_HTML from './pmhr_EditPokemonDeathInfoModal.html'

export default class Pmhr_EditPokemonDeathInfoModal extends Pmhr_Modal {
    constructor() {
        super();
        this.templateBody = TEMPLATE_HTML;
    }
}