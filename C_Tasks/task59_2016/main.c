#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char ** argv)
{
	if(argc != 4) 
	{
		errx(1, "Invalid number of parameters");
	}
	const char * fn1 = argv[1];
	const char * fn2 = argv[2];
	const char * sfn = argv[3];

	struct pair {
		uint32_t pos;
		uint32_t off;
	};
	struct pair data;

	struct stat st;
	if(stat(fn1, &st) < 0)
	{
		err(1, "could not get stats for %s", fn1);
	}
	if(st.st_size % sizeof(data) != 0)
	{
		errx(1, "%s not binary", fn1);
	}

	if(stat(fn2, &st) < 0)
	{
		err(1, "could not get stats for %s", fn2);
	}
	if(st.st_size % sizeof(data) != 0)
	{
		errx(1, "%s not binary", fn2);
	}

	int pairs_fd = open(fn1, O_RDONLY);
	if(pairs_fd < 0) 
	{
		err(1, "Could not open file %s", fn1);
	}

	int nums_fd = open(fn2, O_RDONLY);
	if(nums_fd < 0)
	{
		err(1, "could not open file %s", fn2);
	}

	int res_fd = open(sfn, O_CREAT | O_WRONLY);
	if(res_fd < 0)
	{
		err(1, "could not open file %s", sfn);
	}

	ssize_t num_bytes = 0;
	while ((num_bytes = read(pairs_fd, &data, sizeof(data)) > 0))
	{
		int ch_pos = lseek(nums_fd, data.pos * sizeof(uint32_t), SEEK_SET);
		if(ch_pos < 0)
		{
			err(1, "could not change position");
		}
	
		uint32_t num;
		for(int i = 0; i < data.off; i++)
		{
			num_bytes = read(nums_fd, &num, sizeof(uint32_t));
			if(num_bytes < 0)
			{
				err(1, "could not read from %s", nums_fd);
			}
			
			num_bytes = write(res_fd, &num, sizeof(uint32_t));
			if(num_bytes < 0)
			{
				err(1, "could not write to %s", sfn);
			}
		}
	}

	if(num_bytes < 0)
	{
		err(1, "could not read from %s", fn1);
	}
	
	close(pairs_fd);
	//Error check
	close(nums_fd);
	//Error check
	close(res_fd);
	//Error check
}
