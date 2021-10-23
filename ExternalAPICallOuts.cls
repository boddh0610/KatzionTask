/******************************************************
* Class Auther: Boddh Prakash
* Class Sibject: This apex class will be used to send Transaction and Transaction Items details to external API.
* 
*Last Modified By: Boddh Prakash
*******************************************************/
public class ExternalAPICallOuts {
    
    @future (callout=true) // This method will be used to send list transaction items to external API.
    public static void SendTransactionItems(String ParentId )
    {
        List<JSON2Apex> ListOfItems = new List<JSON2Apex>();
        List<TransactionItem__c	> lTransactionItems = new List<TransactionItem__c>();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        string endPointURL = 'The API URL is not Provided.';
        req.setEndpoint(endPointURL);
        string userName =  'UserName';
        string password = 'Password';
        req.setBody('{"username": "'+ userName+'","secure": "'+ password +'"}');
        string strReqBody = '{"username": "'+ userName+'","secure": "'+ password +'"}';
        string accessToken = '';
        Http http = new Http();
        //  HTTPResponse response = http.send(req);
        HTTPResponse response = new HttpResponse();
        if(Test.isRunningTest()) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"username": "'+username+'","secure": "'+Password+'"}');
            response = res;
        }
        else {
            response = http.send(req);
        } 
        if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody()); 
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() =='accessToken')){
                    parser.nextToken();
                    accessToken= parser.getText();
                }
            }
        }
        
        //*****************************************************************Data Mapping Code Block*****************
        
        if( ParentId != null && ParentId != '' )
        {
            lTransactionItems = [ Select Id, Name, Item_Cost__c,Transaction__c from  TransactionItem__c Where Transaction__r.Id=:ParentId ];
        	
            if( lTransactionItems !=null && lTransactionItems.size() > 0)
            {
               for( TransactionItem__c eachItem : lTransactionItems )
               {
                   JSON2Apex.Keys objKeys = new JSON2Apex.Keys();
                   JSON2Apex.Values objValues = new JSON2Apex.Values();

                   objKeys.TransactionItemID = eachItem.Id;
                   objValues.ItemName = eachItem.Name;
                   objValues.ItemCost = string.valueof(eachItem.Item_Cost__c);
                   JSON2Apex objMainWrap = new JSON2Apex();
                   objMainWrap.Keys=objKeys;
                   objMainWrap.Values=objValues;
                   
                   ListOfItems.add(objMainWrap);
                   
               }
            }
        }
        //*****************************************Data Mapping Code Block End*************************************
        
        //*************************** Calling External API *************************************
        if( accessToken != null && accessToken != '' || Test.isRunningTest())
        {
            Http http1 = new Http();
            HttpRequest request1 = new HttpRequest();
            request1.setHeader('Authorization', accessToken);
            request1.setHeader('Content-Type', 'application/json');
            string endPointURL1 = ' The API End Point Is not provided.';
            request1.setEndpoint(endPointURL1);
            request1.setMethod('POST');                
            request1.setBody( JSON.serialize(ListOfItems) );
            request1.setTimeout(2000);
            
            HttpResponse response1 = http1.send(request1);
            // Parse the JSON response
            if (response1.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +response1.getStatusCode() + ' ' + response1.getStatus());
            } else {
                // This logic is just to keep the api success and fail calls record.
                Transaction__c objParent = new Transaction__c(id=ParentId);
                objParent.All_Child_Sync__c = true;
                update objParent;
                System.debug(response1.getBody());
            }
            
            
        } 
    }
    
    @future (callout=true) // This method will be used to send  transaction details to external API.
    public static void SendTransaction(string TransactionID )
    {
        JSON2ApexTransaction objWrap = new JSON2ApexTransaction();
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        string endPointURL = 'The API URL is not Provided.';
        req.setEndpoint(endPointURL);
        string userName =  'UserName';
        string password = 'Password';
        req.setBody('{"username": "'+ userName+'","secure": "'+ password +'"}');
        string strReqBody = '{"username": "'+ userName+'","secure": "'+ password +'"}';
        string accessToken = '';
        Http http = new Http();
        //  HTTPResponse response = http.send(req);
        HTTPResponse response = new HttpResponse();
        if(Test.isRunningTest()) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"username": "'+username+'","secure": "'+Password+'"}');
            response = res;
        }
        else {
            response = http.send(req);
        } 
        if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody()); 
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() =='accessToken')){
                    parser.nextToken();
                    accessToken= parser.getText();
                }
            }
        }
        
        //*****************************************************************Data Mapping Code Block*****************
        
        if( TransactionID != null && TransactionID != '' )
        { 
            Transaction__c objTransaction = [ Select Id,Total_Cost__c, Total_Discount__c,Transaction_Count__c from Transaction__c where Id=:TransactionID];
            
            JSON2ApexTransaction.Keys ObjKey = new JSON2ApexTransaction.Keys();
                JSON2ApexTransaction.Values ObjValue = new JSON2ApexTransaction.Values();
                ObjKey.TransactionID = objTransaction.Id;
                ObjValue.TotalCost = string.valueof(objTransaction.Total_Cost__c);
                ObjValue.TotalDiscount = string.valueof(objTransaction.Total_Discount__c);
                ObjValue.TotalCount = string.valueof(objTransaction.Transaction_Count__c);
                objWrap.Keys = ObjKey;
                objWrap.Values = ObjValue;
        }
        //*****************************************Data Mapping Code Block End*************************************
        
        //*************************** Calling External API *************************************
        if( accessToken != null && accessToken != '')
        {
            Http http1 = new Http();
            HttpRequest request1 = new HttpRequest();
            request1.setHeader('Authorization', accessToken);
            request1.setHeader('Content-Type', 'application/json');
            string endPointURL1 = ' The API End Point Is not provided.';
            request1.setEndpoint(endPointURL1);
            request1.setMethod('POST');                
            request1.setBody( JSON.serialize(objWrap) );
            request1.setTimeout(2000);
            
            HttpResponse response1 = http1.send(request1);
            // Parse the JSON response
            if (response1.getStatusCode() != 201) {
                System.debug('The status code returned was not expected: ' +response1.getStatusCode() + ' ' + response1.getStatus());
            } else {
                // This logic is just to keep the api success and fail calls record.
                Transaction__c objParent = new Transaction__c(id=TransactionID);
                objParent.Is_Parent_Sync__c = true;
                update objParent;
                System.debug(response1.getBody());
            }
            
            
        } 
    }
}