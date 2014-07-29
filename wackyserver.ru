
class App
  def self.call(env)
    [200, { "Content-Type" => "text/plain"}, ["Hello"]]
  end
end

run App

