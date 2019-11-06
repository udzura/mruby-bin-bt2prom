assert("Hello world") do
  t = Bt2Prom.new "hello"
  assert_equal("hello", t.hello)
end
