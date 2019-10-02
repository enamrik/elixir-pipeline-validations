defmodule ElixirPipelineValidations.ValidatorsTest do
  alias ElixirPipelineValidations.ValidatorError

  use ExUnit.Case

  import ElixirPipelineValidations, only: [pipe: 1, pipe: 2]

  describe "Validators" do
    test "required: should return error on nil" do
      run_func = pipe([:required])
      value    = nil
      assert run_func.([:name], value) == {:error,  %ValidatorError{field: [:name], message: "can't be blank"}}
    end

    test "required: can return error with value" do
      run_func = pipe([:required], verbose_error: true)
      value    = nil
      assert run_func.([:name], value) == {:error, %ValidatorError{field: [:name], message: "can't be blank. `nil` invalid."}}
    end

    test "required: can succeed" do
      run_func = pipe([:required], verbose_error: true)
      value    = "someValue"
      assert run_func.([:name], value) == {:ok, "someValue"}
    end

    test "not_empty: should return error on nil" do
      run_func = pipe([:not_empty])
      value    = nil
      assert run_func.([:name], value) == {:error, %ValidatorError{field: [:name], message: "can't be empty"}}
    end

    test "not_empty: should return error on empty string" do
      run_func = pipe([:not_empty])
      value    = ""
      assert run_func.([:name], value) == {:error, %ValidatorError{field: [:name], message: "can't be empty"}}
    end

    test "not_empty: should return error on empty array" do
      run_func = pipe([:not_empty])
      value    = []
      assert run_func.([:name], value) == {:error, %ValidatorError{field: [:name], message: "can't be empty"}}
    end

    test "not_empty: can return error with value" do
      run_func = pipe([:not_empty], verbose_error: true)
      value    = []
      assert run_func.([:name], value) == {:error, %ValidatorError{field: [:name], message: "can't be empty. `[]` invalid."}}
    end

    test "not_empty: can succeed with non-empty string" do
      run_func = pipe([:not_empty], verbose_error: true)
      value    = "someValue"
      assert run_func.([:name], value) == {:ok, "someValue"}
    end

    test "not_empty: can succeed with non-empty array" do
      run_func = pipe([:not_empty], verbose_error: true)
      value    = ["someValue"]
      assert run_func.([:name], value) == {:ok, ["someValue"]}
    end
  end
end