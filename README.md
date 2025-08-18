Perfecto, te puedo dejarlo como README.md unificado con lo que hace ahora tu web app.
Así queda actualizado con la nueva parte de roles, perfil y logout que añadimos hoy:

⸻

# Sneakers Catalog 👟

Aplicación web en Ruby on Rails para gestionar un catálogo de zapatillas.  
Incluye **roles de usuario** (admin / cliente), autenticación con **Devise**,  
subida de imágenes con Active Storage y estilos con Tailwind CSS.

---

## 🚀 Funcionalidades actuales

### Público / Cliente (no autenticado)

- Ver catálogo de zapatillas publicadas (`published: true`).
- Ver detalle de cada sneaker.
- Registrarse o iniciar sesión.
- Acceder a su perfil y editar datos (vista Devise `edit`).

### Usuario autenticado (cliente normal)

- Igual que el cliente, pero con acceso a:
  - **Enlace a su perfil** desde el layout.
  - **Cerrar sesión** desde cualquier página.

### Usuario Admin

- Todo lo anterior.
- **Enlaces extra en el layout**:
  - Botón "Nueva sneaker".
  - Enlace "Admin" (panel de administración).
- Panel de administración `/admin/sneakers` para:
  - Ver todas las zapatillas (publicadas y ocultas).
  - Crear, editar, publicar/ocultar y eliminar.

---

## 🧱 Modelos principales

### Sneaker

- Campos: `brand`, `model`, `colorway`, `size`, `sku`, `price_cents`, `currency`, `description`, `condition` (enum), `stock`, `published`, `slug`.
- Relación: `has_many_attached :images` (Active Storage).
- Validaciones básicas en `app/models/sneaker.rb`.

### User

- Generado con Devise.
- Campos adicionales: `admin` (boolean).
- Método `admin?` para diferenciar roles.

---

## 🖼️ Vistas destacadas

- `app/views/layouts/application.html.erb`  
  Contiene:

  - Botones de login / logout.
  - Enlace al perfil del usuario.
  - Enlaces admin visibles solo para `current_user.admin?`.

- `app/views/devise/registrations/edit.html.erb`  
  Formulario de edición de perfil, contraseña y correo.

- `app/views/sneakers/index.html.erb`  
  Grid de catálogo con Tailwind.

---

## 🔐 Autenticación y roles

- **Devise** para login, registro, logout y edición de perfil.
- Enlace al perfil:

  ```erb
  <%= link_to (current_user.full_name.presence || current_user.email),
              edit_user_registration_path %>

  •	Botón de cierre de sesión:
  ```

<%= button_to "Cerrar sesión",
destroy_user_session_path,
method: :delete %>

    •	Restricción de accesos:
    •	Controladores del namespace Admin:: heredan de Admin::ApplicationController con:

before_action :authenticate_user!
before_action :require_admin

private

def require_admin
redirect_to root_path, alert: "Acceso denegado" unless current_user.admin?
end

⸻

🗺️ Diagrama de flujo

Visitante ──> Catálogo público (/)
└─> Detalle sneaker

Usuario ──> Catálogo + Perfil (/users/edit)
└─> Logout

Admin ──> Catálogo + Perfil + Panel Admin
└─> CRUD completo de sneakers

⸻

▶️ Cómo correr el proyecto

1. Instalar dependencias

bundle install
npm install

2. Configurar base de datos (PostgreSQL)

En config/database.yml usa tu usuario local:

username: <%= ENV["USER"] %>
host: localhost

Crear y migrar:

bin/rails db:create db:migrate

3. Arrancar en desarrollo

bin/dev

# o

bin/rails s

Abrir: http://localhost:3000

⸻

✅ Próximos pasos
• Añadir OAuth (Google / Apple) para login rápido.
• Mejorar la vista de perfil (/users/show) separada del editor.
• Filtros de búsqueda en catálogo.
• Subida de imágenes con previsualización en el formulario.

---

Si quieres, te lo dejo ya **listo como `README.md` en tu proyecto** para que al hacer push a GitHub aparezca actualizado con esta descripción.  
¿Quieres que lo cree directamente así en tu carpeta?
