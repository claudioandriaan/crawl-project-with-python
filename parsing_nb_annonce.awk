BEGIN {
        nb=0;
                page=0;
}

/risultati/ {
        split($0, ar, /risultati<\/p>/);
        nbr=split(ar[1], ar1, /">/);
                gsub(/[^0-9]/, "", ar1[nbr]);
        nb=ar1[nbr];
  }
END {
print("nb_annonce="nb);
}
