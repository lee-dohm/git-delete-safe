defmodule GitDeleteSafe.State do
  @moduledoc """
  Represents the state of things as the program executes.

  This structure collects the important information that may be of interest to multiple functions
  as the program executes. It starts with the parsed command-line options and arguments provided
  by `OptionParser`. From there, other information that is needed for the program to do its work
  are added to be passed on to later functions.

  For another example of the same pattern used at larger scale, see `Plug.Conn`.
  """

  defstruct [:arguments, :invalid_options, :options]

  @type parsed_options :: {OptionParser.parsed(), OptionParser.argv(), OptionParser.errors()}

  def new({options, arguments, invalid} = _parsed_options) do
    %__MODULE__{
      arguments: arguments,
      invalid_options: invalid,
      options: coalesce_options(options)
    }
  end

  defp coalesce_options(options) do
    coalesce_options(%{}, options)
  end

  defp coalesce_options(map, []), do: map

  defp coalesce_options(map, [{key, value} | tail]) do
    map
    |> Map.update(key, value, &prepend_value(&1, value))
    |> coalesce_options(tail)
  end

  defp prepend_value(list, value) when is_list(list), do: [value | list]
  defp prepend_value(item, value), do: [value | [item]]
end
