# Contributing to Suggest a Feature

This document provides guidelines and information for developers working on this package.

## Working with SVG Assets

This package uses the `vector_graphics` package for rendering SVG icons. Because `vector_graphics` transformers don't work across package boundaries, we pre-compile all SVG assets into `.vec` format.

### Adding or Modifying SVG Assets

When you add new SVG files or modify existing ones in the `assets/` directory, you must re-compile them:

**Step 1:** Add or update your SVG file in `assets/`

**Step 2:** Run the compilation script:
```bash
dart run scripts/compile_svgs.dart
```

**Step 3:** Reference the compiled asset in code:
```dart
// In assets_strings.dart
static const String myIcon = 'assets/compiled/my_icon.svg.vec';
```

### Why Pre-compilation is Required

The `vector_graphics_compiler` package uses asset transformers that only work in application projects, not in library packages. By pre-compiling our SVG assets during development, we ensure that:
- Package users only need the `vector_graphics` runtime dependency
- Users don't need to add `vector_graphics_compiler` or configure transformers
- Assets are optimized for faster rendering

**Important:** Always commit both the source `.svg` files and the compiled `.vec` files to the repository.
