#!/usr/bin/python
# -*- coding: utf-8 -*-
import json
import sys
import re
# Define variable
from imp import reload

import HTMLParser

reload(sys)
sys.setdefaultencoding('utf-8')

tableName = str(sys.argv[1])
jsonFile = str(sys.argv[2])

# siteName = str(sys.argv[3])
# id_client = str(sys.argv[4])

html_parser = HTMLParser.HTMLParser()


# Function definition is here
def clean_html(raw_html):
    cleanr = re.compile('<.*?>')
    cleantext = re.sub(cleanr, '', raw_html)
    return re.sub(r'\s+', ' ', cleantext).strip()


def cleanSQL(str_option):
    result = html_parser.unescape(str(str_option))
    result = clean_html(result)
    result = result.replace('\t', ' ').replace('\r', ' ').replace('\n', ' ').replace("\"", " ").replace("\',", ",").replace("\\", "")
    return re.sub(r'\s+', ' ', result).strip()

def parsing_data(items):

    val = {}
    c = 0

    for item in items:

        #init array value
        for i in range(max_i):
            val[title[i],c]=""

        # collection values 
        for key in item.keys():
            if key == "urn" and item["urn"] is not None:
                val["ID_CLIENT",c]=item["urn"].split(":list:")[1]
                val["CONTACT_NOM",c]=item["urn"].split(":list:")[0]

            if key == "urls" and item["urls"] is not None:
                for keys_item in item["urls"].keys():
                    if keys_item == "default" :
                        val["ANNONCE_LINK",c]=item["urls"]["default"]    
                               
            if key == "images" and item["images"] is not None:
                val["PHOTO"]=len(item["images"])    

            if key == "advertiser" and item["advertiser"] is not None:
                for keys_item in item["advertiser"].keys(): 
                    if keys_item == "company" and item["advertiser"]["company"] is True :
                        val["TYPE",c]="pro"
                    if keys_item == "company" and item["advertiser"]["company"] is False :
                        val["TYPE",c]="particuliers"  

                    if keys_item == "shopName":
                        val["GARAGE_NAME",c]=item["advertiser"]["shopName"]               
                    if keys_item == "name" and "shopName" not in item["advertiser"].keys()  : 
                        val["GARAGE_NAME",c]=item["advertiser"]["name"] 

                    if keys_item == "shopId":
                        val["GARAGE_ID",c]=item["advertiser"]["shopId"]   
                    if keys_item == "userId" and "shopId" not in item["advertiser"].keys()  :
                        val["GARAGE_ID",c]=item["advertiser"]["userId"]    

            if key == "subject" and item["subject"] is not None:
                val["NOM",c]=cleanSQL(item["subject"])
             
            if key == "body" and item["body"] is not None:
                val["ANNONCE_DESC",c]=cleanSQL(item["body"])

            if key == "features" and item["features"] is not None:
                for keys_item in item["features"].keys(): 
                    if keys_item == "/car" :
                        for val_item in item["features"]["/car"]["values"]:
                            if val_item["label"] == "Marca" : 
                                val["MARQUE",c]= val_item["value"]
                            if val_item["label"] == "Modello" : 
                                val["MODELE",c]= val_item["value"]
                            if val_item["label"] == "Versione" : 
                                val["VERSION",c]= val_item["value"]
                    
                    if keys_item == "/car_type" and len(item["features"]["/car_type"]["values"]) > 0:
                        val["CARROSSERIE",c]= item["features"]["/car_type"]["values"][0]["value"]

                    if keys_item == "/doors" and len(item["features"]["/doors"]["values"]) > 0:
                        val["PORTE",c]= item["features"]["/doors"]["values"][0]["value"]

                    if keys_item == "/fuel" and len(item["features"]["/fuel"]["values"]) > 0:
                        val["CARBURANT",c]= item["features"]["/fuel"]["values"][0]["value"]

                    if keys_item == "/price" and len(item["features"]["/price"]["values"]) > 0:
                        val["PRIX",c]= item["features"]["/price"]["values"][0]["key"]

                    if keys_item == "/gearbox" and len(item["features"]["/gearbox"]["values"]) > 0:
                        val["BOITE",c]= item["features"]["/gearbox"]["values"][0]["value"]

                    if keys_item == "/seats" and len(item["features"]["/seats"]["values"]) > 0:
                        val["PLACE",c]= item["features"]["/seats"]["values"][0]["value"]

                    if keys_item == "/mileage_scalar" and len(item["features"]["/mileage_scalar"]["values"]) > 0:
                        val["KM",c]= item["features"]["/mileage_scalar"]["values"][0]["key"]

                    if keys_item == "/year" and len(item["features"]["/year"]["values"]) > 0:
                        val["ANNEE",c]= item["features"]["/year"]["values"][0]["key"]

                    if keys_item == "/month" and len(item["features"]["/month"]["values"]) > 0:
                        val["MOIS",c]= item["features"]["/month"]["values"][0]["key"]

                    if keys_item == "/cubic_capacity" and len(item["features"]["/cubic_capacity"]["values"]) > 0:
                        val["CYLINDRE"]= item["features"]["/cubic_capacity"]["values"][0]["key"]
                    
                    if keys_item == "/vehicle_status" and len(item["features"]["/vehicle_status"]["values"]) > 0:
                        val["VN_IND", c] = item["features"]["/vehicle_status"]["values"][0]["key"]



            if key == "geo" and item["geo"] is not None:
                for keys_item in item["geo"].keys(): 
                    if keys_item == "town" :
                        val["VILLE",c]=item["geo"]["town"]["value"]
                    if keys_item == "city" :
                        val["DEPARTEMENT",c]=item["geo"]["city"]["value"]
                    if keys_item == "region" :
                        val["REGION",c]=item["geo"]["region"]["value"]
        c=c+1    
        # break

    ###### print out fields to extract.tab ######
    max_c=c
    c=0

    for c in range(max_c): 
       
        if val["ID_CLIENT",c] != "":
        
            if str(val["VN_IND", c]) == "1":
                val["VN_IND", c] = 0
            
            if str(val["VN_IND", c]) == "2":
                val["VN_IND", c] = 1

            if str(val["VN_IND", c]) == "3":
                val["VN_IND", c] = 1


            if str(val["TYPE",c])=="particuliers":
                val["TELEPHONE",c]=""
                val["GARAGE_ID",c]=""
                val["GARAGE_NAME",c]=""
            else:
                f = open(tableName, "a") # appending mode 
                f.write(str(val["GARAGE_ID",c])+"\t"+"https://www.subito.it/hades/v1/contacts/ads/"+ str(val["CONTACT_NOM",c])+"\n")
                f.close()

            
            val["CONTACT_NOM",c]=""

            string=""
            for i in range(max_i):
                string = string + cleanSQL(val[title[i],c]) + "\t"
            
            string = string + jsonFile + "\t"

            print (string)



