---
name: flutter-feature-screen-implementation
description: Comprehensive standards and step-by-step implementation guide for building modular, high-performance, responsive screens and features in Flutter following Clean Architecture, BLoC pattern, GetIt DI, GoRouter, and Dio.
---

# Flutter Feature & Screen Implementation Skill

This skill defines the mandatory standards and step-by-step workflow for implementing new features and screens in the Flutter application. It enforces Clean Architecture, the BLoC pattern, GetIt dependency injection, GoRouter navigation, Dio networking, ScreenUtil responsiveness, and strict UI/UX design standards.

---

## 🎯 Objective

Deliver high-performance, fully responsive screens through a clean, robust, and maintainable codebase following a unified architecture across all features.

---

## 🏗 Architectural Directory Layout

Each feature resides under `lib/features/[feature_name]/` structured into clean layers:

```text
lib/features/[feature_name]/
├── data/
│   ├── model/         # Data transfer objects (DTOs), request & response models
│   └── repository/    # Repository implementations (using Dio / ApiConsumer)
├── domain/
│   └── repository/    # Repository interfaces/contracts (& entities if needed)
└── presentation/
    ├── bloc/          # State management (Events, States, BLoC)
    ├── screens/       # Main screen view(s)
    └── widgets/       # Feature-specific modular sub-widgets
```

---

## 🚀 Step-by-Step Implementation Phases

### Phase 1: Foundation (Data & Domain)

1. **Directory Structure Setup**:
   Create `data/` (models, repo impl), `domain/` (repo interface, entity if needed), and `presentation/` (bloc, screens, widgets).

2. **Data Modeling**:
   - Create model classes in `data/model/` using immutable fields (`final`).
   - Use `@JsonSerializable()` or factory constructors (`fromJson`/`toJson`) for JSON serialization.
   - Extend `Equatable` for testing and comparison efficiency.

   *Example (`features/[feature_name]/data/model/example_model.dart`)*:

   ```dart
   import 'package:equatable/equatable.dart';

   class ExampleModel extends Equatable {
     final int id;
     final String title;

     const ExampleModel({
       required this.id,
       required this.title,
     });

     factory ExampleModel.fromJson(Map<String, dynamic> json) {
       return ExampleModel(
         id: json['id'] as int,
         title: json['title'] as String,
       );
     }

     Map<String, dynamic> toJson() {
       return {
         'id': id,
         'title': title,
       };
     }

     @override
     List<Object?> get props => [id, title];
   }
   ```

3. **Domain Repository Interface**:
   - Define abstract repository contracts in `domain/repository/`.
   - Use `dartz` package returning `Either<String, T>` (where Left is the failure message and Right is the success model/data).
   - Enforce the **Dependency Inversion Principle**.

   *Example (`features/[feature_name]/domain/repository/example_repository.dart`)*:

   ```dart
   import 'package:dartz/dartz.dart';
   import '../../data/model/example_model.dart';

   abstract class ExampleRepository {
     Future<Either<String, ExampleModel>> getExampleData(int id);
   }
   ```

4. **API Endpoints**:
   - Define any new network paths in `lib/core/services/remote/endpoints.dart`.

5. **Data Repository Implementation**:
   - Implement domain contracts in `data/repository/` utilizing `Dio` / `ApiConsumer`.

   *Example (`features/[feature_name]/data/repository/example_repository_impl.dart`)*:

   ```dart
   import 'package:dartz/dartz.dart';
   import 'package:cash_for_trash/core/services/remote/api_consumer.dart';
   import 'package:cash_for_trash/core/services/remote/endpoints.dart';
   import '../../domain/repository/example_repository.dart';
   import '../model/example_model.dart';

   class ExampleRepositoryImpl implements ExampleRepository {
     final ApiConsumer apiConsumer;

     ExampleRepositoryImpl({required this.apiConsumer});

     @override
     Future<Either<String, ExampleModel>> getExampleData(int id) async {
       return await apiConsumer.get<ExampleModel>(
         '${EndPoint.examplePath}/$id',
         fromJson: (json) => ExampleModel.fromJson(json),
       );
     }
   }
   ```

