# Taller 4 - Structs, Mapas y Manejo de Archivos en Elixir

## Descripción

Sistema desarrollado en Elixir que integra dos módulos de gestión:

### Ejercicio 1: Gestión de Socios de un Gimnasio
Sistema que permite administrar los socios de un gimnasio y las clases a las que están inscritos. Los datos se persisten en un archivo `socios.csv`.

**Funcionalidades:**
- Crear y eliminar socios
- Inscribir y desinscribir socios de clases
- Buscar socios por cédula
- Listar todos los socios
- Listar socios por clase
- Listar clases de un socio

### Ejercicio 2: Sistema de Inventario de Productos
Sistema que permite gestionar un inventario de productos con consultas funcionales usando `Enum`. Los datos se persisten en un archivo `productos.json` usando la librería **Jason**.

**Funcionalidades:**
- Agregar, actualizar y eliminar productos
- Listar productos
- Consultas: productos con dos vocales, misma letra inicial y final, precio menor a un valor, tres más caros, precio entre dos valores, agrupación por rango de precio

---

## Estructura del proyecto
taller4/
├── lib/
│   └── taller4/
│       ├── application.ex
│       ├── gimnasio/
│       │   ├── socio.ex
│       │   ├── gimnasio.ex
│       │   ├── gestion_archivos.ex
│       │   └── menu.ex
│       └── inventario/
│           ├── producto.ex
│           ├── inventario.ex
│           ├── archivo_json.ex
│           └── menu.ex
├── test/
│   └── taller4/
│       └── inventario_test.exs
├── mix.exs
└── README.md


---

## Cómo ejecutar

### Correr la aplicación
```bash
mix run
```

### Correr las pruebas
```bash
mix test
```

---

## Aprendizajes obtenidos

- **Structs en Elixir:** Aprendimos a definir estructuras de datos tipadas con `defstruct` y `@enforce_keys` para garantizar campos obligatorios.
- **Mapas (Map):** Usamos mapas como estructura principal de almacenamiento en memoria, usando la cédula y el código como claves únicas.
- **Manejo de archivos:** Implementamos persistencia en dos formatos distintos: CSV con funciones nativas de Elixir (`File.read`, `File.write`) y JSON con la librería Jason.
- **Manejo de errores:** Aplicamos el patrón `{:ok, resultado}` y `{:error, motivo}` de forma consistente en todas las funciones, usando `with` para encadenar validaciones.
- **Programación funcional:** Usamos `Enum.filter`, `Enum.map`, `Enum.group_by`, `Enum.sort_by` para implementar las consultas del inventario de forma declarativa.
- **Pruebas con ExUnit:** Implementamos pruebas unitarias para validar el comportamiento de los módulos `Producto` e `Inventario`.
- **Mix y Application:** Aprendimos a estructurar un proyecto Elixir con `mix new --sup`, configurar el módulo `Application` y manejar entornos (`:test` vs `:prod`).

---

## Uso de Inteligencia Artificial

Durante el desarrollo de este taller se utilizó **Claude (Anthropic)** como apoyo en la solución. La IA fue usada de la siguiente manera:

- **Resolución de errores:** Cuando surgieron problemas como el menú ejecutándose durante `mix test`, Claude nos ayudó a identificar la causa y aplicar la solución correcta.
- **Buenas prácticas:** La IA reforzó el uso de patrones idiomáticos de Elixir como `with`, tuplas de error, y funciones pequeñas y claras.


El equipo mantuvo comprensión activa del código, realizando commits individuales y tomando decisiones sobre la arquitectura del proyecto.

---

## Integrantes

- Juan Felipe Ibarra Londoño
- Johan Stiven Pineda Martinez