# Define List Fields which will be identical naming and order with file list_table.awk
title=[]
title.append("ID_CLIENT")		
title.append("ANNONCE_LINK")	
title.append("CONTACT") 			
title.append("NOM")			
title.append("CARBURANT")	
title.append("BOITE")			
title.append("PRIX")		
title.append("KM")		
title.append("ANNEE")	 
title.append("MOIS")	 	
title.append("PLACE")		
title.append("CARROSSERIE")    
title.append("MARQUE")		
title.append("MODELE")		
title.append("VERSION")	
title.append("PORTE")             
title.append("TELEPHONE")		
title.append("TYPE")		              
title.append("GARAGE_NAME")           
title.append("GARAGE_ID")         
title.append("VILLE")    
title.append("DEPARTEMENT") 	           
title.append("CONTACT_NOM")   
title.append("ADRESSE") 
title.append("ANNONCE_DESC") 
title.append("REGION")  
title.append("PHOTO")  
title.append("CYLINDRE")  
title.append("VN_IND")  

max_i=len(title)



with open(jsonFile) as fileData:

    content = fileData.read()

    # collect json text in file HTML
    data_json = content.split("<script id=\"__NEXT_DATA__\" type=\"application/json\">")[1].split("</script>")[0]

    # print (data_json)

    # converting json string to object
    data = json.loads(data_json, encoding='utf-8')    

    # getting list ads
    items = data["props"]["pageProps"]["initialState"]["items"]["list"]

    dict_items=[]

    for ele in items:
        dict_items.append(ele["item"])

       
    parsing_data(dict_items)
