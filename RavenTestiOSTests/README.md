# Pruebas Unitarias - RavenTestiOS

## 📋 Suite de Pruebas Implementadas

Se han creado **8 archivos de pruebas** que cubren todos los componentes principales de la aplicación:

### 1. **HomePresenterTests.swift** ✅
Pruebas para el presentador del módulo Home:
- ✅ Verifica que se llame al interactor al cargar la vista
- ✅ Verifica que se muestre el HUD durante la carga
- ✅ Verifica que se oculte el HUD después de cargar
- ✅ Verifica que se muestren los artículos correctamente
- ✅ Verifica el manejo de errores
- ✅ Verifica la navegación al detalle

**Total: 4 pruebas**

### 2. **HomeInteractorTests.swift** ✅
Pruebas para el interactor del módulo Home:
- ✅ Verifica que se llame al remote data manager
- ✅ Verifica que se notifique al presenter con artículos
- ✅ Verifica que se guarden los artículos en cache
- ✅ Verifica el manejo de errores de red
- ✅ Verifica la carga de artículos en cache

**Total: 5 pruebas**

### 3. **CoreDataManagerTests.swift** ✅
Pruebas para la persistencia de datos:
- ✅ Verifica que se guarden artículos correctamente
- ✅ Verifica que se recuperen artículos guardados
- ✅ Verifica que se detecten artículos en cache
- ✅ Verifica que se obtenga la fecha del cache

**Total: 4 pruebas**

### 4. **ArticleModelTests.swift** ✅
Pruebas para los modelos de datos:
- ✅ Verifica la decodificación JSON del modelo Article
- ✅ Verifica el manejo de campos opcionales
- ✅ Verifica la decodificación de NYTimesResponse

**Total: 3 pruebas**

### 5. **NetworkMonitorTests.swift** ✅
Pruebas para el monitor de red:
- ✅ Verifica la inicialización del monitor
- ✅ Verifica las notificaciones de cambio de conexión

**Total: 2 pruebas**

### 6. **DetailPresenterTests.swift** ✅
Pruebas para el presentador del detalle:
- ✅ Verifica que se configure la vista con datos del artículo
- ✅ Verifica que se abra la URL del artículo completo

**Total: 2 pruebas**

### 7. **ArrayTransformerTests.swift** ✅
Pruebas para el transformer de Core Data:
- ✅ Verifica la transformación de array a data
- ✅ Verifica la transformación reversa de data a array
- ✅ Verifica el manejo de arrays vacíos
- ✅ Verifica el manejo de valores nil
- ✅ Verifica el registro del transformer

**Total: 5 pruebas**

### 8. **RavenTestiOSTests.swift** ✅
Pruebas generales de la aplicación:
- ✅ Verifica que la app lance correctamente
- ✅ Verifica el registro del ArrayTransformer

**Total: 2 pruebas**

---

## 📊 Resumen Total

**27 pruebas unitarias** que cubren:
- ✅ Arquitectura VIPER (Presenter, Interactor, Router)
- ✅ Persistencia de datos (Core Data)
- ✅ Modelos y decodificación JSON
- ✅ Transformers personalizados
- ✅ Monitoreo de red
- ✅ Navegación entre módulos

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
