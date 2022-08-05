#! /bin/bash

path=$1
if [ -z "$1" ]
then
path="access.log"
fi
DADOS=`cat "$path"`
#1 
echo "$DADOS" | awk '{print $7}' | awk -F / '{print $3}' | sort -u | wc -l 
#2
function contador_bytes () {
    APLICACAO="/-"
    BYTES=0
    FOR=`echo "$DADOS" | awk '{print $10":"$5}' | sort`
    ULTIMO=`echo "$FOR" | wc -l`
    COUNT=1
    for i in $FOR
        do
            APP=`echo "$i" | awk -F : '{print $1}'`
            BYTE=`echo "$i" | awk -F : '{print $2}'`
            if [ "$APLICACAO" = "/-" ] 
                then 
                    APLICACAO=$APP
                fi
            if [ "$APLICACAO" = "$APP" ]
                then
                    let BYTES+=$BYTE
                else
                    echo "$APLICACAO $BYTES" 
                    BYTES=$BYTE
                    APLICACAO=$APP
                fi
            if [ $ULTIMO -eq $COUNT ] 
                then
                    echo "$APLICACAO $BYTES" 
                fi
            let COUNT++
        done
}
contador_bytes
#3 
echo "$DADOS" | grep -c TCP_HIT 
#4 
echo "$DADOS" | grep -c TCP_MISS
#5 
echo "$DADOS" | grep -c TCP_DENIED 
#6
echo "$DADOS" | grep -c TCP_REFRESH_UNMODIFIED
#7
function comparador () {
    TIMESTAMP=`echo "$DADOS" | awk '{print $1}'`
    DATAINICIO="$(date -d 2022-07-16T07:44:37 +'%s')"
    DATAFIM="$(date -d 2022-07-16T07:44:51 +'%s')"
    CONTADOR=0
    for i in $TIMESTAMP
        do 
            if (( $(echo "$i > $DATAINICIO" |bc -l) && $(echo "$i < $DATAFIM" |bc -l) )) 
                then
                    let CONTADOR++
                fi
        done
    echo "$CONTADOR"
}
comparador


