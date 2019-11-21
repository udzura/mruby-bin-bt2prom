class Bt2Prom
  VERSION = "0.2.1"

  def run
    $stdin.each_line do |l|
      next if l.strip.empty?
      v = to_prom_lines(l)
      puts v.join("\n") if v
    end
  end

  def version
    puts "#{$0} #{VERSION}"
  end

  def to_prom_lines(l)
    errcount = 0
    v = JSON.parse(l)
    ret = []
    case v["type"]
    when "attached_probes"
      buf = "bpftrace_attached_probes_count #{v["data"]["probes"]}"
      ret << buf
    when "printf"
      buf = "bpftrace_printf{data=#{v["data"].inspect}} 1"
      ret << buf
    when "map"
      data = v["data"]
      $stderr.puts data.inspect if ENV['DEBUG']
      if data.first[1].is_a?(Integer)
        data.each do |varname, value|
          buf = "bpftrace_" << varname.sub("@", "var_") << " "
          buf << value.to_s
          ret << buf
        end
      else
        data.each do |varname, values|
          values.each do |arg0, value|
            buf = "bpftrace_" << varname.sub("@", "var_")
            labels = []
            arg0.split(",").each_with_index do |arg, i|
              labels << "arg#{i}=#{arg.inspect}"
            end
            buf << "{#{labels.join(",")}} "
            buf << value.to_s
            ret << buf
          end
        end
      end
    when "hist"
      data = v["data"]
      if data.first[1].is_a?(Array)
        data.each do |varname, bins|
          bins.each do |bin|
            buf = "bpftrace_" << varname.sub("@", "var_")
            labels = []
            if !bin["min"]
              labels << "max=\"#{bin["max"]}\""
              labels << "range=\"..#{bin["max"]}\""
            else
              labels << "max=\"#{bin["max"]}\""
              labels << "min=\"#{bin["min"]}\""
              labels << "range=\"#{bin["min"]}..#{bin["max"]}\""
            end
            buf << "{#{labels.join(",")}} "
            buf << bin["count"].to_s
            ret << buf
          end
        end
      else
        data.each do |varname, values|
          values.each do |arg0, bins|
            bins.each do |bin|
              buf = "bpftrace_" << varname.sub("@", "var_")
              labels = []
              labels << "arg0=#{arg0.inspect}"
              if !bin["min"]
                labels << "max=\"#{bin["max"]}\""
                labels << "range=\"..#{bin["max"]}\""
              else
                labels << "max=\"#{bin["max"]}\""
                labels << "min=\"#{bin["min"]}\""
                labels << "range=\"#{bin["min"]}..#{bin["max"]}\""
              end
              buf << "{#{labels.join(",")}} "
              buf << bin["count"].to_s
              ret << buf
            end
          end
        end
      end
    else
      $stderr.puts "Unknown type: #{v.inspect}"
      errcount += 1
    end

    return ret
  rescue => e
    $stderr.puts e.inspect
    $stderr.puts e.backtrace
    errcount += 1
    ["bpftrace_parse_error_count #{errcount}"]
  end
end

def __main__(argv)
  cli = Bt2Prom.new
  case argv[0]
  when /(-+)?v(ersion)?/
    cli.version
  else
    cli.run
  end
end
