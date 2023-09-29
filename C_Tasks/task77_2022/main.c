#include <stdint.h>
#include <sys/stat.h>

struct header
{
	uint16_t magic;
	uint16_t filetype;
	uint32_t count;
};

int main(int argc, char** argv)
{
	int fd1 = open(argv[1], O_RDONLY);
	int fd2 = open(argv[2], O_RDONLY);
	int fd3 = open(argv[3], O_RDWR);

	struct header h;
	struct stat st;
	read(fd1, &h, sizeof(h));
	stat(argv[1], &st);
	if(h.magic != 0x5A4D || h.filetype != 1 || (st.st_size - 8) % sizeof(uint16_t) != 0)
	{ errx(1, " "); }
	//TODO for the rest

	
}	
