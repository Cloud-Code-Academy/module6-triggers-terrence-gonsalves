trigger OpportunityTrigger on Opportunity (before update, before delete) {
    new OpportunityTriggerHandler().run();
}