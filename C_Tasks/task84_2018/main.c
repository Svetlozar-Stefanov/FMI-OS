#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv)
{
	int p[2];
	pipe(p);

	pid_t pid = fork();
	if(pid == 0)
	{
		close(p[0]);
		close(1);
		dup(p[1]);
		close(p[1]);
		char  * const args[] = {"find", argv[1], "-type", "f", 
			"-exec", "stat", "-c", "%Y %n", "\{\}", ";", NULL};
		execvp("find", args);
	}
	wait(NULL);

	close(p[1]);

	int p2[2];
	pipe(p2);

	pid = fork();
	if(pid == 0)
	{
		close(0);
		dup(p[0]);
		close(p[0]);
		close(p2[0]);
		dup2(p2[1], 1);
		close(p2[1]);

		execlp("sort", "sort", "-nr", NULL);
		exit(0);
	}
	wait(NULL);

	close(p[0]);
	close(p2[1]);
	dup2(p2[0], 0);
	close(p2[0]);

	execlp("head", "haed", "-n1", NULL);
}
