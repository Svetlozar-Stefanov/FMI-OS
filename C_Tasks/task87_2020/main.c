#include <err.h>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>
#include <fcntl.h>

int main(int argc, char ** argv)
{
	if(argc != 3) { err(1, "parameters"); }
	
	int p[2];
	pipe(p);

	pid_t pid = fork();
	if(pid == 0)
	{
		close(p[0]);
		close(1);
		dup(p[1]);
		close(p[1]);

		if(execlp("cat", "cat", argv[1], NULL) < 0)
		{
			err(1, "hasmu cat");
		}
	}
	wait(NULL);

	close(p[1]);
	int fd = open(argv[2], O_CREAT | O_TRUNC | O_WRONLY, 0644);
	if(fd < 0) { err(1, "ni su otvarq"); }

	uint8_t buff;
	bool esc = false;
	int n_read;
	while((n_read = read(p[0], &buff, sizeof(uint8_t)) > 0))
	{
		if(buff == 0x55 && !esc) { continue; }
		if(buff == 0x7D && !esc) { esc = true; continue; }

		if(esc)
		{
			uint8_t real = buff ^ 0x20;
			if(real != 0x00 
			&& real != 0xFF
			&& real != 0x55
			&& real != 0x7D)
			{ errx(1, "neareln bait"); }

			if(write(fd, &real, 1) < 0) { err(1, "Ne moq i da pisha maika mu satra"); }
			esc = false;
			continue;
		}
		if(write(fd, &buff, 1) < 0) { err(1, "oshte ne moga da pisha. nz kakvo ochakvash"); }
	}
	if(n_read < 0) { err(1, "ni moq da chita"); };

	close(p[0]);
	close(fd);
}
