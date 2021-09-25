# Developers

This document details how this project is setup and how to work in the project.

## Getting started

Once you download the project, you'll see a lot of red in the code base. This is because the packages in this repo use [Freezed](https://pub.dev/packages/freezed) to make generating data classes easier. To fix these issues, perform the following in the package that you want to develop in.

```bash
$ cd packages/dough
$ flutter pub run build_runner watch --delete-conflicting-outputs
```

This will start a [Build Runner](https://pub.dev/packages/build_runner) instance to watch for changes to the code and generate data class code. The generated code isn't committed to git because [Dart says not to](https://dart.dev/guides/libraries/private-files).
