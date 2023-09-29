#include <err.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdint.h>

int main(int argc, char ** argv)
{
	if(argc != 3) { err(1, " "); }

	int fd1 = open(argv[1], O_RDONLY);
	if(fd1 < 0) { err(1, " "); }
	int fd2 = open(argv[2], O_RDONLY);;
	if(fd2 < 0) { err(1, " "); }
	int fd3 = open("output", O_CREAT | O_WRONLY, 0644);

	uint8_t bit;
	uint16_t el;
	while(read(fd1, &bit, 1) > 0)
	{
		read(fd2, &el, 2);
		if(bit == 1)
		{
			write(fd3, &el, 2);
		}
	}
	close(fd1);
	close(fd2);
	close(fd3);
}
