# Test that zombie process exists as zombie in process table

cpid = fork {}
puts `ps -p #{cpid} -o state`
sleep 1
puts `ps -p #{cpid} -o state`
#Process.wait
t = Process.detach(cpid)
puts `ps -p #{cpid} -o state`
puts t.value

