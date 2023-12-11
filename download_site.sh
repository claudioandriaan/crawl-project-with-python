#!/bin/bash
. ~/Lib_Autobiz/Utils.sh
. ~/Lib_Autobiz/list_proxies.sh

ip=0
u_a=0
. /usr/local/bin/list_useragent.sh

# function random user_agent and ip address
incr_ip() {
	a=`od -vAn -N4 -tu4 < /dev/urandom | sed 's/ //g'`

	i=0;   
    # PROXY_ARR[$i]="172.16.2.14:3128"; let "i=i+1";   
    # PROXY_ARR[$i]="172.16.2.14:3228"; let "i=i+1";   

    # Port from 6001 to 6040
    # port=6001;
    # while [ ${port} -le 6040 ]
    # do
        # PROXY_ARR[$i]="172.16.2.14:${port}"; 
            
        # let "port=port+1";
        # let "i=i+1";
    # done
	
	PROXY_ARR[$i]="brd-customer-hl_ea6377fa-zone-zone_new:zzb38oom5oxa@brd.superproxy.io:22225"; let "i=i+1";
	
    max_ip=$i;    
    let "id_proxies=a % max_ip"


    # let "ip=(ip+1) % max_ip"
    
    u_a=1;
    #USERAGENT_ARR[$u_a]="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.3945.130 Safari/537.36"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36 Edg/92.0.902.84"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.3945.130 Safari/537.36"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36"; let "u_a=u_a+1";
	USERAGENT_ARR[$u_a]="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:88.0) Gecko/20100101 Firefox/88.0"; let "u_a=u_a+1";
	max_useragent=$u_a;
	#let "u_a=(u_a+1) % max_useragent"	
	let "u_a=a % max_useragent"
}
ExitProcess () {
        status=$1
        if [ ${status} -ne 0 ]
        then
                echo -e $usage
                echo -e $error
        fi
        kill -9 ${pid_1}
        rm ${work_dir}/${d}/*.$$ ${work_dir}/*.$$ > /dev/null 2>&1 &
        # on arrête les programmes dans le bg
        max_pid=${pid}
        pid=1
        while [ ${pid} -lt ${max_pid} ]
        do
                kill -9 ${pid_arr[$pid]}
                rm ${work_dir}/*.${pid_arr[$pid]}
                let "pid=pid+1"
        done
        exit ${status}
}
#########################
# CHECK WRONG FILE      #
# Return : 1 -> errors  #
#          0 -> ok      #
#########################
function check_wrong_file(){
    file_name=$1;

    # inexist file -> erros
    if [ ! -e ${file_name} -o ! -s ${file_name} ];then
        return 1;
    fi

    # contains code js google captcha
    grep 'geo.captcha-delivery.com' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi

    grep '421 Misdirected Request' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
    grep '403 ERROR' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
    grep 'ERR_TUNNEL_CONNECTION_FAILED' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
    grep 'waiting for selector "iframe" failed: timeout 30000ms exceeded' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi

	grep 'Error 403' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	    
	grep 'Vous ne pouvez pas acc' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi

    grep 'Su Subito trovi tutto. Questa pagina, per' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep 'Whoops, looks like something went wrong' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep '502 Server Error' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep '502 Bad Gateway' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep 'Please enable JS and disable any ad blocker' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep '503 Service Unavailable' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep 'Your device has been paused' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep 'Access Denied' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
	
	grep '<title>Subito.it' ${file_name} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        return 1;
    fi
    	
    return 0;
}


function download_url(){
    local src_link=${1};
    local file=${2};


    
    if [ -e ${file} ]; then
        check_wrong_file ${file}
        if [ $? -eq 1 ]; then
            rm -f ${file}  
        fi
    fi

    local loop=0
    local max_loop=2;
    local cookie=${work_dir}/cookies.$$

    while [ ${loop} -lt ${max_loop} ]
    do
            # on loop tant que la page n'est pas telecharge proprement
            if [ ! -e ${file} -o ! -s "${file}" ]; then

                incr_ip
				curl -k -L -x "http://${PROXY_ARR[$id_proxies]}"  --location ${src_link} -A "${USERAGENT_ARR[$u_a]}" -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' -H 'Connection: keep-alive'  -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-Fetch-Dest: document' -H 'Sec-Fetch-Mode: navigate' -H 'Sec-Fetch-Site: none' -H 'Sec-Fetch-User: ?1' -b "${cookie}" -c "${cookie}" --retry 2 --retry-max-time 60 ${src_link} --compressed -o ${file} 2>&1 

            fi
            
            # on verifie que la page a ete telechargee jusqu'au bout (presence du </html>)
            # si ca n'est pas le cas , on efface 
           check_wrong_file ${file}
            if [ $? -eq 1 ]; then
                rm -f ${file}
                let "loop=loop+1"
            else
                # la page est OK - on sort du loop
                loop=${max_loop}

                echo "* Successful downloaded: ${src_link}  ==> ${PROXY_ARR[$id_proxies]} ==> ${file}"
            fi
    done  

     # remove temporary file
    rm -rf ${cookie}

}

########################
# DOWNLOAD DETAIL MODE #
########################
function download_detail_mode(){

    local file_name=${1};

    local processMax=100;
    local listProcessPids

    while read -r line
    do
        FS='\t' read -r -a array <<< "$line"
        id_client="${array[0]}"
        src_link="${array[1]}"

        local file="${work_dir}/TELEPHONE/annonce_${id_client}.html"


        if [ ${#id_client} -eq 0 -o ${#src_link} -eq 0 ];then
            continue; # there are not id_client or url
        fi

        if [ -e ${file} -a -s ${file} ]; then
            continue; # file exists
        fi


        # Make downloading async
        while [ "${#listProcessPids[@]}" -gt "${processMax}" ]; do

            for i in "${!listProcessPids[@]}" ; do # loop key in listProcessPids

                # Check the pid done or not
                if ! kill -0 "${listProcessPids[${i}]}" # The pid is gone
                then
                    unset "listProcessPids[${i}]" # Remove the pid out of the listProcessPids
                fi
            done

            if [ "${#listProcessPids[@]}" -lt "${processMax}" ]; then
                break
            fi

            sleep 1

        done

        if [ ! -e ${file} -o ! -s "${file}" ]; then
                download_url ${src_link} ${file} &

            # Take the pid and put it in the array
            listProcessPids+=($!)
        fi

    done < ${file_name}

    # waiting all processes to complete
    wait "${listProcessPids[@]}"

    # Empty an array
    unset listProcessPids

    # remove temporary file
    rm -rf ${work_dir}/${d}/cookies.*  ${work_dir}/err.*

}



my_wget () {
	src_link=${my_url};
	file=${out};
	
	local max_loop=8;
	local loop=0;
	if [ -e ${out} ]; then
		check_wrong_file ${out}
		if [ $? -eq 1 ]; then
			rm -f ${out}  
		fi
	fi
	while [ ${loop} -lt ${max_loop} ]
	do
		# on loop tant que la page n'est pas telecharge proprement
		if [ ! -e ${file} -o ! -s "${file}" ]; then
			incr_ip
			test ${get_all_ind} -eq 1 &&  curl -L --proxy "http://${PROXY_ARR[$id_proxies]}" -k --location "${src_link}" -A "${USERAGENT_ARR[$u_a]}" -H "Connection: keep-alive" -c ${cookie} -b ${cookie} --connect-timeout 5 --retry 2  > ${file} 
		fi
		grep "html lang=\"it\"" ${file} > /dev/null
		if [ $? -ne 0 ]; then
			rm -f ${file}
			let "loop=loop+1"
		else
			grep "Vous ne pouvez pas acc" ${file} > /dev/null
			if [ $? -eq 0 ]; then
				rm -f ${file}
				let "loop=loop+1"
			else
				grep "Su Subito trovi tutto. Questa pagina, per" ${file} > /dev/null
				if [ $? -eq 0 ]; then
					rm -f ${file}
					let "loop=loop+1"
				else 
					grep "Su Subito trovi tutto. Questa pagina, per" ${file} > /dev/null
					if [ $? -eq 0 ]; then
						rm -f ${file}
						let "loop=loop+1"
					# la page est OK - on sort du loop
					else 
						loop=${max_loop}
						sleep 0.25
					fi
				fi
			fi
		fi
	done
}

download_region () {
	my_url="${region_url}auto/?order=${SORT}"
	out="${work_dir}/${d}/${region_name}/${region_name}-page-1.html"
	cookie="${work_dir}/${d}/${region_name}/cockies.$$"
	my_wget
	wait
	
	awk -f ${work_dir}/nb_annonce.awk ${out} > ${work_dir}/${d}/nb_annonce.$$
    . ${work_dir}/${d}/nb_annonce.$$

    let "nb_page=nb_annonce/nb_retrieve_per_page"
    let "mod=nb_annonce%nb_retrieve_per_page"
	let "nombre_annonces=nb_annonce"
    if [ ${mod} -gt 0 -a ${nb_page} -gt 0 ]
    then
        let "nb_page=nb_page+1"
    fi

for SORT in priceasc pricedesc 
do
	if [ ${nb_page} -ge 2 ]
	then
        p=1
        while [ ${p} -le ${nb_page} ]
        do
		    my_url="${region_url}auto/?order=${SORT}&o=${p}"
            out="${work_dir}/${d}/${region_name}/${region_name}_${SORT}-page-${p}.html"
            cookie="${work_dir}/${d}/${region_name}/cockies.$$"
            nb_process=$(ps -ef | grep -i SUBITO | grep -i curl | wc -l)
            if [ $nb_process -lt $MAX_nb_process ]; then
                my_wget &
            else
                my_wget
            fi
			wait
            let "p=p+1"
        done
	fi
done
}


download_region_b () {

    my_url="${region_url}auto/"
	out="${work_dir}/${d}/${region_name}/${region_name}-page-1.html"
	cookie="${work_dir}/${d}/${region_name}/cockies.$$"
	my_wget
	wait
	
	awk -f ${work_dir}/nb_annonce.awk ${out} > ${work_dir}/${d}/nb_annonce.$$
	. ${work_dir}/${d}/nb_annonce.$$
	let "nb_page=nb_annonce/nb_retrieve_per_page"
	let "mod=nb_annonce%nb_retrieve_per_page"
	let "nombre_annonces=nb_annonce"
	if [ ${mod} -gt 0 -a ${nb_page} -gt 0 ]
	then
		let "nb_page=nb_page+1"
	fi
	
cp ${work_dir}/tab.prix ${work_dir}/${d}/${region_name}/${region_name}.prix
if [ -s ${work_dir}/${d}/${region_name}/${region_name}.prix ]
then			
	awk '{if($1>$2){next} l++; print "old_step_min["l"]=\""$1"\"; old_step_max["l"]=\""$2"\";"}END{print "old_nb_step=\""l"\";"}' ${work_dir}/${d}/${region_name}/${region_name}.prix > ${work_dir}/${d}/${region_name}/${region_name}_prix_eval.$$

	. ${work_dir}/${d}/${region_name}/${region_name}_prix_eval.$$
	step_counter=1
	prix_max=0
	
	else
	step=2048
	prix_max=-1
	step_counter=0
fi
 
				while [ ${prix_max} -le 2500000 ]
				do
						if [ ${step_counter} -gt 0 ]
						then
							if [ ${step_counter} -gt ${old_nb_step} ]
							then
								step_counter=0
								let "step=step*2"
								let "prix_min=prix_max+1"
								nb_annonce=${max_retrieve}
							else
								prix_min=${old_step_min[$step_counter]}
								prix_max=${old_step_max[$step_counter]}
								let "step=prix_max-prix_min"
								let "step_counter=step_counter+1"

								out="${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html"
								if [ ! -s ${out} ]
								then
									if [ ${lynx_ind} -eq 1 ]; then

									test ${lynx_ind} -eq 1 && incr_ip
									test ${lynx_ind} -eq 1 && incr_u

									my_url="${region_url}auto/?order=priceasc&ps=${prix_min}&pe=${prix_max}"
									out="${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html"
									cookie="${work_dir}/${d}/${region_name}/cockies.$$"

									nb_process=$(ps -ef | grep -i SUBITO | grep -i curl | wc -l)
									if [ $nb_process -lt $MAX_nb_process ]; then
											my_wget &
									else
											my_wget
									fi
									wait
									fi
								fi

								if [ -s ${out} ]
								then
										awk -f ${work_dir}/nb_annonce.awk ${out} > ${work_dir}/${d}/${region_name}/${region_name}_nb_annonces.$$
										nb_annonce=0
										. ${work_dir}/${d}/${region_name}/${region_name}_nb_annonces.$$
										let "nb_page=nb_annonce/nb_retrieve_per_page"
									let "mod=nb_annonce%nb_retrieve_per_page"			
									if [ ${mod} -gt 0 ]
									then
										let "nb_page=nb_page+1"
									fi	
								fi


							fi
						else
							let "step=step*2"
							let "prix_min=prix_max+1"
							nb_annonce=${max_retrieve}
						fi

						while [ ${step} -gt 16 -a ${nb_annonce} -ge ${max_retrieve} ]
						do
							if [ ${step_counter} -gt 0 ]
							then
								let "s1=step_counter - 1"
								step_counter=0
								head -n${s1} ${work_dir}/${d}/${region_name}/${region_name}.prix  > ${work_dir}/${d}/${region_name}/${region_name}.prix2
								mv ${work_dir}/${d}/${region_name}/${region_name}.prix2 ${work_dir}/${d}/${region_name}/${region_name}.prix
							fi

							if [ ${prix_min} -gt 16392 ]
							then
								let "step=step/2"
								let "prix_max=prix_min+step"

							else
								let "step=step/4"
								let "prix_max=prix_min+step"

							fi


							out="${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html"
							if [ ! -s ${out} ]
							then
								if [ ${lynx_ind} -eq 1 ]; then
									
									test ${lynx_ind} -eq 1 && incr_ip
									test ${lynx_ind} -eq 1 && incr_u

									my_url="${region_url}auto/?order=priceasc&ps=${prix_min}&pe=${prix_max}"
									out="${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html"
									cookie="${work_dir}/${d}/${region_name}/cockies.$$"
									
									nb_process=$(ps -ef | grep -i SUBITO | grep -i curl | wc -l)
									if [ $nb_process -lt $MAX_nb_process ]; then
											my_wget &
									else
											my_wget
									fi
									wait						
								fi
							fi
							
							# awk -f ${work_dir}/liste_tab.awk -f ${work_dir}/put_html_into_tab.awk ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$
							python2.7 ${work_dir}/parse_list_files.py ${work_dir}/${d}/all_telephone.tab ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$


							# Parsing du nombres d'annonces
							if [ -s ${out} ]
							then
									awk -f ${work_dir}/nb_annonce.awk ${out} > ${work_dir}/${d}/${region_name}/${region_name}_nb_annonces.$$
									
								nb_annonce=0
								. ${work_dir}/${d}/${region_name}/${region_name}_nb_annonces.$$
							fi



							if [ ${nb_annonce} -ge ${max_retrieve} ]
							then
								if [ -s ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html ]
								then
									rm -f ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > /dev/null 2>&1
								else
									nb_annonce=0
								fi

							fi
						done

						# Sauvergarder le range dans un fichier
						if [ ${step_counter} -eq 0 ]
						then
							if [ ${prix_max} -gt ${prix_min} ]
							then
								echo ${prix_min} ${prix_max} >> ${work_dir}/${d}/${region_name}/${region_name}.prix
							else 
								# awk -f ${work_dir}/liste_tab.awk -f ${work_dir}/put_html_into_tab.awk ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$
								python2.7 ${work_dir}/parse_list_files.py ${work_dir}/${d}/all_telephone.tab ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$

							fi
						fi

					if [  -s ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html ]
					then
							awk -f ${work_dir}/nb_annonce.awk ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > ${work_dir}/${d}/nb_annonce.$$
							. ${work_dir}/${d}/nb_annonce.$$

						# awk -f ${work_dir}/liste_tab.awk -f ${work_dir}/put_html_into_tab.awk ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$

						python2.7 ${work_dir}/parse_list_files.py ${work_dir}/${d}/all_telephone.tab ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-1.html > ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$
					fi

					if [ ${nb_page} -ge 2 ]
					then
						p=2
						while [ ${p} -le ${nb_page} ]
						do
								if [ ! -s ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-${p}.html ]
								then

									test ${lynx_ind} -eq 1 && incr_ip
									test ${lynx_ind} -eq 1 && incr_u
							   ## test ${lynx_ind} -eq 1 && curl --interface "${IP_ARR[$ip]}" --compressed -H"User-Agent: ${USERAGENT_ARR[$u_a]}" "${region_url}auto/?o=${p}" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "TE: Trailers" > ${work_dir}/${d}/${region_name}/${region_name}-page-${p}.html
																					   # curl -k -L -x http://172.16.2.14:3228  --compressed -H"User-Agent: ${USERAGENT_ARR[$u_a]}" "${region_url}auto/?o=${p}" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "TE: Trailers" > ${work_dir}/${d}/${region_name}/${region_name}-page-${p}.html

									my_url="${region_url}auto/?order=priceasc&o=${p}&ps=${prix_min}&pe=${prix_max}"
									out="${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-${p}.html"
									cookie="${work_dir}/${d}/${region_name}/cockies.$$"
									nb_process=$(ps -ef | grep -i SUBITO | grep -i curl | wc -l)
									if [ $nb_process -lt $MAX_nb_process ]; then
											my_wget &
									else
											my_wget
									fi
									wait
								fi
								# awk -f ${work_dir}/liste_tab.awk -f ${work_dir}/put_html_into_tab.awk ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-${p}.html >> ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$
								
								python2.7 ${work_dir}/parse_list_files.py ${work_dir}/${d}/all_telephone.tab ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}-page-${p}.html >> ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$

								let "p=p+1"
						done
					fi
					#comptage de l'affinage par prix
					sort -u  ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.$$ >  ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.tab
					#nombre d annonce observe
					nb_observe_1=`wc -l ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.tab | awk '{ print $1; }'`
					echo -e "${region_name}\t${marque_name_dir}\t${prix_min}\t${prix_max}\t${nb_annonce}\t${nb_observe_1}\tPRIX"
					cat ${work_dir}/${d}/${region_name}/${region_name}_${prix_min}-${prix_max}.tab >> ${work_dir}/${d}/e.tab
					let "step=step*2"
				done
}
#
# MAIN
#
trap 'ExitProcess 1' SIGKILL SIGTERM SIGQUIT SIGINT SIGHUP
echo -e "`date +"%Y-%m-%d %H:%M:%S"`\tDEBUT"

prox=0
s_sleep=0.2
echo -e "`date +"%Y-%m-%d %H:%M:%S"`\tDEBUT"

usage="download_site.sh \n\
\t-a no download - just process what's in the directory\n\
\t-d [date] (default today)\n\
\t-D Delta : ne télécharge que les nouveaux ID (par comparaison avec le dernier fichier id_client_YYYYmmdd)\n\
\t-h help\n\
\t-i id start de la marque\n\
\t-I id   end de la marque (incluse)\n\
\t-M [marque]\n\
\t-m [modele] \n\
\t-r retrieve only, do not download the detailed adds\n\
\t-R reset : delete files to redownload\n\
\t-t table name \n\
\t-x debug mode\n\
\t-z nom du tele\n\
"

date
typeset -i lynx_ind=1
typeset -i get_all_ind=1
typeset -i nb_retrieve_per_page=28
typeset -i nb_processus_IP=9
typeset -i nb_processus_awk=20
typeset -i nb_processus_PROXY=50
typeset -i reset_ind=0
typeset -i loop
typeset -i max_loop=4000
typeset -i pid=1
typeset -i nb_processus=30
MAX_nb_process=30

delta_ind=0
increment_status=1

#Debut de code avant page liste
typeset -i nb_status_MAX=5
typeset -i nb_status=1


. /usr/local/bin/list_ip.sh
. /home/tele/liste_proxy.sh
ip=0
. /usr/local/bin/list_useragent.sh
u_a=0
TAB="	"


while getopts :-aDd:i:I:m:M:p:P:Rrht:xz: name
do
  case $name in

    a)  lynx_ind=0
        let "shift=shift+1"
        ;;

        D)      delta_ind=1
        let "shift=shift+1"
        ;;

    d)  d=$OPTARG
        let "shift=shift+1"
        ;;

    h)  echo -e ${usage}
        ExitProcess 0
        ;;

    i)  MIN_MARQUE_ID=$OPTARG
        let "shift=shift+1"
        ;;

    I)  MAX_MARQUE_ID=$OPTARG
        let "shift=shift+1"
        ;;

    m)  my_modele=`echo $OPTARG | tr '[:lower:]' '[:upper:]' `
        let "shift=shift+1"
        ;;

    M)  my_region=`echo $OPTARG | tr '[:lower:]' '[:upper:]' `
        let "shift=shift+1"
        ;;

    r)  get_all_ind=0
        let "shift=shift+1"
        ;;

    R)  reset_ind=1
        let "shift=shift+1"
        ;;

    t)  table=$OPTARG
        let "shift=shift+1"
        ;;

        p)      min_reg=$OPTARG
        let "shift=shift+1"
        ;;

        P)      max_reg=$OPTARG
        let "shift=shift+1"
        ;;

    x)  set -x
        let "shift=shift+1"
        ;;

    z)  let "shift=shift+1"
        ;;

    --) break
        ;;

  esac
done
shift ${shift}

if [ $# -ne 0 ]
then
        error="Bad arguments, $@"
        ExitProcess 1
fi

if [ "${d}X" = "X" ]
then
        d=`date +"%Y%m%d"`
fi

work_dir=`pwd`

if [ "${table}X" = "X" ]
then
	table="SUBITO_"`date +"%Y_%m"`
fi

mkdir -p ${work_dir}/ERROR ${work_dir}/${d}/TEL ${work_dir}/${d}/ALL ${work_dir}/${d}/UPD ${work_dir}/${d}/MONTHLY/
if [ ! -s ${work_dir}/${d}/MONTHLY/start ]; then mkdir -p ${work_dir}/${d}/MONTHLY/; now=$(date +"%s");echo -n -e ${now} > ${work_dir}/${d}/MONTHLY/start;fi


rm -f ${work_dir}/${d}/lynx* > /dev/null 2>&1
#rm -f ${work_dir}/${d}/VO_ANNONCE* > /dev/null 2>&1

grep -v -i "iPhone" /usr/local/bin/list_useragent.sh > a.$$
. ./a.$$
u_a=0

. /usr/local/bin/list_ip.sh
ip=0

veille=$(date +"%Y%m%d" -d"  1 day ago")

#Avant DL page liste
echo "list $nb_status" > ${work_dir}/${d}/MONTHLY/status

. ${work_dir}/region.eval

# min region
if [ "${min_reg}X" != "X" ]
then
        r="${min_reg}"
else
        r=1
fi
# max region
if [ "${max_reg}X" != "X" ]
then
        max_region="${max_reg}"
fi
while [ ${r} -lt ${max_region} ]
do
    region_url=`echo ${REGION_URL[$r]}`
    region_id=`echo ${REGION_ID[$r]}`
    region_name=`echo ${REGION_NAME[$r]} | sed 's/ /_/g'`
    mkdir -p ${work_dir}/${d}/${region_name}

    cd ${work_dir}/${d}/${region_name}
				 
	if [ "${region_name}" = "CAMPANIA" -o "${region_name}" = "EMILIA_ROMAGNA" -o "${region_name}" = "LAZIO" -o "${region_name}" = "LOMBARDIA" -o "${region_name}" = "PIEMONTE" -o "${region_name}" = "PUGLIA" -o "${region_name}" = "SICILIA" -o "${region_name}" = "TOSCANA" -o "${region_name}" = "VENETO"  ]
	then
		download_region_b > ${work_dir}/${d}/${region_name}/log_${region_name} 2>&1 &
		wait
	else	
        download_region > ${work_dir}/${d}/${region_name}/log_${region_name} 2>&1 &
		wait
	fi 

	find  ${work_dir}/${d}/${region_name}/ -name \*.html -type f -exec python2.7 ${work_dir}/parse_list_files.py ${work_dir}/${d}/all_telephone.tab {} \; > ${work_dir}/${d}/${region_name}/${region_name}.temp
	 
	awk -f ${work_dir}/nb_annonce.awk ${work_dir}/${d}/${region_name}/${region_name}-page-1.html > ${work_dir}/${d}/nb_annonce.$$
	. ${work_dir}/${d}/nb_annonce.$$

	# Comptage par region
	sort -u -k1,1 -t"${TAB}" ${work_dir}/${d}/${region_name}/${region_name}.temp | awk -F"\t" '{ if(prev==$1) next; prev=$1; print $0; }' > ${work_dir}/${d}/${region_name}/${region_name}.tab
	
	nb_observe=`wc -l ${work_dir}/${d}/${region_name}/${region_name}.tab | awk '{ print $1; }'`
	echo -e "\t${region_name}\t${nb_annonce}\t${nb_observe}\tREGION"
	cat ${work_dir}/${d}/${region_name}/${region_name}.tab >>  ${work_dir}/${d}/extract.$$	
	cat ${work_dir}/${d}/${region_name}/${region_name}.tab >>  ${work_dir}/${d}/e.tab
    let "r=r+1"
done #FIN REGION
wait

# Because we have all important information in list pages with json data 
# We ignore detail pages, and only crawl minsites and telephone for pro ads 


# downloading telephone for pro ads 
sort -u -k1,1 ${work_dir}/${d}/all_telephone.tab > ${work_dir}/${d}/telephone.tab
rm -rf ${work_dir}/${d}/all_telephone.tab
mkdir -p ${work_dir}/TELEPHONE/
download_detail_mode ${work_dir}/${d}/telephone.tab

# crawling and parsing minisite
# ${work_dir}/${d}/GARAGE/ ==> contains list pages of minisite
# ${work_dir}/${d}/ALL_GARAGE/ ==> contains detail pages minisite
# Output file locates in  ${work_dir}/${d}/VO_ANNONCE_garage.sql
./download_minisite.sh -zAUTOIT_SUBITO -d${d}


# parsing list pages
echo "list_parsing $nb_status" > ${work_dir}/${d}/MONTHLY/status
sort -u -k1,1 -t"${TAB}" ${work_dir}/${d}/extract.$$ | awk -F"\t" '{ if(prev==$1) next; prev=$1; print $0; }'  >  ${work_dir}/${d}/extract.tab
awk -f ~/Lib_Autobiz/Utils.awk -f ${work_dir}/put_tab_into_db.awk  -f ${work_dir}/liste_tab.awk -vtable=${table} ${work_dir}/${d}/extract.tab > ${work_dir}/${d}/VO_ANNONCE_insert.sql

# parsing telephone
find ${work_dir}/TELEPHONE/ -name \*.html -exec awk -f ~/Lib_Autobiz/Utils.awk -f ${work_dir}/parsing_telephone.awk -vtable=${table} {} \; > ${work_dir}/${d}/VO_ANNONCE_update_telephone.sql


#Avant fin code source
echo $nb_status > ${work_dir}/${d}/MONTHLY/status
cp ${work_dir}/${d}/extract.tab ${work_dir}/${d}/*sql ${work_dir}/${d}/MONTHLY/

echo "integration $nb_status" > ${work_dir}/${d}/MONTHLY/status
DB=VOIT
table="SUBITO_"$(date -d"${d} " +"%Y_%m")
table_last="IT_"$(date -d"${d} -1 month" +"%Y_%m")
cat ${work_dir}/${d}/MONTHLY/VO_ANNONCE_insert.sql ${work_dir}/${d}/VO_ANNONCE_garage.sql ${work_dir}/${d}/VO_ANNONCE_update_telephone.sql > ${work_dir}/${d}/MONTHLY/${table}.sql
input_file=${work_dir}/${d}/MONTHLY/${table}.sql
. /home/tele/DEV_WORKING/insertions_all/data_integration.sh

#Test download ok
#if [ $nb_status -ge $nb_status_MAX ]; then
	echo "OK" > ${work_dir}/${d}/MONTHLY/status_ok
#fi
# echo -e "`date +"%Y-%m-%d %H:%M:%S"`\tFIN"
now=$(date +"%s");echo -n -e ${now} > ${work_dir}/${d}/MONTHLY/end


ExitProcess 0



