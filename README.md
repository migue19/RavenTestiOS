# RavenTestiOS 📱

## 📖 Descripción

**RavenTestiOS** es una aplicación iOS nativa desarrollada en Swift que permite a los usuarios consultar y visualizar los artículos más populares del **New York Times**. La aplicación consume la API oficial de NYTimes para mostrar los artículos más enviados por email en los últimos 7 días, proporcionando una experiencia de usuario fluida con soporte completo para modo offline.

## 🎯 Propósito de la Aplicación

La aplicación fue creada con los siguientes objetivos:

1. **Consumir API del NY Times**: Integración con la API de Most Popular Articles para obtener contenido actualizado
2. **Persistencia Local**: Almacenar artículos en Core Data para acceso sin conexión a internet
3. **Experiencia Offline First**: Mostrar contenido en cache inmediatamente mientras se actualizan los datos
4. **Navegación Intuitiva**: Permitir al usuario explorar artículos y ver detalles completos
5. **Demostrar Mejores Prácticas**: Implementar arquitectura limpia, separación de responsabilidades y código testeable

## 🏗️ Arquitectura

La aplicación utiliza la arquitectura **VIPER** (View, Interactor, Presenter, Entity, Router), un patrón arquitectónico que proporciona una clara separación de responsabilidades y facilita el testing.

### Componentes VIPER

#### 📱 **View (Vista)**
- **Responsabilidad**: Mostrar datos y capturar interacciones del usuario
- **Archivos**: `HomeVC.swift`, `DetailVC.swift`, `ArticleCell.swift`
- **Características**:
  - UITableView para lista de artículos
  - Banner de estado de conectividad
  - Celdas personalizadas reutilizables
  - Navegación nativa de iOS

#### 🎨 **Presenter (Presentador)**
- **Responsabilidad**: Lógica de presentación y formato de datos para la vista
- **Archivos**: `HomePresenter.swift`, `DetailPresenter.swift`
- **Características**:
  - Formatea datos para la UI
  - Maneja eventos de usuario
  - Controla HUD de carga
  - Gestiona mensajes de error/éxito

#### 🔄 **Interactor (Interactor)**
- **Responsabilidad**: Lógica de negocio de la aplicación
- **Archivos**: `HomeInteractor.swift`, `DetailInteractor.swift`
- **Características**:
  - Coordina entre remote y local data managers
  - Implementa estrategia de cache
  - Maneja fallback a datos offline
  - Valida y procesa datos

#### 📦 **Entity (Entidades)**
- **Responsabilidad**: Modelos de datos de la aplicación
- **Archivos**: `HomeModels.swift` (Article, NYTimesResponse, Media)
- **Características**:
  - Estructuras Codable para JSON
  - Modelos de Core Data
  - Transformers personalizados

#### 🚪 **Router (Enrutador)**
- **Responsabilidad**: Navegación entre módulos y creación de vistas
- **Archivos**: `HomeRouter.swift`, `DetailRouter.swift`
- **Características**:
  - Inyección de dependencias
  - Creación de módulos VIPER
  - Navegación entre pantallas

### Diagrama de Flujo VIPER

```
┌──────────┐         ┌────────────┐         ┌─────────────┐
│   View   │ ◄─────► │  Presenter │ ◄─────► │ Interactor  │
└──────────┘         └────────────┘         └─────────────┘
     │                     │                        │
     │                     │                        ▼
     │                     │                 ┌─────────────┐
     │                     │                 │   Entity    │
     │                     │                 └─────────────┘
     │                     │                        │
     ▼                     ▼                        ▼
┌──────────┐         ┌────────────┐         ┌─────────────┐
│  Router  │         │  Wireframe │         │Data Managers│
└──────────┘         └────────────┘         └─────────────┘
```

## 🛠️ Tecnologías y Frameworks

### Core Technologies
- **Swift 5.9+**: Lenguaje de programación
- **UIKit**: Framework de interfaz de usuario
- **Core Data**: Persistencia local de datos
- **Foundation**: Frameworks base de iOS

### Networking & Data
- **ConnectionLayer**: Pod personalizado para peticiones HTTP
- **Codable**: Decodificación/Codificación JSON
- **URLSession**: Manejo de requests HTTP

### Third-Party Libraries (CocoaPods)
- **ConnectionLayer**: Capa de abstracción para networking
- **SwiftMessages**: Mensajes y notificaciones elegantes
- **Lottie-iOS**: Animaciones JSON

