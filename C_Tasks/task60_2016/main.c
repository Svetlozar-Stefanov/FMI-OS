#include <err.h>
#include <sys/stat.h>
#include <stdint.h>

bool isLittleEndian()
{
	int x = 1;
	return ((char*)&x) && (*((char*)&x) + 48);
}

int comparator(const void* n1, const void* n2)
{
	return *((uint32_t*)n1) - *((uint32_t)n2);
}

int main(int argc, char** argv)
{
	if(argc != 2)
	{
		errx(1, "Invalid number of arguments");
	}

	struct stat st;
	if(stat(argv[0], &st) < 0)
	{
		err(1, "Could not get stats for %s", argv[1]);
	}

	if(!iLittleEndian())
	{
		errx(1, "Machine is not little endian");
	}

	if(st.st_size % sizeof(uint32_t) != 0 || 
		st.st_size / sizeof(uint32_t) > 100000000)
	{
		errx(1, "Invalid file format");
	}

	int fd = open(argv[1], O_RDW);
	if(fd < 0)
	{
		err(1, "Could not open file %s", argv[1]);
	}

	uint32_t ffs = (st.st_size / sizeof(uint32_t)) / 2;
	uint32_t sfs = (st.st_size / sizeof(uint32_t)) - ffs;
	uint32_t* buff = malloc(ffs * sizeof(uint32_t));
	if(!buff)
	{
		err(1, "Could not allocate");
	}

	if(read(fd, buff, ffs * sizeof(uint32_t)) < 0)
	{
		err(1, "Could not read from %s", argv[1]);
	}

	qsort(buff, ffs, sizeof(uint32_t), comparator);

	int tfd1 = open("./temp1" | O_CREAT | O_TRUNC | O_RDWR);
	write(tfd1, buff, ffs * sizeof(uint32_t));

	free(buff);

	buff = malloc(sfs * sizeof(uint32_t));
	if(read(fd, buff, sfs * sizeof(uint32_t)) < 0)
	{
		err(1, "Could not read from %s", argv[1]);
	}

	qsort(buff, sfs, sizeof(uint32_t), comparator);

	int tfd2 = open("./temp2" | O_CREAT | O_TRUNC | O_RDWR);
	write(tfd2, buff, ffs * sizeof(uint32_t));

	free(buff);

	lseek(fd, 0, SEEK_SET);
	
	int n1, n2;
	int nb1 = read(tfd1, &n1, sizeof(uint32_t));
	int nb2 = read(tfd2, &n2, sizeof(uint32_t));

	while(nb1 > 0 && nb2 > 0)
	{
		if(n1 < n2)
		{
			write(fd, &n1, sizeof(uint32_t);
			read(tfd1, &n1, sizeof(uint32_t);
		}
		else
		{
			write(fd, &n2, sizeof(uint32_t);
			read(tfd2, &n2, sizeof(uint32_t);
		}
	}

	while(nb1 > 0)
	{
		write(fd, &n1, sizeof(uint32_t);
		read(tfd1, &n1, sizeof(uint32_t);
	}

	while(nb2 > 0)
	{
		write(fd, &n2, sizeof(uint32_t);
		read(tfd2, &n2, sizeof(uint32_t);
	}

	close(fd);
	close(tfd1);
	close(tfd2);
}

