#!/bin/bash

# 24 Jul, 2023. Ricardo Rios
# Erase group option. Make e-mail field mandatory. Make send email optional.

# Sept 07, 2015. Added group option. lconcha

# Modification: June 26, 2012
# Luis Concha


print_help()
{
  echo "
`basename $0` <login> <\"full Name\"> <\"email\">

Options:
-noemail Don't send welcome email.
"

}


if [ $# -lt 2 ] 
then
	echo " ERROR: Need more arguments..."
	print_help
	exit 1
fi



user_login=$1
user_name=$2
user_email=$3

grp="fmriuser"

write_email=1
send_email=1

declare -i i
i=1
for arg in "$@"
do
  case "$arg" in
  -h|-help) 
    print_help
    exit 1
  ;;
  -noemail)
    nextarg=`expr $i + 1` 
    send_email=0
  ;;
  esac
  i=$[$i+1]
done




# Checar si soy sudo
if [ ! $(id -u) -eq 0 ]; then
	echo "Only sudo can do this"
	exit 2
fi


if [ -d /home/inb/${user_login} ]
then
  echo "User already exists."
  exit 2
fi


useradd -g $grp \
  --base-dir /home/inb \
  --create-home \
  --comment "$user_name" \
  --shell /bin/bash \
  $user_login
passwd $user_login


if [ $write_email -eq 1 ]
then
  email_file=/home/inb/${user_login}/.email
  echo " Writing $user_email to $email_file"
  echo $user_email > $email_file
fi


# quitar el shadowing, que no se lleva bien con el NIS
pwunconv
grpunconv

# Poner archivos vacios para gshadow y shadow, para que el chroot de fslview no se queje
touch /etc/shadow
touch /etc/gshadow


# Actualizar el NIS
make -C /var/yp


# Activar la configuracion del laboratorio
echo "source \$FMRILAB_CONFIGFILE" >> /home/inb/${user_login}/.bashrc




if [ $send_email -eq 1 ]
then
  %pawd="add backticks"cat /home/inb/lconcha/fmrilab_software/tools/private/.emailpwd
  %smtpserver=smtp.gmail.com:587
  %xuser="inb.fmrilab"
  
  pawd=`cat /home/inb/lconcha/fmrilab_software/tools/private/sendinblue.pwd`
  smtpserver=smtp-relay.sendinblue.com:587
  xuser="lconcha@gmail.com"
  
  message_file=/home/inb/soporte/configs/bienvenida.html
  sendemail -f lconcha@unam.mx \
            -t $user_email \
            -o reply-to=lconcha@unam.mx \
            -cc lconcha@gmail.com \
            -u "Nueva cuenta en Don Clusterio" \
            -o message-content-type=html \
            -o message-charset=UTF-8 \
            -o message-file=$message_file \
            -s $smtpserver \
            -xu $xuser \
            -xp $pawd

fi


echo "Finished creating user $user_login and updated NIS"

#Incluir al usuario en cluster (funciona solo en host cluster)
#qconf -au $user_login arusers
#qconf -au $user_login users