---

### Phase 2: Logic & Dependency Injection

1. **BLoC Implementation**:
   - Define Events (e.g., `GetExampleDataEvent`) and States (e.g., `ExampleInitialState`, `ExampleLoadingState`, `ExampleLoadedState`, `ExampleErrorState`).
   - **Multi-State / Tab Data Rule**: If there are more than one data set/state in one BLoC (e.g. multiple tabs or async resources), you MUST handle them using a unified state class with `copyWith` so that updating one data set never overwrites or erases existing state data for other tabs or sections.
   - Extend `Equatable` across all events and states to prevent unnecessary rebuilds.
   - Inject repository into the BLoC via named parameters.

   *Event (`features/[feature_name]/presentation/bloc/example_event.dart`)*:

   ```dart
   import 'package:equatable/equatable.dart';

   abstract class ExampleEvent extends Equatable {
     const ExampleEvent();

     @override
     List<Object?> get props => [];
   }

   class GetExampleDataEvent extends ExampleEvent {
     final int id;
     const GetExampleDataEvent(this.id);

     @override
     List<Object?> get props => [id];
   }
   ```

   *State (`features/[feature_name]/presentation/bloc/example_state.dart`)*:

   ```dart
   import 'package:equatable/equatable.dart';
   import '../../data/model/example_model.dart';

   abstract class ExampleState extends Equatable {
     const ExampleState();

     @override
     List<Object?> get props => [];
   }

   class ExampleInitialState extends ExampleState {}
   class ExampleLoadingState extends ExampleState {}
   class ExampleLoadedState extends ExampleState {
     final ExampleModel data;
     const ExampleLoadedState(this.data);

     @override
     List<Object?> get props => [data];
   }
   class ExampleErrorState extends ExampleState {
     final String errorMessage;
     const ExampleErrorState(this.errorMessage);

     @override
     List<Object?> get props => [errorMessage];
   }
   ```

   *BLoC (`features/[feature_name]/presentation/bloc/example_bloc.dart`)*:

   ```dart
   import 'package:flutter_bloc/flutter_bloc.dart';
   import '../../domain/repository/example_repository.dart';
   import 'example_event.dart';
   import 'example_state.dart';

   class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
     final ExampleRepository repository;

     ExampleBloc({required this.repository}) : super(ExampleInitialState()) {
       on<GetExampleDataEvent>(_onGetExampleData);
     }

     Future<void> _onGetExampleData(
       GetExampleDataEvent event,
       Emitter<ExampleState> emit,
     ) async {
       emit(ExampleLoadingState());
       final result = await repository.getExampleData(event.id);
       result.fold(
         (error) => emit(ExampleErrorState(error)),
         (data) => emit(ExampleLoadedState(data)),
       );
     }
   }
   ```

2. **Service Locator Registration**:
   - Register Repository using `sl.registerLazySingleton`.
   - Register BLoC using `sl.registerLazySingleton` (or `sl.registerFactory` when fresh instances are needed) in `lib/core/di/service_locator.dart`.

   ```dart
   // Service Locator Registration in service_locator.dart
   sl.registerLazySingleton<ExampleRepository>(
     () => ExampleRepositoryImpl(apiConsumer: sl()),
   );
   sl.registerLazySingleton<ExampleBloc>(
     () => ExampleBloc(repository: sl()),
   );
   ```

3. **Routing Configuration**:
   - Register path constants in `lib/core/routing/app_routes.dart`.
   - Configure route logic in `lib/core/routing/router_generator.dart`, binding BLoC via `BlocProvider`.

   ```dart
   // Under lib/core/routing/router_generator.dart:
   GoRoute(
     path: AppRoutes.exampleScreen,
     builder: (context, state) => BlocProvider(
       create: (context) => sl<ExampleBloc>()..add(const GetExampleDataEvent(1)),
       child: const ExampleScreen(),
     ),
   );
   ```

