BEGIN{
    c=0;
}

# <h2 class="shop_listing_name">
#     <a href="https://impresapiu.subito.it/shops/7925-eurotarget"">
/<h2 class="shop_listing_name">/{
    c++        
    getline; 

    split($0, ar, "<a href=\""); 
    split(ar[2], ar1, "\"");
    url[c]=ar1[1]; 

    nb=split(ar1[1],arr_2,"/");
    split(arr_2[nb],arr_3,"-")
    id[c]=arr_3[1]; 

}
    
END{
    max_c=c; 
    for (c=1; c<=max_c; c++){
        if(length(id[c]) > 0 && length(url[c]) > 0){
            print id[c]"\t"url[c]
        }
       
    }
}