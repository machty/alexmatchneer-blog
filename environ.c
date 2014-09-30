#include <stdio.h>
extern char **environ;
int main() {
  printf("%s\n", environ[0]);
  return 0;
}

