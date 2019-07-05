defmodule GitDeleteSafe.StateTest do
  use ExUnit.Case, async: true

  alias GitDeleteSafe.State

  def options(options \\ [], arguments \\ [], invalid \\ []) do
    {options, arguments, invalid}
  end

  test "creates a state struct from an OptionParser tuple" do
    state = State.new(options())

    assert state.arguments == []
    assert state.invalid_options == []
    assert state.options == %{}
  end

  test "converts the options into a map so they can be pattern-matched" do
    state = State.new(options(foo: "bar"))

    assert state.options == %{foo: "bar"}
  end

  test "concatenates multiple option keys into a list" do
    state = State.new(options(foo: "bar", foo: "baz"))

    assert state.options.foo == ["baz", "bar"]
  end
end
