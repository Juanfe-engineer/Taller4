defmodule Taller4.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = []
    opts = [strategy: :one_for_one, name: Taller4.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    if Mix.env() != :test do
      menu_principal()
    end

    {:ok, pid}
  end

  defp menu_principal do
    IO.puts("""
    \n
         SISTEMA DE GESTIÓN
             TALLER 4

    1. Gestión de Gimnasio
    2. Sistema de Inventario
    0. Salir
    """)

    case IO.gets("Elige una opción: ") |> String.trim() do
      "1" ->
        Taller4.Gimnasio.Menu.iniciar()
        menu_principal()

      "2" ->
        Taller4.Inventario.Menu.iniciar()
        menu_principal()

      "0" ->
        IO.puts("\n ¡Hasta luego!")

      _ ->
        IO.puts(" Opción inválida, intenta de nuevo.")
        menu_principal()
    end
  end
end
