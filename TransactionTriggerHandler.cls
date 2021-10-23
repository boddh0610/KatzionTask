public class TransactionTriggerHandler {
    
    public static void onAfter( list<Transaction__c> TriggerNew )
    {
        for( Transaction__c each : TriggerNew )
        {
            if( each.All_Child_Sync__c)
            {
                ExternalAPICallOuts.SendTransaction(each.id);
            }
        }
    }

}