f = File.open('wat')

# This alternates and alternates.
# So where does the fooking pointer live? I'm still
# confused about copying file handles.
2.times do
  fork do
    puts f.read
  end
end


