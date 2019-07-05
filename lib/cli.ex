defmodule GitDeleteSafe.CLI do
  @moduledoc """
  Handles the command-line interface for the utility.
  """

  alias GitDeleteSafe.State

  require Logger

  defmacrop log_state(state) do
    quote do
      Logger.debug(fn -> "Starting #{format_function(__ENV__.function)}" end)
      Logger.debug(fn -> inspect(unquote(state)) end)
    end
  end

  def main(args) do
    args
    |> parse_arguments()
    |> run()
  end

  def parse_arguments(args) do
    args
    |> OptionParser.parse(
      switches: [
        debug: :boolean,
        verbose: :boolean
      ],
      aliases: [
        d: :debug,
        v: :verbose
      ]
    )
    |> State.new()
  end

  def run(%State{} = state) do
    state
    |> set_verbosity()
    |> fetch()
    |> has_no_uncommitted_files()
    |> has_no_stashed_changes()
    |> handle_success()
  end

  def fetch(state) do
    case execute_git(["fetch"]) do
      {_, _output, 0} -> state
      error -> handle_git_error(state, error)
    end
  end

  def handle_success(%State{success: false}), do: shutdown(1)
  def handle_success(_state), do: nil

  def has_no_stashed_changes(%State{} = state) do
    case execute_git(["stash", "list"]) do
      {_, "", 0} ->
        Logger.debug("#{state.working_dir} has no stashed changes")

        state

      {_, output, 0} ->
        Logger.error("#{state.working_dir} has stashed changes")

        output
        |> String.split("\n", trim: true)
        |> Enum.each(fn line -> Logger.info("\t#{line}") end)

        %State{state | success: false}

      error ->
        handle_git_error(state, error)
    end
  end

  def has_no_uncommitted_files(%State{} = state) do
    case execute_git(["status", "--porcelain"]) do
      {_, "", 0} ->
        Logger.debug("#{state.working_dir} has no uncommitted files")

        state

      {_, output, 0} ->
        Logger.error("#{state.working_dir} has uncommitted files")

        output
        |> String.split("\n", trim: true)
        |> Enum.each(fn line -> Logger.info("\t#{line}") end)

        %State{state | success: false}

      error ->
        handle_git_error(state, error)
    end
  end

  defp execute_git(list) when is_list(list) do
    command = "git #{Enum.join(list, " ")}"

    Logger.debug("Execute `#{command}`")

    {output, error_code} = System.cmd("git", list)

    {command, output, error_code}
  end

  defp format_function({name, arity}), do: "#{name}/#{arity}"

  defp handle_git_error(%State{options: %{debug: true}}, {command, output, error_code}) do
    Logger.debug("`#{command}` exited with error code #{error_code}")

    output
    |> String.split("\n")
    |> Enum.each(fn line -> Logger.debug("\t" <> line) end)

    shutdown(error_code)
  end

  defp handle_git_error(_state, {_command, _output, error_code}), do: shutdown(error_code)

  defp set_verbosity(%State{options: %{debug: true}} = state) do
    Logger.configure_backend(:console, level: :debug)

    log_state(state)

    state
  end

  defp set_verbosity(%State{options: %{verbose: true}} = state) do
    log_state(state)

    Logger.configure_backend(:console, level: :info)

    state
  end

  defp set_verbosity(state), do: state

  defp shutdown(error_code), do: exit({:shutdown, error_code})
end
