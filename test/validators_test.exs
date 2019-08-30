defmodule ElixirPipelineValidations.ValidatorsTest do
  use ExUnit.Case

  import ElixirPipelineValidations, only: [combine: 1, combine: 2]

  describe "Validators" do
    test "required: should return error on nil" do
      run_func = combine([:required])
      value    = nil
      assert run_func.([:name], value) == {:error, "name can't be blank"}
    end

    test "required: can return error with value" do
      run_func = combine([:required], verbose_error: true)
      value    = nil
      assert run_func.([:name], value) == {:error, "name can't be blank. `nil` invalid."}
    end

    test "required: can succeed" do
      run_func = combine([:required], verbose_error: true)
      value    = "someValue"
      assert run_func.([:name], value) == {:ok, "someValue"}
    end
  end
end