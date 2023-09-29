#include <unistd.h>

int main(int argc, char** argv)
{
	execlp("ls", "ls", argv[1], 0);
}
