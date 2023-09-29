#include <err.h>
#include <sys/stat.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <fcntl.h>

bool isBinary(const char* path);
bool isValidIdx(const char* path);

struct info{
	uint16_t offset;
	uint8_t length;
	uint8_t saved;
};

bool isBinary(const char* path)
{
	struct stat st;
	if(stat(path, &st) < 0)
	{
		err(1, "Could not get info about %s", path);
	}

	if(st.st_size % sizeof(uint8_t) != 0)
		return false;

	return true;
}

bool isValidIdx(const char* path)
{
	struct stat st;
	if(stat(path, &st) < 0)
	{
		err(1, "Could not get info about %s", path);
	}

	if(st.st_size % sizeof(struct info) != 0)
		return false;

	return true;
}


int main(int argc, char** argv)
{
	if(argc != 5)
	{
		errx(1, "Invalid number of parameters");
	}
	
	const char* f1 = argv[1];
	const char* idx1 = argv[2];
	const char* f2 = argv[3];
	const char* idx2 = argv[4];

	if(!isBinary(f1))
	{
		errx(1, "%s not binary", f1);
	}
		
	if(!isValidIdx(idx1))
	{
		errx(1, "%s not valid", idx1);
	}

	int fd1 = open(f1, O_RDONLY);
	if(fd1 < 0)
	{
		err(1, "Could not open %s", f1);
	}

	int fdi1 = open(idx1, O_RDONLY);
	if(fdi1 < 0)
	{
		err(1, "Could not open %s", idx1);
	}

	int fd2 = open(f2, O_WRONLY | O_CREAT);
	int fdi2 = open(idx2, O_WRONLY | O_CREAT);
	
	struct info inf;
	uint16_t pos = 0;
	while(read(fdi1, &inf, sizeof(inf)) > 0)
	{
		if(lseek(f1, inf.offset * sizeof(uint8_t), SEEK_SET) < 0)
		{
			err(1, "Could not move to pos %d", inf.offset);
		}

		char letter;
		ssize_t nr =  read(f1, &letter, sizeof(char));
		if(letter < 'A' || letter > 'Z')
		{
			continue;
		}

		struct info newInf;
		newInf.offset = pos;
		newInf.length = inf.length;
		newInf.saved = 0;
		for(int i = 1; i < inf.length; i++)
		{
			if(write(fd2, &letter, sizeof(char)) < 0)
			{
				err(1, "Could not write to %s", f2);
			}
			pos++;
			nr = read(f1, &letter, sizeof(char));
		}		

		if(write(fdi2, &newInf, sizeof(newInf)) < 0)
		{
			err(1, "Could not write to %s", idx2);
		}
	}

	close(fd1);
	close(fdi1);
	close(fd2);
	close(fdi2);
	
	return 0;
}
