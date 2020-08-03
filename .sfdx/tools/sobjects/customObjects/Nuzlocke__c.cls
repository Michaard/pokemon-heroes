// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Nuzlocke__c {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Double Pokemons_Caught__c;
    global Double Pokemons_Deceased__c;
    global Date Start_Date__c;
    global Date End_Date__c;
    global String End_Status__c;
    /* Check, if Nuzlocke run involves more than one Elite Four fights, thus assembling more than one final team
    */
    global Boolean Multiple_Elite_Four_Fights__c;
    global Boolean Is_Finished__c;
    global String Allowed_Catching_Methods_Per_Area__c;
    global String Legendaries_Rule__c;
    global String Safari_Zone_Rule__c;
    global Hero__c Hero__r;
    global Id Hero__c;
    global String Game_Version__c;
    global String Rival_Name__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<Attachment> Attachments;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<Final_Team__c> Final_Teams__r;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<Nuzlocke__Share> Shares;
    global List<Pokemon__c> Pokemons__r;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<TopicAssignment> TopicAssignments;
    global List<ContentDistribution> RelatedRecord;
    global List<ContentVersion> FirstPublishLocation;
    global List<EventChangeEvent> What;
    global List<EventRelationChangeEvent> Relation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskChangeEvent> What;

    global Nuzlocke__c () 
    {
    }
}