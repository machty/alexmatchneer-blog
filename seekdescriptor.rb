File.open('shareddesctest.txt', 'w') do |f|
  if fork
    # parent
    f.seek(1, IO::SEEK_SET)
    Process.wait
  else
    # child
    sleep 1
    f.write "wat"
  end
end

