public class TransactionItemTgrHandler {
    
    public static void onAfterInsert( List<TransactionItem__c> TriggerNew )
    {
        
        for( TransactionItem__c eachItem : TriggerNew )
        {
            if( eachItem.Transaction_Count__c ==  eachItem.Related_Transaction_Count__c )
            {
                System.debug('---Is Method Called--->True');
                // Calling External API class to send list of transaction Items.
				ExternalAPICallOuts.SendTransactionItems(eachItem.Transaction__c);
                
            }
        }
            
    }

}