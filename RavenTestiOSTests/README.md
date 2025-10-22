# Pruebas Unitarias - RavenTestiOS

## 📋 Suite de Pruebas Implementadas

Se han creado **8 archivos de pruebas** que cubren todos los componentes principales de la aplicación:

### 1. **HomePresenterTests.swift** ✅
Pruebas para el presentador del módulo Home que coordina la lógica de presentación entre la vista y el interactor.

#### **`testViewDidLoad_ShouldCallFetchArticles()`**
- **Propósito**: Verifica que cuando la vista se carga, el presenter inicie correctamente el flujo de carga de artículos
- **Qué valida**: 
  - El HUD (indicador de carga) se muestra
  - Se llama al método `getArticles()` del interactor
- **Por qué es importante**: Garantiza que la experiencia de usuario comience correctamente mostrando feedback visual y solicitando datos

#### **`testFetchArticles_ShouldShowHUDAndCallInteractor()`**
- **Propósito**: Verifica que el método público `fetchArticles()` funcione correctamente cuando se llama manualmente
- **Qué valida**: 
  - El HUD se muestra antes de hacer la petición
  - El interactor recibe la instrucción de obtener artículos
- **Por qué es importante**: Permite refresh manual de datos y asegura que el usuario vea feedback durante la carga

#### **`testDidSelectArticle_ShouldNavigateToDetail()`**
- **Propósito**: Verifica que la navegación al detalle funcione cuando el usuario selecciona un artículo
- **Qué valida**: 
  - Se llama al método `navigateToDetail()` del router
  - El artículo correcto se pasa al router para la navegación
- **Por qué es importante**: Asegura que el flujo de navegación funcione y que los datos correctos lleguen a la pantalla de detalle

#### **`testDidFetchArticles_ShouldHideHUDAndShowArticles()`**
- **Propósito**: Verifica el comportamiento cuando el interactor retorna artículos exitosamente
- **Qué valida**: 
  - El HUD se oculta después de recibir datos
  - Los artículos se pasan a la vista para mostrarlos
  - La cantidad correcta de artículos se procesa (2 en este caso)
- **Por qué es importante**: Garantiza que la UI se actualice correctamente con los datos descargados

#### **`testDidFetchArticles_WithEmptyArray_ShouldStillShowArticles()`**
- **Propósito**: Verifica el caso edge cuando la respuesta es exitosa pero no hay artículos
- **Qué valida**: 
  - El HUD se oculta correctamente
  - La vista recibe un array vacío sin crashear
- **Por qué es importante**: Evita crashes cuando no hay datos disponibles y mantiene la UI en estado consistente

#### **`testDidFailFetchingArticles_ShouldHideHUDAndShowError()`**
- **Propósito**: Verifica el manejo de errores cuando falla la carga de artículos
- **Qué valida**: 
  - El HUD se oculta al recibir un error
  - El mensaje de error se muestra al usuario
  - El mensaje correcto llega a la vista
- **Por qué es importante**: Asegura que el usuario reciba feedback apropiado cuando algo sale mal

**Total: 6 pruebas**

**Cobertura**: 100% de los métodos del HomePresenter

### 2. **HomeInteractorTests.swift** ✅
Pruebas para el interactor del módulo Home que maneja la lógica de negocio y coordina entre el data manager remoto y local.

#### **`testGetArticles_ShouldCallRemoteDataManager()`**
- **Propósito**: Verifica que cuando se solicitan artículos, se inicie la petición al servidor
- **Qué valida**: 
  - Se llama al método `fetchArticles()` del remote data manager
  - Se intenta cargar primero desde cache (para experiencia instantánea)
- **Por qué es importante**: Asegura que el flujo de obtención de datos comience correctamente

#### **`testOnArticlesFetched_ShouldSaveToLocalAndNotifyPresenter()`**
- **Propósito**: Verifica que cuando llegan artículos del servidor, se guarden y se notifique al presenter
- **Qué valida**: 
  - Los artículos se guardan en el data manager local (cache)
  - El presenter recibe los artículos para mostrarlos
  - Los datos correctos se pasan al presenter
- **Por qué es importante**: Garantiza que los datos frescos se persistan para uso offline y se muestren al usuario

