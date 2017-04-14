#!/system/bin/sh

umask 022

# mv files.x-1 to files.x
#mv_files()
#{
	if [ -z "$1" ]; then
	  echo "No file name!"
	  return
	fi
	if [ -z "$2" ]; then
	  LAST_FILE=64
	else
	  LAST_FILE=$2
	fi

#	echo $1 $2 $LAST_FILE
	i=$LAST_FILE
	while [ $i -gt 0 ]; do
#	for ((i=$LAST_FILE; i>=0; i--)); do
	  prev=$(($i-1))
	  if [ -e "$1.$prev" ]; then
#	    echo mv $1.$prev $1.$i
	    mv $1.$prev $1.$i
	  fi
	  i=$(($i-1))
	done

	if [ -e $1 ]; then
#	  echo mv $1 $1.1
	  mv $1 $1.1
	fi
#}
