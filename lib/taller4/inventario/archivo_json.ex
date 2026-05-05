defmodule Taller4.Inventario.ArchivoJSON do
  alias Taller4.Inventario.Producto

  @archivo "productos.json"

  # Carga los productos desde el archivo JSON. Si no existe, lo crea.

  def cargar_productos do
    case File.read(@archivo) do
      {:ok, contenido} ->
        parsear_json(contenido)

      {:error, :enoent} ->
        case File.write(@archivo, "{}") do
          :ok -> {:ok, %{}}
          {:error, razon} -> {:error, "No se pudo crear el archivo: #{razon}"}
        end

      {:error, razon} ->
        {:error, "Error al leer el archivo: #{razon}"}
    end
  end


  # Guarda todos los productos en el archivo JSON.

  def guardar_productos(productos) when is_map(productos) do
    mapa_serializable =
      productos
      |> Map.values()
      |> Enum.map(fn p ->
        %{
          "codigo"   => p.codigo,
          "nombre"   => p.nombre,
          "precio"   => p.precio,
          "cantidad" => p.cantidad
        }
      end)
      |> Enum.reduce(%{}, fn p, acc -> Map.put(acc, p["codigo"], p) end)

    case Jason.encode(mapa_serializable, pretty: true) do
      {:ok, json} ->
        case File.write(@archivo, json) do
          :ok -> :ok
          {:error, razon} -> {:error, "Error al escribir el archivo: #{razon}"}
        end

      {:error, razon} ->
        {:error, "Error al serializar JSON: #{razon}"}
    end
  end


  # Privadas 

  defp parsear_json(""), do: {:ok, %{}}

  defp parsear_json(contenido) do
    case Jason.decode(contenido) do
      {:ok, mapa} ->
        productos =
          mapa
          |> Enum.reduce(%{}, fn {_clave, p}, acc ->
            case Producto.nuevo(p["codigo"], p["nombre"], p["precio"], p["cantidad"]) do
              {:ok, producto} -> Map.put(acc, producto.codigo, producto)
              _ -> acc
            end
          end)

        {:ok, productos}

      {:error, razon} ->
        {:error, "Error al parsear JSON: #{razon}"}
    end
  end
end