### Persistence & Data
- **Core Data**: Base de datos local
- **ArrayTransformer**: Transformer personalizado para arrays en Core Data
- **NSSecureUnarchiveFromData**: Serialización segura

### Monitoring & Services
- **Network Monitor**: Detección de cambio de conectividad en tiempo real
- **NotificationCenter**: Sistema de eventos

## 📂 Estructura del Proyecto

```
RavenTestiOS/
├── AppDelegate.swift                 # Punto de entrada, configuración Core Data
├── SceneDelegate.swift               # Manejo de escenas, inicialización
│
├── Features/                         # Módulos de la aplicación
│   ├── Home/                         # Módulo principal (lista de artículos)
│   │   ├── HomeVC.swift             # Vista
│   │   ├── HomePresenter.swift      # Presentador
│   │   ├── HomeInteractor.swift     # Interactor
│   │   ├── HomeRouter.swift         # Router
│   │   ├── HomeProtocols.swift      # Contratos VIPER
│   │   ├── HomeModels.swift         # Modelos de datos
│   │   ├── HomeRemoteDataManager.swift  # API calls
│   │   ├── HomeLocalDataManager.swift   # Core Data
│   │   └── Cells/
│   │       └── ArticleCell.swift    # Celda personalizada
│   │
│   └── Detail/                       # Módulo de detalle
│       ├── DetailVC.swift
│       ├── DetailPresenter.swift
│       ├── DetailInteractor.swift
│       ├── DetailRouter.swift
│       └── DetailProtocols.swift
│
├── Services/                         # Servicios compartidos
│   ├── CoreDataManager.swift        # Singleton para Core Data
│   ├── NetworkMonitor.swift         # Monitor de conectividad
│   └── ArrayTransformer.swift       # Transformer para Core Data
│
├── Base/                             # Clases base y utilidades
│   ├── BaseController.swift         # ViewController base
│   ├── BaseProtocols.swift          # Protocolos generales
│   └── ProgressHUDView.swift        # Indicador de carga
│
├── Commons/                          # Componentes compartidos
│   └── Messages/                     # Sistema de mensajes
│
├── Extensions/                       # Extensiones de Swift/UIKit
│   └── UITableView+Extensions.swift # Registro/Dequeue simplificado
│
├── Constants/                        # Constantes de la app
│
└── RavenTestiOS.xcdatamodeld/       # Modelo de Core Data
    └── Article (Entity)              # Entidad de artículos
```

## ⚙️ Funcionalidades Principales

### 1. Lista de Artículos (Home)
- ✅ Consume API del NY Times (Most Emailed Articles)
- ✅ Muestra artículos en UITableView
- ✅ Celdas personalizadas con título, resumen y autor
- ✅ Pull-to-refresh para actualizar
- ✅ Indicador de carga (HUD)
- ✅ Banner de estado offline

### 2. Detalle de Artículo
- ✅ Vista completa con scroll
- ✅ Imagen del artículo (descarga asíncrona)
- ✅ Sección, título, autor, fecha y resumen
- ✅ Botón para abrir artículo completo en Safari
- ✅ Fecha formateada en español

### 3. Persistencia Offline
- ✅ Almacenamiento automático en Core Data
- ✅ Carga instantánea desde cache
- ✅ Actualización en background
- ✅ Estrategia "Cache First, Network Second"
- ✅ Detección de datos obsoletos

### 4. Monitoreo de Red
- ✅ Detección en tiempo real de conectividad
- ✅ Banner visual cuando está offline
- ✅ Notificaciones de cambio de estado
- ✅ Manejo inteligente de fallbacks

## 🧪 Testing

La aplicación incluye un **suite completo de 27 pruebas unitarias**:

### Pruebas Implementadas
- ✅ **HomePresenterTests** (4 pruebas)
- ✅ **HomeInteractorTests** (5 pruebas)
- ✅ **CoreDataManagerTests** (4 pruebas)
- ✅ **ArticleModelTests** (3 pruebas)
- ✅ **NetworkMonitorTests** (2 pruebas)
- ✅ **DetailPresenterTests** (2 pruebas)
- ✅ **ArrayTransformerTests** (5 pruebas)
- ✅ **RavenTestiOSTests** (2 pruebas)

