# Code Standards

---

## Fields

Booleans should be prefixed with `is`, `has` etc.
Examples: `isActive`, `hasCompletedSomething`.

Functions should be prefixed with `on`.
Examples: `onPressed`, `onCompleted`.

---

## Class structure and order

1. Constructors / Factories
2. Fields
3. Getters / Setters
4. Static members first
5. Methods

---

## Naming policy

Folders should be named in snakecase and if possible use only one word.
Files should be named in snakecase.
Classes and enums should be named in pascalcase.
Variables and functions should be named in camelcase.

Examples:

- PascalCase: `HomeScreen`
- camelCase: `isActive`
- snake_case: `flutter_dotenv`

---

## Imports order

1. Built-in Dart libraries
2. Built-in Flutter libraries
3. Third-party libraries
4. Custom libraries

Use relative imports for custom packages.

```dart
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme/palette.dart';
```