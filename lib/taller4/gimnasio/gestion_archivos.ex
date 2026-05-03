defmodule Taller4.Gimnasio.GestionArchivos do
  alias Taller4.Gimnasio.Socio

  @archivo "socios.csv"
  @cabecera "cedula,nombre,edad,clases\n"

  # Carga los socios desde el CSV. Si no existe, lo crea.

  def cargar_socios do
    case File.read(@archivo) do
      {:ok, contenido} ->
        parsear_csv(contenido)

      {:error, :enoent} ->
        case File.write(@archivo, @cabecera) do
          :ok -> {:ok, %{}}
          {:error, razon} -> {:error, "No se pudo crear el archivo: #{razon}"}
        end

      {:error, razon} ->
        {:error, "Error al leer el archivo: #{razon}"}
    end
  end


  # Guarda todos los socios en el CSV.
  def guardar_socios(socios) when is_map(socios) do
    filas =
      socios
      |> Map.values()
      |> Enum.map(&socio_a_linea/1)
      |> Enum.join("\n")

    contenido =
      if filas == "", do: @cabecera, else: @cabecera <> filas <> "\n"

    case File.write(@archivo, contenido) do
      :ok -> :ok
      {:error, razon} -> {:error, "Error al guardar: #{razon}"}
    end
  end


  # Privadas

  defp parsear_csv(contenido) do
    socios =
      contenido
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> Enum.reduce(%{}, fn linea, acc ->
        case parsear_linea(linea) do
          {:ok, socio} -> Map.put(acc, socio.cedula, socio)
          _ -> acc
        end
      end)

    {:ok, socios}
  end

  defp parsear_linea(linea) do
    case String.split(linea, ",") do
      [cedula, nombre, edad_str, clases_str] ->
        clases = if clases_str == "", do: [], else: String.split(clases_str, ";", trim: true)
        Socio.nuevo(cedula, nombre, edad_str, clases)

      _ ->
        {:error, "Línea inválida: #{linea}"}
    end
  end

  defp socio_a_linea(%Socio{cedula: c, nombre: n, edad: e, clases: clases}) do
    clases_str = Enum.join(clases, ";")
    "#{c},#{n},#{e},#{clases_str}"
  end
end
