/*
	Querying XML data using XQuery
*/

DECLARE @x AS XML;
SET @x = N'<Family id="1804">  
    <row id="17"><name>Robin</name></row>  
    <row id="47"><name>Lana</name></row>  
    <row id="81"><name>Merriam</name></row>  
</Family>';

SELECT xrow.query(
'let $r := self::node() 
  return <person id="{$r/@id}">{$r/name/text()}</person>')
FROM @x.nodes('/Family/row') AS Members(xrow);