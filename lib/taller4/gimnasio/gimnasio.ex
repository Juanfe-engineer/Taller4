defmodule Taller4.Gimnasio.Gimnasio do
  alias Taller4.Gimnasio.Socio
  alias Taller4.Gimnasio.GestionArchivos

  # Carga los socios desde el archivo CSV.

  def cargar do
    GestionArchivos.cargar_socios()
  end


  # Crea un nuevo socio y lo agrega al mapa.

  def crear_socio(socios, cedula, nombre, edad) do
    cond do
      Map.has_key?(socios, cedula) ->
        {:error, "Ya existe un socio con la cédula #{cedula}"}

      true ->
        case Socio.nuevo(cedula, nombre, edad) do
          {:ok, socio} ->
            nuevos_socios = Map.put(socios, cedula, socio)
            case GestionArchivos.guardar_socios(nuevos_socios) do
              :ok -> {:ok, nuevos_socios}
              {:error, razon} -> {:error, razon}
            end

          {:error, razon} ->
            {:error, razon}
        end
    end
  end


  # Elimina un socio por cédula.

  def eliminar_socio(socios, cedula) do
    if Map.has_key?(socios, cedula) do
      nuevos_socios = Map.delete(socios, cedula)
      case GestionArchivos.guardar_socios(nuevos_socios) do
        :ok -> {:ok, nuevos_socios}
        {:error, razon} -> {:error, razon}
      end
    else
      {:error, "No existe un socio con la cédula #{cedula}"}
    end
  end


  # Inscribe a un socio en una clase.

  def inscribir_clase(socios, cedula, clase) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} ->
        case Socio.agregar_clase(socio, clase) do
          {:ok, socio_actualizado} ->
            nuevos_socios = Map.put(socios, cedula, socio_actualizado)
            case GestionArchivos.guardar_socios(nuevos_socios) do
              :ok -> {:ok, nuevos_socios}
              {:error, razon} -> {:error, razon}
            end

          {:error, razon} ->
            {:error, razon}
        end

      :error ->
        {:error, "No existe un socio con la cédula #{cedula}"}
    end
  end


  # Desinscribe a un socio de una clase.

  def desinscribir_clase(socios, cedula, clase) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} ->
        case Socio.eliminar_clase(socio, clase) do
          {:ok, socio_actualizado} ->
            nuevos_socios = Map.put(socios, cedula, socio_actualizado)
            case GestionArchivos.guardar_socios(nuevos_socios) do
              :ok -> {:ok, nuevos_socios}
              {:error, razon} -> {:error, razon}
            end

          {:error, razon} ->
            {:error, razon}
        end

      :error ->
        {:error, "No existe un socio con la cédula #{cedula}"}
    end
  end


  # Busca un socio por cédula.

  def buscar_socio(socios, cedula) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} -> {:ok, socio}
      :error -> {:error, "No existe un socio con la cédula #{cedula}"}
    end
  end


  # Lista todos los socios.

  def listar_socios(socios) do
    {:ok, Map.values(socios)}
  end


  # Lista todos los socios inscritos en una clase específica.

  def listar_socios_por_clase(socios, clase) do
    resultado =
      socios
      |> Map.values()
      |> Enum.filter(fn socio -> clase in socio.clases end)

    {:ok, resultado}
  end


  # Lista todas las clases de un socio dada su cédula.
  
  def listar_clases_socio(socios, cedula) do
    case Map.fetch(socios, cedula) do
      {:ok, socio} -> {:ok, socio.clases}
      :error -> {:error, "No existe un socio con la cédula #{cedula}"}
    end
  end
end
