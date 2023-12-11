BEGIN { FS="\t" }
{
	printf ("SET SQL_MODE = \"\"; ")
	if ( $1 > 0 ) {
		id++

		print "insert into "table" (VO_ANNONCE_ID) values ("id");";
		printf "update "table" set "
		
		for(i=1; i<max_i; i++) {
			if ( length($i) > 0  ) {
				val[title[i]] = $i;
	           printf ("%s=\"%s\", ", title[i], cleanSQL(val[title[i]]))
	        }
		}
		printf (" site=\"subito\" where VO_ANNONCE_ID=%s;\n", id)
	}
}
