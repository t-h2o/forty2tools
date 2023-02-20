#include "test_project.h"

static int	subtract_n(int a, int n);

int	add_2(int a)
{
	return (a + 2);
}

int	subtract_2(int a)
{
	return(subtract_n(a, 2));
}

static int	subtract_n(int a, int n)
{
	return(a - n);
}
