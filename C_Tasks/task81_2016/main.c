#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>

int main()
{
	char command[20];
	scanf("%s", command);

	while(strcmp(command, "exit") != 0)
	{
		pid_t pid = fork();
		if(pid == 0)
		{
			if(execlp(command, command, 0, 0) < 0)
			{
				err(1, "Invalid command %s kur", command);
			}
			exit(0);
		}
		wait(NULL);
		scanf("%s", command);
	}
}
