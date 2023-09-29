#include <stdio.h> //printf
#include <fcntl.h> //open, close
#include <err.h> //err

int main(int argc, char ** argv){
	const char * fname = argv[1];
	int fd = open(fname, O_RDONLY);
	if (fd < 0) {
		err(1, "could not open file %s", fname);
	}
		
	int counter[256];
	for(int i = 1; i < 256; i++)
	{
		counter[i] = 0;
	}

	char buff;
	int num_bytes = read(fd, &buff, 1);
	while(num_bytes > 0)
	{
		counter[buff]++;
		num_bytes = read(fd, &buff, 1);
	}

	if (num_bytes < 0) {
		err(1, "could not read from file %s", fname);
	}

	if (close(fd) < 0) {
		err(1, "could not close file %s", fname);
	}

	fd = open(fname, O_WRONLY | O_TRUNC);

	for(int i = 1; i < 256; i++)
	{
		for(int j = 0; j < counter[i]; j++)
		{
			char ch = i;
			int written = write(fd, &ch, 1);
			if(written < 0)
			{
				err(1, "could not writte data");
			}
			if(written != 1)
			{
				errx(1, "could not write all at once");
			}
		}
	}

	if (close(fd) < 0) {
		err(1, "could not close file %s", fname);
	}
}
