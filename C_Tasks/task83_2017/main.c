#include <string.h>
#include <err.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char** argv)
{
	const char* command = "echo";
	if(argc == 2)
	{
		if(strlen(argv[1]) > 4) { errx(1, ""); }
		
		command = argv[1];
	}

	int p[2];
	pipe(p);

	pid_t pid = fork();
	if(pid == 0)
	{
		close(p[1]);
		char* args[10] = {NULL};

		int i = 0;	
		args[i] = (char*)malloc(sizeof(char) * 5);
		strcpy(args[i++], command);

		int j = 0;
		char arg[5];
		char c;
		while(read(p[0], &c, 1) > 0)
		{
			if(c != ' ' && c != '\n')
			{
				if(j > 3) { errx(1, "long arg"); };
				arg[j++] = c;
			}
			else
			{
				arg[j] = '\0';
				args[i] = (char*)malloc(sizeof(char) * 5);
				strcpy(args[i++], arg);

				for(int l = 0; l < 4; l++)
				{
					arg[l] = '\0';
				}
				j=0;
			}
		}

		close(p[0]);
		execvp(command, args);
		exit(0);
	}

	close(p[0]);
	int buff;
	while((buff = getchar()) > 0)
	{
		char c = (char)buff;
		write(p[1], &c, 1);
	}
	close(p[1]);
	wait(NULL);
}
