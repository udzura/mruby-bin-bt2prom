def assert_input_parsed(title, input: "", expected: "")
  assert("attached_probes") do
    b = Bt2Prom.new
    data = input
    assert_equal(expected.chomp, b.to_prom_lines(input).join("\n"))
  end
end

expected = <<PROM
bpftrace_attached_probes_count 1
PROM
assert_input_parsed(
  "attached_probes",
  input: '{"type": "attached_probes", "data": {"probes": 1}}',
  expected: expected
)

expected = <<PROM
bpftrace_printf{data=\"[7147479679208] Hello, \\\"world\\n\"} 1
PROM
assert_input_parsed(
  "attached_probes",
  input: '{"type": "printf", "data": "[7147479679208] Hello, \"world\n"}',
  expected: expected
)

input = '{"type": "map", "data": {"@c": 103}}'
expected = <<PROM
bpftrace_var_c 103
PROM
assert_input_parsed(
  "map",
  input: input,
  expected: expected
)

input = '{"type": "map", "data": {"@c": {"systemd-journal": 1, "docker-containe": 21, "dockerd": 23, "redis-server": 38}}}'
expected = <<PROM
bpftrace_var_c{arg0="systemd-journal"} 1
bpftrace_var_c{arg0="docker-containe"} 21
bpftrace_var_c{arg0="dockerd"} 23
bpftrace_var_c{arg0="redis-server"} 38
PROM
assert_input_parsed(
  "map(nested)",
  input: input,
  expected: expected
)

input = '{"type": "hist", "data": {"@c": [{"max": -1, "count": 37}, {"min": 0, "max": 0, "count": 0}, {"min": 1, "max": 1, "count": 0}, {"min": 2, "max": 3, "count": 0}, {"min": 4, "max": 7, "count": 0}, {"min": 8, "max": 15, "count": 0}, {"min": 16, "max": 31, "count": 14}, {"min": 32, "max": 63, "count": 4}, {"min": 64, "max": 127, "count": 0}, {"min": 128, "max": 255, "count": 0}, {"min": 256, "max": 511, "count": 20}]}}'
expected = <<PROM
bpftrace_var_c{max="-1",range="..-1"} 37
bpftrace_var_c{max="0",min="0",range="0..0"} 0
bpftrace_var_c{max="1",min="1",range="1..1"} 0
bpftrace_var_c{max="3",min="2",range="2..3"} 0
bpftrace_var_c{max="7",min="4",range="4..7"} 0
bpftrace_var_c{max="15",min="8",range="8..15"} 0
bpftrace_var_c{max="31",min="16",range="16..31"} 14
bpftrace_var_c{max="63",min="32",range="32..63"} 4
bpftrace_var_c{max="127",min="64",range="64..127"} 0
bpftrace_var_c{max="255",min="128",range="128..255"} 0
bpftrace_var_c{max="511",min="256",range="256..511"} 20
PROM
assert_input_parsed(
  "hist",
  input: input,
  expected: expected
)

input = '{"type": "hist", "data": {"@c": {"vminfo": [{"min": 0, "max": 0, "count": 1}, {"min": 1, "max": 1, "count": 0}, {"min": 2, "max": 3, "count": 0}, {"min": 4, "max": 7, "count": 0}, {"min": 8, "max": 15, "count": 0}, {"min": 16, "max": 31, "count": 0}, {"min": 32, "max": 63, "count": 0}, {"min": 64, "max": 127, "count": 0}, {"min": 128, "max": 255, "count": 0}, {"min": 256, "max": 511, "count": 5}], "redis-server": [{"max": -1, "count": 19}, {"min": 0, "max": 0, "count": 0}, {"min": 1, "max": 1, "count": 0}]}}}'
expected = <<PROM
bpftrace_var_c{arg0="vminfo",max="0",min="0",range="0..0"} 1
bpftrace_var_c{arg0="vminfo",max="1",min="1",range="1..1"} 0
bpftrace_var_c{arg0="vminfo",max="3",min="2",range="2..3"} 0
bpftrace_var_c{arg0="vminfo",max="7",min="4",range="4..7"} 0
bpftrace_var_c{arg0="vminfo",max="15",min="8",range="8..15"} 0
bpftrace_var_c{arg0="vminfo",max="31",min="16",range="16..31"} 0
bpftrace_var_c{arg0="vminfo",max="63",min="32",range="32..63"} 0
bpftrace_var_c{arg0="vminfo",max="127",min="64",range="64..127"} 0
bpftrace_var_c{arg0="vminfo",max="255",min="128",range="128..255"} 0
bpftrace_var_c{arg0="vminfo",max="511",min="256",range="256..511"} 5
bpftrace_var_c{arg0="redis-server",max="-1",range="..-1"} 19
bpftrace_var_c{arg0="redis-server",max="0",min="0",range="0..0"} 0
bpftrace_var_c{arg0="redis-server",max="1",min="1",range="1..1"} 0
PROM
assert_input_parsed(
  "hist(nested)",
  input: input,
  expected: expected
)
