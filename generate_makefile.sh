#!/bin/sh
printf "generate a Makefile automatically\n"

help () {
	printf "Help: do not set any arguments\n"
}

makefile_header () {
	echo "NAME	=	program

CC		=	gcc
DB		=	lldb

CFLAGS	=	-Wall
CFLAGS	+=	-Wextra
CFLAGS	+=	-Werror
CFLAGS	+=	-g

OFLAGS	=	-fsanitize=address


#	Sources

SRCD	=	srcs
" > Makefile
}

makefile_footer () {
echo "

#	Objets

OBJD	=	objs
OBJS	=	\$(addprefix \$(OBJD)/, \$(notdir \$(SRCS:.c=.o)))

RM		=	rm -rf

vpath %.c \$(SRCD):\$(SRCD)/class


all : \$(NAME)

\$(NAME):	\$(OBJS)
	@printf \"\$(YELLOW)Creating executable..\$(DEFAULT)\n\"
	@\$(CC) \$(OBJS) \$(OFLAGS) -o \$(NAME)
	@printf \"\$(GREEN)---> \$(NAME) is ready\$(DEFAULT)\n\"

\$(OBJD)/%.o : %.c | \$(OBJD)
	@printf \"\$(YELLOW)Compiling \$(DEFAULT)\$<\n\"
	@\$(CC) \$(CFLAGS) -I\$(INCD) -o \$@ -c \$<

\$(OBJD) :
	@mkdir -p \$(OBJD)

clean:
	@\$(RM) \$(OBJD)
	@printf \"\$(RED)Removed \$(CYAN)\$(OBJD)\$(DEFAULT)\n\"

fclean: clean
	@\$(RM) \$(NAME)
	@printf \"\$(RED)Removed \$(CYAN)\$(NAME)\$(DEFAULT)\n\"

re:	fclean all


db: all
	\$(DB) \$(NAME)

format:
	@cat \$(SRCS) \$(INCS) \$(TMPS) > /tmp/before
	@clang-format -i \$(SRCS) \$(INCS) \$(TMPS)
	@cat \$(SRCS) \$(INCS) \$(TMPS) > /tmp/after
	@diff -u --color=auto /tmp/before /tmp/after || true


diagram:
	asciidoctor -r asciidoctor-diagram README.adoc -o assets/index.html

doc: diagram
	asciidoctor README.adoc -o index.html


.PHONY: all clean fclean libclean fullclean

#COLORS
RED = \033[1;31m
GREEN = \033[1;32m
YELLOW = \033[1;33m
CYAN = \033[1;36m
DEFAULT = \033[0m" >> Makefile
}

makefile_headers_title () {
	echo "

#	Headers

INCD	=	headers
" >> Makefile
}

makefile_sources () {
	find srcs -type f -printf "SRCS	+=	\$(SRCD)/%f\n" >> Makefile
}

makefile_headers () {
	find headers -type f -printf "INCS	+=	\$(INCD)/%f\n" >> Makefile
}

main () {
	file_name="Makefile"

	makefile_header
	makefile_sources
	makefile_headers_title
	makefile_headers
	makefile_footer
}

# Check the number of arguments
if [ ${#} -ne 0 ]; then
	help
	exit 1
fi

main
