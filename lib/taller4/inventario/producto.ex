defmodule Taller4.Inventario.Producto do
  @enforce_keys [:codigo, :nombre, :precio, :cantidad]
  defstruct [:codigo, :nombre, :precio, :cantidad]

  @type t :: %__MODULE__{
          codigo: String.t(),
          nombre: String.t(),
          precio: float(),
          cantidad: non_neg_integer()
        }


  # Crea un nuevo producto con validaciones.

  def nuevo(codigo, nombre, precio, cantidad) do
    with {:ok, codigo}   <- validar_codigo(codigo),
         {:ok, nombre}   <- validar_nombre(nombre),
         {:ok, precio}   <- validar_precio(precio),
         {:ok, cantidad} <- validar_cantidad(cantidad) do
      {:ok, %__MODULE__{codigo: codigo, nombre: nombre, precio: precio, cantidad: cantidad}}
    end
  end


  # Validaciones privadas

  defp validar_codigo(codigo) when is_binary(codigo) do
    codigo = String.trim(codigo)
    cond do
      codigo == ""          -> {:error, "El código no puede estar vacío"}
      String.length(codigo) > 5 -> {:error, "El código debe tener máximo 5 caracteres"}
      true                  -> {:ok, codigo}
    end
  end
  defp validar_codigo(_), do: {:error, "El código debe ser texto válido"}


  defp validar_nombre(nombre) when is_binary(nombre) do
    nombre = String.trim(nombre)
    cond do
      nombre == "" ->
        {:error, "El nombre no puede estar vacío"}
      !Regex.match?(~r/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, nombre) ->
        {:error, "El nombre solo puede contener letras"}
      true ->
        {:ok, nombre}
    end
  end
  defp validar_nombre(_), do: {:error, "El nombre debe ser texto válido"}


  defp validar_precio(precio) when is_number(precio) and precio >= 0, do: {:ok, precio / 1}
  defp validar_precio(precio) when is_binary(precio) do
    case Float.parse(String.trim(precio)) do
      {n, ""} when n >= 0 -> {:ok, n}
      _ ->
        case Integer.parse(String.trim(precio)) do
          {n, ""} when n >= 0 -> {:ok, n / 1}
          _ -> {:error, "El precio debe ser un número mayor o igual a 0"}
        end
    end
  end
  defp validar_precio(_), do: {:error, "El precio debe ser un número mayor o igual a 0"}

  
  defp validar_cantidad(cantidad) when is_integer(cantidad) and cantidad >= 0, do: {:ok, cantidad}
  defp validar_cantidad(cantidad) when is_binary(cantidad) do
    case Integer.parse(String.trim(cantidad)) do
      {n, ""} when n >= 0 -> {:ok, n}
      _ -> {:error, "La cantidad debe ser un entero mayor o igual a 0"}
    end
  end
  defp validar_cantidad(_), do: {:error, "La cantidad debe ser un entero mayor o igual a 0"}
end
