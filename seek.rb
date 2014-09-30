

File.open("seektestfile", "r+") do |f|
  f.write("begin")
  f.seek(10, IO::SEEK_SET)
  f.write("end")
end


