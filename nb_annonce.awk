BEGIN {
        nb=0;
                page=0;
}

/risultati/ {
        split($0, ar, /risultati<\/p>/);
        nbr=split(ar[1], ar1, /">/);
		gsub(/[^0-9]/, "", ar1[nbr]);
        nb=ar1[nbr];	
			
		page=nb/28
		mod=nb%28
		p=int(page)
		if ( $mod -gt 0 -a $page -gt 0 ) {
			p=p+1
		}
		
}

#/totalPages/ {
#        split($0, pg, /"totalPages":/);
#        split(pg[2], pg1, /,/);
#        gsub(/[^0-9]/, "", pg1[1]);
#        if (page==0) {
#                page=pg1[1];
#        }
#}


END {
    # print("nb_annonce="nb";");
    print ("nb_annonce="nb";" "nb_page="p";");
}


