import json

file = open("pmt_tables.json","r")

data = json.load(file)

file.close()

for table in data:
 print("IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE name = '" + table['name'] + "' AND xtype = 'U')\nBEGIN")
