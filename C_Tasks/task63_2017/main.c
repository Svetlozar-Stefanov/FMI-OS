#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdbool.h>

void print_start(int* line);

void print_start(int* line)
{
	if(*line > 0)
	{
		printf("%d ", (*line)++);
	}
}

int main(int argc, char** argv)
{
	int line = 0;
	int arg = 1;
	if(argc > 1 && strcmp(argv[arg], "-n") == 0)
	{
		line++;
		arg++;
	}

	print_start(&line);
	bool nl = false;

	if(argc-arg != 0)
	{
		for(;arg < argc; arg++)
		{	
			if(strcmp(argv[arg], "-") == 0)
			{
				char buff;
				while(read(0, &buff, 1) > 0)
				{
					if(nl)
					{
						print_start(&line);
						nl=false;	
					}
					printf("%c", buff);
					if(buff == '\n')
					{
						nl = true;
					}
				}
			}
			else
			{
				char buff;
				int fd = open(argv[arg], O_RDONLY);
				if(fd < 0)
				{
					err(1, "Could not open %s", argv[arg]);
				}
				while(read(fd, &buff, 1) > 0)
				{
					if(nl)
					{
						print_start(&line);
						nl = false;
					}
					printf("%c", buff);
					if(buff == '\n')
					{
						nl = true;
					}
				}
			}
		}
	}
	else
	{
		char buff;
		while(read(0, &buff, 1) > 0)
		{
			if(nl)
			{
				print_start(&line);
				nl = false;
			}
			printf("%c", buff);
			if(buff == '\n')
			{
				nl = true;
			}
		}
	}
}
