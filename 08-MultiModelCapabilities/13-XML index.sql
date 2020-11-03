/*
	Adding XML index on XML column
*/
DROP TABLE IF EXISTS XmlDocs;
GO
CREATE TABLE XmlDocs (
	id INT IDENTITY PRIMARY KEY, 
	doc XML
);
GO

CREATE SELECTIVE XML INDEX sxi_docs  
ON XmlDocs(doc) 
FOR (
	path_price = '/row/info/price' AS SQL INT,   
	path_name = '/row/info/name' AS SQL NVARCHAR(100)  
);