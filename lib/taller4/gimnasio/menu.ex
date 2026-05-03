defmodule Taller4.Gimnasio.Menu do
  alias Taller4.Gimnasio.Gimnasio

  def iniciar do
    IO.puts("\nBienvenido al Sistema de Gestión del Gimnasio")

    case Gimnasio.cargar() do
      {:ok, socios} ->
        loop(socios)

      {:error, razon} ->
        IO.puts("Error al cargar datos: #{razon}")
    end
  end

  defp loop(socios) do
    IO.puts("""
    \n═══════════════════════════════
          MENÚ GIMNASIO
      ═══════════════════════════════
    1. Crear socio
    2. Eliminar socio
    3. Inscribir socio en clase
    4. Desinscribir socio de clase
    5. Buscar socio por cédula
    6. Listar todos los socios
    7. Listar socios por clase
    8. Listar clases de un socio
    0. Volver al menú principal
    """)

    case IO.gets("Elige una opción: ") |> String.trim() do
      "1" -> loop(crear_socio(socios))
      "2" -> loop(eliminar_socio(socios))
      "3" -> loop(inscribir_clase(socios))
      "4" -> loop(desinscribir_clase(socios))
      "5" -> loop(buscar_socio(socios))
      "6" -> loop(listar_socios(socios))
      "7" -> loop(listar_por_clase(socios))
      "8" -> loop(listar_clases_socio(socios))
      "0" -> socios
      _   ->
        IO.puts("Opción inválida, intenta de nuevo.")
        loop(socios)
    end
  end


  # Opciones

  defp crear_socio(socios) do
    cedula = IO.gets("Cédula: ") |> String.trim()
    nombre = IO.gets("Nombre: ") |> String.trim()
    edad   = IO.gets("Edad: ")   |> String.trim()

    case Gimnasio.crear_socio(socios, cedula, nombre, edad) do
      {:ok, nuevos_socios} ->
        IO.puts("Socio creado exitosamente.")
        nuevos_socios

      {:error, razon} ->
        IO.puts("Error: #{razon}")
        socios
    end
  end


  defp eliminar_socio(socios) do
    cedula = IO.gets("Cédula del socio a eliminar: ") |> String.trim()

    case Gimnasio.eliminar_socio(socios, cedula) do
      {:ok, nuevos_socios} ->
        IO.puts("Socio eliminado exitosamente.")
        nuevos_socios

      {:error, razon} ->
        IO.puts("Error: #{razon}")
        socios
    end
  end


  defp inscribir_clase(socios) do
    cedula = IO.gets("Cédula del socio: ") |> String.trim()
    clase  = IO.gets("Nombre de la clase: ") |> String.trim()

    case Gimnasio.inscribir_clase(socios, cedula, clase) do
      {:ok, nuevos_socios} ->
        IO.puts("Socio inscrito en '#{clase}' exitosamente.")
        nuevos_socios

      {:error, razon} ->
        IO.puts("Error: #{razon}")
        socios
    end
  end


  defp desinscribir_clase(socios) do
    cedula = IO.gets("Cédula del socio: ") |> String.trim()
    clase  = IO.gets("Nombre de la clase: ") |> String.trim()

    case Gimnasio.desinscribir_clase(socios, cedula, clase) do
      {:ok, nuevos_socios} ->
        IO.puts("Socio desinscrito de '#{clase}' exitosamente.")
        nuevos_socios

      {:error, razon} ->
        IO.puts("Error: #{razon}")
        socios
    end
  end


  defp buscar_socio(socios) do
    cedula = IO.gets("Cédula del socio: ") |> String.trim()

    case Gimnasio.buscar_socio(socios, cedula) do
      {:ok, socio} ->
        IO.puts("""
        \nSocio encontrado:
        Cédula : #{socio.cedula}
        Nombre : #{socio.nombre}
        Edad   : #{socio.edad}
        Clases : #{Enum.join(socio.clases, ", ")}
        """)

      {:error, razon} ->
        IO.puts("Error: #{razon}")
    end

    socios
  end


  defp listar_socios(socios) do
    {:ok, lista} = Gimnasio.listar_socios(socios)

    if lista == [] do
      IO.puts("No hay socios registrados.")
    else
      IO.puts("\nLista de socios:")
      Enum.each(lista, fn s ->
        IO.puts("  [#{s.cedula}] #{s.nombre} | Edad: #{s.edad} | Clases: #{Enum.join(s.clases, ", ")}")
      end)
    end

    socios
  end


  defp listar_por_clase(socios) do
    clase = IO.gets("Nombre de la clase: ") |> String.trim()

    {:ok, lista} = Gimnasio.listar_socios_por_clase(socios, clase)

    if lista == [] do
      IO.puts("No hay socios inscritos en '#{clase}'.")
    else
      IO.puts("\nSocios inscritos en '#{clase}':")
      Enum.each(lista, fn s ->
        IO.puts("  [#{s.cedula}] #{s.nombre}")
      end)
    end

    socios
  end


  defp listar_clases_socio(socios) do
    cedula = IO.gets("Cédula del socio: ") |> String.trim()

    case Gimnasio.listar_clases_socio(socios, cedula) do
      {:ok, []} ->
        IO.puts("El socio no está inscrito en ninguna clase.")

      {:ok, clases} ->
        IO.puts("\nClases del socio:")
        Enum.each(clases, fn c -> IO.puts("  - #{c}") end)

      {:error, razon} ->
        IO.puts("Error: #{razon}")
    end
    socios
  end
end
