¡perfecto! te dejo 2 README listos:
• README del proyecto (estado actual) — qué hace tu app hoy, cómo correrla y cómo está organizado (incluye diagrama).
• README – Login/Admin (pasos para añadir autenticación) — guía paso a paso para proteger el panel con Devise y dejarlo listo para agregar OAuth.

⸻

README — Sneakers Catalog (Estado actual)

# Sneakers Catalog (Rails + PostgreSQL + Tailwind + Active Storage)

Catálogo simple para mostrar zapatillas con imágenes y un panel de administración
para gestionar productos. Público ve solo lo publicado; administración gestiona todo.

## 🚀 Puesta en marcha

### 1) PostgreSQL local

Conexión usando tu usuario de macOS (no `postgres`):

````yaml
# config/database.yml (extracto)
development:
  <<: *default
  database: sneakers_catalog_development
  username: <%= ENV["USER"] %>
  host: localhost

test:
  <<: *default
  database: sneakers_catalog_test
  username: <%= ENV["USER"] %>
  host: localhost

Permisos (si hiciera falta):

psql -d postgres
ALTER ROLE <tu_usuario> WITH SUPERUSER CREATEDB LOGIN;
\q

Crear DBs y migrar:

bin/rails db:create
bin/rails db:migrate

2) Estilos e imágenes
	•	Tailwind (build ya configurado).
	•	Active Storage para imágenes.
	•	Variantes de imagen con image_processing + vips.

bundle install
bundle add image_processing
brew install vips
bin/rails tailwindcss:build

3) Arrancar

bin/dev   # recomendado (watcher de Tailwind)
# o
bin/rails s

Visita http://localhost:3000.

⸻

🧱 Modelo principal

Sneaker:
	•	brand, model, colorway, size, sku
	•	price_cents (precio en centavos), currency
	•	description
	•	condition (enum): new_with_box, new_no_box, used_like_new, used_good, used_fair
	•	stock, published (control de visibilidad), slug (opcional)
	•	Imágenes: has_many_attached :images

Validaciones y helpers en app/models/sneaker.rb.

⸻

🗺️ Rutas y controladores

# config/routes.rb
resources :sneakers
root "sneakers#index"     # catálogo público (solo publicadas)

namespace :admin do
  root to: "sneakers#index"
  resources :sneakers, only: [:index, :edit, :update, :destroy] do
    member { patch :toggle_publish }  # publicar/ocultar
  end
  # (opcional) resources :customers, :campaigns ...
end

	•	Público
	•	/ o /sneakers → lista en grid, solo published: true.
	•	/sneakers/:id → detalle.
	•	Admin
	•	/admin/sneakers → listado completo (publicadas y ocultas).
	•	Acciones: Ver, Editar, Publicar/Ocultar, Borrar.

⸻

🖼️ Vistas
	•	app/views/sneakers/index.html.erb — Grid tipo tienda (Tailwind).
	•	app/views/sneakers/_form.html.erb — Form con campos claros y subida múltiple de imágenes.
	•	app/views/admin/sneakers/index.html.erb — Tabla de gestión (ID, marca/modelo, SKU, precio, estado, publicado, imágenes, acciones).

⸻

🔐 Accesos (visión actual vs futura)

