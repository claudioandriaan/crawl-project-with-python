BEGIN   {        
	i=0;
	title[++i]="GARAGE_ID";          
	title[++i]="GARAGE_NAME";          
	title[++i]="ADRESSE";     
    title[++i]="CP";         
	title[++i]="MINI_SITE";             
	title[++i]="WEBSITE";				
	title[++i]="TELEPHONE";			
	max_i=i	;
}

# "name": "GRANSASSOCAR s.r.l.",
/"name":/{
    split($0,arr,"\"name\":");
    split(arr[2],arr_1,",");

    val["GARAGE_NAME"]=arr_1[1]
}

#"url": "http://www.gransassocar.com",
/"url":/{
    split($0,arr,"\"url\":");
    split(arr[2],arr_1,",");

    val["WEBSITE"]=arr_1[1]
}

#"address": "Via Gran Sasso, 20010 Bareggio MI, Italia",
/"address":/{
    split($0,arr,"\"address\":");
    split(arr[2],arr_1,"\",");

    val["ADRESSE"]=arr_1[1]

    nb=split(arr_1[1],arr_2,",");
    split(arr_2[nb-1],arr_3," ")
    val["CP"]=arr_3[1];

    if(match(val["CP"],/[a-zA-Z]/) > 0){
        val["CP"]="";
    }
}

# personal_page_id:    '53',
/personal_page_id:/{
    split($0,arr,"personal_page_id:");
    split(arr[2],arr_1,",");

    val["GARAGE_ID"]=arr_1[1];
    gsub(/[^0-9]/,"",val["GARAGE_ID"]);
}

# <link rel="canonical" href="https://impresapiu.subito.it/shops/53-gransassocar-s-r-l">
/rel="canonical"/{
    split($0,arr,"href=\"");
    split(arr[2],arr_1,"\"");
    val["MINI_SITE"]=arr_1[1]
}

# <div class="cell">
#     <span>0290360751</span>
/<div class="cell">/{
    getline;
    str=cleanSQL($0);

    gsub(/[^0-9]/,"",str);
   
    if(length(str) > 0 && length(val["TELEPHONE"])==0){
        val["TELEPHONE"]=str;
    }
}

END {

	if (val["GARAGE_ID"]!=""){
	    printf "update "table" set "

	    for (i=1; i<=max_i;i++) {
	        if (val[title[i]] != "" ) {
	           printf ("%s=\"%s\", ", title[i], cleanSQL(val[title[i]]))
	        }
	
	    }
	    printf " site=\"subito\" where site=\"subito\" and GARAGE_ID=\""cleanSQL(val["GARAGE_ID"])"\";\n"
	}

}