---

### Phase 3: Assets & Localization

1. **Multi-Language Support**:
   - Add new strings to `assets/translations/en.json` and `assets/translations/ar.json`.
   - Access translated strings in UI using `context.tr('key_name')`.

2. **Icons, Images, and Assets**:
   - Add new icon paths to `app_icons.dart` if needed.
   - Add new image paths to `app_images.dart` if needed.
   - Register asset paths in `app_assets.dart` / `pubspec.yaml` when necessary.

---

### Phase 4: UI Development

1. **Screen Modularization**:
   - Decompose complex screens into small, specialized sub-widgets stored in the feature's `presentation/widgets/` folder.
   - Every sub-widget must reside in its own dedicated file.
   - Follow strict naming: The file and class name must end with the feature name and role (e.g., `ProfileHeaderProfileWidget` for a widget, or `HomeQuickActionsHomeSection` for a section).

2. **Shared UI Components**:
   - Reuse common widgets from `lib/core/widgets/` or `features/widgets/` folder (e.g., `CustomPrimaryButton`, `LoadingIndicatorWidget`).

3. **Styling & Responsiveness**:
   - **Dimensions**: Wrap ALL sizing values using `ScreenUtil` extensions (`.w` for width, `.h` for height, `.r` for radius, `.sp` for text size).
   - **Colors**: **No Static Colors Rule**. Never use hardcoded colors (`Colors.white`, `Colors.black`, `Colors.orange`). Retrieve colors exclusively via `context.colorScheme` or `AppTheme` extensions to guarantee light/dark mode compatibility.
   - **Typography**: Prefer `context.textTheme` extensions (e.g., `context.textTheme.headlineMedium`) over manual `TextStyle` declarations.

4. **State Handling & Shared Error/Empty Widget (MANDATORY)**:
   - **Never inline error or empty state UI directly inside a screen's `BlocBuilder`.** Always delegate to `CustomErrorOrEmptyWidget` from `lib/core/widgets/custom_error_or_empty_widget.dart`.
   - **Error State**: Use `isError: true`, pass `errorMessage` from the BLoC state, and pass `onRetry` callback to re-dispatch the initial event.
   - **Empty State**: Use `isError: false`, provide contextual `icon`, `title`, and `message`.
   - The widget provides a premium design with themed colors, icons, and a styled **"Try Again"** button on error.

   *Example Screen View (`features/[feature_name]/presentation/screens/example_screen.dart`)*:

   ```dart
   import 'package:flutter/material.dart';
   import 'package:flutter_bloc/flutter_bloc.dart';
   import 'package:flutter_screenutil/flutter_screenutil.dart';
   import 'package:cash_for_trash/core/extensions/theme_extensions.dart';
   import 'package:cash_for_trash/core/widgets/custom_error_or_empty_widget.dart';
   import '../bloc/example_bloc.dart';
   import '../bloc/example_state.dart';

   class ExampleScreen extends StatelessWidget {
     const ExampleScreen({super.key});

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: Text(
             context.tr('example_title'),
             style: context.textTheme.titleLarge,
           ),
         ),
         body: BlocBuilder<ExampleBloc, ExampleState>(
           builder: (context, state) {
             if (state is ExampleLoadingState) {
               return const Center(child: LoadingIndicatorWidget());
             } else if (state is ExampleLoadedState) {
               if (state.items.isEmpty) {
                 return const CustomErrorOrEmptyWidget(
                   isError: false,
                   title: 'No Items Found',
                   message: 'There are currently no items available.',
                   icon: Icons.inbox_rounded,
                 );
               }
               return Padding(
                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                 child: ListView.builder(
                   itemCount: state.items.length,
                   itemBuilder: (context, index) => Text(state.items[index].title),
                 ),
               );
             } else if (state is ExampleErrorState) {
               return CustomErrorOrEmptyWidget(
                 isError: true,
                 errorMessage: state.errorMessage,
                 onRetry: () {
                   context.read<ExampleBloc>().add(const GetExampleDataEvent(1));
                 },
               );
             }
             return const SizedBox.shrink();
           },
         ),
       );
     }
   }
   ```

