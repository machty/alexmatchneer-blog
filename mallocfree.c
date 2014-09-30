#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
  long long * foo = malloc(sizeof(long long));
  *foo = 1;

  long long * bar = malloc(sizeof(long long));
  *bar = 1;

  printf("%lld %lld\n", *foo, *bar);

  int size, size2;

  size = *((int*) (((void *) foo) - 1));
  size2 = *((int*) (((void *) foo) - 2));
  printf("size of allocated foo chunk %d %d \n", size, size2);

  free(bar);
  free(foo);

  size = *((int*) (((void *) foo) - 1));
  printf("size of allocated foo chunk %d \n", size);

  printf("%lld %lld\n", *foo, *bar);

}


