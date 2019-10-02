defmodule ElixirPipelineValidationsTest do
  import ElixirPipelineValidations, only: [pipe: 1]
  use ExUnit.Case

  test "pipe: can succeed" do
    func1 = fn val -> {:ok, "#{val} 1"} end
    func2 = fn val -> {:ok, "#{val} 2"} end
    func3 = fn val -> {:ok, "#{val} 3"} end

    run_func = pipe([func1, func2, func3])
    value = "someValue"

    assert run_func.([:name], value) == {:ok, "someValue 1 2 3"}
  end

  test "pipe: can optionally pass name and value to func if func has arity of 2" do
    func1 = fn name, val -> {:ok, "#{val} #{inspect(name)}:1"} end
    func2 = fn name, val -> {:ok, "#{val} #{inspect(name)}:2"} end
    func3 = fn val -> {:ok, "#{val} 3"} end

    run_func = pipe([func1, func2, func3])
    value = "someValue"

    assert run_func.([:name], value) == {:ok, "someValue [:name]:1 [:name]:2 3"}
  end

  test "pipe: can pass no params to func" do
    func1 = fn name, val -> {:ok, "#{val} #{inspect(name)}:1"} end
    func2 = fn name, val -> {:ok, "#{val} #{inspect(name)}:2"} end
    func3 = fn-> {:ok, "3"} end

    run_func = pipe([func1, func2, func3])
    value = "someValue"

    assert run_func.([:name], value) == {:ok, "3"}
  end

  test "pipe: can skip func if no value" do
    func1 = fn val -> {:ok, "#{val} 1"} end
    func2 = fn val -> {:ok, "#{val} 2"} end
    func3 = fn _   -> :ok end

    run_func = pipe([func1, func2, func3])
    value = "someValue"

    assert run_func.([:name], value) == {:ok, "someValue 1 2"}
  end

  test "pipe: will short-circuit errors" do
    func1 = fn val -> {:ok, "#{val} 1"} end
    func2 = fn _   -> {:error, "SomeError"} end
    func3 = fn val -> {:ok, "#{val} 3"} end

    run_func = pipe([func1, func2, func3])
    value = "someValue"

    assert run_func.([:name], value) == {:error, "SomeError"}
  end
end
