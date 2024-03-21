import { LightningElement, api } from 'lwc';
/* Labels */
import PMHR_FinalTeamListSectionTitle from '@salesforce/label/c.PMHR_FinalTeamListSectionTitle';
import PMHR_FinalTeamListNoTeamsMessage from '@salesforce/label/c.PMHR_FinalTeamListNoTeamsMessage';
import PMHR_FinalTeamListNoMembersMessage from '@salesforce/label/c.PMHR_FinalTeamListNoMembersMessage';

export default class pmhrNuzlockeFinalTeamItem extends LightningElement {
    @api finalTeam;

    label;

    constructor() {
        super();
        this.label = {
            PMHR_FinalTeamListNoTeamsMessage,
            PMHR_FinalTeamListNoMembersMessage
        };
    }

    get finalTeamCardTitle() {
        return (this.finalTeam == null) ? PMHR_FinalTeamListSectionTitle : this.finalTeam.name;
    }

    get isFinalTeamNull() {
        return this.finalTeam == null;
    }

    get isFinalTeamEmpty() {
        return this.finalTeam?.members == null || this.finalTeam.members.length == 0;
    }

    get finalTeamUrl() {
        return (this.finalTeam == null) ? '' : '/' + this.finalTeam.id;
    }
}