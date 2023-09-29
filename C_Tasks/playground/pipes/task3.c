#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char** argv)
{
	int p[2];
	pipe(p);

	pid_t pid = fork();
	if(pid == 0)
	{
		close(p[1]);
		dup2(p[0], 0);
		execlp("wc", "wc", "-c", (char*)NULL);
		close(p[0]);
		exit(0);
	}

	close(p[0]);
	write(p[1], argv[1], strlen(argv[1]));
	close(p[1]);
	wait(NULL);
	exit(0);
}
