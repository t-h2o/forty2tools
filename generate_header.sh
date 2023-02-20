#!/bin/sh
printf "generate header automatically from source folder\n"

help () {
	printf "usage: [header_name] [srcs_directory]\n"
}

main () {
	# Set a file name
	file_name=$(printf "%s.h" ${1} | awk '{print tolower($0)}')

	# Set to upper the argument and append _H
	header_guard_name=$(printf "%s_H" ${1} | awk '{print toupper($0)}')

	#find protoypes using ctags
	function_protoypes=$(ctags -Rx ${2} | grep 'function' | grep -v static | grep -vw main | sed -re 's,\s+, ,g' | cut -d ' ' -f 5-)
	# ctags -Rx
	#	x to output to terminal in humanreadable form
	#	R to recursivly search the directory
	# sed -re 's,\s+, ,g'
	#	to convert all whitspace on a line a single space
	# cut -d ' ' -f 5-)
	#	split the line into colums using ' ' as delim and take everything from the 5th column

	# Print the header guard into a new file
	printf "#ifndef %s\n" ${header_guard_name} > ${file_name}
	printf "#define %s\n\n" ${header_guard_name} >> ${file_name}

	printf '%s\n\n' "${function_protoypes}" >> ${file_name}

	printf "#endif /* %s */\n" ${header_guard_name} >> ${file_name}
}

# Check the number of arguments
if [ ${#} -ne 2 ]; then
	help
	exit 1
fi

main ${1} ${2}
