defmodule ElixirPipelineValidations.ValidatorError do
  defstruct [:field, :message]

  def new([_ | _] = field, message) when is_list(field) when is_binary(message) do
    %__MODULE__{field: field, message: message}
  end

  def tail_field_name(%__MODULE__{field: field}) do
    field |> Enum.take(-1) |> Enum.at(0)
  end
end
