


logsdir=/misc/sesamo/backup/logs.borg

hosts=$(find $logsdir -mtime -1 -name *.log | awk -F_ '{print $NF}' | sort | uniq | sed 's/\.log//')


# logs_with_errors=""
# while read f
# do 
#   strtest=$(grep "finished with errors" $f)
#   if [ ! -z "$strtest" ]; then
#     echolor orange "Error in $f"
#     logs_with_errors=$(echo "${logs_with_errors} $f")
#   else
#     echolor green "No errors in $f"
#   fi
# done < <(find $logsdir -mtime -1)

logs_with_errors=""
for h in $hosts
do 
  A="[~~~~~~~~~~~~~~~~~~~~~]";
  B=$h

  f=$(ls -rt $logsdir/*${h}.log | tail -n 1)
  strtest=$(grep "finished with errors" $f)
  if [ ! -z "$strtest" ]; then
    echo "Error in $f"
    logs_with_errors=$(echo "${logs_with_errors} $f")
  else
    echo -n "${A:0:-${#B}} $B ] No errors in $f"
    echo ""
  fi
done 

if [ -z $logs_with_errors ]
then
  echo "All is looking good!"
  exit 0
fi

echo ""
echo "Logs with errors:"
for f in $logs_with_errors
do
  str=$(grep /root/.cache/borg ${f})
  lockfile=$(echo $str | sed -E 's/.*(\/root\/\.cache\/borg.*\s).*/\1/')
  if [ ! -z "$lockfile" ]
  then
    echo "Problem with lock file in $f $lockfile"
  else
    echo "Unrecognized error found in $f"
  fi
  
done

