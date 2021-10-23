/******************************************************
* Class Auther: Boddh Prakash
* Class Sibject: This apex class will be used to parse the request JSON data.
* 
*Last Modified By: Boddh Prakash
*******************************************************/

public class JSON2Apex {

    public Keys keys;
    public Values values;

    public class Keys {
        public String TransactionItemID;
    }

    public class Values {
        public String ItemCost;
        public String ItemName;
    }

    
    public static List<JSON2Apex> parse(String json) {
        return (List<JSON2Apex>) System.JSON.deserialize(json, List<JSON2Apex>.class);
    }
}