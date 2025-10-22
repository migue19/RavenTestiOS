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
- **ConnectionLayer** ⭐: Pod personalizado **desarrollado por mí** para peticiones HTTP
  - Capa de abstracción moderna sobre URLSession
  - **ConnectionLayerDebug**: Sistema de logging detallado para requests/responses
  - Configuración automática según entorno (DEBUG/RELEASE)
  - API limpia basada en closures
  - Manejo robusto de errores de red
- **Codable**: Decodificación/Codificación JSON
- **URLSession**: Manejo de requests HTTP (usado internamente por ConnectionLayer)

### Third-Party Libraries (CocoaPods)
- **ConnectionLayer** ⭐: **Pod propio desarrollado por mí** - Capa de abstracción para networking
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
├── Components/                       # Componentes reutilizables de UI
│   ├── PlaceholderView.swift        # Vista de estado vacío
│   └── OfflineBannerView.swift      # Banner de conectividad
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
│   └── Constants.swift               # API Keys y URLs
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

## 🎨 Componentes Reutilizables

### PlaceholderView
Componente simple y elegante para mostrar cuando no hay datos en la tabla.

**Características:**
- 📝 Mensaje claro: "No hay artículos para mostrar"
- 🔄 Botón de recarga interactivo
- 🎯 Se muestra automáticamente como `backgroundView` del `UITableView`
- ✨ Diseño centrado y minimalista

**Uso:**
```swift
// Configurar callback
placeholderView.onRetry = { [weak self] in
    self?.presenter?.viewDidLoad()
}

// Mostrar cuando no hay artículos
if articles.isEmpty {
    tableView.backgroundView = placeholderView
} else {
    tableView.backgroundView = nil
}
```

**Cuándo se muestra:**
- Cuando `articles.count == 0` (por cualquier razón)
- Error en la API
- Sin conexión y sin cache
- Primera carga sin datos

### OfflineBannerView
Banner dinámico que aparece en la parte superior cuando no hay conexión.

**Características:**
- 📡 Detección automática de conectividad
- 🎨 Altura animada (0 a 40 puntos)
- 🟠 Color naranja para máxima visibilidad
- 📵 Mensaje: "Sin conexión - Mostrando datos guardados"

**Uso:**
```swift
// Actualizar según conectividad
offlineBanner.updateConnectivityStatus(isConnected: isConnected)

// Métodos disponibles
offlineBanner.show()    // Muestra el banner
offlineBanner.hide()    // Oculta el banner
```

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
Edita `Constants/Constants.swift` y reemplaza con tu API key válido:
```swift
struct NYTimesApi {
    static let key = "TU_API_KEY_AQUI"  // ⬅️ Reemplaza con tu API Key
    // ...resto del código
}
```

**Obtener API Key:**
1. Visita: https://developer.nytimes.com/
2. Crea una cuenta gratuita
3. Ve a "Apps" → "Create App"
4. Activa **"Most Popular API"**
5. Copia tu API Key y pégala en `Constants.swift`

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

## ⭐ ConnectionLayer - Pod Personalizado

**ConnectionLayer** es un **pod desarrollado por mí** que proporciona una capa de abstracción moderna y elegante para realizar peticiones HTTP en iOS.

### 🎯 ¿Por qué crear mi propio pod?

En lugar de usar librerías de terceros como Alamofire o Moya, decidí desarrollar mi propia solución de networking por las siguientes razones:

1. **Control Total**: Entender completamente cómo funciona cada parte del código
2. **Aprendizaje Profundo**: Dominar URLSession y networking en iOS a bajo nivel
3. **Sin Dependencias Externas**: Reducir el tamaño de la app y evitar breaking changes
4. **Personalización**: API diseñada específicamente para mis necesidades
5. **Mantenibilidad**: Código propio es más fácil de mantener y extender

### 🚀 Características de ConnectionLayer

