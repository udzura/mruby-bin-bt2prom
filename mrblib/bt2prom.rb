class Bt2Prom
  VERSION = "0.1.0"

  def run
    $stdin.each_line do |l|
      next if l.strip.empty?
      v = to_prom_lines(l)
      puts v.join("\n") if v
    end
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
      if data.keys.first !~ /^@/
        data.each do |arg0, value|
          buf = "bpftrace_map"
          buf << "{arg0=#{arg0.inspect}} "
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
    else
      $stderr.puts "Unknown type: #{v.inspect}"
      errcount += 1
    end

    return ret
  rescue => e
    $stderr.puts e.inspect
    errcount += 1
    ["bpftrace_parse_error_count #{errcount}"]
  end
end

def __main__(argv)
  cli = Bt2Prom.new
  cli.run
end
