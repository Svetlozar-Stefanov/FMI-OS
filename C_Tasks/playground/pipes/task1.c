#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv)
{
	int fd = open(argv[1], O_WRONLY);

	write(fd, "fo", 2);

	pid_t pid = fork();
	if(pid == 0)
	{
		if(write(fd, "bar\n", 4) < 0)
		{
			err(1, "couldnt write");
		}
		exit(0);
	}
	else
	{
		int status;
		if(wait(&status) < 0)
		{
			err(1, "could not wait");
		}

		if(!WIFEXITED(status))
		{
			err(1, "could not trminate normally");
		}
		if(WEXITSTATUS(status) != 0)
		{
			err(1, "exit stus not 0");
		}
		
		write(fd, "o\n", 2);
	}

	close(fd);
}
