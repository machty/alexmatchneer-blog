#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void foo();

int main() {
  void *curBrk;

  int pointer;
  printf("xxx is %p\n", (void *) &pointer);

  foo();

  curBrk = sbrk(0);
  printf("brk is %p\n", curBrk);

  for (int i = 0; i < 20; ++i) {
    int * wat = malloc(sizeof (int));
    printf("wat is %p\n", wat);
  }

  curBrk = sbrk(0);
  printf("brk is %p\n", curBrk);

  return 0;
}

void foo() {
  int pointer;
  printf("foo is %p\n", (void *) &pointer);
}