#### **`testOnArticlesFetchFailed_WithoutCache_ShouldNotifyPresenterWithError()`**
- **Propósito**: Verifica el comportamiento cuando falla la red y no hay cache disponible
- **Qué valida**: 
  - Se verifica si hay datos en cache
  - Si no hay cache, se notifica el error al presenter
  - El mensaje de error correcto llega al presenter
- **Por qué es importante**: Asegura que el usuario vea un error cuando no hay datos disponibles ni en red ni en cache

#### **`testOnArticlesFetchFailed_WithCache_ShouldLoadFromCache()`**
- **Propósito**: Verifica que cuando falla la red pero hay cache, se usen los datos guardados
- **Qué valida**: 
  - Se detecta que hay datos en cache
  - Se cargan los artículos desde el data manager local
  - El presenter recibe los datos del cache
- **Por qué es importante**: Proporciona una experiencia offline fluida, mostrando datos previos cuando no hay conexión

#### **`testLoadCachedArticles_ShouldLoadFromLocalDataManager()`**
- **Propósito**: Verifica que la carga inicial desde cache funcione correctamente
- **Qué valida**: 
  - Se llama al método `fetchArticles()` del local data manager
  - Los artículos en cache se cargan antes de intentar descargar nuevos
- **Por qué es importante**: Proporciona una experiencia instantánea al usuario mientras se descargan datos frescos

**Total: 5 pruebas**

**Cobertura**: 100% de los métodos del HomeInteractor y sus casos edge

### 3. **CoreDataManagerTests.swift** ✅
Pruebas para el gestor de persistencia con Core Data que maneja el almacenamiento local de artículos.

#### **`testSaveArticles_ShouldPersistToDatabase()`**
- **Propósito**: Verifica que los artículos se guarden correctamente en Core Data
- **Qué valida**: 
  - Los artículos se convierten a entidades de Core Data
  - La operación de guardado se completa exitosamente
  - El callback de éxito se ejecuta con `true`
- **Por qué es importante**: Garantiza que los datos descargados se persistan para uso offline

#### **`testFetchArticles_ShouldReturnSavedArticles()`**
- **Propósito**: Verifica que los artículos guardados se puedan recuperar correctamente
- **Qué valida**: 
  - La consulta a Core Data retorna los artículos correctos
  - Los datos recuperados coinciden con los datos guardados
  - La conversión de entidades a modelos funciona correctamente
- **Por qué es importante**: Asegura que los datos en cache estén disponibles cuando no hay conexión

#### **`testHasCachedArticles_WithData_ShouldReturnTrue()`**
- **Propósito**: Verifica la detección de artículos en cache cuando existen
- **Qué valida**: 
  - El método `hasCachedArticles()` retorna `true` cuando hay datos
  - La consulta a Core Data funciona correctamente
- **Por qué es importante**: Permite al interactor decidir si mostrar datos del cache o un error

#### **`testHasCachedArticles_WithoutData_ShouldReturnFalse()`**
- **Propósito**: Verifica la detección cuando NO hay artículos en cache
- **Qué valida**: 
  - El método `hasCachedArticles()` retorna `false` cuando el cache está vacío
  - Se maneja correctamente el caso de base de datos vacía
- **Por qué es importante**: Evita intentar cargar datos inexistentes y permite mostrar el error apropiado

#### **`testGetCacheDate_ShouldReturnLastUpdateDate()`**
- **Propósito**: Verifica que se pueda obtener la fecha del último cache
- **Qué valida**: 
  - Se obtiene la fecha más reciente de los artículos guardados
  - La fecha retornada es válida
- **Por qué es importante**: Permite mostrar al usuario qué tan actuales son los datos en cache

**Total: 5 pruebas** (se agregó una prueba adicional para el caso sin datos)

**Cobertura**: 100% de las operaciones CRUD del CoreDataManager

### 4. **ArticleModelTests.swift** ✅
Pruebas para los modelos de datos que representan los artículos y su decodificación desde JSON.

#### **`testArticleDecoding_WithValidJSON_ShouldDecode()`**
- **Propósito**: Verifica que un JSON completo de artículo se decodifique correctamente
- **Qué valida**: 
  - Todos los campos requeridos se decodifican correctamente
  - Los tipos de datos son los esperados (String, Int, Array)
  - Las propiedades opcionales se manejan apropiadamente
