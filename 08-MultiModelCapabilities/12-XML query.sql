/*
	Querying XML data
*/

DECLARE @i INT = 47;
DECLARE @x xml;
SET @x='<Family id="1804">  
    <row id="17"><name>Robin</name></row>  
    <row id="47"><name>Lana</name></row>  
    <row id="81"><name>Merriam</name></row>  
</Family>';

SELECT  
	family_id = @x.value('(/Family/@id)[1]', 'int'),
	family_81_name = @x.value('(//row[@id=81]/name)[1]', 'varchar(20)'),
	family_name = @x.query('//row[@id=sql:variable("@i")]/name')
SELECT
	family_member = xrow.value('name[1]', 'varchar(20)'),
	family_member_id = xrow.value('@id[1]', 'varchar(20)'),
	family_member_xml = xrow.query('.')
FROM 
	@x.nodes('/Family/row') AS Members(xrow)
WHERE 
	xrow.value('@id[1]', 'int') < 50
AND 
	xrow.exist('.[@id > 5]') = 1

/*
	Insert new XML element into the existing document.
*/
SET @x.modify('insert <row id="109"><name>Danica</name></row>     
			into (/Family)[1]') ;
SELECT @x;