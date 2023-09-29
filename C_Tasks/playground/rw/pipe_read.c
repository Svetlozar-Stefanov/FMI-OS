#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

int main(){
	
		execlp("wc", "wc", "-c", NULL);
}
