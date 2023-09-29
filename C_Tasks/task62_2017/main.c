#include <err.h>
#include <sys/stat.h>
#include <stdint.h>
#include <fcntl.h>

void binaryTest(const char* path);
void dataTest(const char* path);
void cmpSize(const char* p1, const char * p2);

struct data{
	uint16_t offset;
	uint8_t original;
	uint8_t nbyte;
};


void binaryTest(const char* path)
{
	struct stat st;
	if(stat(path, &st) < 0)
	{
		err(1, "Could not get state for %s", path);
	}

	if(st.st_size % sizeof(uint8_t) != 0)
	{
		errx(1, "File %s is in invalid format", path);
	}	
}

void dataTest(const char* path)
{
	struct stat st;
	if(stat(path, &st) < 0)
	{
		err(1, "Could not get state for %s", path);
	}

	if(st.st_size % sizeof(struct data) != 0)
	{
		errx(1, "%s invalid format", path);
	}
}

void cmpSize(const char* p1, const char* p2)
{
	struct stat st1;
	if(stat(p1, &st1) < 0)
	{
		err(1, "err stat %s", p1);
	}

	struct stat st2;
	if(stat(p2, &st2) < 0)
	{
		err(1, "err stat %s", p2);
	}

	if(st1.st_size != st2.st_size)
	{
		errx(1, "Files different length");
	}
}

int main(int argc, char ** argv)
{
	if(argc != 4)
	{
		errx(1, "Invalid number of arguments");
	}
	binaryTest(argv[1]);
	binaryTest(argv[2]);	
	//dataTest(argv[3]);
	cmpSize(argv[1], argv[2]);
	
	int fd1 = open(argv[1], O_RDONLY);
	int fd2 = open(argv[2], O_RDONLY);
	int fd3 = open(argv[3], O_CREAT | O_TRUNC | O_WRONLY, 644 );
	//Tests

	uint8_t b1, b2;
	while( read(fd1, &b1, sizeof(uint8_t)) > 0 &&
			read(fd2, &b2, sizeof(uint8_t)) >0 )
	{
		if(b1 != b2)
		{
			struct data d;
			d.offset = lseek(fd1, 0, SEEK_CUR);
			d.original = b1;
			d.nbyte = b2;

			if(write(fd3, &d, sizeof(d)) < 0)
			{
				err(1, "Could not write in %s", argv[3]);
			}
		}
	}

	close(fd1);
	close(fd2);
	close(fd3);
}
