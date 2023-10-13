# --- Check student servers ----
# Check http to student servers and update state in DB
#
import sys
import time
from xmlrpc import server
import mysql.connector
import os
#from dotenv import load_dotenv
from pathlib import Path
import requests

#######################################
# Read variables to connect DataBase
#dotenv_path = Path('.env')
#load_dotenv(dotenv_path=dotenv_path)

DBHOST    = os.getenv('DBHOST')
DBUSER    = os.getenv('DBUSER')
DBNAME    = os.getenv('DBNAME')
DBTABLE   = os.getenv('DBTABLE')
DBPORT    = os.getenv('DBPORT')
DBPASS    = os.getenv('DBPASS')

#######################################
# Connect to DataBase
try: 
  mydb = mysql.connector.connect(
    host=DBHOST,
    user=DBUSER,
    password=DBPASS,
    database=DBNAME,
    port=DBPORT
  )
  mycursor = mydb.cursor()
except mysql.connector.Error as e:
  print("Error DB: {}".format(e))
else:
  #######################################
  # Loop check Student Servers
  while True:
    # Read list of student Servers
    sql = "SELECT server_ip FROM "+ DBTABLE
    try:
      mycursor.execute(sql)
      server_list  = mycursor.fetchall()
    except mysql.connector.Error as e:
      print("Error DB: {}".format(e))
    else:
      #######################################
      # Connect to servers
      for server_ip in server_list:
        rURL = 'http://'+ server_ip[0]
        print (rURL)
        test_result = "0"
        try: 
          webUrl = requests.get(rURL, timeout=1)
        except requests.exceptions.RequestException as e:
          print("Error connection")
        else:
        #  if webUrl.status_code == 200 : test_result = "1"
          test_result = "1"
  
        ######################################################
        # Update DB with status (UPDATE: server_test,timestamp)
        localtime = time.localtime()
        timestamp = time.strftime("%I:%M:%S %p", localtime)
        sql_timestamp = "UPDATE "+ DBTABLE + " SET server_check='"+ timestamp +"' WHERE server_ip ='" + server_ip[0] + "'"
        sql_check = "UPDATE " + DBTABLE + " SET server_test='"+ test_result +"' WHERE server_ip ='" + server_ip[0] + "'"   
        print ("updating DB")
        try: 
          if test_result == "0" : mycursor.execute(sql_timestamp)
          mycursor.execute(sql_check)
          mydb.commit()
        except mysql.connector.Error as e:
            print("Error DB: {}".format(e))
        else:
          print(mycursor.rowcount, "record(s) affected")
    
    ######################################################
    # Sleep for
    time.sleep(35)
