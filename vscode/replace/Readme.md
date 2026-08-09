# VS Code Replace Dictionary

A practical reference for Replace / Replace All in Visual Studio Code, including capture groups, Regex transformations, case conversion, Dart/Flutter refactoring, imports, paths, and cleanup recipes.

> This README starts with a **quick table reference**, followed by the **full detailed guide**.

---

## Contents

- [Quick Table Reference](#quick-table-reference)
- [Detailed Reference](#detailed-reference)

---

## Quick Table Reference

A practical quick-reference for **Replace / Replace All** in Visual Studio Code, with Regex, capture groups, Dart/Flutter refactoring examples, path changes, and cleanup recipes.

> Enable **Use Regular Expression `.*`** when Search contains Regex. Always review the replacement preview before running **Replace All** across a project.

| # | Operation | Search | Replace | Example | Notes |
|---:|---|---|---|---|---|
| 1 | Basic concept | `TenantView` | `TenantEntity` | TenantView → TenantEntity | Search finds text/patterns; Replace defines the replacement. |
| 2 | Core Replace symbols | — | `See the Replace symbols table` | $1, $2, $&, $$, $<name>, \u, \l, \U, \L | These symbols reuse captured text or transform case. |
| 3 | Capture Groups | `get(\w+)View` | `get$1Entity` | getTenantView → getTenantEntity | $1 contains the first captured group. |
| 4 | Multiple Capture Groups | `(\w+)_(\w+)` | `$2_$1` | tenant_account → account_tenant | $1 and $2 follow the order of the groups in Search. |
| 5 | Basic replacement patterns | — | `See examples below` | Prefix, suffix, deletion, reordering | Use capture groups when part of the original text must be preserved. |
| 6 | View → Entity | `\b([A-Z]\w*)View\b` | `$1Entity` | TenantAccountView → TenantAccountEntity | Useful for PascalCase type names. |
| 7 | get...View → get...Entity | `\bget(\w*)View\b` | `get$1Entity` | getTenantView → getTenantEntity | Captures the middle part after get. |
| 8 | Response → Entity | `\b([A-Z]\w*)Response\b` | `$1Entity` | UserResponse → UserEntity | — |
| 9 | DTO → Entity | `\b([A-Z]\w*)(?:Dto\|DTO)\b` | `$1Entity` | UserDto → UserEntity | — |
| 10 | Model → Entity | `\b([A-Z]\w*)Model\b` | `$1Entity` | TenantModel → TenantEntity | — |
| 11 | Remove a suffix | `\b(\w+)View\b` | `$1` | TenantAccountView → TenantAccount | — |
| 12 | Add a suffix | `\b(TenantAccount)\b` | `$1Entity` | TenantAccount → TenantAccountEntity | — |
| 13 | Remove a prefix | `\bSuper(\w+)\b` | `$1` | SuperTextTheme → TextTheme | — |
| 14 | Add a prefix | `\b(TextTheme)\b` | `Super$1` | TextTheme → SuperTextTheme | — |
| 15 | Reorder words | `\b(\w+)_(\w+)\b` | `$2_$1` | tenant_account → account_tenant | — |
| 16 | Replace a camelCase prefix | `\bget([A-Z]\w*)\b` | `fetch$1` | getTenantAccount → fetchTenantAccount | — |
| 17 | create → add | `\bcreate([A-Z]\w*)\b` | `add$1` | createTenant → addTenant | — |
| 18 | update → edit | `\bupdate([A-Z]\w*)\b` | `edit$1` | updateTenant → editTenant | — |
| 19 | delete → remove | `\bdelete([A-Z]\w*)\b` | `remove$1` | deleteTenant → removeTenant | — |
| 20 | Rename a class while preserving its base name | `class\s+(\w+)View\b` | `class $1Entity` | class TenantView → class TenantEntity | — |
| 21 | Named Capture Groups | `(?<name>[A-Z]\w*)View` | `$<name>Entity` | TenantAccountView → TenantAccountEntity | — |
| 22 | Reuse the full match with $& | `\bTenant\b` | `Super$&` | Tenant → SuperTenant | $& means the entire matched text. |
| 23 | Duplicate the full match | `\bTenant\b` | `$&$&` | Tenant → TenantTenant | — |
| 24 | Wrap matched text in parentheses | `\b(TenantEntity)\b` | `($1)` | TenantEntity → (TenantEntity) | — |
| 25 | Add quotes | `\b(TenantEntity)\b` | `'$1'` | TenantEntity → 'TenantEntity' | — |
| 26 | Remove single quotes | `'([^']+)'` | `$1` | 'TenantEntity' → TenantEntity | — |
| 27 | Double quotes → single quotes | `"([^"]*)"` | `'$1'` | "Tenant" → 'Tenant' | — |
| 28 | Single quotes → double quotes | `'([^']*)'` | `"$1"` | 'Tenant' → "Tenant" | — |
| 29 | Add a comma at the end of each line | `^(.+[^,])$` | `$1,` | Tenant → Tenant, | — |
| 30 | Remove a trailing comma | `,\s*$` | *(empty)* | Tenant, → Tenant | Leave Replace empty. |
| 31 | Delete text | `\bView\b` | *(empty)* | View → deleted | Any match can be deleted by leaving Replace empty. |
| 32 | Delete TODO lines | `^\s*//\s*TODO:?.*$` | *(empty)* | // TODO: remove this → deleted | — |
| 33 | Collapse extra blank lines | `(\r?\n\s*){3,}` | `<br><br>` | 3+ blank lines → 2 line breaks | — |
| 34 | Replace repeated spaces with one space | `[ \t]{2,}` | ` ` | foo    bar → foo bar | — |
| 35 | Remove trailing spaces | `[ \t]+$` | *(empty)* | line··· → line | — |
| 36 | Remove leading spaces | `^[ \t]+` | *(empty)* |     value → value | Use carefully; indentation matters for readability. |
| 37 | Reverse three underscore-separated parts | `(\w+)_(\w+)_(\w+)` | `$3_$2_$1` | tenant_account_group → group_account_tenant | — |
| 38 | Add a prefix to every line | `^(.+)$` | `- $1` | Tenant → - Tenant | — |
| 39 | Convert lines to Markdown checkboxes | `^(.+)$` | `- [ ] $1` | Tenant → - [ ] Tenant | — |
| 40 | Convert lines to quoted values | `^(.+)$` | `'$1',` | tenant → 'tenant', | — |
| 41 | Convert lines to Dart list items | `^(.+)$` | `  '$1',` | tenant →   'tenant', | — |
| 42 | Convert key=value to JSON-like syntax | `^(\w+)=(.+)$` | `"$1": "$2",` | name=Tenant → "name": "Tenant", | — |
| 43 | Convert key: value to key=value | `^(\w+):\s*(.+)$` | `$1=$2` | name: Tenant → name=Tenant | — |
| 44 | Add final | `^(\s*)(\w+\s+\w+\s*=)` | `$1final $2` | String name = → final String name = | Approximate pattern; review matches. |
| 45 | Remove final | `\bfinal\s+` | *(empty)* | final value → value | — |
| 46 | Remove const | `\bconst\s+` | *(empty)* | const Widget() → Widget() | — |
| 47 | Add const before a constructor | `\b(TenantEntity)\(` | `const $1(` | TenantEntity( → const TenantEntity( | — |
| 48 | Replace a type while preserving nullable ? | `\bTenantView(\?)?` | `TenantEntity$1` | TenantView? → TenantEntity? | — |
| 49 | List<View> → List<Entity> | `List<([A-Z]\w*)View>` | `List<$1Entity>` | List<TenantView> → List<TenantEntity> | — |
| 50 | Future<View> → Future<Entity> | `Future<([A-Z]\w*)View>` | `Future<$1Entity>` | Future<TenantView> → Future<TenantEntity> | — |
| 51 | Generic <View> → <Entity> | `<([A-Z]\w*)View>` | `<$1Entity>` | <TenantView> → <TenantEntity> | — |
| 52 | Rename a parameter | `\btenantView\b` | `tenantEntity` | tenantView → tenantEntity | — |
| 53 | Rename PascalCase and camelCase separately | `\bTenantView\b` | `TenantEntity` | TenantView → TenantEntity | Use a second replacement for tenantView → tenantEntity. |
| 54 | Lowercase the first letter | `\b([A-Z])(\w*)\b` | `\l$1$2` | TenantAccount → tenantAccount | — |
| 55 | Uppercase the first letter | `\b([a-z])(\w*)\b` | `\u$1$2` | tenantAccount → TenantAccount | — |
| 56 | Convert a capture to UPPERCASE | `\b(\w+)\b` | `\U$1` | tenant → TENANT | — |
| 57 | Convert a capture to lowercase | `\b(\w+)\b` | `\L$1` | TENANT → tenant | — |
| 58 | Uppercase only the first character | `\b([a-z])(\w*)\b` | `\u$1$2` | tenant → Tenant | — |
| 59 | Lowercase only the first character | `\b([A-Z])(\w*)\b` | `\l$1$2` | Tenant → tenant | — |
| 60 | Two-part snake_case → PascalCase | `\b([a-z]+)_([a-z]+)\b` | `\u$1\u$2` | tenant_account → TenantAccount | — |
| 61 | Two-part snake_case → camelCase | `\b([a-z]+)_([a-z]+)\b` | `$1\u$2` | tenant_account → tenantAccount | — |
| 62 | Replace an old import path with a new one | `import 'package:app/features/tenant_account/(.*)';` | `import 'package:app/modules/features/tenant_account/$1';` | features/... → modules/features/... | — |
| 63 | Move /features/ to /modules/features/ in imports | `(package:[^'\"]+)/features/` | `$1/modules/features/` | package:app/features/... → package:app/modules/features/... | — |
| 64 | Replace /infrastructure/ with /data/ | `/infrastructure/` | `/data/` | infrastructure → data | — |
| 65 | Replace a path segment while preserving feature and tail | `lib/features/([^/]+)/infrastructure/(.*)` | `lib/features/$1/data/$2` | lib/features/x/infrastructure/a.dart → lib/features/x/data/a.dart | — |
| 66 | Rename a file inside an import | `presentation\.dart` | `index.dart` | presentation.dart → index.dart | — |
| 67 | Delete a full response.dart import | `^\s*import\s+['\"][^'\"]*response\.dart['\"];\s*\r?\n?` | *(empty)* | import '...response.dart'; → deleted | — |
| 68 | Delete a specific part of directive | `^\s*part\s+of\s+['\"]domain\.dart['\"];\s*\r?\n?` | *(empty)* | part of 'domain.dart'; → deleted | — |
| 69 | Replace part of application.dart with domain.dart | `part of ['\"]([^'\"]*)application\.dart['\"];` | `part of '$1domain.dart';` | application.dart → domain.dart | — |
| 70 | Rename RepositoryImpl | `\b([A-Z]\w*)RepositoryImpl\b` | `$1Repository` | AuthRepositoryImpl → AuthRepository | — |
| 71 | Add a UseCase suffix | `\bclass\s+([A-Z]\w*)(?<!UseCase)\b` | `class $1UseCase` | class GetTenant → class GetTenantUseCase | Broad pattern; restrict the file scope. |
| 72 | Add UseCase inside usecase folders | `\bclass\s+([A-Z]\w+)\b` | `class $1UseCase` | class GetTenant → class GetTenantUseCase | Files to Include: lib/**/domain/usecases/**/*.dart; avoid existing UseCase names. |
| 73 | Remove Response from a variable | `\b(\w+)Response\b` | `$1` | signInResponse → signIn | — |
| 74 | response → entity in camelCase | `\b(\w+)Response\b` | `$1Entity` | signInResponse → signInEntity | — |
| 75 | View → Entity for PascalCase/camelCase identifiers | `\b(\w+)View\b` | `$1Entity` | getTenantView → getTenantEntity | Broad pattern; use carefully. |
| 76 | Replace a standalone word only | `\bView\b` | `Entity` | View → Entity | Does not change TenantView. |
| 77 | Replace a suffix inside identifiers | `View\b` | `Entity` | TenantView → TenantEntity | Also changes tenantView and getTenantView. |
| 78 | Replace a prefix inside identifiers | `\bget` | `fetch` | getTenant → fetchTenant | — |
| 79 | Insert a word after a prefix | `\bget([A-Z])` | `getCurrent$1` | getTenant → getCurrentTenant | — |
| 80 | Insert text between two parts | `\bTenant(View)\b` | `TenantAccount$1` | TenantView → TenantAccountView | — |
| 81 | Remove a middle word | `\bTenantAccount(View\|Entity)\b` | `Tenant$1` | TenantAccountEntity → TenantEntity | — |
| 82 | Replace multiple suffixes with Entity | `\b([A-Z]\w*)(?:View\|Response\|DTO\|Dto\|Model)\b` | `$1Entity` | UserResponse → UserEntity | — |
| 83 | Add required | `^(\s*)(this\.\w+,)$` | `$1required $2` | this.name, → required this.name, | Use only inside constructor parameters. |
| 84 | Remove required | `\brequired\s+` | *(empty)* | required this.name → this.name | — |
| 85 | Convert parameter to required this.x | `^(\s*)this\.(\w+),$` | `$1required this.$2,` | this.name, → required this.name, | — |
| 86 | Add nullable ? | `\b(TenantEntity)\b` | `$1?` | TenantEntity → TenantEntity? | — |
| 87 | Remove nullable ? | `\b(TenantEntity)\?` | `$1` | TenantEntity? → TenantEntity | — |
| 88 | Convert nullable type to non-nullable | `\b([A-Z]\w*)\?` | `$1` | String? → String | Broad pattern; scope it carefully. |
| 89 | Wrap a type in List<> | `\b(TenantEntity)\b` | `List<$1>` | TenantEntity → List<TenantEntity> | — |
| 90 | Remove a List<> wrapper | `List<([^>]+)>` | `$1` | List<TenantEntity> → TenantEntity | — |
| 91 | Future<T> → T | `Future<([^>]+)>` | `$1` | Future<TenantEntity> → TenantEntity | Nested generics may need a more specific pattern. |
| 92 | T → Future<T> | `\b(TenantEntity)\b` | `Future<$1>` | TenantEntity → Future<TenantEntity> | — |
| 93 | Add await | `^(\s*)(repository\.\w+\()` | `$1await $2` | repository.get( → await repository.get( | Review matches manually. |
| 94 | Remove await | `\bawait\s+` | *(empty)* | await repository.get() → repository.get() | — |
| 95 | Add return | `^(\s*)(repository\.\w+\(.*\);)$` | `$1return $2` | repository.get(); → return repository.get(); | — |
| 96 | Remove return | `\breturn\s+` | *(empty)* | return value → value | — |
| 97 | Add const to selected constructors | `\b(SizedBox\|EdgeInsets\|Duration)\(` | `const $1(` | SizedBox( → const SizedBox( | May create duplicate const. |
| 98 | Avoid constructors already preceded by const | `(?<!const\s)\b(SizedBox\|Duration)\(` | `const $1(` | SizedBox( → const SizedBox( | Depends on lookbehind support. |
| 99 | Reorder positional function parameters | `foo\(([^,]+),\s*([^)]+)\)` | `foo($2, $1)` | foo(name, id) → foo(id, name) | — |
| 100 | Reorder named constructor parameters | `Tenant\(name:\s*([^,]+),\s*id:\s*([^)]+)\)` | `Tenant(id: $2, name: $1)` | Tenant(name: name, id: id) → Tenant(id: id, name: name) | — |
| 101 | Split camelCase into words | `([a-z])([A-Z])` | `$1 $2` | tenantAccountGroup → tenant Account Group | — |
| 102 | Split PascalCase/camelCase boundaries | `([a-z0-9])([A-Z])` | `$1 $2` | TenantAccount → Tenant Account | — |
| 103 | Replace spaces with underscores | `\s+` | `_` | tenant account group → tenant_account_group | — |
| 104 | Replace underscores with spaces | `_` | ` ` | tenant_account → tenant account | — |
| 105 | Replace dashes with underscores | `-` | `_` | tenant-account → tenant_account | — |
| 106 | Replace underscores with dashes | `_` | `-` | tenant_account → tenant-account | — |
| 107 | Remove a numeric suffix | `\b(\w+)\d+\b` | `$1` | TenantView2 → TenantView | — |
| 108 | Add a version suffix | `\b(TenantView)\b` | `$1V2` | TenantView → TenantViewV2 | — |
| 109 | Remove simple parentheses | `\(([^()]+)\)` | `$1` | (TenantEntity) → TenantEntity | Does not handle nested parentheses. |
| 110 | Add this. | `\b(value)\b` | `this.$1` | value → this.value | — |
| 111 | Remove this. | `\bthis\.(\w+)` | `$1` | this.value → value | — |
| 112 | Map<String, dynamic> → custom typedef | `\bMap<String,\s*dynamic>\b` | `JsonMap` | Map<String, dynamic> → JsonMap | — |
| 113 | dynamic → Object? | `\bdynamic\b` | `Object?` | dynamic value → Object? value | Review semantics before Replace All. |
| 114 | print → debugPrint | `\bprint\s*\(` | `debugPrint(` | print(value) → debugPrint(value) | — |
| 115 | debugPrint → logger | `\bdebugPrint\s*\((.*)\);` | `logger.debug($1);` | debugPrint(value); → logger.debug(value); | Nested/multiline expressions may need a stricter pattern. |
| 116 | Insert a comment before each match | `^(\s*)(class\s+\w+View.*)$` | `$1// TODO: migrate View to Entity\n$1$2` | class TenantView → comment + class | Insert an actual line break in Replace if needed. |
| 117 | Insert a blank line after each match | `^(.*TODO.*)$` | `$1\n` | TODO line → TODO line + blank line | — |
| 118 | import → export | `^\s*import\s+(['\"][^'\"]+['\"]);\s*$` | `export $1;` | import 'a.dart'; → export 'a.dart'; | — |
| 119 | export → import | `^\s*export\s+(['\"][^'\"]+['\"]);\s*$` | `import $1;` | export 'a.dart'; → import 'a.dart'; | — |
| 120 | Change quotes in imports only | `import\s+"([^"]+)";` | `import '$1';` | import "a.dart"; → import 'a.dart'; | — |
| 121 | Remove .dart from paths | `\.dart\b` | *(empty)* | file.dart → file | — |
| 122 | Add .dart | `\b([\w/]+)(?<!\.dart)\b` | `$1.dart` | path/file → path/file.dart | Broad pattern; use on path lists only. |
| 123 | Rename a package | `package:old_app/` | `package:new_app/` | package:old_app/... → package:new_app/... | — |
| 124 | Move a feature path while preserving feature and tail | `package:app/features/([^/]+)/(.*)` | `package:app/modules/features/$1/$2` | features/x/a.dart → modules/features/x/a.dart | — |
| 125 | Preserve indentation | `^(\s*)oldText` | `$1newText` |     oldText →     newText | $1 retains leading whitespace. |
| 126 | Preserve indentation while changing line ending syntax | `^(\s*)(.+);$` | `$1$2,` |     final a = 1; →     final a = 1, | — |
| 127 | Wrap matched text in a function | `\b(TenantEntity)\b` | `wrap($1)` | TenantEntity → wrap(TenantEntity) | — |
| 128 | Wrap the full matched expression | `repository\.\w+\([^;]*\)` | `await $&` | repository.get() → await repository.get() | $& is the full match. |
| 129 | Use named groups to reorder text | `(?<first>\w+)_(?<second>\w+)` | `$<second>_$<first>` | tenant_account → account_tenant | — |
| 130 | Safer Replace All for one exact type | `\bTenantProductView\b` | `TenantProductEntity` | TenantProductView → TenantProductEntity | Less flexible but safer for large refactors. |
| 131 | Quick Cheat Sheet | — | `See the Cheat Sheet table` | Common View/Entity/DTO/import replacements | — |
| 132 | Critical rules before Replace All | — | `See safety rules` | Preview, scope, exclude generated files, commit first | — |
| 133 | Practical example matching your current search | `\bget([A-Za-z0-9_]*)View\b` | `get$1Entity` | getProductDetailsView → getProductDetailsEntity | Capture the middle part with (...) and reuse it as $1. |

---

## Core Replace Symbols

| Symbol | Meaning | Example |
|---|---|---|
| `$1` | Contents of capture group 1 | `get(\w+)View` → `get$1Entity` |
| `$2` | Contents of capture group 2 | `(\w+)_(\w+)` → `$2_$1` |
| `$3` | Contents of capture group 3 | Use when Search has at least three capturing groups |
| `$&` | Entire matched text | `Tenant` → `Super$&` |
| `$$` | Literal `$` character | `value` → `$$value` |
| `$<name>` | Named capture group | `(?<name>\w+)View` → `$<name>Entity` |
| `\u` | Uppercase the next character | `\u$1` |
| `\l` | Lowercase the next character | `\l$1` |
| `\U` | Uppercase following replacement text | `\U$1` |
| `\L` | Lowercase following replacement text | `\L$1` |

## Quick Cheat Sheet

| Goal | Search | Replace |
|---|---|---|
| `View → Entity` | `\b([A-Z]\w*)View\b` | `$1Entity` |
| `get...View → get...Entity` | `\bget(\w*)View\b` | `get$1Entity` |
| `Response → Entity` | `\b([A-Z]\w*)Response\b` | `$1Entity` |
| `DTO → Entity` | `\b([A-Z]\w*)(?:Dto\|DTO)\b` | `$1Entity` |
| Remove `View` suffix | `\b(\w+)View\b` | `$1` |
| Remove `Super` prefix | `\bSuper(\w+)\b` | `$1` |
| Swap two parts | `(\w+)_(\w+)` | `$2_$1` |
| Lowercase first letter | `\b([A-Z])(\w*)\b` | `\l$1$2` |
| Uppercase first letter | `\b([a-z])(\w*)\b` | `\u$1$2` |
| Remove `this.` | `\bthis\.(\w+)` | `$1` |
| `print → debugPrint` | `\bprint\s*\(` | `debugPrint(` |
| Rename a package | `package:old_app/` | `package:new_app/` |

## Safety Rules Before Replace All

| # | Rule |
|---:|---|
| 1 | Inspect the Search results and replacement preview first. |
| 2 | Restrict the scope with **Files to Include**. |
| 3 | Exclude generated files such as `*.g.dart`, `*.freezed.dart`, and `*.drift.dart`. |
| 4 | Use `\b` when you need whole-identifier matching. |
| 5 | Use capture groups when part of the original text must be preserved. |
| 6 | `$1`, `$2`, etc. correspond to the capture-group order in Search. |
| 7 | Use `$$` when you need a literal dollar sign in the replacement. |
| 8 | Avoid broad expressions such as `\w+` across the entire project without scoping. |
| 9 | Create a Git commit before a large refactor. |
| 10 | Run `dart format .` and then `dart analyze` or `flutter analyze` after the replacement. |

---

## Detailed Reference

A practical English reference for **Replace / Replace All** in Visual Studio Code, including Regular Expressions, capture groups, case conversion, Dart/Flutter refactoring, imports, paths, generics, and text cleanup.

> Enable **Use Regular Expression `.*`** whenever Search contains Regex.

## Core Replace Symbols

| Symbol | Meaning | Example |
|---|---|---|
| `$1` | Contents of capture group 1 | `get(\w+)View` → `get$1Entity` |
| `$2` | Contents of capture group 2 | `(\w+)_(\w+)` → `$2_$1` |
| `$3` | Contents of capture group 3 | Use when Search has at least three capturing groups |
| `$&` | Entire matched text | `Tenant` → `Super$&` |
| `$$` | Literal `$` character | `value` → `$$value` |
| `$<name>` | Named capture group | `(?<name>\w+)View` → `$<name>Entity` |
| `\u` | Uppercase the next character | `\u$1` |
| `\l` | Lowercase the next character | `\l$1` |
| `\U` | Uppercase following replacement text | `\U$1` |
| `\L` | Lowercase following replacement text | `\L$1` |

---

## 1) Basic concept

**Search:**

```regex
TenantView
```

**Replace:**

```text
TenantEntity
```

**Example:**

```text
TenantView → TenantEntity
```

**Notes:**

Search finds text/patterns; Replace defines the replacement.

---

## 2) Core Replace symbols

**Replace:**

```text
See the Replace symbols table
```

**Example:**

```text
$1, $2, $&, $$, $<name>, \u, \l, \U, \L
```

**Notes:**

These symbols reuse captured text or transform case.

---

## 3) Capture Groups

**Search:**

```regex
get(\w+)View
```

**Replace:**

```text
get$1Entity
```

**Example:**

```text
getTenantView → getTenantEntity
```

**Notes:**

$1 contains the first captured group.

---

## 4) Multiple Capture Groups

**Search:**

```regex
(\w+)_(\w+)
```

**Replace:**

```text
$2_$1
```

**Example:**

```text
tenant_account → account_tenant
```

**Notes:**

$1 and $2 follow the order of the groups in Search.

---

## 5) Basic replacement patterns

**Replace:**

```text
See examples below
```

**Example:**

```text
Prefix, suffix, deletion, reordering
```

**Notes:**

Use capture groups when part of the original text must be preserved.

---

## 6) View → Entity

**Search:**

```regex
\b([A-Z]\w*)View\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
TenantAccountView → TenantAccountEntity
```

**Notes:**

Useful for PascalCase type names.

---

## 7) get...View → get...Entity

**Search:**

```regex
\bget(\w*)View\b
```

**Replace:**

```text
get$1Entity
```

**Example:**

```text
getTenantView → getTenantEntity
```

**Notes:**

Captures the middle part after get.

---

## 8) Response → Entity

**Search:**

```regex
\b([A-Z]\w*)Response\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
UserResponse → UserEntity
```

---

## 9) DTO → Entity

**Search:**

```regex
\b([A-Z]\w*)(?:Dto|DTO)\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
UserDto → UserEntity
```

---

## 10) Model → Entity

**Search:**

```regex
\b([A-Z]\w*)Model\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
TenantModel → TenantEntity
```

---

## 11) Remove a suffix

**Search:**

```regex
\b(\w+)View\b
```

**Replace:**

```text
$1
```

**Example:**

```text
TenantAccountView → TenantAccount
```

---

## 12) Add a suffix

**Search:**

```regex
\b(TenantAccount)\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
TenantAccount → TenantAccountEntity
```

---

## 13) Remove a prefix

**Search:**

```regex
\bSuper(\w+)\b
```

**Replace:**

```text
$1
```

**Example:**

```text
SuperTextTheme → TextTheme
```

---

## 14) Add a prefix

**Search:**

```regex
\b(TextTheme)\b
```

**Replace:**

```text
Super$1
```

**Example:**

```text
TextTheme → SuperTextTheme
```

---

## 15) Reorder words

**Search:**

```regex
\b(\w+)_(\w+)\b
```

**Replace:**

```text
$2_$1
```

**Example:**

```text
tenant_account → account_tenant
```

---

## 16) Replace a camelCase prefix

**Search:**

```regex
\bget([A-Z]\w*)\b
```

**Replace:**

```text
fetch$1
```

**Example:**

```text
getTenantAccount → fetchTenantAccount
```

---

## 17) create → add

**Search:**

```regex
\bcreate([A-Z]\w*)\b
```

**Replace:**

```text
add$1
```

**Example:**

```text
createTenant → addTenant
```

---

## 18) update → edit

**Search:**

```regex
\bupdate([A-Z]\w*)\b
```

**Replace:**

```text
edit$1
```

**Example:**

```text
updateTenant → editTenant
```

---

## 19) delete → remove

**Search:**

```regex
\bdelete([A-Z]\w*)\b
```

**Replace:**

```text
remove$1
```

**Example:**

```text
deleteTenant → removeTenant
```

---

## 20) Rename a class while preserving its base name

**Search:**

```regex
class\s+(\w+)View\b
```

**Replace:**

```text
class $1Entity
```

**Example:**

```text
class TenantView → class TenantEntity
```

---

## 21) Named Capture Groups

**Search:**

```regex
(?<name>[A-Z]\w*)View
```

**Replace:**

```text
$<name>Entity
```

**Example:**

```text
TenantAccountView → TenantAccountEntity
```

---

## 22) Reuse the full match with $&

**Search:**

```regex
\bTenant\b
```

**Replace:**

```text
Super$&
```

**Example:**

```text
Tenant → SuperTenant
```

**Notes:**

$& means the entire matched text.

---

## 23) Duplicate the full match

**Search:**

```regex
\bTenant\b
```

**Replace:**

```text
$&$&
```

**Example:**

```text
Tenant → TenantTenant
```

---

## 24) Wrap matched text in parentheses

**Search:**

```regex
\b(TenantEntity)\b
```

**Replace:**

```text
($1)
```

**Example:**

```text
TenantEntity → (TenantEntity)
```

---

## 25) Add quotes

**Search:**

```regex
\b(TenantEntity)\b
```

**Replace:**

```text
'$1'
```

**Example:**

```text
TenantEntity → 'TenantEntity'
```

---

## 26) Remove single quotes

**Search:**

```regex
'([^']+)'
```

**Replace:**

```text
$1
```

**Example:**

```text
'TenantEntity' → TenantEntity
```

---

## 27) Double quotes → single quotes

**Search:**

```regex
"([^"]*)"
```

**Replace:**

```text
'$1'
```

**Example:**

```text
"Tenant" → 'Tenant'
```

---

## 28) Single quotes → double quotes

**Search:**

```regex
'([^']*)'
```

**Replace:**

```text
"$1"
```

**Example:**

```text
'Tenant' → "Tenant"
```

---

## 29) Add a comma at the end of each line

**Search:**

```regex
^(.+[^,])$
```

**Replace:**

```text
$1,
```

**Example:**

```text
Tenant → Tenant,
```

---

## 30) Remove a trailing comma

**Search:**

```regex
,\s*$
```

**Replace:**

```text

```

**Example:**

```text
Tenant, → Tenant
```

**Notes:**

Leave Replace empty.

---

## 31) Delete text

**Search:**

```regex
\bView\b
```

**Replace:**

```text

```

**Example:**

```text
View → deleted
```

**Notes:**

Any match can be deleted by leaving Replace empty.

---

## 32) Delete TODO lines

**Search:**

```regex
^\s*//\s*TODO:?.*$
```

**Replace:**

```text

```

**Example:**

```text
// TODO: remove this → deleted
```

---

## 33) Collapse extra blank lines

**Search:**

```regex
(\r?\n\s*){3,}
```

**Replace:**

```text



```

**Example:**

```text
3+ blank lines → 2 line breaks
```

---

## 34) Replace repeated spaces with one space

**Search:**

```regex
[ \t]{2,}
```

**Replace:**

```text
 
```

**Example:**

```text
foo    bar → foo bar
```

---

## 35) Remove trailing spaces

**Search:**

```regex
[ \t]+$
```

**Replace:**

```text

```

**Example:**

```text
line··· → line
```

---

## 36) Remove leading spaces

**Search:**

```regex
^[ \t]+
```

**Replace:**

```text

```

**Example:**

```text
    value → value
```

**Notes:**

Use carefully; indentation matters for readability.

---

## 37) Reverse three underscore-separated parts

**Search:**

```regex
(\w+)_(\w+)_(\w+)
```

**Replace:**

```text
$3_$2_$1
```

**Example:**

```text
tenant_account_group → group_account_tenant
```

---

## 38) Add a prefix to every line

**Search:**

```regex
^(.+)$
```

**Replace:**

```text
- $1
```

**Example:**

```text
Tenant → - Tenant
```

---

## 39) Convert lines to Markdown checkboxes

**Search:**

```regex
^(.+)$
```

**Replace:**

```text
- [ ] $1
```

**Example:**

```text
Tenant → - [ ] Tenant
```

---

## 40) Convert lines to quoted values

**Search:**

```regex
^(.+)$
```

**Replace:**

```text
'$1',
```

**Example:**

```text
tenant → 'tenant',
```

---

## 41) Convert lines to Dart list items

**Search:**

```regex
^(.+)$
```

**Replace:**

```text
  '$1',
```

**Example:**

```text
tenant →   'tenant',
```

---

## 42) Convert key=value to JSON-like syntax

**Search:**

```regex
^(\w+)=(.+)$
```

**Replace:**

```text
"$1": "$2",
```

**Example:**

```text
name=Tenant → "name": "Tenant",
```

---

## 43) Convert key: value to key=value

**Search:**

```regex
^(\w+):\s*(.+)$
```

**Replace:**

```text
$1=$2
```

**Example:**

```text
name: Tenant → name=Tenant
```

---

## 44) Add final

**Search:**

```regex
^(\s*)(\w+\s+\w+\s*=)
```

**Replace:**

```text
$1final $2
```

**Example:**

```text
String name = → final String name =
```

**Notes:**

Approximate pattern; review matches.

---

## 45) Remove final

**Search:**

```regex
\bfinal\s+
```

**Replace:**

```text

```

**Example:**

```text
final value → value
```

---

## 46) Remove const

**Search:**

```regex
\bconst\s+
```

**Replace:**

```text

```

**Example:**

```text
const Widget() → Widget()
```

---

## 47) Add const before a constructor

**Search:**

```regex
\b(TenantEntity)\(
```

**Replace:**

```text
const $1(
```

**Example:**

```text
TenantEntity( → const TenantEntity(
```

---

## 48) Replace a type while preserving nullable ?

**Search:**

```regex
\bTenantView(\?)?
```

**Replace:**

```text
TenantEntity$1
```

**Example:**

```text
TenantView? → TenantEntity?
```

---

## 49) List<View> → List<Entity>

**Search:**

```regex
List<([A-Z]\w*)View>
```

**Replace:**

```text
List<$1Entity>
```

**Example:**

```text
List<TenantView> → List<TenantEntity>
```

---

## 50) Future<View> → Future<Entity>

**Search:**

```regex
Future<([A-Z]\w*)View>
```

**Replace:**

```text
Future<$1Entity>
```

**Example:**

```text
Future<TenantView> → Future<TenantEntity>
```

---

## 51) Generic <View> → <Entity>

**Search:**

```regex
<([A-Z]\w*)View>
```

**Replace:**

```text
<$1Entity>
```

**Example:**

```text
<TenantView> → <TenantEntity>
```

---

## 52) Rename a parameter

**Search:**

```regex
\btenantView\b
```

**Replace:**

```text
tenantEntity
```

**Example:**

```text
tenantView → tenantEntity
```

---

## 53) Rename PascalCase and camelCase separately

**Search:**

```regex
\bTenantView\b
```

**Replace:**

```text
TenantEntity
```

**Example:**

```text
TenantView → TenantEntity
```

**Notes:**

Use a second replacement for tenantView → tenantEntity.

---

## 54) Lowercase the first letter

**Search:**

```regex
\b([A-Z])(\w*)\b
```

**Replace:**

```text
\l$1$2
```

**Example:**

```text
TenantAccount → tenantAccount
```

---

## 55) Uppercase the first letter

**Search:**

```regex
\b([a-z])(\w*)\b
```

**Replace:**

```text
\u$1$2
```

**Example:**

```text
tenantAccount → TenantAccount
```

---

## 56) Convert a capture to UPPERCASE

**Search:**

```regex
\b(\w+)\b
```

**Replace:**

```text
\U$1
```

**Example:**

```text
tenant → TENANT
```

---

## 57) Convert a capture to lowercase

**Search:**

```regex
\b(\w+)\b
```

**Replace:**

```text
\L$1
```

**Example:**

```text
TENANT → tenant
```

---

## 58) Uppercase only the first character

**Search:**

```regex
\b([a-z])(\w*)\b
```

**Replace:**

```text
\u$1$2
```

**Example:**

```text
tenant → Tenant
```

---

## 59) Lowercase only the first character

**Search:**

```regex
\b([A-Z])(\w*)\b
```

**Replace:**

```text
\l$1$2
```

**Example:**

```text
Tenant → tenant
```

---

## 60) Two-part snake_case → PascalCase

**Search:**

```regex
\b([a-z]+)_([a-z]+)\b
```

**Replace:**

```text
\u$1\u$2
```

**Example:**

```text
tenant_account → TenantAccount
```

---

## 61) Two-part snake_case → camelCase

**Search:**

```regex
\b([a-z]+)_([a-z]+)\b
```

**Replace:**

```text
$1\u$2
```

**Example:**

```text
tenant_account → tenantAccount
```

---

## 62) Replace an old import path with a new one

**Search:**

```regex
import 'package:app/features/tenant_account/(.*)';
```

**Replace:**

```text
import 'package:app/modules/features/tenant_account/$1';
```

**Example:**

```text
features/... → modules/features/...
```

---

## 63) Move /features/ to /modules/features/ in imports

**Search:**

```regex
(package:[^'\"]+)/features/
```

**Replace:**

```text
$1/modules/features/
```

**Example:**

```text
package:app/features/... → package:app/modules/features/...
```

---

## 64) Replace /infrastructure/ with /data/

**Search:**

```regex
/infrastructure/
```

**Replace:**

```text
/data/
```

**Example:**

```text
infrastructure → data
```

---

## 65) Replace a path segment while preserving feature and tail

**Search:**

```regex
lib/features/([^/]+)/infrastructure/(.*)
```

**Replace:**

```text
lib/features/$1/data/$2
```

**Example:**

```text
lib/features/x/infrastructure/a.dart → lib/features/x/data/a.dart
```

---

## 66) Rename a file inside an import

**Search:**

```regex
presentation\.dart
```

**Replace:**

```text
index.dart
```

**Example:**

```text
presentation.dart → index.dart
```

---

## 67) Delete a full response.dart import

**Search:**

```regex
^\s*import\s+['\"][^'\"]*response\.dart['\"];\s*\r?\n?
```

**Replace:**

```text

```

**Example:**

```text
import '...response.dart'; → deleted
```

---

## 68) Delete a specific part of directive

**Search:**

```regex
^\s*part\s+of\s+['\"]domain\.dart['\"];\s*\r?\n?
```

**Replace:**

```text

```

**Example:**

```text
part of 'domain.dart'; → deleted
```

---

## 69) Replace part of application.dart with domain.dart

**Search:**

```regex
part of ['\"]([^'\"]*)application\.dart['\"];
```

**Replace:**

```text
part of '$1domain.dart';
```

**Example:**

```text
application.dart → domain.dart
```

---

## 70) Rename RepositoryImpl

**Search:**

```regex
\b([A-Z]\w*)RepositoryImpl\b
```

**Replace:**

```text
$1Repository
```

**Example:**

```text
AuthRepositoryImpl → AuthRepository
```

---

## 71) Add a UseCase suffix

**Search:**

```regex
\bclass\s+([A-Z]\w*)(?<!UseCase)\b
```

**Replace:**

```text
class $1UseCase
```

**Example:**

```text
class GetTenant → class GetTenantUseCase
```

**Notes:**

Broad pattern; restrict the file scope.

---

## 72) Add UseCase inside usecase folders

**Search:**

```regex
\bclass\s+([A-Z]\w+)\b
```

**Replace:**

```text
class $1UseCase
```

**Example:**

```text
class GetTenant → class GetTenantUseCase
```

**Notes:**

Files to Include: lib/**/domain/usecases/**/*.dart; avoid existing UseCase names.

---

## 73) Remove Response from a variable

**Search:**

```regex
\b(\w+)Response\b
```

**Replace:**

```text
$1
```

**Example:**

```text
signInResponse → signIn
```

---

## 74) response → entity in camelCase

**Search:**

```regex
\b(\w+)Response\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
signInResponse → signInEntity
```

---

## 75) View → Entity for PascalCase/camelCase identifiers

**Search:**

```regex
\b(\w+)View\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
getTenantView → getTenantEntity
```

**Notes:**

Broad pattern; use carefully.

---

## 76) Replace a standalone word only

**Search:**

```regex
\bView\b
```

**Replace:**

```text
Entity
```

**Example:**

```text
View → Entity
```

**Notes:**

Does not change TenantView.

---

## 77) Replace a suffix inside identifiers

**Search:**

```regex
View\b
```

**Replace:**

```text
Entity
```

**Example:**

```text
TenantView → TenantEntity
```

**Notes:**

Also changes tenantView and getTenantView.

---

## 78) Replace a prefix inside identifiers

**Search:**

```regex
\bget
```

**Replace:**

```text
fetch
```

**Example:**

```text
getTenant → fetchTenant
```

---

## 79) Insert a word after a prefix

**Search:**

```regex
\bget([A-Z])
```

**Replace:**

```text
getCurrent$1
```

**Example:**

```text
getTenant → getCurrentTenant
```

---

## 80) Insert text between two parts

**Search:**

```regex
\bTenant(View)\b
```

**Replace:**

```text
TenantAccount$1
```

**Example:**

```text
TenantView → TenantAccountView
```

---

## 81) Remove a middle word

**Search:**

```regex
\bTenantAccount(View|Entity)\b
```

**Replace:**

```text
Tenant$1
```

**Example:**

```text
TenantAccountEntity → TenantEntity
```

---

## 82) Replace multiple suffixes with Entity

**Search:**

```regex
\b([A-Z]\w*)(?:View|Response|DTO|Dto|Model)\b
```

**Replace:**

```text
$1Entity
```

**Example:**

```text
UserResponse → UserEntity
```

---

## 83) Add required

**Search:**

```regex
^(\s*)(this\.\w+,)$
```

**Replace:**

```text
$1required $2
```

**Example:**

```text
this.name, → required this.name,
```

**Notes:**

Use only inside constructor parameters.

---

## 84) Remove required

**Search:**

```regex
\brequired\s+
```

**Replace:**

```text

```

**Example:**

```text
required this.name → this.name
```

---

## 85) Convert parameter to required this.x

**Search:**

```regex
^(\s*)this\.(\w+),$
```

**Replace:**

```text
$1required this.$2,
```

**Example:**

```text
this.name, → required this.name,
```

---

## 86) Add nullable ?

**Search:**

```regex
\b(TenantEntity)\b
```

**Replace:**

```text
$1?
```

**Example:**

```text
TenantEntity → TenantEntity?
```

---

## 87) Remove nullable ?

**Search:**

```regex
\b(TenantEntity)\?
```

**Replace:**

```text
$1
```

**Example:**

```text
TenantEntity? → TenantEntity
```

---

## 88) Convert nullable type to non-nullable

**Search:**

```regex
\b([A-Z]\w*)\?
```

**Replace:**

```text
$1
```

**Example:**

```text
String? → String
```

**Notes:**

Broad pattern; scope it carefully.

---

## 89) Wrap a type in List<>

**Search:**

```regex
\b(TenantEntity)\b
```

**Replace:**

```text
List<$1>
```

**Example:**

```text
TenantEntity → List<TenantEntity>
```

---

## 90) Remove a List<> wrapper

**Search:**

```regex
List<([^>]+)>
```

**Replace:**

```text
$1
```

**Example:**

```text
List<TenantEntity> → TenantEntity
```

---

## 91) Future<T> → T

**Search:**

```regex
Future<([^>]+)>
```

**Replace:**

```text
$1
```

**Example:**

```text
Future<TenantEntity> → TenantEntity
```

**Notes:**

Nested generics may need a more specific pattern.

---

## 92) T → Future<T>

**Search:**

```regex
\b(TenantEntity)\b
```

**Replace:**

```text
Future<$1>
```

**Example:**

```text
TenantEntity → Future<TenantEntity>
```

---

## 93) Add await

**Search:**

```regex
^(\s*)(repository\.\w+\()
```

**Replace:**

```text
$1await $2
```

**Example:**

```text
repository.get( → await repository.get(
```

**Notes:**

Review matches manually.

---

## 94) Remove await

**Search:**

```regex
\bawait\s+
```

**Replace:**

```text

```

**Example:**

```text
await repository.get() → repository.get()
```

---

## 95) Add return

**Search:**

```regex
^(\s*)(repository\.\w+\(.*\);)$
```

**Replace:**

```text
$1return $2
```

**Example:**

```text
repository.get(); → return repository.get();
```

---

## 96) Remove return

**Search:**

```regex
\breturn\s+
```

**Replace:**

```text

```

**Example:**

```text
return value → value
```

---

## 97) Add const to selected constructors

**Search:**

```regex
\b(SizedBox|EdgeInsets|Duration)\(
```

**Replace:**

```text
const $1(
```

**Example:**

```text
SizedBox( → const SizedBox(
```

**Notes:**

May create duplicate const.

---

## 98) Avoid constructors already preceded by const

**Search:**

```regex
(?<!const\s)\b(SizedBox|Duration)\(
```

**Replace:**

```text
const $1(
```

**Example:**

```text
SizedBox( → const SizedBox(
```

**Notes:**

Depends on lookbehind support.

---

## 99) Reorder positional function parameters

**Search:**

```regex
foo\(([^,]+),\s*([^)]+)\)
```

**Replace:**

```text
foo($2, $1)
```

**Example:**

```text
foo(name, id) → foo(id, name)
```

---

## 100) Reorder named constructor parameters

**Search:**

```regex
Tenant\(name:\s*([^,]+),\s*id:\s*([^)]+)\)
```

**Replace:**

```text
Tenant(id: $2, name: $1)
```

**Example:**

```text
Tenant(name: name, id: id) → Tenant(id: id, name: name)
```

---

## 101) Split camelCase into words

**Search:**

```regex
([a-z])([A-Z])
```

**Replace:**

```text
$1 $2
```

**Example:**

```text
tenantAccountGroup → tenant Account Group
```

---

## 102) Split PascalCase/camelCase boundaries

**Search:**

```regex
([a-z0-9])([A-Z])
```

**Replace:**

```text
$1 $2
```

**Example:**

```text
TenantAccount → Tenant Account
```

---

## 103) Replace spaces with underscores

**Search:**

```regex
\s+
```

**Replace:**

```text
_
```

**Example:**

```text
tenant account group → tenant_account_group
```

---

## 104) Replace underscores with spaces

**Search:**

```regex
_
```

**Replace:**

```text
 
```

**Example:**

```text
tenant_account → tenant account
```

---

## 105) Replace dashes with underscores

**Search:**

```regex
-
```

**Replace:**

```text
_
```

**Example:**

```text
tenant-account → tenant_account
```

---

## 106) Replace underscores with dashes

**Search:**

```regex
_
```

**Replace:**

```text
-
```

**Example:**

```text
tenant_account → tenant-account
```

---

## 107) Remove a numeric suffix

**Search:**

```regex
\b(\w+)\d+\b
```

**Replace:**

```text
$1
```

**Example:**

```text
TenantView2 → TenantView
```

---

## 108) Add a version suffix

**Search:**

```regex
\b(TenantView)\b
```

**Replace:**

```text
$1V2
```

**Example:**

```text
TenantView → TenantViewV2
```

---

## 109) Remove simple parentheses

**Search:**

```regex
\(([^()]+)\)
```

**Replace:**

```text
$1
```

**Example:**

```text
(TenantEntity) → TenantEntity
```

**Notes:**

Does not handle nested parentheses.

---

## 110) Add this.

**Search:**

```regex
\b(value)\b
```

**Replace:**

```text
this.$1
```

**Example:**

```text
value → this.value
```

---

## 111) Remove this.

**Search:**

```regex
\bthis\.(\w+)
```

**Replace:**

```text
$1
```

**Example:**

```text
this.value → value
```

---

## 112) Map<String, dynamic> → custom typedef

**Search:**

```regex
\bMap<String,\s*dynamic>\b
```

**Replace:**

```text
JsonMap
```

**Example:**

```text
Map<String, dynamic> → JsonMap
```

---

## 113) dynamic → Object?

**Search:**

```regex
\bdynamic\b
```

**Replace:**

```text
Object?
```

**Example:**

```text
dynamic value → Object? value
```

**Notes:**

Review semantics before Replace All.

---

## 114) print → debugPrint

**Search:**

```regex
\bprint\s*\(
```

**Replace:**

```text
debugPrint(
```

**Example:**

```text
print(value) → debugPrint(value)
```

---

## 115) debugPrint → logger

**Search:**

```regex
\bdebugPrint\s*\((.*)\);
```

**Replace:**

```text
logger.debug($1);
```

**Example:**

```text
debugPrint(value); → logger.debug(value);
```

**Notes:**

Nested/multiline expressions may need a stricter pattern.

---

## 116) Insert a comment before each match

**Search:**

```regex
^(\s*)(class\s+\w+View.*)$
```

**Replace:**

```text
$1// TODO: migrate View to Entity\n$1$2
```

**Example:**

```text
class TenantView → comment + class
```

**Notes:**

Insert an actual line break in Replace if needed.

---

## 117) Insert a blank line after each match

**Search:**

```regex
^(.*TODO.*)$
```

**Replace:**

```text
$1\n
```

**Example:**

```text
TODO line → TODO line + blank line
```

---

## 118) import → export

**Search:**

```regex
^\s*import\s+(['\"][^'\"]+['\"]);\s*$
```

**Replace:**

```text
export $1;
```

**Example:**

```text
import 'a.dart'; → export 'a.dart';
```

---

## 119) export → import

**Search:**

```regex
^\s*export\s+(['\"][^'\"]+['\"]);\s*$
```

**Replace:**

```text
import $1;
```

**Example:**

```text
export 'a.dart'; → import 'a.dart';
```

---

## 120) Change quotes in imports only

**Search:**

```regex
import\s+"([^"]+)";
```

**Replace:**

```text
import '$1';
```

**Example:**

```text
import "a.dart"; → import 'a.dart';
```

---

## 121) Remove .dart from paths

**Search:**

```regex
\.dart\b
```

**Replace:**

```text

```

**Example:**

```text
file.dart → file
```

---

## 122) Add .dart

**Search:**

```regex
\b([\w/]+)(?<!\.dart)\b
```

**Replace:**

```text
$1.dart
```

**Example:**

```text
path/file → path/file.dart
```

**Notes:**

Broad pattern; use on path lists only.

---

## 123) Rename a package

**Search:**

```regex
package:old_app/
```

**Replace:**

```text
package:new_app/
```

**Example:**

```text
package:old_app/... → package:new_app/...
```

---

## 124) Move a feature path while preserving feature and tail

**Search:**

```regex
package:app/features/([^/]+)/(.*)
```

**Replace:**

```text
package:app/modules/features/$1/$2
```

**Example:**

```text
features/x/a.dart → modules/features/x/a.dart
```

---

## 125) Preserve indentation

**Search:**

```regex
^(\s*)oldText
```

**Replace:**

```text
$1newText
```

**Example:**

```text
    oldText →     newText
```

**Notes:**

$1 retains leading whitespace.

---

## 126) Preserve indentation while changing line ending syntax

**Search:**

```regex
^(\s*)(.+);$
```

**Replace:**

```text
$1$2,
```

**Example:**

```text
    final a = 1; →     final a = 1,
```

---

## 127) Wrap matched text in a function

**Search:**

```regex
\b(TenantEntity)\b
```

**Replace:**

```text
wrap($1)
```

**Example:**

```text
TenantEntity → wrap(TenantEntity)
```

---

## 128) Wrap the full matched expression

**Search:**

```regex
repository\.\w+\([^;]*\)
```

**Replace:**

```text
await $&
```

**Example:**

```text
repository.get() → await repository.get()
```

**Notes:**

$& is the full match.

---

## 129) Use named groups to reorder text

**Search:**

```regex
(?<first>\w+)_(?<second>\w+)
```

**Replace:**

```text
$<second>_$<first>
```

**Example:**

```text
tenant_account → account_tenant
```

---

## 130) Safer Replace All for one exact type

**Search:**

```regex
\bTenantProductView\b
```

**Replace:**

```text
TenantProductEntity
```

**Example:**

```text
TenantProductView → TenantProductEntity
```

**Notes:**

Less flexible but safer for large refactors.

---

## 131) Quick Cheat Sheet

**Replace:**

```text
See the Cheat Sheet table
```

**Example:**

```text
Common View/Entity/DTO/import replacements
```

---

## 132) Critical rules before Replace All

**Replace:**

```text
See safety rules
```

**Example:**

```text
Preview, scope, exclude generated files, commit first
```

---

## 133) Practical example matching your current search

**Search:**

```regex
\bget([A-Za-z0-9_]*)View\b
```

**Replace:**

```text
get$1Entity
```

**Example:**

```text
getProductDetailsView → getProductDetailsEntity
```

**Notes:**

Capture the middle part with (...) and reuse it as $1.

---

# Quick Cheat Sheet

| Goal | Search | Replace |
|---|---|---|
| `View → Entity` | `\b([A-Z]\w*)View\b` | `$1Entity` |
| `get...View → get...Entity` | `\bget(\w*)View\b` | `get$1Entity` |
| `Response → Entity` | `\b([A-Z]\w*)Response\b` | `$1Entity` |
| `DTO → Entity` | `\b([A-Z]\w*)(?:Dto\|DTO)\b` | `$1Entity` |
| `Model → Entity` | `\b([A-Z]\w*)Model\b` | `$1Entity` |
| Remove `View` | `\b(\w+)View\b` | `$1` |
| Remove `Super` | `\bSuper(\w+)\b` | `$1` |
| Swap two parts | `(\w+)_(\w+)` | `$2_$1` |
| Preserve the full match | `Tenant` | `Super$&` |
| Literal `$` | `value` | `$$value` |
| Uppercase first letter | `\b([a-z])(\w*)\b` | `\u$1$2` |
| Lowercase first letter | `\b([A-Z])(\w*)\b` | `\l$1$2` |
| Uppercase capture | `\b(\w+)\b` | `\U$1` |
| Lowercase capture | `\b(\w+)\b` | `\L$1` |
| Remove trailing spaces | `[ \t]+$` | *(empty)* |
| Collapse spaces | `[ \t]{2,}` | one space |
| Add a prefix to every line | `^(.+)$` | `- $1` |
| Quote every line | `^(.+)$` | `'$1',` |
| import → export | `^\s*import\s+(['"][^'"]+['"]);\s*$` | `export $1;` |
| Remove `this.` | `\bthis\.(\w+)` | `$1` |
| print → debugPrint | `\bprint\s*\(` | `debugPrint(` |

# Recommended Workflow

1. Run Search first and inspect all matches.
2. Review the replacement preview.
3. Restrict the operation with **Files to Include**.
4. Exclude generated code.
5. Use word boundaries (`\b`) for identifier-level replacements.
6. Prefer capture groups when preserving parts of the original text.
7. Create a Git commit before a large refactor.
8. After changes, run:

```bash
dart format .
```

Then:

```bash
dart analyze
```

or:

```bash
flutter analyze
```