- ✅ **API Moderna**: Basada en closures y callbacks
- ✅ **Type-Safe**: Uso de enums para métodos HTTP y errores
- ✅ **Debug Integrado**: Sistema de logging detallado activable
- ✅ **Manejo Robusto de Errores**: Categorización clara de errores de red
- ✅ **Ligero y Rápido**: Sin overhead innecesario
- ✅ **Fácil de Usar**: API intuitiva y simple

### 💻 Ejemplo de Uso

```swift
// Inicializar con debug habilitado
let connectionLayer = ConnectionLayer(isDebug: true)

// Hacer una petición GET
connectionLayer.request(
    url: "https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json",
    method: .get,
    params: ["api-key": apiKey],
    success: { data in
        // Procesar datos exitosos
        let decoder = JSONDecoder()
        let response = try? decoder.decode(NYTimesResponse.self, from: data)
    },
    fail: { error in
        // Manejar error
        print("Error: \(error)")
    }
)
```

### 📦 Instalación (CocoaPods)

```ruby
pod 'ConnectionLayer', :git => 'https://github.com/tu-usuario/ConnectionLayer.git'
```

### 🏗️ Arquitectura Interna

```
ConnectionLayer
    ↓
URLSession (Foundation)
    ↓
Network Layer (iOS)
```

El pod actúa como una capa delgada sobre URLSession, proporcionando una API más amigable sin perder el control de las peticiones HTTP.

## 🔍 ConnectionLayerDebug

La aplicación utiliza **ConnectionLayerDebug** para facilitar el desarrollo y debugging de las peticiones HTTP.

### ¿Qué es ConnectionLayerDebug?

Es un sistema de logging integrado en el pod `ConnectionLayer` que muestra información detallada de todas las peticiones y respuestas HTTP en la consola de Xcode.

### Configuración Automática por Entorno

El debug se activa/desactiva automáticamente según el entorno:

```swift
// Archivo: Enviroment.swift
var connectionLayerDebug: Bool {
    #if DEBUG
    return true  // ✅ Activa logs detallados en desarrollo
    #else
    return false // ❌ Desactiva logs en producción
    #endif
}
```

### Uso en RemoteDataManager

```swift
// Archivo: HomeRemoteDataManager.swift
private let connectionLayer = ConnectionLayer(isDebug: connectionLayerDebug)
```

### Información que Muestra en Consola

Cuando `connectionLayerDebug = true`, verás en la consola:

#### 📤 Request (Petición):
```
URL: https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json?api-key=xxx
Method: GET
Headers: ["Content-Type": "application/json", "Accept": "application/json"]
Body: No Body
```

#### 📥 Response (Respuesta):
```
Status Code: 200
Response(JSON): {
    "status": "OK",
    "copyright": "Copyright (c) 2025 The New York Times Company...",
    "num_results": 20,
    "results": [...]
}
Servicio exitoso
```

#### ❌ Error:
```
Transport error: The Internet connection appears to be offline.
```

### Ventajas del ConnectionLayerDebug

1. **Debugging Rápido**: Identifica problemas de red al instante
2. **Validación de Datos**: Verifica que los parámetros sean correctos
3. **Monitoreo de Headers**: Revisa que los headers estén bien configurados
4. **Análisis de Respuestas**: Ve exactamente qué datos devuelve el servidor
5. **Sin Impacto en Producción**: Se desactiva automáticamente en builds de release

### Ejemplo de Output Real

```console
🌐 [ConnectionLayer] ========================================
URL: https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json?api-key=YOUR_KEY
Method: GET
Headers: ["Content-Type": "application/json"]
Body: No Body
----------------------------------------
Status Code: 200
Response(JSON): {
    num_results = 20;
    results = (
        {
            abstract = "The article discusses...";
            byline = "By Jane Doe";
            id = 100000009123456;
            title = "Breaking News Story";
            ...
        }
    );
    status = OK;
}
Servicio exitoso
🌐 ========================================
```

