
print(){
clear
echo "______                      _    _            "
echo "| ___ \                    | |  (_)          "
echo "| |_/ / _ __   __ _    ___ | |_  _   ___   ___ "
echo "|  __/ |  __| / _  |  / __|| __|| | / __| / _ \\"
echo "| |    | |   | (_| | | (__ | |_ | || (__ |  __/"
echo "\_|    |_|    \__,_|  \___| \__\|_| \___| \___|"
echo ""
echo "(_)       | |    (_)                    "
echo " _  _ __  | |     _  _ __   _   _ __  __"
echo "| ||  _ \ | |    | ||  _ \ | | | |\ \/ /"
echo "| || | | || |____| || | | || |_| | >  <"
echo "|_||_| |_|\_____/|_||_| |_| \__,_|/_/\_\\"
echo "-NAME-----------------CMD--------------------PID-----STIME----"
for (( i=0 ; i<20 ; i++ ))
do
   name_index=${s_name_index}+${i}
   index=${s_index}+${i}
   printf '|'
   if [ $i -eq $name_cur ]; then
       printf "[41m"
   fi
   printf "%20s[0m|" ${name[$name_index]:0:20}
   if [ $i -eq $pro_cur ]; then
       printf "[42m"
   fi
   if [ "${FB[$index]}" = "+" ]; 
     then FB='F' 
     else FB='B'
   fi
   if [ "$((${#cmd[@]}))" -eq 0 -o "${cmd[$index]}" = '' ]; then
       FB=''
   fi
   printf '%-2s%20s|[0m' ${FB} ${cmd[$index]:0:20} 
   if [ $i -eq $pro_cur ]; then
        printf "[42m"
   fi
   printf "%7s|[0m"  ${pid[$index]:0:7}
   if [ $i -eq $pro_cur ]; then
        printf "[42m"
   fi
   printf "%8s[0m|" ${stime[$index]:0:8} 
   printf "\n"
done
echo "--------------------------------------------------------------"
}
noperm(){
clear
clear
echo '                            _   _  _____'
echo '                           | \ | ||  _  |'
echo '                           |  \| || | | |'
echo '                           |     || | | |'
echo '                           | |\  |\ \_/ /'
echo '                           \_| \_| \___/'
echo ' _____  _____ ______  ___  ___ _____  _____  _____  _____  _____  _   _ '
echo '|__ _ \|  ___|| ___ \ |  \/  ||_   _|/  ___|/  ___||_   _||  _  || \ | |'
echo '| |_/ /| |__  | |_/ / | _  _ |  | |  \ `--. \ `--.   | |  | | | ||  \| |'
echo '| _ _/ |  __| |    /  | |\/| |  | |   `--. \ `--. \  | |  | | | || _   |'
echo '| |    | |___ | |\ \  | |  | | _| |_ /\__/ //\__/ / _| |_ \ \_/ /| |\  |'
echo '\_|    \____/ \_| \_| \_|  |_/ \___/ \____/ \____/  \___/  \___/ \_| \_/'
echo ""
echo "enter any key"
    read -n 1 
}
cpu(){
    clear
    clear
    echo "process ${cmd[$pro_cur+$s_index]}
          %CPU : ${CPU[$pro_cur+$s_index]}"
    echo " "
    echo "enter any key"
    read -n 1
}
error(){
    clear
    clear
    echo "                 _____  ______  ______  _____  ______"
    echo "                |  ___|| ____ \| ____ \|  _  || ____ \\"
    echo "                | |__  | |__/ /| |__/ /| | | || |__/ /"
    echo "                |  __| |     / |     / | | | ||     /"
    echo "                | |___ | |\  \ | |\  \ \ \_/ /| |\  \\"
    echo "                \____/ \_| \__|\_| \__| \___/ |_| \__|"·
    echo " "
    echo " "
    echo "               ${name[$name_cur]} is not a process"
    echo " "
    echo "               ${name[$name_cur]} is a user"
    echo " "
    echo "               Enter any key"
        read -n 1
                         }
declare -i pro_cur=-1
declare -i name_cur=0
declare -i s_index=0
declare -i s_name_index=0
while [ 1 ]
do
declare -a name=(`cat /etc/passwd | cut -f1 -d: | sort`)
declare -a cmd=(`ps -o cmd -u ${name[$name_cur+$s_name_index]} --sort=-pid | grep -v "CMD" | cut -f 1 -d ' '`)
declare -a pid=(`ps -o pid -u ${name[$name_cur+$s_name_index]} --sort=-pid | grep -v "PID"`)
declare -a stime=(`ps -o stime -u ${name[$name_cur+$s_name_index]} --sort=-pid | grep -v "STIME"`)
declare -a FB=(`ps -o stat -u ${name[$name_cur+$s_name_index]} --sort=-pid | grep -v "STAT" | rev | cut -c 1`)
declare -a CPU=(`ps  -o pcpu -u ${name[$name_cur+$s_name_index]} --sort=-pid | grep -v "%CPU"` )
print
echo "If you want to exit , Please Type 'q' or 'Q'"
echo "if you want to check cpu usage of process , type 'cp'"

read -n 3 key
    if [[ "$key" = 'k' || -z "$key" ]]; then
        if [ "$pro_cur" -gt -1 ]; then
            if [ "${name[$name_cur+$s_name_index]}" = `whoami` ]; then
                killall -9 ${cmd[$pro_cur+$s_index]}
            elif [ "${name[$name_cur+$s_name_index]}" != `whoami` ]; then
                noperm
            fi
        else
            if [ "$pro_cur" -eq -1 ]; then
                error
            fi
        fi
    elif [ "$key" = 'cp' ]; then
        if [ "$pro_cur" -ge 0 ]; then
            cpu
        else
            error
        fi
    elif [ "$key" = 'q' ] || [ "$key" = 'Q' ]; then
        break
    elif [ "$key" = '[A' ]; then
        if [ "$pro_cur" -eq -1 ]; then
            if [ "$name_cur" -gt 0 ]; then
                name_cur=${name_cur}-1
                s_index=0 #reset
            else
                if [ "$s_name_index" -gt 0 ]; then
                    s_name_index=${s_name_index}-1
                fi
            fi
        else
            if [ "$pro_cur" -gt 0 ]; then
                pro_cur=${pro_cur}-1
            else
                if [ "$s_index" -gt 0 ]; then
                    s_index=${s_index}-1
                fi
            fi
        fi
    elif [ "$key" = '[B' ]; then
        if [ "$pro_cur" -eq -1 ]; then
            if [ "$name_cur" -lt 19 -a "$name_cur" -lt $((${#name[@]}-1)) ]; then
                name_cur=${name_cur}+1
                s_index=0 #reset
            else
                if [ "$s_name_index" -lt $((${#name[@]} - 20)) ]; then
                     s_name_index=${s_name_index}+1
                fi
            fi
        else
            if [ "$pro_cur" -lt $((${#cmd[@]}-1)) -a "$pro_cur" -lt 19 ]; then
                pro_cur=${pro_cur}+1
            else 
                if [ "$s_index" -lt $((${#cmd[@]} - 20)) ]; then
                    s_index=${s_index}+1
                fi
            fi
        fi
    elif [ "$key" = '[C' ]; then
         if [ "$pro_cur" -eq -1 -a "$((${#cmd[@]}))" -gt 0 ]; then
            pro_cur=0
         fi
    elif [ "$key" = '[D' ]; then
        if [ "$pro_cur" -ge 0 ]; then
            pro_cur=-1
        fi
    fi
done
