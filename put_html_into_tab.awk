BEGIN { c=1 }
/urls":{"default":"/ {
        nb=split($0, ar, "\"urn\":\"id:ad:")
        for(j=2; j<=nb; j++) {
                split(ar[j], tab, ":")
                val["CONTACT", c]=tab[1]
                split(ar[j], tab_1, "\"subject\":\"")
                split(tab_1[2], ar_1, "\"")
                val["NOM", c]=ar_1[1]
                split(ar[j], ar1, "urls\":\\{\"default\":\"")
                split(ar1[2], ar2, "\"")
                val["ANNONCE_LINK", c]=ar2[1]
                n=split(ar2[1], ar_2, "-")
                split(ar_2[n], ar_3, ".")
                val["ID_CLIENT", c]=ar_3[1]

                split(ar[j], ar_35, /"advertiser":{"name":"/)
                split(ar_35[2], ar_36, "\",\"")
                val["GARAGE_NAME", c]=ar_36[1]

                split(ar[j], ar_37, /","userId":"/)
                split(ar_37[2], ar_38, "\",\"")
                val["GARAGE_ID", c]=ar_38[1]

                val["REGION", c]=dep
                split(ar[j], ar_4, "Carburante\",\"values\":\\[\\{\"key\":\"[0-9]+\",\"value\":\"")
                split(ar_4[2], ar_5, "\"")
                val["CARBURANT", c]=ar_5[1]
                split(ar[j], ar_6, "Cambio\",\"values\":\\[\\{\"key\":\"[0-9]+\",\"value\":\"")
                split(ar_6[2], ar_7, "\"")
                val["BOITE", c]=ar_7[1]
                split(ar[j], ar_8, "Prezzo\",\"values\":\\[\\{\"key\":\"[0-9]+\",\"value\":\"")
                split(ar_8[2], ar_9, "\"")
                gsub("[^0-9]", "", ar_9[1])
                val["PRIX", c]=ar_9[1]
                split(ar[j], ar_10, "Anno di immatricolazione\",\"values\":\\[\\{\"key\":\"[0-9]+\",\"value\":\"")
                split(ar_10[2], ar_11, "\"")
                val["ANNEE", c]=ar_11[1]
                split(ar[j], ar_12, "Posti\",\"values\":\\[\\{\"key\":\"[0-9]+\",\"value\":\"")
                split(ar_12[2], ar_13, "\"")
                val["PLACE", c]=ar_13[1]
                split(ar[j], ar_14, "Tipologia\",\"values\":\\[\\{\"key\":\"[0-9]+\",\"value\":\"")
                split(ar_14[2], ar_15, "\"")
                val["CARROSSERIE", c]=ar_15[1]
                split(ar[j], ar_16, "\",\"weight\":[0-9]+,\"level\":[0-9]+,\"label\":\"Marca\"")
                n=split(ar_16[1], ar_17, "\"")
                val["MARQUE", c]=ar_17[n]
                split(ar[j], ar_18, "\",\"weight\":[0-9]+,\"level\":[0-9]+,\"label\":\"Modello\"")
                nbm=split(ar_18[1], ar_19, "\"")
                val["MODELE", c]=ar_19[nbm]
                split(ar[j], ar_20, "\",\"weight\":[0-9]+,\"level\":[0-9]+,\"label\":\"Versione\"")
                nbv=split(ar_20[1], ar_21, "\"")
                val["VERSION", c]=ar_21[nbv]
                split(ar[j], ar_22, "Numero di porte\",\"values\":\\[\\{\"key\":\"[0-9]+\",\"value\":\"")
                split(ar_22[2], ar_23, "\"")
                val["PORTE", c]=ar_23[1]
                split(ar[j], ar_24, "\"phone\":\"")
                split(ar_24[2], ar_25, "\"")
                val["TELEPHONE", c]=ar_25[1]
                split(ar[j], ar_26, "\"company\":")
                split(ar_26[2], ar_27, ",")

                if (match(ar_27[1], /true/)) {
                        val["TYPE", c]="pro"
                        split(ar[j], ar_28, "\"shopName\":\"")
                        split(ar_28[2], ar_29, "\"")
                        #val["GARAGE_NAME", c]=ar_29[1]
                }


                if (match(ar_27[1], /false/)) {
                        val["TYPE", c]="particuliers"
                }
                split(ar[j], ar_30, "town\":\\{\"id\":\"[0-9]+\",\"value\":\"")
                split(ar_30[2], ar_31, "\"")
                val["VILLE", c]=ar_31[1]
                split(ar[j], ar_32, "regionId\":\"[0-9]+\",\"shortName\":\"")
                split(ar_32[2], ar_33, "\"")
                val["DEPARTEMENT", c]=ar_33[1]



                c++
        }
}
END {
        max_c=c
        for (c=1; c<max_c; c++) {
                for(i=1; i<max_i; i++) {
                        gsub("\"", "", val[title[i], j])
                        gsub("&quot;", "", val[title[i], j])
                        printf("%s\t", trim(val[title[i] ,c]))
                        #printf("%s=\"%s\"\t", title[i], trim(val[title[i] ,c]))
                }
                printf("\n")
        }
}
function ltrim(s) {
        sub(/^[ \t]*/, "", s);
        return s
}

function rtrim(s) {
        sub(/[ \t]*$/, "", s);
        return s
}

function trim(s) {
        return rtrim(ltrim(s));
}
