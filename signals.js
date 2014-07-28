var done = false;

process.on("SIGUSR1", function() {
  done = true;
});

console.log("pid: ", process.pid);

var timerId = setInterval(function() {
  if (done) {
    console.log("DONEZO");
    clearInterval(timerId);
  } else {
    process.stdout.write(".");
  }
}, 500);




