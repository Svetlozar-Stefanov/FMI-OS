#include <err.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv)
{
	if(argc != 2)
	{
		errx(1, "invalid number of parameters");
	}

	int p[2];
	if(pipe(p) < 0)
	{
		err(1, "pipe fail");
	}

	pid_t pid = fork();
	if(pid > 0)
	{
		close(p[0]);
		dup2(p[1], 1);
		execlp("cat", "cat", argv[1], 0);
		close(p[1]);
	}
	else {
		close(p[1]);
		dup2(p[0], 0);
		execlp("sort", "sort", 0, 0);
		close(p[0]);
		exit(0);
	}
}
