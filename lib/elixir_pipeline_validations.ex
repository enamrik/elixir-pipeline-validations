defmodule ElixirPipelineValidations do
  alias ElixirPipelineValidations.Validators

  @default_validators %{
    required: &Validators.required/3
  }

  def combine(funcs, options \\ []) do
    fn name, value ->
      name = if is_list(name), do: Enum.join(name, "."), else: name
      funcs
      |> Enum.reduce({:ok, value}, fn func, cur_value ->

        func = if is_atom(func),
                  do:   @default_validators[func],
                  else: func

        case cur_value do
          {:ok,      val} -> return_value =
                               case :erlang.fun_info(func)[:arity] do
                                 0 -> func.()
                                 1 -> func.(val)
                                 2 -> func.(name, val)
                                 3 -> func.(name, val, options)
                               end

                             case return_value do
                               :ok             -> {:ok,       val}
                               {:ok,  new_val} -> {:ok,   new_val}
                               {:error, error} -> {:error,  error}
                               new_val         -> {:ok,   new_val}
                             end
          {:error, error} -> {:error, error}
        end
      end)
    end
  end
end
