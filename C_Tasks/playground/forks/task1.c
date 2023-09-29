#include <unistd.h>

int main()
{
	execl("/bin/date", "date", (char*)NULL);
}
