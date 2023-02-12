#!/bin/sh
printf "generate header automatically from source folder\n"

help () {
	printf "Help: you should set a name as argument\n"
}

main () {
	# Set to upper the argument and append _H
	header_guard_name=$(printf "%s_H" ${1} | awk '{print toupper($0)}')

	# Print the header guard name
	echo ${header_guard_name}
}

# Check the number of arguments
if [ ${#} -ne 1 ]; then
	help
	exit 1
fi

main ${1}
