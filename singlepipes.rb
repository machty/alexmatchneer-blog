require 'benchmark'
require 'stringio'

n = 100000
Benchmark.bm do |x|
  x.report("pipes:") {
    n.times do
      rd, wr = IO.pipe
      wr.write "HELLO"
      wr.close
      raise "wat" unless rd.read == "HELLO"
      rd.close
    end
  }

  x.report("StringIO") {
    n.times do
      s = StringIO.new("HELLO")
      raise "wat" unless s.read == "HELLO"
      s.close
    end
  }

  rd, wr = IO.pipe
  x.report("pipes:") {
    n.times do
      wr.write "HELLO"
      raise "wat" unless rd.read == "HELLO"
    end
  }
  wr.close
  rd.close
end


