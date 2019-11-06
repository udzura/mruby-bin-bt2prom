class Bt2Prom
  VERSION = "0.1.0"

  def run
    puts "#{$0}: #{VERSION}"
  end
end

def __main__(argv)
  cli = Bt2Prom.new
  cli.run
end
