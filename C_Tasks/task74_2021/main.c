#include <err.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv)
{
	if(argc != 3) { errx(1, "kur"); }

	int fd1 = open(argv[1],O_RDONLY);
	if(fd1 < 0) {err(1, " "); }
	int fd2 = open(argv[2], O_CREAT | O_TRUNC | O_WRONLY, 0644);
	if(fd2 < 0) { err(1, " "); }

	uint8_t buff;
	while(read(fd1, &buff, sizeof(uint8_t)) > 0)
	{
		uint16_t nb = 0;
		int op = 0;
		int np = 0;
		while(op < 8)
		{
			uint8_t cur =  buff & (1 << op);
			printf("cur:%d\n", cur);
			if(cur == 0)
			{
				nb = nb | (1 << np);
			}
			else
			{
				nb = nb | (1 << (np + 1));
			}
			printf("nb: %d\n", nb);
			op++;
			np+=2;
		}

		if(write(fd2, &nb, sizeof(uint16_t)) < 0) {err(1, " "); }
	}

	close(fd1);
	close(fd2);
}
