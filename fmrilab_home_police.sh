#!/bin/bash


# Checar si soy sudo
if [ ! $(id -u) -eq 0 ]; then
        echo "Only sudo can do this"
        exit 2
fi


# checar que estoy en tesla
if [[ ! $(hostname) == tesla ]]; then
  echo "Hay que hacer esto en tesla, no en otra PC"
  exit 2
fi


home_size_threshold_bytes=4000000
#for uhome in /home/inb/*
#do
#  echo "Checking $uhome"
#  homesize=$(du -sb $uhome)
#  if [ $homesize -gt $home_size_threshold_bytes ]
#  then
#    echo "$uhome has size of $homesize , which is too big"
#  fi
#done


police_report=/home/inb/soporte/du_police.txt
sort $police_report | while read line
do
  size=$(echo $line | awk '{print $1}')
  u=$(echo $line | awk '{print $2}' | sed 's/\.\///')
  if [ ! -z $(echo $size | grep G ) ]
  then
    #echo "$u has a home over 1 GB"
    echo ""
  else
    #echo "$u has less than 1 GB"
    continue
  fi

sizenoG=${size%G}

gbthreshold=300
send_email=1
#users_to_disable=/tmp/users_to_disable.txt
users_to_warn=""
if (( $(echo "$sizenoG > $gbthreshold" |bc -l) ))
then
    echo " --- $u has $sizenoG GB in home. tzzzz."
    email=$(cat /home/inb/$u/.email)
    if [ -z $email ]
    then
      echo "[WARNING] Could not get email for $u"
      echo "          $u has been added to the user disable list)."
      echo $u >> /tmp/users_to_disable.txt
    else
      echo "[INFO] email for $u is $email"
    fi

if [ $send_email -eq 0 ]
then
  pawd=`cat /home/inb/lconcha/fmrilab_software/tools/private/sendinblue.pwd`
  smtpserver=smtp-relay.sendinblue.com:587
  xuser="lconcha@gmail.com"
  message_file=/tmp/message.txt
  echo "Hola $u" > $message_file
  echo ""  >> $message_file
  echo "Tu HOME en don clusterio pesa más de $gbthreshold GB" >> $message_file
  echo "Necesitas borrar archivos. Revisa tus Downloads y tu papelera de reciclaje." >>  $message_file
  echo "Gracias."  >> $message_file
  echo ""  >> $message_file
  echo "Luis Concha."  >> $message_file


  echo sendemail -f lconcha@unam.mx \
            -t $email \
            -o reply-to=lconcha@unam.mx \
            -cc lconcha@gmail.com \
            -u "Tu home en Don Clusterio es demasiado grande" \
            -o message-content-type=html \
            -o message-charset=UTF-8 \
            -o message-file=$message_file \
            -s $smtpserver \
            -xu $xuser \
            -xp $pawd

fi


fi

done

echo "------"
echo "Users to disable in file /tmp/users_to_disable.txt :"
cat /tmp/users_to_disable.txt
echo ""
rm /tmp/users_to_disable.txt