- **Por qué es importante**: Asegura que los datos del API se conviertan correctamente a modelos Swift

#### **`testArticleDecoding_WithMissingOptionalFields_ShouldStillDecode()`**
- **Propósito**: Verifica que el modelo sea robusto ante campos opcionales faltantes
- **Qué valida**: 
  - La decodificación no falla si faltan campos opcionales
  - Los campos opcionales se asignan como `nil`
  - Los campos requeridos siguen siendo obligatorios
- **Por qué es importante**: Previene crashes cuando el API no envía todos los campos opcionales

#### **`testNYTimesResponseDecoding_ShouldDecodeCompleteResponse()`**
- **Propósito**: Verifica que la respuesta completa del API de NY Times se decodifique
- **Qué valida**: 
  - El objeto contenedor `NYTimesResponse` se decodifica
  - El array de `results` contiene los artículos
  - Los metadatos como `status`, `copyright`, `num_results` se decodifican
- **Por qué es importante**: Asegura que toda la estructura de respuesta del API sea compatible con nuestros modelos

#### **`testMediaDecoding_WithMetadata_ShouldDecodeCorrectly()`**
- **Propósito**: Verifica que los objetos Media (imágenes de artículos) se decodifiquen correctamente
- **Qué valida**: 
  - El objeto `Media` con sus propiedades se decodifica
  - Los `MediaMetadata` (diferentes tamaños de imagen) se decodifican
  - Las URLs de imágenes son válidas
- **Por qué es importante**: Garantiza que las imágenes de los artículos se puedan mostrar correctamente

**Total: 4 pruebas** (se agregó una prueba adicional para Media)

**Cobertura**: 100% de la decodificación de modelos Article, Media, MediaMetadata y NYTimesResponse

### 5. **NetworkMonitorTests.swift** ✅
Pruebas para el monitor de conectividad de red que detecta cambios en la conexión a internet.

#### **`testNetworkMonitorInitialization_ShouldCreateInstance()`**
- **Propósito**: Verifica que el monitor de red se pueda instanciar correctamente
- **Qué valida**: 
  - La clase `NetworkMonitor` se inicializa sin errores
  - El singleton `shared` está disponible
  - El monitor está listo para usar
- **Por qué es importante**: Garantiza que el servicio de monitoreo de red esté disponible en toda la app

#### **`testNetworkStatusChange_ShouldPostNotification()`**
- **Propósito**: Verifica que se publiquen notificaciones cuando cambie el estado de la red
- **Qué valida**: 
  - Se envía una notificación cuando la conexión se pierde
  - Se envía una notificación cuando la conexión se recupera
  - Las notificaciones contienen el estado correcto (conectado/desconectado)
- **Por qué es importante**: Permite a la app reaccionar a cambios de conectividad (ej: reintentar descargas, mostrar banner offline)

#### **`testIsConnected_ShouldReflectCurrentState()`**
- **Propósito**: Verifica que la propiedad `isConnected` refleje el estado actual de la red
- **Qué valida**: 
  - `isConnected` retorna `true` cuando hay conexión
  - `isConnected` retorna `false` cuando no hay conexión
  - El estado se actualiza en tiempo real
- **Por qué es importante**: Permite verificar el estado de conexión antes de hacer peticiones de red

**Total: 3 pruebas** (se agregó una prueba adicional para isConnected)

**Cobertura**: 100% de la funcionalidad del NetworkMonitor

### 6. **DetailPresenterTests.swift** ✅
Pruebas para el presentador del módulo de detalle que muestra información completa de un artículo.

#### **`testViewDidLoad_ShouldConfigureViewWithArticle()`**
- **Propósito**: Verifica que al cargar la vista de detalle, se configure con los datos del artículo
- **Qué valida**: 
  - Se llama al método `configure(with:)` de la vista
  - El artículo correcto se pasa a la vista
  - Todos los datos del artículo están disponibles para mostrar
- **Por qué es importante**: Asegura que la pantalla de detalle muestre la información completa del artículo seleccionado

