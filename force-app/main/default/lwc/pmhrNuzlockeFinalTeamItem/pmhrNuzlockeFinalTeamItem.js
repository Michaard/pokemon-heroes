import { LightningElement, api } from 'lwc';
/** labels **/
import PMHR_Section_Title_Final_Team_Members from '@salesforce/label/c.PMHR_Section_Title_Final_Team_Members'
import PMHR_Placeholder_Final_Team_Members_List from '@salesforce/label/c.PMHR_Placeholder_Final_Team_Members_List'
import PMHR_Placeholder_Empty_Final_Team_Members_List from '@salesforce/label/c.PMHR_Placeholder_Empty_Final_Team_Members_List'

export default class PMHR_NuzlockeFinalTeamItem extends LightningElement {
    @api finalTeam;
    labels;

    constructor() {
        super();
        this.labels = {
            PMHR_Section_Title_Final_Team_Members,
            PMHR_Placeholder_Final_Team_Members_List,
            PMHR_Placeholder_Empty_Final_Team_Members_List
        };
    }

    get finalTeamCardTitle() {
        return this._checkIsFinalTeamNull() ? this.labels.PMHR_Section_Title_Final_Team_Members : this.finalTeam.name;
    }

    get isFinalTeamNull() {
        return this._checkIsFinalTeamNull();
    }

    get isFinalTeamEmpty() {
        return this._checkIsFinalTeamNull() == false && (this.finalTeam.members == null || this.finalTeam.members.length == 0);
    }

    get finalTeamUrl() {
        return this._checkIsFinalTeamNull() ? '' : '/' + this.finalTeam.id;
    }

    _checkIsFinalTeamNull() {
        return this.finalTeam == null;
    }
}