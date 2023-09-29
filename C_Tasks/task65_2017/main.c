#include <stdio.h>
#include <fcntl.h>

void stdin_read()
{
	char buff;
	while(read(0, &buff, 1) > 0)
	{
		printf("%c", buff);
	}
}

int main(int argc, char ** argv)
{
	if(argc == 1)
	{
		stdin_read();
	}
	else if(argc > 1)
	{
		for(int i = 1; i < argc; i++)
		{
			if(argv[i][0] != '-')
			{
				int fd = open(argv[i], O_RDONLY);
				char buff;
				while(read(fd, &buff, 1) > 0)
				{
					printf("%c", buff);
				}
			}
			else
			{
				stdin_read();
			}
		}
	}
}
		
