
# Configuración de PostgreSQL en Rails (Entorno Local)

Este documento explica cómo configurar la conexión a PostgreSQL para el entorno de desarrollo y pruebas en un proyecto Rails, evitando errores por roles inexistentes.

## 1. Contexto
Rails utiliza tres entornos de base de datos por defecto:
- **development** → para trabajar en local.
- **test** → para ejecutar pruebas automatizadas.
- **production** → para el despliegue en servidores.

Cada entorno se configura en el archivo `config/database.yml`.

## 2. Problema común
En instalaciones de PostgreSQL vía Homebrew en macOS, el rol `postgres` no siempre existe.  
Esto provoca errores como:

```

FATAL: role "postgres" does not exist

````

## 3. Solución aplicada
En los entornos `development` y `test`, indicamos a Rails que use el **usuario local de macOS** (que ya existe como rol en Postgres) y nos conectamos vía `localhost`:

```yaml
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
````

### Explicación:

* **`<%= ENV["USER"] %>`**: Inserta el nombre de usuario de tu sesión en macOS (ej. `home`), que coincide con un rol válido en Postgres.
* **`host: localhost`**: Fuerza la conexión TCP a `127.0.0.1:5432` en lugar de sockets Unix (`/tmp/.s.PGSQL.5432`).

## 4. Permisos en Postgres

Asegúrate de que tu usuario tenga permisos suficientes:

```bash
psql -d postgres
```

Dentro de la consola `psql`:

```sql
ALTER ROLE home WITH SUPERUSER CREATEDB LOGIN;
\q
```

*(Cambia `home` por tu usuario si es distinto.)*

## 5. Creación de bases de datos

Con la configuración lista, crea las bases de datos y aplica migraciones:

```bash
bin/rails db:create
bin/rails db:migrate
```

Ahora puedes iniciar el servidor de Rails:

```bash
bin/rails s
```

Visita `http://localhost:3000` para verificar que la conexión funciona correctamente.

```

---

Si quieres, en el siguiente bloque del README te puedo añadir la parte de **migraciones y estructura del catálogo de zapatillas** para que quede todo documentado desde ya. Así el README sería un manual completo de instalación + estructura de datos.
```
