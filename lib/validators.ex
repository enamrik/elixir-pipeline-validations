defmodule ElixirPipelineValidations.Validators do

  def required(name, value, options) do
    case value do
      nil   -> {:error, "#{name} can't be blank#{get_suffix(options, value)}"}
      _else -> {:ok, value}
    end
  end

  def not_empty(name, value, options) do
    error_result = {:error, "#{name} can't be empty#{get_suffix(options, value)}"}
    case value do
      nil   -> error_result
      ""    -> error_result
      []    -> error_result
      _else -> {:ok, value}
    end
  end

  defp get_suffix(options, value) do
    if Keyword.get(options, :verbose_error, false),
       do:   ". `#{inspect(value)}` invalid.",
       else: ""
  end
end
