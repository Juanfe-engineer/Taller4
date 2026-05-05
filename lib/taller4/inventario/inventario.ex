defmodule Taller4.Inventario.Inventario do
  alias Taller4.Inventario.Producto
  alias Taller4.Inventario.ArchivoJSON


  # Carga los productos desde el archivo JSON.

  def cargar do
    ArchivoJSON.cargar_productos()
  end


  # Agrega un nuevo producto al inventario.

  def agregar_producto(productos, codigo, nombre, precio, cantidad) do
    if Map.has_key?(productos, codigo) do
      {:error, "Ya existe un producto con el código #{codigo}"}
    else
      case Producto.nuevo(codigo, nombre, precio, cantidad) do
        {:ok, producto} ->
          nuevos = Map.put(productos, codigo, producto)
          case ArchivoJSON.guardar_productos(nuevos) do
            :ok -> {:ok, nuevos}
            {:error, razon} -> {:error, razon}
          end

        {:error, razon} ->
          {:error, razon}
      end
    end
  end


  # Actualiza un producto existente.

  def actualizar_producto(productos, codigo, nombre, precio, cantidad) do
    if Map.has_key?(productos, codigo) do
      case Producto.nuevo(codigo, nombre, precio, cantidad) do
        {:ok, producto} ->
          nuevos = Map.put(productos, codigo, producto)
          case ArchivoJSON.guardar_productos(nuevos) do
            :ok -> {:ok, nuevos}
            {:error, razon} -> {:error, razon}
          end

        {:error, razon} ->
          {:error, razon}
      end
    else
      {:error, "No existe un producto con el código #{codigo}"}
    end
  end


  # Elimina un producto por código.

  def eliminar_producto(productos, codigo) do
    if Map.has_key?(productos, codigo) do
      nuevos = Map.delete(productos, codigo)
      case ArchivoJSON.guardar_productos(nuevos) do
        :ok -> {:ok, nuevos}
        {:error, razon} -> {:error, razon}
      end
    else
      {:error, "No existe un producto con el código #{codigo}"}
    end
  end


  # Lista todos los productos.

  def listar_productos(productos) do
    {:ok, Map.values(productos)}
  end


  # CONSULTAS CON ENUM

  # Productos cuyo nombre contenga al menos dos vocales. Retorna [{codigo, nombre}]"

  def productos_con_dos_vocales(productos) do
    resultado =
      productos
      |> Map.values()
      |> Enum.filter(fn p ->
        p.nombre
        |> String.downcase()
        |> String.graphemes()
        |> Enum.count(&(&1 in ["a", "e", "i", "o", "u", "á", "é", "í", "ó", "ú"])) >= 2
      end)
      |> Enum.map(fn p -> {p.codigo, p.nombre} end)

    {:ok, resultado}
  end


  # Productos cuyo nombre comience y termine con la misma letra.

  def productos_misma_letra(productos) do
    resultado =
      productos
      |> Map.values()
      |> Enum.filter(fn p ->
        nombre = String.downcase(p.nombre)
        primera = String.first(nombre)
        ultima = String.last(nombre)
        primera != nil and primera == ultima
      end)

    {:ok, resultado}
  end


  # Productos con precio por debajo de un valor dado.
  def productos_precio_menor(productos, valor) do
    resultado =
      productos
      |> Map.values()
      |> Enum.filter(fn p -> p.precio < valor end)

    {:ok, resultado}
  end


  # Los tres productos más caros del inventario."
  def tres_mas_caros(productos) do
    resultado =
      productos
      |> Map.values()
      |> Enum.sort_by(fn p -> p.precio end, :desc)
      |> Enum.take(3)

    {:ok, resultado}
  end



  # Productos con precio entre dos valores.
  
  def productos_precio_entre(productos, min, max) do
    resultado =
      productos
      |> Map.values()
      |> Enum.filter(fn p -> p.precio >= min and p.precio <= max end)
      |> Enum.map(fn p -> "#{p.nombre} - #{p.precio}" end)
      |> Enum.join(", ")

    {:ok, resultado}
  end


  # Agrupa productos por rango de precio.

  def agrupar_por_precio(productos) do
    grupos =
      productos
      |> Map.values()
      |> Enum.group_by(fn p ->
        cond do
          p.precio < 50_000 -> :menor
          p.precio >= 50_000 and p.precio <= 100_000 -> :medio
          true -> :mayor
        end
      end)

    resultado = %{
      menor: Map.get(grupos, :menor, []),
      medio: Map.get(grupos, :medio, []),
      mayor: Map.get(grupos, :mayor, [])
    }

    {:ok, resultado}
  end
end