### Ejecutar Pruebas
```bash
# En Xcode: Cmd + U

# Por terminal:
xcodebuild test -workspace RavenTestiOS.xcworkspace \
  -scheme RavenTestiOS \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## 🚀 Instalación

### Requisitos
- Xcode 15.0+
- iOS 15.0+
- CocoaPods instalado
- API Key del NY Times

### Pasos

1. **Clonar el repositorio**
```bash
git clone [repository-url]
cd RavenTestiOS
```

2. **Instalar dependencias**
```bash
pod install
```

3. **Configurar API Key**
Edita `HomeRemoteDataManager.swift` y agrega tu API key:
```swift
let apiKey = "TU_API_KEY_AQUI"
```

4. **Abrir workspace**
```bash
open RavenTestiOS.xcworkspace
```

5. **Compilar y ejecutar**
- Selecciona un simulador
- Presiona `Cmd + R`

## 📡 API del NY Times

La aplicación consume el endpoint:
```
GET https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json
```

**Parámetros:**
- `api-key`: Tu API key del NY Times

**Obtener API Key:**
1. Visita https://developer.nytimes.com/
2. Crea una cuenta
3. Genera una API key para "Most Popular API"

## 🎨 Diseño y UX

### Patrones de Diseño Implementados
- **VIPER**: Arquitectura principal
- **Singleton**: CoreDataManager, NetworkMonitor
- **Delegate Pattern**: Comunicación entre capas VIPER
- **Factory Pattern**: Creación de módulos en Routers
- **Repository Pattern**: Data Managers
- **Observer Pattern**: NotificationCenter para eventos

### Principios SOLID
- ✅ **Single Responsibility**: Cada clase tiene una única responsabilidad
- ✅ **Open/Closed**: Extensible sin modificar código existente
- ✅ **Liskov Substitution**: Protocolos bien definidos
- ✅ **Interface Segregation**: Protocolos específicos por capa
- ✅ **Dependency Inversion**: Inyección de dependencias

## 📊 Flujo de Datos

### Carga de Artículos
```
1. Usuario abre app
2. HomeView llama a Presenter.viewDidLoad()
3. Presenter llama a Interactor.getArticles()
4. Interactor:
   ├─ Carga cache (LocalDataManager)
   ├─ Muestra datos en cache inmediatamente
   ├─ Intenta obtener datos frescos (RemoteDataManager)
   └─ Si tiene éxito: actualiza cache y UI
5. Presenter formatea datos
6. View muestra artículos en TableView
```

### Modo Offline
```
1. NetworkMonitor detecta pérdida de conexión
2. NotificationCenter envía evento
3. HomeView recibe notificación
4. Muestra banner naranja "Sin conexión"
5. Interactor usa solo LocalDataManager
6. Muestra mensaje: "Mostrando datos guardados"
```

## 🔒 Consideraciones de Seguridad

- ✅ API Key no debe estar hardcodeada en producción
- ✅ Usa HTTPS para todas las peticiones
- ✅ Core Data encriptado si maneja datos sensibles
- ✅ Validación de datos del servidor
- ✅ Manejo seguro de errores

## 🌟 Características Destacadas

1. **Arquitectura Limpia**: VIPER proporciona separación clara de responsabilidades
2. **Testeable**: 27 pruebas unitarias con mocks completos
3. **Offline First**: Funciona sin internet desde el primer lanzamiento
4. **Moderno**: Usa las últimas APIs de iOS y Swift
5. **Escalable**: Fácil agregar nuevos módulos/features
6. **Mantenible**: Código bien organizado y documentado

## 📝 TODO / Mejoras Futuras

- [ ] Agregar búsqueda de artículos
- [ ] Implementar categorías/filtros
- [ ] Guardar artículos favoritos
- [ ] Compartir artículos en redes sociales
- [ ] Dark mode completo
- [ ] Soporte para iPad
- [ ] Widgets de iOS
- [ ] Internacionalización (i18n)
- [ ] Aumentar cobertura de tests a 100%
- [ ] Agregar pruebas de integración

## 👨‍💻 Autor

**Miguel Mexicano Herrera**
- Fecha de creación: 21 de Octubre, 2025

## 📄 Licencia

Este proyecto fue creado con fines de demostración y aprendizaje.

---

**¿Preguntas o sugerencias?** Abre un issue o contacta al desarrollador.
