public class LogAnalyticController {

	[HttpGet]
	public void CountBySeverity(){
		var QUERY = @"SELECT severity, total = COUNT(*)
				FROM WebSite.Logs
				GROUP BY severity
 				FOR JSON PATH";
		connection.QueryInto(Response.Body, QUERY);
	}

}