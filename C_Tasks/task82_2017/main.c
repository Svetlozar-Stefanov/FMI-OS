#include <unistd.h>
#include <err.h>
#include <stdlib.h>

int main()
{
	int p1[2];
	int p2[2];
	if(pipe(p1) < 0) { err(1, ""); }
	
	pid_t pid = fork();
	if(pid < 0) { err(1, ""); }

	if(pid == 0)
	{
		close(p1[0]);
		dup2(p1[1], 1);
		char* args[] = {"cut", "-d:", "-f7", "/etc/passwd", NULL};
		if(execvp("cut", args) < 0) { err(1,""); }
		exit(0);
	}
	wait(NULL);

	if(pipe(p2) < 0) { err(1, ""); }

	pid = fork();
	if(pid < 0) { err(1, ""); }

	if(pid == 0)
	{
		close(p1[1]);
		dup2(p1[0], 0);
		close(p2[0]);
		dup2(p2[1], 1);
		char* args[] = {"uniq", "-c", NULL};
		if(execvp("uniq", args) < 0) { err(1,""); }
		exit(0);
	}
	
	close(p1[1]);
	close(p1[0]);
	close(p2[1]);
	dup2(p2[0], 0);

	char* args[] = {"sort", "-nr", NULL};
	if(execvp("sort", args) < 0) { err(1,""); }
	exit(0);
}
