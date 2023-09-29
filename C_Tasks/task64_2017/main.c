#include <err.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>

void binTest(const char* path);

void binTest(const char* path)
{
	struct stat st;
	if(stat(path, &st) < 0)
	{
		err(1,"err stat %s", path);
	}

	if(st.st_size % sizeof(uint8_t) != 0)
	{
		errx(1, "not bin");
	}
}

int main(int argc, char ** argv)
{
	if(argc != 4)
	{
		errx(1, "Invalid number of param");
	}
	binTest(argv[1]);
	binTest(argv[2]);

	struct data{
		uint16_t offset;
		uint8_t original;
		uint8_t nbyte;
	} d;
	
	struct stat st;
	if(stat(argv[3], &st) < 0)
	{
		err(1, "err stat %s", argv[3]);
	}

	if(st.st_size % sizeof(d) != 0)
	{
		errx(1, "inv format %s", argv[3]);
	}

	int fd1 = open(argv[1], O_RDONLY);
	int fd2 = open(argv[2], O_WRONLY | O_CREAT, 644);
	int fd3 = open(argv[3], O_RDONLY);

	uint8_t buff;
	while(read(fd1, &buff, sizeof(uint8_t)) > 0)
	{
		write(fd2, &buff, sizeof(uint8_t));
	}

	while(read(fd3, &d, sizeof(d)) > 0)
	{
		lseek(fd2, d.offset, SEEK_SET);
		read(fd1, &buff, sizeof(uint8_t));
		if(buff != d.original)
		{
			errx(1, "inconsistent file %s", argv[1]);
		}
		lseek(fd2, d.offset, SEEK_SET);
		write(fd2, &d.nbyte, sizeof(uint8_t));
	}
}
