#include <err.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <fcntl.h>
#include <stdint.h>
#include <errno.h>
#include <stdbool.h>

int main(int argc, char** argv)
{
	if(argc > 4) { errx(1, " "); }
	if(strlen(argv[1]) > 1) { errx(2, " ");	 }
	
	int sec = argv[1][0] - '0';	
	const char* comm = argv[2];
	char** args = (char**)malloc((argc-1) * sizeof(char*));
	for(int i = 2; i < argc; i++)
	{
		args[i-2] = argv[i];
	}
	args[argc-1] = NULL;

	int fd = open("run.log", O_CREAT | O_TRUNC | O_WRONLY, 0644);
	if(fd < 0) { err(3, " "); };
	int count=0;

	while(count < 2)
	{
		pid_t pid = fork();
		if(pid < 0) { err(5, " "); }
		time_t start = time(NULL);
		if(pid == 0)
		{
			if(execvp(comm, args) < 0)
			{
				err(1, " ");
			}
		}
		int status;
		if(wait(&status) < 0) { err(1, " "); }
		time_t stop = time(NULL);
		if(write(fd, &start, sizeof(time)) < 0) { err(4, " "); }
		int er = status;
		if(WIFEXITED(status)){
			er = WEXITSTATUS(status);
		}
		if(write(fd, &stop, sizeof(time_t)) < 0) { err(4, " "); };
		if(write(fd, &er, sizeof(int)) < 0) { err(4, " "); } 

		fprintf(stderr, "%ld %ld %d\n", start, stop, er);

		if(er != 0 || stop - start < sec)
		{
			count++;
		}
		else { count = 0; }
	}

	close(fd);
}
