#! /bin/bash


for file in $(env | grep '^FILE_' | cut -d'=' -f 1); do
  value="${!file}"
  NAME=$(echo $file | cut -d'_' -f2-)
  echo -e "$value" > $NAME
  chmod +x $NAME
done

for command in $(env | grep 'COMMAND_' | cut -d'=' -f 1); do
  NAME=$(echo $command | cut -d'_' -f2-)
  value="${!command}"
  bash -c "${value}" 2>&1 | ts "%Y-%m-%d %H:%M:%S | ${NAME} |" &
done


for executable in $(env | grep '^EXECUTABLE_' | cut -d'=' -f 1); do
  value="${!executable}"
  NAME=$(echo $executable | cut -d'_' -f2-)
  echo -e "$value" > $NAME
  chmod +x $NAME
  ./$NAME 2>&1 | ts "%Y-%m-%d %H:%M:%S | ${NAME} |" &
done

for executable in $(find /executables -type f); do
  NAME=$(basename $executable)
  chmod +x $executable
  $executable 2>&1 | ts "%Y-%m-%d %H:%M:%S | ${NAME} |" &
done

bash -c "while true; do sleep 5; done" &
wait -n
exit $?
