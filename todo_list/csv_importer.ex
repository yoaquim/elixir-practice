defmodule TodoList.CsvImporter do
  defp read_file_lines(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp parse_line_entry(lines_list) do
    lines_list
    |> Stream.map(&convert_to_tuple(&1))
    |> Stream.map(&tuple_to_map(&1))
    |> Enum.to_list
  end

  defp convert_to_tuple(entry_string) do
    [date_string | tail] = String.split(entry_string, " ")
    [title | _] = tail
    [year, month, date] = date_string
        |> String.split("/")
        |> Stream.map(&String.to_integer(&1))
        |> Enum.to_list
    {{year, month, date}, title }
  end

  defp tuple_to_map({date, title})do
    %{date: date, title: title}
  end

  def import(path) do
    read_file_lines(path)
    |> parse_line_entry
    |> TodoList.new
  end
end