Hoy: /admin/* está abierto mientras desarrollas.
Próximo paso: proteger /admin con login (Devise) y, si quieres, OAuth (Google/Apple).

⸻

🧭 Diagrama de vistas y roles

            ┌───────────────────────────┐
            │  Visitante / Cliente      │
            │  (no autenticado)         │
            └──────────────┬────────────┘
                           │
      ┌────────────────────┴──────────────────────┐
      │                                            │
┌───────────────┐                          ┌──────────────────┐
│ / (Catálogo)  │                          │ /customers/new   │
│ - Listado     │                          │ Formulario:      │
│   publicado   │                          │  nombre, email,  │
│ - Detalles    │                          │  teléfono, etc.  │
└───────────────┘                          └──────────────────┘

(El cliente NO accede a /admin ni ve productos ocultos)

┌────────────────────────────────────────────────────────────┐
│                     Usuario Admin                          │
│       (Login vía /users/sign_in u OAuth — próximamente)    │
└───────────────┬────────────────────────────────────────────┘
                │
     ┌──────────┴──────────┐
     │                     │
┌───────────────┐   ┌─────────────────────┐
│ /admin/sneakers│   │ /admin/customers   │
│ - CRUD         │   │ - Listado clientes │
│ - Publicar     │   │ - (futuro) filtros │
│ - Ocultar      │   │ - Ver/Borrar       │
└───────────────┘   └─────────────────────┘


⸻

✅ Checklist rápido
	•	Catálogo público con grid y fotos.
	•	Active Storage funcionando.
	•	Panel /admin/sneakers para gestionar inventario.
	•	Siguiente: Login (Devise) + (opcional) OAuth Google/Apple.

---

# README — Añadir Login al Admin (Devise + base para OAuth)

```markdown
# Autenticación del panel (Devise) + base para OAuth

Objetivo: proteger `/admin/*` con login. Opcional: preparar OAuth (Google/Apple).

## 1) Instalar Devise

```bash
bundle add devise
bin/rails generate devise:install
bin/rails generate devise User
bin/rails db:migrate

Rutas Devise

Se añaden automáticamente (registro, login, logout):
	•	/users/sign_in
	•	/users/sign_out (DELETE)
	•	/users/sign_up (si mantienes registro abierto)

2) Proteger el namespace /admin

Crea un controlador base del admin:

# app/controllers/admin/application_controller.rb
module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
  end
end

Haz que los controladores del admin hereden de él:

# app/controllers/admin/sneakers_controller.rb
module Admin
  class SneakersController < Admin::ApplicationController
    # ...
  end
end

Con esto, cualquier ruta /admin/... exigirá usuario logueado.

3) Botones Entrar/Salir (layout)

En tu layout (app/views/layouts/application.html.erb), añade:

<% if user_signed_in? %>
  <%= link_to "Salir", destroy_user_session_path,
        data: { turbo_method: :delete }, class: "px-3 py-2 border rounded" %>
<% else %>
  <%= link_to "Entrar", new_user_session_path,
        class: "px-3 py-2 border rounded" %>
<% end %>

4) (Opcional) Restringir registro

Si no quieres que cualquiera se registre:
	•	Desactiva el enlace a /users/sign_up en tus vistas.
	•	O sobreescribe Devise para cerrar sign_up en producción.

5) Base para OAuth (Google y Apple)

Instala gems:

bundle add omniauth omniauth-rails_csrf_protection
bundle add omniauth-google-oauth2
bundle add omniauth-apple

Habilita en el modelo:

# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 apple]

  def self.from_omniauth(auth)
    user = find_or_initialize_by(email: auth.info.email)
    user.password = SecureRandom.hex(16) if user.new_record?
    user.save!
    user
  end
end

Config Devise:

# config/initializers/devise.rb
config.omniauth :google_oauth2,
  ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"]

config.omniauth :apple,
  ENV["APPLE_CLIENT_ID"], "",
  {
    scope: "email name",
    team_id: ENV["APPLE_TEAM_ID"],
    key_id:  ENV["APPLE_KEY_ID"],
    pem:     ENV["APPLE_PRIVATE_KEY_PEM"]
  }

Rutas de callbacks:

# config/routes.rb
devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

namespace :admin do
  root to: "sneakers#index"
  resources :sneakers, only: [:index, :edit, :update, :destroy] do
    member { patch :toggle_publish }
  end
end

Controller de callbacks:

# app/controllers/users/omniauth_callbacks_controller.rb
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2; handle_auth("Google"); end
    def apple;        handle_auth("Apple");  end

    private
    def handle_auth(kind)
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind:) if is_navigational_format?
      else
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
    end
  end
end

Botones en login:

<!-- app/views/devise/sessions/new.html.erb -->
<%= button_to "Entrar con Google", user_google_oauth2_omniauth_authorize_path,
      method: :post, class: "px-4 py-2 border rounded w-full mb-2" %>
<%= button_to "Entrar con Apple",  user_apple_omniauth_authorize_path,
      method: :post, class: "px-4 py-2 border rounded w-full" %>

Variables de entorno (ejemplo en macOS, terminal):

export GOOGLE_CLIENT_ID=...
export GOOGLE_CLIENT_SECRET=...
export APPLE_CLIENT_ID=...
export APPLE_TEAM_ID=...
export APPLE_KEY_ID=...
export APPLE_PRIVATE_KEY_PEM="$(cat AuthKey_XXXXXX.p8)"

6) Probar

bin/dev
# abre /users/sign_in
# intenta acceder a /admin/sneakers (debe pedir login)

7) Producción (tips rápidos)
	•	Forzar HTTPS (callback OAuth requiere https en prod).
	•	Configurar host y secrets (Rails credentials/ENV).
	•	Limitar registro (solo admins) si no quieres usuarios públicos.

⸻

✅ Checklist
	•	bundle install, generar Devise y migrar.
	•	Crear Admin::ApplicationController con before_action :authenticate_user!.
	•	Heredar controladores admin de Admin::ApplicationController.
	•	Botones Entrar/Salir en layout.
	•	(Opcional) configurar OAuth y probar callbacks.

¿Te lo dejo también como archivos en tu proyecto (por ejemplo `README.md` y `README_AUTH.md`) o prefieres copiar/pegar tú directamente?
````
