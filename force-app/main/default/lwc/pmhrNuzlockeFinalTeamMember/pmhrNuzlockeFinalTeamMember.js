import { LightningElement, api } from 'lwc';

export default class PMHR_NuzlockeFinalTeamMember extends LightningElement {
    @api teamMember;

    get recordUrl() {
        return "/" + this.teamMember.id;
    }
}