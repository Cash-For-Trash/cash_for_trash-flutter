<!-- markdownlint-disable -->

# Flutter Feature & Screen Implementation Guide

This guide describes how to implement a new feature/screen in the Flutter application following Clean Architecture, BLoC pattern, GetIt dependency injection, and GoRouter navigation. It ensures adherence to SOLID principles, design patterns, and high-performance practices.

---

## 🏗 Architectural Directory Layout

Each feature resides under `lib/features/[feature_name]/` and contains:
```text
lib/features/[feature_name]/
├── data/
│   ├── model/         # Data transfer objects (DTOs), request & response models
│   └── repositories/  # Implementation of domain repository interfaces
├── domain/
│   └── repositories/  # Repository contracts/interfaces
└── presentation/
    ├── bloc/          # State management (events, states, BLoC)
    ├── screens/       # Main screen view(s)
    └── widgets/       # Component-specific sub-widgets (modularized)
```

---

## 🚀 Step-by-Step Implementation Phases

### Phase 1: Foundation (Data & Domain)

#### 1. Data Modeling
Define the data structures under `data/model/` using the latest Dart features (like records or pattern matching if applicable) and standard JSON serialization.
* Use `@JsonSerializable()`.
* Extend `Equatable` for request models if they need comparisons (e.g., in unit testing).
* Make fields `final` to ensure immutability.

*Example: `features/[feature_name]/data/model/example_response_model.dart`*
```dart
import 'package:equatable/equatable.dart';

class ExampleResponseModel extends Equatable {
  final int id;
  final String title;

  const ExampleResponseModel({
    required this.id,
    required this.title,
  });

  factory ExampleResponseModel.fromJson(Map<String, dynamic> json) {
    return ExampleResponseModel(
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

#### 2. Domain Repository Contract
Under `domain/repositories/`, define an abstract class outlining operations. 
* Use the functional programming package `dartz` to return `Either<String, T>` (where `String` is the failure/error message and `T` is the success payload).
* Follow the **Dependency Inversion Principle** (high-level policy domain should not depend on low-level data implementation).

*Example: `features/[feature_name]/domain/repositories/example_repository.dart`*
```dart
import 'package:dartz/dartz.dart';
import '../data/model/example_response_model.dart';

abstract class ExampleRepository {
  Future<Either<String, ExampleResponseModel>> getExampleData(int id);
}
```

#### 3. Data Repository Implementation
Under `data/repositories/`, implement the contract. Inject the remote `ApiConsumer` or local helper.
* Always define network endpoints in `core/services/remote/endpoints.dart`.
* Use the injected `ApiConsumer` to execute requests.

*Example: `features/[feature_name]/data/repositories/example_repository_impl.dart`*
```dart
import 'package:dartz/dartz.dart';
import '../../core/services/remote/api_consumer.dart';
import '../../core/services/remote/endpoints.dart';
import '../domain/repositories/example_repository.dart';
import '../model/example_response_model.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final ApiConsumer apiConsumer;

  ExampleRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, ExampleResponseModel>> getExampleData(int id) async {
    return await apiConsumer.get<ExampleResponseModel>(
      '${EndPoint.examplePath}/$id',
      fromJson: (json) => ExampleResponseModel.fromJson(json),
    );
  }
}
```

---

### Phase 2: Logic & Dependency Injection

#### 1. State Management (BLoC)
Write the event, state, and BLoC files. Ensure all states extend `Equatable` to prevent redundant UI rebuilds.

*Example BLoC Event:*
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

*Example BLoC State:*
```dart
import 'package:equatable/equatable.dart';
import '../../data/model/example_response_model.dart';

abstract class ExampleState extends Equatable {
  const ExampleState();

  @override
  List<Object?> get props => [];
}

class ExampleInitialState extends ExampleState {}
class ExampleLoadingState extends ExampleState {}
class ExampleLoadedState extends ExampleState {
  final ExampleResponseModel data;
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

*Example BLoC:*
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/example_repository.dart';
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

#### 2. Service Locator (Dependency Injection)
Register the repository and BLoC inside `lib/core/di/service_locator.dart`.
* Use `registerLazySingleton` for repositories (one instance persisted).
* Use `registerFactory` for BLoCs to instantiate a fresh controller whenever needed, avoiding stale states.

```dart
// Features - Example
sl.registerLazySingleton<ExampleRepository>(
  () => ExampleRepositoryImpl(apiConsumer: sl()),
);
sl.registerFactory(() => ExampleBloc(repository: sl()));
```

#### 3. Routing (GoRouter Registration)
Register the path in `lib/core/routing/app_routes.dart` and bind the route logic in `lib/core/routing/router_generator.dart`.
Provide the BLoC at the routing level to scoped widgets.

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

#### 1. Multi-Language Strings
Add localizations for English (`lib/core/localization/l10n/en.json`) and Arabic (`lib/core/localization/l10n/ar.json`).
* Reference string in UI: `context.tr('key')` (ensure necessary localization extensions or packages are imported).

#### 2. Image and Icon Declarations
Add asset constant paths to central classes like `AppIcons` or `AppImages` under `lib/core/constants/` or equivalent configuration files.

---

### Phase 4: UI Development (High Performance & Responsive Design)

#### 1. Styling Guidelines
* **Responsive Layouts**: Always wrap dimensions with `ScreenUtil` using extensions `.w` for width, `.h` for height, `.r` for radii, and `.sp` for fonts.
* **Theme-Based Styling**: Never hardcode colors. Use theme context selectors such as `context.colorScheme` or custom theme color abstractions.

#### 2. Modular Widgets
Avoid large build methods. Split complex layouts into smaller, isolated private or public widgets located inside the feature's `widgets/` folder.
* Utilize `const` constructors on all stateless/stateful child widgets to facilitate cache recycling and prevent unnecessary framework redraws.

#### 3. State-Driven UI Lifecycle
Handle the state transitions smoothly with `BlocBuilder`. Use loading indicators (`LoadingIndicatorWidget` / Shimmers) and friendly state representations for error/empty outcomes.

*Example screen layout:*
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/extensions/theme_extensions.dart'; // Example extension
import '../bloc/example_bloc.dart';
import '../bloc/example_state.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: BlocBuilder<ExampleBloc, ExampleState>(
        builder: (context, state) {
          if (state is ExampleLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExampleLoadedState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              key: ValueKey(state.data.id),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.data.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ExampleErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(color: context.colorScheme.error),
              ),
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

## ⚡ SOLID & Performance Best Practices

1. **Single Responsibility Principle (SRP)**:
   * Keep widgets small and specialized.
   * Business logic should live strictly in BLoC.
   * Networking must remain encapsulated within the data sources and repository.

2. **Open/Closed Principle (OCP)**:
   * Program to abstract interfaces (`ExampleRepository`) rather than implementations (`ExampleRepositoryImpl`).
   * Add new behaviors by creating subclass or decorator classes rather than modifying stable core implementation.

3. **Performance Optimization (Flutter-Specific)**:
   * Use **`const` constructors** wherever possible to reduce widget rebuild cycles.
   * Prefer **`ListView.builder`** over rendering list maps directly for dynamic content to support lazy loading of children.
   * Cache remote images using **`CachedNetworkImage`** with custom placeholder shimmers to prevent layout thrashing and high network usage.
   * Minimize the rebuild scope by localizing `BlocBuilder`s to the specific part of the widget tree that actually depends on the state data.
