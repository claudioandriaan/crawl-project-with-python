BEGIN   {        
	i=1;
	title[i]="TELEPHONE";			i++;	
	max_i=i	;
}
{ gsub("\r", "", $0)}

/"phone_number":/ {
	split($0, ar, "\"phone_number\":\"")
	split(ar[2], ar_1, "\"")
	val["TELEPHONE"]=ar_1[1]
}

END{
	n=split(FILENAME, ar1, "_")
	split(ar1[n], ar2, /\.html|\.txt/)
	garage_id=ar2[1]
	
	if(length(val["TELEPHONE"]) > 0){

		printf("update "table" set ")
		for(i=1;i<max_i;i++) {
			if (val[title[i]]!="") {
				printf("%s=\"%s\", ", title[i], val[title[i]])
			}
		}
		printf (" SITE=\"subito\" where SITE=\"subito\" and GARAGE_ID=\"%s\";\n", garage_id)
	}
}