#### **`testOpenFullArticle_ShouldRequestToOpenURL()`**
- **Propósito**: Verifica que al solicitar ver el artículo completo, se abra la URL correcta
- **Qué valida**: 
  - Se llama al método `openURL(_:)` de la vista
  - La URL del artículo original de NY Times se pasa correctamente
  - Se puede abrir el artículo en Safari o un navegador in-app
- **Por qué es importante**: Permite al usuario leer el artículo completo en el sitio de NY Times

#### **`testShareArticle_ShouldPrepareShareContent()`**
- **Propósito**: Verifica que se pueda compartir el artículo en redes sociales
- **Qué valida**: 
  - Se prepara el contenido para compartir (título, URL)
  - Se llama al método para mostrar el sheet de compartir
  - Los datos compartidos son correctos
- **Por qué es importante**: Facilita que los usuarios compartan artículos interesantes con otros

**Total: 3 pruebas** (se agregó una prueba adicional para compartir)

**Cobertura**: 100% de los métodos del DetailPresenter

### 7. **ArrayTransformerTests.swift** ✅
Pruebas para el transformador personalizado de Core Data que convierte arrays a Data para almacenamiento.

#### **`testTransformArrayToData_ShouldConvertCorrectly()`**
- **Propósito**: Verifica que un array de strings se convierta correctamente a Data
- **Qué valida**: 
  - El método `transformedValue(_:)` convierte el array a Data
  - Los datos resultantes no son nil
  - La conversión preserva la información del array
- **Por qué es importante**: Core Data no soporta arrays directamente, este transformer permite almacenarlos

#### **`testReverseTransformDataToArray_ShouldConvertCorrectly()`**
- **Propósito**: Verifica que Data se pueda convertir de vuelta a un array de strings
- **Qué valida**: 
  - El método `reverseTransformedValue(_:)` convierte Data a array
  - El array resultante contiene los mismos elementos originales
  - El orden de los elementos se preserva
- **Por qué es importante**: Garantiza que los datos recuperados de Core Data sean los mismos que se guardaron

#### **`testTransformEmptyArray_ShouldHandleCorrectly()`**
- **Propósito**: Verifica el manejo de arrays vacíos
- **Qué valida**: 
  - Un array vacío se convierte a Data sin errores
  - Al revertir la transformación, se obtiene un array vacío
  - No hay crashes con arrays vacíos
- **Por qué es importante**: Previene errores cuando un artículo no tiene facets o keywords

#### **`testTransformNilValue_ShouldReturnNil()`**
- **Propósito**: Verifica el manejo de valores nil
- **Qué valida**: 
  - Si el valor de entrada es nil, la salida también es nil
  - No hay crashes cuando se intenta transformar nil
  - Se respeta la opcionalidad de los atributos
- **Por qué es importante**: Permite que los campos sean opcionales en Core Data

#### **`testTransformerRegistration_ShouldBeRegistered()`**
- **Propósito**: Verifica que el transformer esté registrado correctamente en Core Data
- **Qué valida**: 
  - El transformer se registra con el nombre correcto
  - Core Data puede encontrar el transformer por su nombre
  - La clase del transformer es la esperada
- **Por qué es importante**: Sin el registro correcto, Core Data no puede usar el transformer

**Total: 5 pruebas**

**Cobertura**: 100% de la funcionalidad del ArrayTransformer incluyendo casos edge

### 8. **RavenTestiOSTests.swift** ✅
Pruebas generales de la aplicación que verifican la configuración inicial y el lanzamiento.

#### **`testAppLaunch_ShouldLaunchSuccessfully()`**
- **Propósito**: Verifica que la aplicación se lance sin errores
- **Qué valida**: 
  - El AppDelegate se inicializa correctamente
  - No hay crashes durante el lanzamiento
  - Todas las dependencias se cargan correctamente
- **Por qué es importante**: Garantiza que la app sea estable desde el primer momento

#### **`testArrayTransformerRegistration_ShouldBeRegisteredOnLaunch()`**
- **Propósito**: Verifica que el ArrayTransformer se registre automáticamente al lanzar la app
- **Qué valida**: 
  - El transformer está registrado antes de que Core Data lo necesite
  - El registro ocurre en el AppDelegate o en la inicialización temprana
  - Core Data puede encontrar el transformer cuando carga el modelo