---

## ⚡ SOLID Principles & Performance Rules

1. **Single Responsibility Principle (SRP)**:
   - Keep build methods short and widgets isolated.
   - Retain all business logic inside BLoCs.
   - Encapsulate network calls inside repository implementations using `Dio`.

2. **Open/Closed Principle (OCP)**:
   - Program against abstract repository interfaces (`ExampleRepository`) instead of direct concrete classes.

3. **Flutter Performance Optimization**:
   - Use `const` constructors on all stateless/stateful child widgets to minimize rebuild cycles.
   - Use `ListView.builder` for dynamic lists to support lazy child loading.
   - Localize `BlocBuilder` scopes to only the widgets that require state updates.
   - If any screen/widget can be `StatelessWidget`, prefer stateless over stateful.
   - **Map & Interactive View Optimization**: Avoid dispatching BLoC state updates on high-frequency gesture callbacks like `onCameraMove` during map dragging. Instead, update local state or use `onCameraIdle` to trigger BLoC state changes only when movement completes, preserving 60/120fps native performance.
   - **Theme Extensions Usage**: Retrieve styling exclusively using `context.colorScheme` and `context.textTheme` extensions instead of verbose `Theme.of(context)` calls.

4. **No Comments Rule**:
   - **Never add inline comments, block comments, or doc comments** anywhere in the code (no `//`, `/* */`, or `///`).
   - Code must be self-documenting through clear naming of classes, methods, variables, and files.
   - Use descriptive names that express intent without needing explanation.

5. **Naming Conventions for Files and Classes**:
   - **Standard Format**: Name any new file or class using the pattern: `<feature_name>_<role>_<type>` (e.g., `onboarding_worker_screen.dart` / `OnboardingWorkerScreen`).
     - `feature_name`: The name of the feature (e.g., `onboarding_worker`).
     - `role`: The user role (e.g., `admin`, `worker`).
     - `type`: The type of component (e.g., `screen`, `widget`, `cubit`, `state`).
   - **Screen-Specific Widgets**: If a widget is created specifically for a single screen, its name must contain the screen name followed by the specific widget name, section name, or purpose (e.g., `onboarding_worker_screen_header.dart` / `OnboardingWorkerScreenHeader`).

6. **Flutter 3.44.4 Modern & Non-Deprecated Code Standard**:
   - Always write modern, stable code compliant with Flutter 3.44.4 standards.
   - Never use deprecated Flutter/Dart methods, properties, or constructors (e.g. use `Color.withValues(alpha: ...)` instead of `withOpacity()`, use `context.colorScheme` & `context.textTheme` extensions, avoid deprecated parameters).
   - Ensure all written code is clean, warning-free, and adheres strictly to non-deprecated APIs.

---

## 📷 Image Picker Pattern (Admin Forms)

When an admin screen needs to allow uploading an image, always use the shared helper located at:
`lib/core/helpers/image_picker_helper.dart`

### Architecture Rule: Repository Owns the Transport Format

The decision of whether to send `FormData` (multipart) or a plain `Map<String, dynamic>` (JSON) belongs exclusively to the **repository implementation layer**. No other layer (Event, BLoC, Screen) should ever import `FormData`, `MultipartFile`, or carry an `isFormData` flag.

| Layer | Responsibility |
| --- | --- |
| **Screen** | Collects `Map<String, dynamic> fields` and `String? imagePath`. Dispatches a typed event. |
| **Event** | Carries `Map<String, dynamic> fields` and `String? imagePath`. No Dio imports. |
| **BLoC** | Passes `event.fields` and `event.imagePath` straight to the repository. No format awareness. |
| **Repository (impl)** | `if (imagePath != null)` → build `FormData` + `isFromData: true`. Else → plain `Map` + `isFromData: false`. |

