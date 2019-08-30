defmodule ElixirPipelineValidations.Validators do
  def required(name, value, options) do

    case value do
      nil   -> suffix = if Keyword.get(options, :verbose_error, false),
                           do:   ". `#{inspect(value)}` invalid.",
                           else: ""
               {:error, "#{name} can't be blank#{suffix}"}
      _else -> {:ok, value}
    end
  end
end