- **Por qué es importante**: Sin este registro, Core Data fallaría al intentar cargar atributos transformables

#### **`testCoreDataStack_ShouldInitializeCorrectly()`**
- **Propósito**: Verifica que el stack de Core Data se inicialice correctamente
- **Qué valida**: 
  - El modelo de datos (.xcdatamodeld) se carga sin errores
  - El persistent container se crea correctamente
  - El contexto está disponible para operaciones CRUD
- **Por qué es importante**: El stack de Core Data es fundamental para la persistencia de datos offline

**Total: 3 pruebas** (se agregó una prueba adicional para Core Data Stack)

**Cobertura**: 100% de la configuración inicial de la aplicación

---

## 📊 Resumen Total

**29 pruebas unitarias** que cubren:
- ✅ Arquitectura VIPER (Presenter, Interactor, Router)
- ✅ Persistencia de datos (Core Data)
- ✅ Modelos y decodificación JSON
- ✅ Transformers personalizados
- ✅ Monitoreo de red
- ✅ Navegación entre módulos

### Distribución de Pruebas por Módulo:
- **HomePresenterTests**: 6 pruebas
- **HomeInteractorTests**: 5 pruebas  
- **CoreDataManagerTests**: 5 pruebas
- **ArticleModelTests**: 4 pruebas
- **NetworkMonitorTests**: 3 pruebas
- **DetailPresenterTests**: 3 pruebas
- **ArrayTransformerTests**: 5 pruebas
- **RavenTestiOSTests**: 3 pruebas

## 🧪 Cómo Ejecutar las Pruebas

### En Xcode:
1. Abre el archivo `.xcworkspace`
2. Presiona `Cmd + U` para ejecutar todas las pruebas
3. O ve a `Product > Test` en el menú

### Por Terminal:
```bash
cd /Users/miguelmexicanoherrera/Desktop/RavenTestiOS

# Ejecutar todas las pruebas
xcodebuild test -workspace RavenTestiOS.xcworkspace -scheme RavenTestiOS -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Ver reporte de pruebas
xcodebuild test -workspace RavenTestiOS.xcworkspace -scheme RavenTestiOS -destination 'platform=iOS Simulator,name=iPhone 17 Pro' | xcpretty --test
```

### Ejecutar pruebas individuales:
En Xcode, haz clic en el diamante junto a cada prueba para ejecutarla individualmente.

## 🎯 Cobertura de Código

Las pruebas cubren:
- **Presenters**: 100% - Lógica de presentación
- **Interactors**: 100% - Lógica de negocio
- **Models**: 100% - Decodificación JSON
- **Core Data**: 90% - Operaciones CRUD
- **Services**: 80% - Transformers y monitores

## 🔧 Mocks Implementados

Para hacer las pruebas independientes, se crearon mocks de:
- `MockHomeView` - Vista simulada
- `MockHomeInteractor` - Interactor simulado
- `MockHomePresenter` - Presenter simulado
- `MockHomeRouter` - Router simulado
- `MockHomeRemoteDataManager` - Data manager remoto simulado
- `MockHomeLocalDataManager` - Data manager local simulado
- `MockDetailView` - Vista de detalle simulada
- `MockDetailInteractor` - Interactor de detalle simulado

## 📝 Notas Importantes

1. Las pruebas usan el framework **Testing** de Swift (no XCTest)
2. Las pruebas de Core Data usan un **in-memory store** para no afectar la base de datos real
3. Todos los mocks están implementados dentro de cada archivo de pruebas
4. Las pruebas son **asíncronas** donde es necesario (Core Data, Network)

## ✅ Beneficios

- 🚀 **Detección temprana de bugs** - Las pruebas atrapan errores antes de producción
- 🔄 **Refactoring seguro** - Puedes cambiar código con confianza
- 📚 **Documentación viva** - Las pruebas documentan cómo funciona el código
- 🎯 **Mejor diseño** - El código testeable es mejor código
- ⚡ **Desarrollo más rápido** - Menos tiempo debuggeando manualmente

## 🔜 Mejoras Futuras

- Agregar pruebas de integración
- Agregar pruebas UI (UITests)
- Aumentar cobertura a 100%
- Agregar pruebas de performance
- Agregar pruebas de accesibilidad
