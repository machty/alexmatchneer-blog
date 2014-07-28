#include <stdio.h>
#include <signal.h>
#include <unistd.h>

static int gotSignal = 0;

void wat(int s) {
  printf("Got Signal %d", s);
  gotSignal = 1;
}

int main() {
  /* SIGUSR1 == 16 */
  signal(SIGUSR1, &wat);

  pid_t pid = getpid();
  printf("The process id is %d", pid);

  // prevent signal from getting here
  sigset_t s;
  sigaddset(&s, SIGUSR1);
  // uncomment to block the signal from arriving
  //sigprocmask(SIG_BLOCK, &s, NULL);

  while(!gotSignal) {
    printf(".");
    fflush(stdout);
    sleep(1);
  }

  printf("\nDone!\n");
}


// I got embarrassed thinking about how I over-explained to Tim some
// technological thing. A quick embarrassed spaz on the computer. It's
// so GOD DAMN INGRAINED. FUCKLES.