### Desactivar Manualmente

Si necesitas desactivar el debug temporalmente sin cambiar el entorno:

```swift
// En Enviroment.swift
var connectionLayerDebug: Bool {
    return false // Desactiva manualmente
}
```

### Mejores Prácticas

✅ **DO (Hacer):**
- Mantener activado en DEBUG para facilitar desarrollo
- Revisar los logs cuando hay errores de red
- Usar para validar estructura de JSON
- Verificar que los parámetros se envíen correctamente

❌ **DON'T (No hacer):**
- Dejar activado en producción (afecta rendimiento)
- Loggear información sensible (passwords, tokens personales)
- Confiar solo en logs sin manejar errores programáticamente

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

1. **Arquitectura Limpia VIPER**: Separación clara de responsabilidades, fácil de testear y mantener
2. **Componentes Reutilizables**: 
   - `PlaceholderView`: Estado vacío simple y elegante
   - `OfflineBannerView`: Banner animado de conectividad
   - `ArticleCell`: Celda personalizada con extensions
3. **Persistencia Completa**: Core Data con estrategia offline-first y cache inteligente
4. **Networking Profesional**: ConnectionLayer propio con sistema de debug integrado
5. **27 Pruebas Unitarias**: Cobertura completa con mocks y test doubles
6. **Experiencia de Usuario Superior**:
   - Placeholder simple cuando no hay datos
   - Banner de conectividad en tiempo real
   - Carga instantánea desde cache
   - HUD de progreso elegante
7. **Código Moderno**: Swift 5.9+, Principios SOLID, Patrones de diseño
8. **Sin Warnings**: Código limpio sin conflictos de layout ni memory leaks

## 📱 Experiencia de Usuario

### Estado Normal
- ✅ Lista de 20 artículos del NY Times
- ✅ Scroll fluido con celdas de altura dinámica
- ✅ Tap en artículo → Navegación al detalle
- ✅ Imágenes descargadas asincrónicamente

### Sin Artículos (articles.count == 0)
- 📝 Mensaje: "No hay artículos para mostrar"
- 🔄 Botón "Recargar" para reintentar
- Se muestra por cualquier razón: error API, sin internet, sin cache

### Sin Conexión
- 🟠 Banner naranja arriba: "Sin conexión - Mostrando datos guardados"
- 📦 Artículos desde cache (si existen)
- 🔄 Se actualiza automáticamente al recuperar conexión

## 🔒 Consideraciones de Seguridad

- ✅ API Key configurable en un solo lugar (`Constants.swift`)
- ✅ HTTPS para todas las peticiones
- ✅ Validación de datos del servidor
- ✅ Manejo seguro de errores
- ⚠️ Nota: En producción, el API Key debería estar en variables de entorno o Keychain

## 📝 TODO / Mejoras Futuras

- [ ] Agregar búsqueda de artículos
- [ ] Implementar categorías/filtros
- [ ] Pull-to-refresh
- [ ] Compartir artículos en redes sociales
- [ ] Modo oscuro personalizado
- [ ] Animaciones entre vistas
- [ ] Widget de iOS para artículos recientes

## 👨‍💻 Autor

**Miguel Mexicano Herrera**

- Pod personalizado: **ConnectionLayer** - Capa de networking propia
- Arquitectura: VIPER completa con 2 módulos
- Testing: 27 pruebas unitarias
- Componentes: Reutilizables y documentados

## 📄 Licencia

Este proyecto fue desarrollado como prueba técnica para demostrar habilidades en:
- Arquitectura iOS (VIPER)
- Persistencia (Core Data)
- Networking (ConnectionLayer personalizado)
- Testing (Unit Tests)
- UI/UX (Componentes reutilizables)

---

**⭐ Proyecto completo con arquitectura profesional, persistencia offline-first, y componentes reutilizables ⭐**
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
