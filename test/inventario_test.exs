defmodule Taller4.Inventario.InventarioTest do
  use ExUnit.Case
  
  alias Taller4.Inventario.Producto
  alias Taller4.Inventario.Inventario

  # Pruebas de Producto

  test "crear producto válido" do
    assert {:ok, producto} = Producto.nuevo("A001", "Mancuerna", 45000.0, 10)
    assert producto.codigo == "A001"
    assert producto.nombre == "Mancuerna"
    assert producto.precio == 45000.0
    assert producto.cantidad == 10
  end

  test "error si código tiene más de 5 caracteres" do
    assert {:error, _} = Producto.nuevo("ABCDEF", "Mancuerna", 45000.0, 10)
  end

  test "error si nombre contiene números" do
    assert {:error, _} = Producto.nuevo("A001", "Mancuerna123", 45000.0, 10)
  end

  test "error si precio es negativo" do
    assert {:error, _} = Producto.nuevo("A001", "Mancuerna", -100.0, 10)
  end

  test "error si cantidad es negativa" do
    assert {:error, _} = Producto.nuevo("A001", "Mancuerna", 45000.0, -5)
  end

  # Pruebas de Inventario

  test "agregar producto al inventario" do
    {:ok, p1} = Producto.nuevo("A001", "Mancuerna", 45000.0, 10)
    productos = %{"A001" => p1}

    assert {:ok, nuevos} = Inventario.agregar_producto(productos, "B002", "Barra", 80000.0, 5)
    assert Map.has_key?(nuevos, "B002")
  end

  test "no permite códigos duplicados" do
    {:ok, p1} = Producto.nuevo("A001", "Mancuerna", 45000.0, 10)
    productos = %{"A001" => p1}

    assert {:error, _} = Inventario.agregar_producto(productos, "A001", "Barra", 80000.0, 5)
  end

  test "eliminar producto existente" do
    {:ok, p1} = Producto.nuevo("A001", "Mancuerna", 45000.0, 10)
    productos = %{"A001" => p1}

    assert {:ok, nuevos} = Inventario.eliminar_producto(productos, "A001")
    refute Map.has_key?(nuevos, "A001")
  end

  test "error al eliminar producto inexistente" do
    assert {:error, _} = Inventario.eliminar_producto(%{}, "X999")
  end

  test "productos con dos o más vocales" do
    {:ok, p1} = Producto.nuevo("A001", "Mancuerna", 45000.0, 10)
    {:ok, p2} = Producto.nuevo("B002", "Barra", 80000.0, 5)
    productos = %{"A001" => p1, "B002" => p2}

    assert {:ok, lista} = Inventario.productos_con_dos_vocales(productos)
    codigos = Enum.map(lista, fn {codigo, _} -> codigo end)
    assert "A001" in codigos
  end

  test "tres productos más caros" do
    {:ok, p1} = Producto.nuevo("A001", "Mancuerna", 45000.0, 10)
    {:ok, p2} = Producto.nuevo("B002", "Barra", 80000.0, 5)
    {:ok, p3} = Producto.nuevo("C003", "Cuerda", 120000.0, 3)
    {:ok, p4} = Producto.nuevo("D004", "Disco", 200000.0, 2)
    productos = %{"A001" => p1, "B002" => p2, "C003" => p3, "D004" => p4}

    assert {:ok, lista} = Inventario.tres_mas_caros(productos)
    assert length(lista) == 3
    assert hd(lista).precio == 200000.0
  end
end
