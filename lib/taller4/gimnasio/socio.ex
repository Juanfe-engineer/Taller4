defmodule Taller4.Gimnasio.Socio do
  @enforce_keys [:cedula, :nombre, :edad]
  defstruct [:cedula, :nombre, :edad, clases: []]

  @type t :: %__MODULE__{
          cedula: String.t(),
          nombre: String.t(),
          edad: pos_integer(),
          clases: [String.t()]
        }


  # Crea un nuevo socio con validaciones.

  def nuevo(cedula, nombre, edad, clases \\ []) do
    with {:ok, cedula} <- validar_cedula(cedula),
         {:ok, nombre} <- validar_nombre(nombre),
         {:ok, edad} <- validar_edad(edad) do
      {:ok, %__MODULE__{cedula: cedula, nombre: nombre, edad: edad, clases: clases}}
    end
  end

  # Agrega una clase al socio si no está ya inscrito.

  def agregar_clase(%__MODULE__{} = socio, clase) do
    clase = String.trim(clase)
    cond do
      clase == "" -> {:error, "El nombre de la clase no puede estar vacío"}
      clase in socio.clases -> {:error, "El socio ya está inscrito en '#{clase}'"}
      true -> {:ok, %{socio | clases: socio.clases ++ [clase]}}
    end
  end

  # Elimina una clase del socio.

  def eliminar_clase(%__MODULE__{} = socio, clase) do
    clase = String.trim(clase)
    if clase in socio.clases do
      {:ok, %{socio | clases: List.delete(socio.clases, clase)}}
    else
      {:error, "El socio no está inscrito en '#{clase}'"}
    end
  end


  # Validaciones privadas

  defp validar_cedula(cedula) when is_binary(cedula) do
    cedula = String.trim(cedula)
    if cedula == "", do: {:error, "La cédula no puede estar vacía"}, else: {:ok, cedula}
  end
  defp validar_cedula(_), do: {:error, "La cédula debe ser texto válido"}


  defp validar_nombre(nombre) when is_binary(nombre) do
    nombre = String.trim(nombre)
    if nombre == "", do: {:error, "El nombre no puede estar vacío"}, else: {:ok, nombre}
  end
  defp validar_nombre(_), do: {:error, "El nombre debe ser texto válido"}

  
  defp validar_edad(edad) when is_integer(edad) and edad > 0, do: {:ok, edad}
  defp validar_edad(edad) when is_binary(edad) do
    case Integer.parse(String.trim(edad)) do
      {n, ""} when n > 0 -> {:ok, n}
      _ -> {:error, "La edad debe ser un número entero positivo"}
    end
  end
  defp validar_edad(_), do: {:error, "La edad debe ser un número entero positivo"}
end
