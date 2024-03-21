import { LightningElement, api } from 'lwc';

export default class pmhrNuzlockeFinalTeamMember extends LightningElement {
    @api teamMember;

    get recordUrl() {
        return "/" + this.teamMember.id;
    }
}