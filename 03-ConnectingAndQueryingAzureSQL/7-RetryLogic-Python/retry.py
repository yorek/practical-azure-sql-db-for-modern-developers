import pyodbc
import random
from tenacity import *
import logging

logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
logger = logging.getLogger(__name__)

server = 'tcp:<servername>.database.windows.net,1433'
database = 'WideWorldImporters-Full'
username = '<username>'
password = '<password>'


def is_retriable(value):
    # Define all retriable error codes from https://docs.microsoft.com/en-us/azure/sql-database/troubleshoot-connectivity-issues-microsoft-azure-sql-database
    RETRY_CODES = [  
        1204,   
        1205,  
        1222,  
        49918, 
        49919, 
        49920, 
        4060,  
        4221,  
        40143, 
        40613, 
        40501, 
        40540, 
        40197, 
        10929, 
        10928, 
        10060, 
        10054, 
        10053, 
        233,
        208,
        42000,   
        64,
        20,
        0
        ]
    ret = value in RETRY_CODES
    return ret

@retry(stop=stop_after_attempt(3), wait=wait_fixed(10), after=after_log(logger, logging.DEBUG))
def my_database_operation():

    global server
    global realserver
    global database
    global username
    global password

    try:
        cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password+';Connect Timeout=10;')
        cursor = cnxn.cursor()

        tsql = "SELECT @@VERSIONZZZ;"

        with cursor.execute(tsql):
            row = cursor.fetchone()
            print (str(row[0]))
    except Exception as e:
        if isinstance(e,pyodbc.ProgrammingError) or isinstance(e,pyodbc.OperationalError):            
            if is_retriable(int(e.args[0])):
                raise
    pass

my_database_operation()