<!-- Author: Daniel Benjamin Perez Morales -->
<!-- GitHub: https://github.com/D4nitrix13 -->
<!-- GitLab: https://gitlab.com/D4nitrix13 -->
<!-- Email: danielperezdev@proton.me -->

# Go RESTful API Starter Kit (Boilerplate)

Este proyecto es un **starter kit** diseñado para aprender y desarrollar **APIs RESTful en Go**, siguiendo buenas prácticas profesionales como **Clean Architecture**, principios **SOLID**, separación de capas, pruebas unitarias y uso de herramientas modernas para despliegue y automatización.

El objetivo principal es ofrecer una base sólida para construir servicios backend mantenibles, escalables y fáciles de extender.

---

## Características Principales

Este boilerplate incluye desde el primer momento:

* Endpoints REST estándar.
* CRUD completo sobre una entidad (álbum).
* Autenticación basada en JWT.
* Manejo de configuración por entorno (local, dev, qa, prod).
* Logging estructurado con contexto.
* Manejo centralizado de errores.
* Validación de datos y manejo correcto de JSON.
* Migraciones de base de datos con archivos `.up.sql` y `.down.sql`.
* Paginación nativa en endpoints.
* Makefile con tareas automatizadas.
* Soporte para Docker y Docker Compose.
* Base de datos PostgreSQL lista para levantarse con un solo comando.
* Pruebas unitarias completas.
* Live reload para desarrollo.

Incluye todos los conceptos clave que un backend moderno debe dominar: arquitectura limpia, servicios, repositorios, validación, autenticación, manejo de errores, transacciones, paginación, logging, migraciones, configuración por entornos y pruebas.

---

## Tecnologías y Librerías Usadas

* **Routing:** ozzo-routing
* **ORM / DB Access:** ozzo-dbx
* **Migraciones:** golang-migrate
* **Validación:** ozzo-validation
* **Logging:** zap
* **JWT:** jwt-go
* **Base de datos:** PostgreSQL
* **Contenedores:** Docker + Docker Compose
* **Automatización:** Makefile

Todas estas librerías pueden reemplazarse fácilmente gracias a la estructura modular del proyecto.

---

## Requisitos Previos

* **Go 1.13+**
* **Docker 17.05+**
* **docker-compose**
* (Opcional) `fswatch` para live reload

---

## Puesta en Marcha

```bash
git clone https://github.com/D4nitrix13/Go-Clean-Architecture-API-Starter.git
cd Go-Clean-Architecture-API-Starter
```

**Ejecutar Aplicación en Docker:**

```bash
make up
```

La API estará disponible en:

```bash
http://127.0.0.1:8080
```

---

## Endpoints Disponibles

| Método | Endpoint         | Descripción                        |
| ------ | ---------------- | ---------------------------------- |
| GET    | `/healthcheck`   | Verifica el estado del servicio    |
| POST   | `/v1/login`      | Autentica al usuario y retorna JWT |
| GET    | `/v1/albums`     | Lista paginada de álbumes          |
| GET    | `/v1/albums/:id` | Ver detalle de un álbum            |
| POST   | `/v1/albums`     | Crear un álbum                     |
| PUT    | `/v1/albums/:id` | Actualizar un álbum                |
| DELETE | `/v1/albums/:id` | Eliminar un álbum                  |

---

## Ejemplos con curl

## 1. Healthcheck

```bash
/bin/curl http://localhost:8080/healthcheck -s
```

---

### 2. Obtener token JWT & ID De Album

```bash
TOKEN=$(
  /bin/curl -X POST \
    -H "Content-Type: application/json" \
    -d '{"username":"demo","password":"pass"}' \
    http://localhost:8080/v1/login -s | jq -r '.token'
)
```

```bash
ALBUM_ID=$(
  /bin/curl -s -X GET \
    -H "Authorization: Bearer $TOKEN" \
    http://localhost:8080/v1/albums \
  | jq -r '.items[0].id'
)
```

---

### 3. Listar álbumes

```bash
/bin/curl -X GET \
  -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/v1/albums -s | jq --color-output --indent 2 --ascii-output
```

---

### 4. Crear álbum

```bash
/bin/curl -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Album",
    "artist": "Daniel",
    "price": 25.5
  }' http://localhost:8080/v1/albums -s
```

---

### 5. Actualizar álbum

```bash
/bin/curl -s -X PUT \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated",
    "artist": "Daniel P.",
    "price": 199.99
  }' "http://localhost:8080/v1/albums/$ALBUM_ID" | jq --color-output --indent 2 --ascii-output
```

---

### 6. Eliminar álbum

```bash
/bin/curl -s -X DELETE \
  -H "Authorization: Bearer $TOKEN" \
  "http://localhost:8080/v1/albums/$ALBUM_ID" | jq --color-output --indent 2 --ascii-output
```

---

## Estructura del Proyecto

```bash
.
├── cmd/              Aplicaciones principales del proyecto
│   └── server/       Servidor HTTP
├── config/           Configuración por entorno
├── internal/         Código privado del dominio
│   ├── album/        Lógica del CRUD
│   ├── auth/         Autenticación JWT
│   ├── entity/       Entidades del dominio
│   ├── errors/       Middleware y respuesta de errores
│   ├── healthcheck/  Healthcheck
│   └── test/         Utilidades para pruebas
├── pkg/              Librerías públicas del proyecto
│   ├── accesslog/    Logging de accesos
│   ├── dbcontext/    Manejo de BD y transacciones
│   ├── log/          Logger
│   └── pagination/   Paginación
├── migrations/        Archivos de migración SQL
└── testdata/         Datos de prueba
```

---

## Tareas con Makefile

| Comando              | Descripción                                                                      |
| -------------------- | -------------------------------------------------------------------------------- |
| `make`               | Muestra la ayuda con todos los comandos disponibles (`help`).                    |
| `make help`          | Lista los comandos del Makefile y su descripción.                                |
| `make up`            | Levanta todos los servicios en segundo plano y aplica las migraciones.           |
| `make stop`          | Detiene los contenedores sin eliminarlos.                                        |
| `make down`          | Elimina contenedores, redes y volúmenes del proyecto.                            |
| `make migrate`       | Aplica todas las migraciones pendientes (`migrate up`).                          |
| `make migrate-down`  | Revierte la última migración aplicada (`migrate down 1`).                        |
| `make migrate-reset` | Elimina el esquema de la base de datos y vuelve a aplicar todas las migraciones. |

---

## Despliegue con Docker

Construir imagen:

```bash
make build-docker
```

Ejecutar manualmente:

```bash
docker run -p 8080:8080 \
  -e APP_ENV=prod \
  go-rest-api
```
