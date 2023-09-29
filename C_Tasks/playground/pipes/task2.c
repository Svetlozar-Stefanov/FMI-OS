#include <unistd.h>
#include <err.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv)
{
	int p[2];
	if(pipe(p) < 0)
	{
		err(1, "failed pipe");
	}

	pid_t pid = fork();
	if(pid > 0)
	{
		write(p[1], argv[1], strlen(argv[1]));
		//close(p[1]);
	}
	else
	{
		//close(p[1]);
		char buff[2048];
		read(p[0], buff, 2048);
		printf("%s", buff);
		exit(0);
	}
	
	wait(NULL);
	printf("kur");
}
