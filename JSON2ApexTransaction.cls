public class JSON2ApexTransaction {

	public class Keys {
		public String TransactionID;
	}

	public class Values {
		public String TotalCost;
		public String TotalDiscount;
		public String TransactionDate;
		public String TotalCount;
	}

	public Keys keys;
	public Values values;

	
	public static JSON2ApexTransaction parse(String json) {
		return (JSON2ApexTransaction) System.JSON.deserialize(json, JSON2ApexTransaction.class);
	}
}