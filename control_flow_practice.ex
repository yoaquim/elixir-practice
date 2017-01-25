defmodule ControlFlowPractice do

  def list_len(list) do
    calc_len(list, 0)
  end

  defp calc_len([], count) do
    count
  end

  defp calc_len([_ | tail], count) do
    calc_len(tail, count + 1)
  end

  def range(from, to) do
    get_num_from_range([], from, to)
  end

  defp get_num_from_range(list, start, bound) when bound < start do
    list
  end

  defp get_num_from_range(list, start, bound) do
    get_num_from_range([bound | list], start, bound - 1)
  end

  def positive(list) do
    get_positives(list, [])
  end

  defp get_positives([], final_list) do
    Enum.reverse(final_list)
  end

  defp get_positives([head | tail], final_list) when head > 0 do
    get_positives(tail, [head | final_list])
  end

  defp get_positives([_ | tail], final_list) do
    get_positives(tail, final_list)
  end

end