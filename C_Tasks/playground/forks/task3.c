#include <unistd.h>

int main()
{
	execlp("sleep", "sleep", "5", (char*)NULL);
}
