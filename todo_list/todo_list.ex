defmodule TodoList do

    defstruct auto_id: 1, entries: %{}

    def new(entries \\ []) do
      Enum.reduce(entries, %TodoList{}, &add_entry(&2, &1))
    end

    def add_entry(%TodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do

        entry = Map.put(entry, :id, auto_id);
        new_entries = Map.put(entries, auto_id, entry);

        %TodoList{todo_list | entries: new_entries, auto_id: auto_id + 1}
    end

    def entries(%TodoList{entries: entries}, date) do
        entries
        |> Stream.filter( fn({_, entry}) ->
                entry.date == date
           end)
        |> Enum.map( fn({_, entry}) ->
                entry
           end)
    end

    def update_entry(%TodoList{entries: entries} = todo_list, entry_id, updater_fun) do
        case entries[entry_id] do
          nil -> todo_list

          old_entry ->
            old_entry_id = old_entry.id
            new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
            new_entries = Map.put(entries, new_entry.id, new_entry);
            %TodoList{todo_list | entries: new_entries}
        end
    end

    def delete_entry(%TodoList{entries: entries} = todo_list, entry_id) do

        #==================
        # ALSO WORKS
        #==================
        #        new_entries = entries
        #        |> Stream.filter(fn ({id, _}) ->
        #                id != entry_id
        #            end)
        #        |> Enum.to_list
        #        %TodoList{todo_list | entries: new_entries}

        %TodoList{todo_list | entries: Map.delete(entries, entry_id)}
    end

end

# Protocal impl so TodoList can be collectable
# i.e.: can collect enumerables using TodoList

defimpl Collectable, for: TodoList do

  def into(original) do
    {original, &into_callback/2}
  end

  defp into_callback(todo_list {:cont, entry}) do
    TodoList.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list

  defp into_callback(todo_list, :halt), do: :ok

end
