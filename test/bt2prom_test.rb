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

assert("map") do
  b = Bt2Prom.new
end

assert("hist") do
  b = Bt2Prom.new
end
