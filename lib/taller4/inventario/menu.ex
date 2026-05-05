defmodule Taller4.Inventario.Menu do
  alias Taller4.Inventario.Inventario

  def iniciar do
    IO.puts("\nBienvenido al Sistema de Inventario")

    case Inventario.cargar() do
      {:ok, productos} ->
        loop(productos)

      {:error, razon} ->
        IO.puts("Error al cargar datos: #{razon}")
    end
  end

  defp loop(productos) do
    IO.puts("""
    \n═══════════════════════════════
          MENÚ INVENTARIO
    ═══════════════════════════════
    1. Agregar producto
    2. Actualizar producto
    3. Eliminar producto
    4. Listar productos
    5. Productos con dos o más vocales
    6. Productos que inician y terminan con la misma letra
    7. Productos con precio menor a un valor
    8. Los tres productos más caros
    9. Productos con precio entre dos valores
    10. Agrupar productos por rango de precio
    0. Volver al menú principal
    ═══════════════════════════════
    """)

    case IO.gets("Elige una opción: ") |> String.trim() do
      "1"  -> loop(agregar_producto(productos))
      "2"  -> loop(actualizar_producto(productos))
      "3"  -> loop(eliminar_producto(productos))
      "4"  -> loop(listar_productos(productos))
      "5"  -> loop(dos_vocales(productos))
      "6"  -> loop(misma_letra(productos))
      "7"  -> loop(precio_menor(productos))
      "8"  -> loop(tres_mas_caros(productos))
      "9"  -> loop(precio_entre(productos))
      "10" -> loop(agrupar_precio(productos))
      "0"  -> productos
      _    ->
        IO.puts("Opción inválida, intenta de nuevo.")
        loop(productos)
    end
  end


  # Opciones

  defp agregar_producto(productos) do
    codigo   = IO.gets("Código (máx 5 caracteres): ") |> String.trim()
    nombre   = IO.gets("Nombre (solo letras): ")      |> String.trim()
    precio   = IO.gets("Precio: ")                    |> String.trim()
    cantidad = IO.gets("Cantidad: ")                  |> String.trim()

    case Inventario.agregar_producto(productos, codigo, nombre, precio, cantidad) do
      {:ok, nuevos} ->
        IO.puts("Producto agregado exitosamente.")
        nuevos

      {:error, razon} ->
        IO.puts("Error: #{razon}")
        productos
    end
  end


  defp actualizar_producto(productos) do
    codigo   = IO.gets("Código del producto a actualizar: ") |> String.trim()
    nombre   = IO.gets("Nuevo nombre (solo letras): ")       |> String.trim()
    precio   = IO.gets("Nuevo precio: ")                     |> String.trim()
    cantidad = IO.gets("Nueva cantidad: ")                   |> String.trim()

    case Inventario.actualizar_producto(productos, codigo, nombre, precio, cantidad) do
      {:ok, nuevos} ->
        IO.puts("Producto actualizado exitosamente.")
        nuevos

      {:error, razon} ->
        IO.puts("Error: #{razon}")
        productos
    end
  end


  defp eliminar_producto(productos) do
    codigo = IO.gets("Código del producto a eliminar: ") |> String.trim()

    case Inventario.eliminar_producto(productos, codigo) do
      {:ok, nuevos} ->
        IO.puts("Producto eliminado exitosamente.")
        nuevos

      {:error, razon} ->
        IO.puts("Error: #{razon}")
        productos
    end
  end


  defp listar_productos(productos) do
    {:ok, lista} = Inventario.listar_productos(productos)

    if lista == [] do
      IO.puts("No hay productos registrados.")
    else
      IO.puts("\nLista de productos:")
      Enum.each(lista, fn p ->
        IO.puts("  [#{p.codigo}] #{p.nombre} | Precio: #{p.precio} | Cantidad: #{p.cantidad}")
      end)
    end

    productos
  end


  defp dos_vocales(productos) do
    {:ok, lista} = Inventario.productos_con_dos_vocales(productos)

    if lista == [] do
      IO.puts("No hay productos con dos o más vocales en el nombre.")
    else
      IO.puts("\nProductos con dos o más vocales:")
      Enum.each(lista, fn {codigo, nombre} ->
        IO.puts("  [#{codigo}] #{nombre}")
      end)
    end

    productos
  end


  defp misma_letra(productos) do
    {:ok, lista} = Inventario.productos_misma_letra(productos)

    if lista == [] do
      IO.puts("No hay productos que inicien y terminen con la misma letra.")
    else
      IO.puts("\nProductos que inician y terminan con la misma letra:")
      Enum.each(lista, fn p ->
        IO.puts("  [#{p.codigo}] #{p.nombre}")
      end)
    end

    productos
  end


  defp precio_menor(productos) do
    valor = IO.gets("Ingresa el valor máximo de precio: ") |> String.trim()

    case Float.parse(valor) do
      {n, _} ->
        {:ok, lista} = Inventario.productos_precio_menor(productos, n)

        if lista == [] do
          IO.puts("No hay productos con precio menor a #{n}.")
        else
          IO.puts("\nProductos con precio menor a #{n}:")
          Enum.each(lista, fn p ->
            IO.puts("  [#{p.codigo}] #{p.nombre} | Precio: #{p.precio}")
          end)
        end

      :error ->
        IO.puts("Valor inválido.")
    end

    productos
  end


  defp tres_mas_caros(productos) do
    {:ok, lista} = Inventario.tres_mas_caros(productos)

    if lista == [] do
      IO.puts("No hay productos registrados.")
    else
      IO.puts("\nLos tres productos más caros:")
      Enum.each(lista, fn p ->
        IO.puts("  [#{p.codigo}] #{p.nombre} | Precio: #{p.precio}")
      end)
    end

    productos
  end


  defp precio_entre(productos) do
    min = IO.gets("Precio mínimo: ") |> String.trim()
    max = IO.gets("Precio máximo: ") |> String.trim()

    with {min_val, _} <- Float.parse(min),
         {max_val, _} <- Float.parse(max) do
      {:ok, resultado} = Inventario.productos_precio_entre(productos, min_val, max_val)

      if resultado == "" do
        IO.puts("No hay productos en ese rango de precio.")
      else
        IO.puts("\nProductos entre #{min_val} y #{max_val}:")
        IO.puts("  #{resultado}")
      end
    else
      _ -> IO.puts("Valores inválidos.")
    end

    productos
  end


  defp agrupar_precio(productos) do
    {:ok, grupos} = Inventario.agrupar_por_precio(productos)

    IO.puts("\nProductos agrupados por precio:")

    IO.puts("\nMenores a 50.000:")
    if grupos.menor == [] do
      IO.puts("  Sin productos")
    else
      Enum.each(grupos.menor, fn p ->
        IO.puts("    [#{p.codigo}] #{p.nombre} | #{p.precio}")
      end)
    end

    IO.puts("\n Entre 50.000 y 100.000:")
    if grupos.medio == [] do
      IO.puts("  Sin productos")
    else
      Enum.each(grupos.medio, fn p ->
        IO.puts("    [#{p.codigo}] #{p.nombre} | #{p.precio}")
      end)
    end

    IO.puts("\n Mayores a 100.000:")
    if grupos.mayor == [] do
      IO.puts("  Sin productos")
    else
      Enum.each(grupos.mayor, fn p ->
        IO.puts("    [#{p.codigo}] #{p.nombre} | #{p.precio}")
      end)
    end

    productos
  end
end