### Usage Pattern

#### 1. Screen — collect fields and image path

```dart
String? _selectedImagePath;

Future<void> _pickImage() async {
  final path = await ImagePickerHelper.pickImageFromGallery();
  if (path != null) setState(() => _selectedImagePath = path);
}

void _save() {
  if (_formKey.currentState?.validate() ?? false) {
    final fields = <String, dynamic>{
      'field_name': controller.text.trim(),
    };
    context.read<FeatureBloc>().add(
      CreateFeatureEvent(fields: fields, imagePath: _selectedImagePath),
    );
    context.pop();
  }
}
```

> **No `FormData`, no `MultipartFile`, no `dio` import in the screen.**

#### 2. Event — strongly typed, no Dio

```dart
import 'package:equatable/equatable.dart';

class CreateFeatureEvent extends FeatureEvent {
  final Map<String, dynamic> fields;
  final String? imagePath;

  const CreateFeatureEvent({required this.fields, this.imagePath});

  @override
  List<Object?> get props => [fields, imagePath];
}

class UpdateFeatureEvent extends FeatureEvent {
  final String id;
  final Map<String, dynamic> fields;
  final String? imagePath;

  const UpdateFeatureEvent({required this.id, required this.fields, this.imagePath});

  @override
  List<Object?> get props => [id, fields, imagePath];
}
```

#### 3. Domain Repository Interface — no Dio

```dart
Future<Either<String, FeatureModel>> createFeature(
  Map<String, dynamic> fields,
  String? imagePath,
);

Future<Either<String, FeatureModel>> updateFeature(
  String id,
  Map<String, dynamic> fields,
  String? imagePath,
);
```

#### 4. Repository Implementation — owns FormData logic

```dart
import 'package:dio/dio.dart';

@override
Future<Either<String, FeatureModel>> createFeature(
  Map<String, dynamic> fields,
  String? imagePath,
) async {
  final bool hasImage = imagePath != null;
  final Object data;
  if (hasImage) {
    final imageFile = await MultipartFile.fromFile(
      imagePath,
      filename: imagePath.split('/').last,
    );
    data = FormData.fromMap({...fields, 'image': imageFile});
  } else {
    data = fields;
  }
  return await apiConsumer.post<FeatureModel>(
    EndPoint.featurePath,
    data: data,
    isFromData: hasImage,
    fromJson: (json) => FeatureModel.fromJson(json['data'] ?? json),
  );
}
```

> The same `if (hasImage)` pattern applies identically to `update` (PUT) methods.

#### 5. Image preview container in the screen

```dart
GestureDetector(
  onTap: _pickImage,
  child: Container(
    width: double.infinity,
    height: 160.h,
    decoration: BoxDecoration(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: colorScheme.outline, width: 1.5),
    ),
    child: _selectedImagePath != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.file(File(_selectedImagePath!), fit: BoxFit.cover),
          )
        : (existingImageUrl != null && existingImageUrl!.isNotEmpty)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.network(existingImageUrl!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 40.r, color: colorScheme.onSurfaceVariant),
                  SizedBox(height: 8.h),
                  Text(context.tr('tap_to_add_image'), style: context.textTheme.bodySmall),
                ],
              ),
  ),
)
```

### Key Rules

- **Never use `FormData` outside the repository implementation.** Screens, Events, and BLoCs must stay clean of Dio transport types.
- When `imagePath != null` → send `FormData` with `isFromData: true` (multipart upload).
- When `imagePath == null` → send plain `Map<String, dynamic>` with `isFromData: false` (JSON). This avoids unnecessary multipart overhead for text-only requests.
- Import `dart:io` for `File` only in the screen (for preview). Import `package:dio/dio.dart` (`FormData`, `MultipartFile`) only in repository implementations.
- Never hardcode the image field name `name` for garbage types — the backend expects `garbage_type_name`.
- For update (PUT), always use `apiConsumer.put(...)` — not `patch`.
