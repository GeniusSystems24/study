# VS Code Search & Regex Dictionary

A practical reference for searching in Visual Studio Code using plain text, Regular Expressions, file globs, Dart/Flutter patterns, and Clean Architecture checks.

> This README starts with a **quick table reference**, followed by the **full detailed guide**.

---

## Contents

- [Quick Table Reference](#quick-table-reference)
- [Detailed Reference](#detailed-reference)

---

## Quick Table Reference

A quick-reference English dictionary for **Visual Studio Code search, Regular Expressions, Replace, Dart/Flutter refactoring, Glob patterns, and Clean Architecture checks**.

> Enable **Use Regular Expression `.*`** when using Regex.  
> Patterns under **Files to Include / Files to Exclude** are **Glob patterns**, not Regex.

| Category | Goal | Search / Pattern | Example | Notes |
|---|---|---|---|---|
| VS Code | Match case | `Aa` | `TenantView` differs from `tenantView` | Enable Match Case |
| VS Code | Match whole word | `ab` | `View` does not match `TenantView` | Enable Match Whole Word |
| VS Code | Enable Regex | `.*` | Use `\bget\w*View\b` | Enable Use Regular Expression |
| Regex Basics | Any single character | `.` | `get.View` → `getAView` | Matches exactly one character |
| Regex Basics | Any number of characters | `.*` | `get.*View` | Zero or more characters |
| Regex Basics | One or more characters | `.+` | `get.+View` | Does not match `getView` |
| Regex Basics | Zero or one character | `.?` | `get.?View` | Matches `getView` and `getAView` |
| Regex Basics | Word boundary | `\b` | `\bView\b` | Prevents partial-name matches |
| Regex Basics | Start of line | `^` | `^import` | Matches the beginning of a line |
| Regex Basics | End of line | `$` | `;$` | Matches the end of a line |
| Regex Basics | Whitespace | `\s` | `^\s*import` | Space, tab, or line break depending on context |
| Regex Basics | Non-whitespace | `\S` | `\S+` | Any non-whitespace character |
| Regex Basics | Digit | `\d` | `id\d+` | Usually equivalent to `[0-9]` |
| Regex Basics | Non-digit | `\D` | `\D+` | Any character that is not a digit |
| Regex Basics | Word character | `\w` | `get\w*View` | Useful for identifiers |
| Regex Basics | Non-word character | `\W` | `\W+` | Opposite of `\w` |
| Character Sets | Character set | `[abc]` | `[A-Z]` | Matches one character from the set |
| Character Sets | Character range | `[a-z]` | `[A-Za-z0-9_]` | Useful for identifiers |
| Character Sets | Negated character set | `[^0-9]` | `[^A-Za-z]` | Matches a character not in the set |
| Groups | OR / alternation | `A\|B` | `Entity\|View` | Matches either option |
| Groups | Capture group | `(...)` | `get(\w+)View` | Use `$1` in Replace |
| Groups | Non-capturing group | `(?:...)` | `(?:View\|Response)` | Groups without capturing |
| Quantifiers | Zero or more | `*` | `a*` | Can match zero occurrences |
| Quantifiers | One or more | `+` | `a+` | Requires at least one occurrence |
| Quantifiers | Zero or one | `?` | `a?` | Optional |
| Quantifiers | Exact count | `{n}` | `\d{4}` | Example: exactly 4 digits |
| Quantifiers | Minimum count | `{n,}` | `\d{3,}` | 3 or more |
| Quantifiers | Range | `{n,m}` | `\d{2,5}` | Between 2 and 5 |
| Escaping | Literal dot | `\.` | `file\.dart` | `.` has a special Regex meaning |
| Escaping | Literal opening parenthesis | `\(` | `method\(` | Search for `(` |
| Escaping | Literal closing parenthesis | `\)` | `\)` | Search for `)` |
| Escaping | Literal square brackets | `\[` / `\]` | `\[\w+\]` | Search for the brackets themselves |
| Escaping | Literal dollar sign | `\$` | `\$value` | Search for `$` literally |
| Identifiers | Starts with get and ends with View | `\bget\w*View\b` | `getTenantView` | Also matches `getView` |
| Identifiers | get...View with content in between | `\bget\w+View\b` | `getTenantView` | Does not match `getView` |
| Identifiers | get + PascalCase + View | `\bget[A-Z][A-Za-z0-9]*View\b` | `getTenantAccountView` | More restrictive |
| Identifiers | Names starting with Super | `\bSuper\w+\b` | `SuperTextTheme` |  |
| Identifiers | Super...View names | `\bSuper\w*View\b` | `SuperConfirmView` |  |
| Identifiers | Tenant...Entity names | `\bTenant\w*Entity\b` | `TenantAccountEntity` |  |
| Identifiers | Tenant...View names | `\bTenant\w*View\b` | `TenantProductView` |  |
| Identifiers | Dart identifier | `[A-Za-z_$][A-Za-z0-9_$]*` | `tenant_$value` | General identifier pattern |
| Dart Classes | Any class | `^\s*class\s+\w+` | `class TenantAccount` |  |
| Dart Classes | Class ending in View | `^\s*class\s+\w+View\b` | `class TenantView` |  |
| Dart Classes | Class ending in Entity | `^\s*class\s+\w+Entity\b` | `class TenantEntity` |  |
| Dart Classes | Class ending in Response | `^\s*class\s+\w+Response\b` | `class SignInResponse` |  |
| Dart Classes | Class ending in DTO | `^\s*class\s+\w+(Dto\|DTO)\b` | `class UserDto` |  |
| Dart Classes | Class ending in UseCase | `^\s*class\s+\w+UseCase\b` | `class GetTenantUseCase` |  |
| Dart Classes | Abstract repository | `^\s*abstract\s+class\s+\w+Repository\b` | `abstract class AuthRepository` |  |
| Dart Classes | Repository implementation | `\bclass\s+\w+RepositoryImpl\b` | `class AuthRepositoryImpl` |  |
| Dart Methods | Methods starting with get | `\bget\w*\s*\(` | `getTenant(` |  |
| Dart Methods | Methods starting with create | `\bcreate\w*\s*\(` | `createTenant(` |  |
| Dart Methods | Methods starting with update | `\bupdate\w*\s*\(` | `updateTenant(` |  |
| Dart Methods | Methods starting with delete | `\bdelete\w*\s*\(` | `deleteTenant(` |  |
| Dart Methods | Dart getter | `\bget\s+\w+` | `get textTheme` |  |
| Dart Methods | Function name ending in View | `\b\w+View\s*\(` | `buildDetailsView(` |  |
| Dart Types | Any View type | `\b[A-Z]\w*View\b` | `TenantAccountView` |  |
| Dart Types | Any Entity type | `\b[A-Z]\w*Entity\b` | `TenantAccountEntity` |  |
| Dart Types | Any Response type | `\b[A-Z]\w*Response\b` | `SignInResponse` |  |
| Dart Types | Any Model type | `\b[A-Z]\w*Model\b` | `TenantModel` |  |
| Dart Types | View or Response | `\b[A-Z]\w*(?:View\|Response)\b` | `TenantView` / `TenantResponse` |  |
| Dart Types | View, Response, or DTO | `\b[A-Z]\w*(?:View\|Response\|Dto\|DTO)\b` | `UserDTO` |  |
| Dart Types | Nullable type | `\b[A-Z]\w*\?` | `String?` |  |
| Dart Types | Nullable TextTheme | `\bTextTheme\?` | `TextTheme? textTheme` |  |
| Dart Types | Future<T> | `\bFuture<[^>]+>` | `Future<TenantEntity>` | Nested generics may require a more specific pattern |
| Dart Types | Future<void> | `\bFuture<void>\b` | `Future<void>` |  |
| Dart Types | List<T> | `\bList<[^>]+>` | `List<TenantEntity>` |  |
| Dart Types | Map<K,V> | `\bMap<[^>]+>` | `Map<String, dynamic>` |  |
| Dart Types | Map<String, dynamic> | `\bMap<String,\s*dynamic>\b` | `Map<String, dynamic>` |  |
| Dart Types | dynamic | `\bdynamic\b` | `dynamic value` |  |
| Dart Fields | required this.x | `\brequired\s+this\.\w+` | `required this.textTheme` |  |
| Dart Fields | this.x | `\bthis\.\w+` | `this.value` |  |
| Dart Fields | final | `^\s*final\s+` | `final value = 1;` |  |
| Dart Fields | static | `^\s*static\s+` | `static value` |  |
| Dart Fields | static final | `^\s*static\s+final\s+` | `static final value` |  |
| Dart Fields | static const | `^\s*static\s+const\s+` | `static const value` |  |
| Dart Imports | All imports | `^\s*import\s+['"].+['"];\s*$` | `import 'a.dart';` |  |
| Dart Imports | Imports containing tenant_account | `^\s*import\s+['"][^'"]*tenant_account[^'"]*['"];\s*$` | `.../tenant_account/...` |  |
| Dart Imports | Presentation imports | `import\s+['"][^'"]*/presentation/[^'"]*['"]` | `.../presentation/...` |  |
| Dart Imports | Data imports | `import\s+['"][^'"]*/data/[^'"]*['"]` | `.../data/...` |  |
| Dart Imports | Domain imports | `import\s+['"][^'"]*/domain/[^'"]*['"]` | `.../domain/...` |  |
| Dart Imports | Import ending in _view.dart | `import\s+['"][^'"]*_view\.dart['"];` | `import 'tenant_view.dart';` |  |
| Dart Imports | Import ending in response.dart | `import\s+['"][^'"]*response\.dart['"];` | `import 'response.dart';` |  |
| Dart Imports | Imports under /models/ | `import\s+['"][^'"]*/models/[^'"]*['"]` | `.../models/...` |  |
| Dart Parts | Any part directive | `^\s*part\s+['"][^'"]+['"];\s*$` | `part 'entity.dart';` |  |
| Dart Parts | Any part of directive | `^\s*part\s+of\s+.+;\s*$` | `part of 'domain.dart';` |  |
| Dart Parts | Import appearing after part (approx.) | `part[^;]*;[\s\S]*?\n\s*import\s+` | Flags suspicious ordering | Review results manually |
| Refactoring | View → Entity | `\b([A-Z]\w*)View\b` | Replace: `$1Entity` | Review Preview before Replace All |
| Refactoring | get...View → get...Entity | `\bget(\w*)View\b` | Replace: `get$1Entity` |  |
| Refactoring | Remove View suffix | `\b(\w+)View\b` | Replace: `$1` |  |
| Refactoring | Add Entity suffix to a specific name | `\b(TenantAccount)\b` | Replace: `$1Entity` |  |
| Refactoring | ViewTenant → TenantView | `\bView(\w+)\b` | Replace: `$1View` |  |
| Clean Architecture | Presentation depends on Data | `import\s+['"][^'"]*/data/` | Include: `lib/**/presentation/**/*.dart` | Usually a dependency violation |
| Clean Architecture | Presentation depends on Infrastructure | `import\s+['"][^'"]*/infrastructure/` | Include: `lib/**/presentation/**/*.dart` |  |
| Clean Architecture | Domain depends on Data | `import\s+['"][^'"]*/data/` | Include: `lib/**/domain/**/*.dart` |  |
| Clean Architecture | Domain depends on Presentation | `import\s+['"][^'"]*/presentation/` | Include: `lib/**/domain/**/*.dart` |  |
| Clean Architecture | DTO/Response inside Presentation | `\b\w+(?:Response\|Dto\|DTO)\b` | Include: `lib/**/presentation/**/*.dart` |  |
| Comments | TODO | `\bTODO\b` | `// TODO:` |  |
| Comments | TODO or FIXME | `\b(?:TODO\|FIXME)\b` | `// FIXME:` |  |
| Comments | Single-line comment | `^\s*//.*` | `// comment` |  |
| Comments | Blank line | `^\s*$` | Blank line |  |
| Comments | 3 or more blank lines | `(\r?\n\s*){3,}` | Replace with fewer line breaks |  |
| Strings | Single-quoted string | `'[^']*'` | `'hello'` |  |
| Strings | Double-quoted string | `"[^"]*"` | `"hello"` |  |
| Strings | Hard-coded URL | `https?://[^\s'"]+` | `https://example.com` |  |
| Line Endings | Windows/Linux newline | `\r?\n` | Windows `\r\n` or Linux `\n` |  |
| Multiline | Multiline matching | `class\s+\w+[\s\S]*?extends\s+StatelessWidget` | Class through `extends` | Use carefully |
| Multiline | Greedy match | `".*"` | `"a" "b"` may match everything | Largest possible match |
| Multiline | Lazy match | `".*?"` | `"a"` then `"b"` | Smallest possible match |
| Lookaround | Positive lookahead | `Tenant(?=View)` | `TenantView` → matches Tenant |  |
| Lookaround | Negative lookahead | `Tenant(?!View)` | `TenantEntity` |  |
| Lookaround | Positive lookbehind | `(?<=Tenant)View` | `TenantView` → matches View |  |
| Lookaround | Negative lookbehind | `(?<!Tenant)View` | `ProductView` | Support can vary by Regex engine/context |
| Miscellaneous | Annotation | `@\w+` | `@override` |  |
| Miscellaneous | override annotation | `^\s*@override` | `@override` |  |
| Miscellaneous | if statement | `\bif\s*\(` | `if (` |  |
| Miscellaneous | switch statement | `\bswitch\s*\(` | `switch (` |  |
| Miscellaneous | try block | `\btry\s*\{` | `try {` |  |
| Miscellaneous | catch block | `\bcatch\s*\(` | `catch (` |  |
| Miscellaneous | throw | `\bthrow\s+` | `throw Exception()` |  |
| Miscellaneous | print | `\bprint\s*\(` | `print(value)` |  |
| Miscellaneous | debugPrint | `\bdebugPrint\s*\(` | `debugPrint(value)` |  |
| Miscellaneous | == null | `==\s*null` | `value == null` |  |
| Miscellaneous | != null | `!=\s*null` | `value != null` |  |
| Miscellaneous | Cast using as | `\s+as\s+\w+` | `value as TenantEntity` |  |
| Miscellaneous | Null assertion (approx.) | `\w+!(?![=])` | `value!` | Avoids `!=` |
| Miscellaneous | Deprecated annotation | `@deprecated\|@Deprecated` | `@Deprecated()` |  |
| Data Formats | IPv4-shaped address | `\b(?:\d{1,3}\.){3}\d{1,3}\b` | `192.168.1.1` | Does not validate each octet as 0..255 |
| Data Formats | UUID | `\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\b` | `550e8400-e29b-41d4-a716-446655440000` |  |
| Data Formats | Line containing only digits | `^\s*\d+\s*$` | `12345` |  |
| Data Formats | Repeated words | `\b(\w+)\s+\1\b` | `value value` | Depends on backreference support |
| Files to Include | All Dart files | `**/*.dart` | All Dart files | Glob, not Regex |
| Files to Include | Dart files under lib | `lib/**/*.dart` | All Dart files under `lib` |  |
| Files to Include | Presentation files | `lib/**/presentation/**/*.dart` | All presentation files |  |
| Files to Include | Domain files | `lib/**/domain/**/*.dart` | All domain files |  |
| Files to Include | Data files | `lib/**/data/**/*.dart` | All data files |  |
| Files to Include | Use cases | `lib/**/domain/usecases/**/*.dart` | All use cases |  |
| Files to Include | Entities | `lib/**/domain/entities/**/*.dart` | All entities |  |
| Files to Include | Tests | `test/**/*.dart` | All tests |  |
| Files to Include | Multiple extensions | `**/*.{dart,yaml,json}` | Dart/YAML/JSON |  |
| Files to Exclude | Generated .g.dart files | `**/*.g.dart` | Exclude generated code |  |
| Files to Exclude | Freezed files | `**/*.freezed.dart` | Exclude Freezed output |  |
| Files to Exclude | Drift generated files | `**/*.drift.dart` | Exclude Drift output |  |
| Files to Exclude | build directory | `**/build/**` | Exclude build output |  |
| Files to Exclude | Common generated files | `**/*.g.dart,**/*.freezed.dart,**/*.drift.dart,**/generated/**` | Exclude multiple generated patterns |  |
| Glob | Single path level | `*` | `lib/*.dart` | Does not cross directories |
| Glob | Any number of directories | `**` | `lib/**/*.dart` |  |
| Glob | Single character | `?` | `file?.dart` |  |
| Glob | Extension alternatives | `{a,b}` | `**/*.{dart,json}` |  |

---

## Common Replace Recipes

| Operation | Search | Replace | Before | After |
|---|---|---|---|---|
| `View → Entity` | `\b([A-Z]\w*)View\b` | `$1Entity` | `TenantAccountView` | `TenantAccountEntity` |
| `get...View → get...Entity` | `\bget(\w*)View\b` | `get$1Entity` | `getTenantView` | `getTenantEntity` |
| Remove `View` suffix | `\b(\w+)View\b` | `$1` | `TenantView` | `Tenant` |
| Add `Entity` suffix | `\b(TenantAccount)\b` | `$1Entity` | `TenantAccount` | `TenantAccountEntity` |
| Reorder `ViewTenant` | `\bView(\w+)\b` | `$1View` | `ViewTenant` | `TenantView` |

## Most-Used Patterns

| Goal | Regex |
|---|---|
| Starts with `get` and ends with `View` | `\bget\w*View\b` |
| Same, but requires content between them | `\bget\w+View\b` |
| Any class ending with `View` | `^\s*class\s+\w+View\b` |
| Any type ending with `View` | `\b[A-Z]\w*View\b` |
| Any type ending with `Entity` | `\b[A-Z]\w*Entity\b` |
| Any `Response` type | `\b[A-Z]\w*Response\b` |
| `View`, `Response`, or `DTO` | `\b[A-Z]\w*(?:View|Response|Dto|DTO)\b` |
| Any import | `^\s*import\s+.+;\s*$` |
| Any `part of` | `^\s*part\s+of\s+.+;\s*$` |
| Blank line | `^\s*$` |
| `TODO` or `FIXME` | `\b(?:TODO|FIXME)\b` |
| Dart identifier | `[A-Za-z_$][A-Za-z0-9_$]*` |

## Before Using Replace All

| # | Rule |
|---:|---|
| 1 | Run Search first and inspect all matches. |
| 2 | Restrict the scope with **Files to Include**. |
| 3 | Exclude generated files such as `*.g.dart`, `*.freezed.dart`, and `*.drift.dart`. |
| 4 | Use `\b` when you need whole-identifier matching. |
| 5 | Prefer capture groups such as `(...)` and replacements like `$1`, `$2`. |
| 6 | Create a Git commit before a large refactor. |
| 7 | After changes, run `dart format .` and then `dart analyze` or `flutter analyze`. |

---

## Detailed Reference

A practical English reference for **Visual Studio Code search and replace**, including Regex, Dart/Flutter patterns, refactoring recipes, file globs, and Clean Architecture checks.

> When using Regex, enable **Use Regular Expression `.*`** in the VS Code Search panel.

## VS Code Search Modes

| Option | Icon | Purpose |
|---|---:|---|
| Match Case | `Aa` | Match uppercase/lowercase exactly |
| Match Whole Word | `ab` | Match complete words only |
| Use Regular Expression | `.*` | Interpret the search query as Regex |

---

## 1. Match case

**Category:** VS Code

**Pattern:**

`Aa`

**Example:**

`TenantView` differs from `tenantView`

**Notes:**

Enable Match Case

---

## 2. Match whole word

**Category:** VS Code

**Pattern:**

`ab`

**Example:**

`View` does not match `TenantView`

**Notes:**

Enable Match Whole Word

---

## 3. Enable Regex

**Category:** VS Code

**Pattern:**

`.*`

**Example:**

Use `\bget\w*View\b`

**Notes:**

Enable Use Regular Expression

---

## 4. Any single character

**Category:** Regex Basics

**Pattern:**

`.`

**Example:**

`get.View` → `getAView`

**Notes:**

Matches exactly one character

---

## 5. Any number of characters

**Category:** Regex Basics

**Pattern:**

`.*`

**Example:**

`get.*View`

**Notes:**

Zero or more characters

---

## 6. One or more characters

**Category:** Regex Basics

**Pattern:**

`.+`

**Example:**

`get.+View`

**Notes:**

Does not match `getView`

---

## 7. Zero or one character

**Category:** Regex Basics

**Pattern:**

`.?`

**Example:**

`get.?View`

**Notes:**

Matches `getView` and `getAView`

---

## 8. Word boundary

**Category:** Regex Basics

**Pattern:**

`\b`

**Example:**

`\bView\b`

**Notes:**

Prevents partial-name matches

---

## 9. Start of line

**Category:** Regex Basics

**Pattern:**

`^`

**Example:**

`^import`

**Notes:**

Matches the beginning of a line

---

## 10. End of line

**Category:** Regex Basics

**Pattern:**

`$`

**Example:**

`;$`

**Notes:**

Matches the end of a line

---

## 11. Whitespace

**Category:** Regex Basics

**Pattern:**

`\s`

**Example:**

`^\s*import`

**Notes:**

Space, tab, or line break depending on context

---

## 12. Non-whitespace

**Category:** Regex Basics

**Pattern:**

`\S`

**Example:**

`\S+`

**Notes:**

Any non-whitespace character

---

## 13. Digit

**Category:** Regex Basics

**Pattern:**

`\d`

**Example:**

`id\d+`

**Notes:**

Usually equivalent to `[0-9]`

---

## 14. Non-digit

**Category:** Regex Basics

**Pattern:**

`\D`

**Example:**

`\D+`

**Notes:**

Any character that is not a digit

---

## 15. Word character

**Category:** Regex Basics

**Pattern:**

`\w`

**Example:**

`get\w*View`

**Notes:**

Useful for identifiers

---

## 16. Non-word character

**Category:** Regex Basics

**Pattern:**

`\W`

**Example:**

`\W+`

**Notes:**

Opposite of `\w`

---

## 17. Character set

**Category:** Character Sets

**Pattern:**

`[abc]`

**Example:**

`[A-Z]`

**Notes:**

Matches one character from the set

---

## 18. Character range

**Category:** Character Sets

**Pattern:**

`[a-z]`

**Example:**

`[A-Za-z0-9_]`

**Notes:**

Useful for identifiers

---

## 19. Negated character set

**Category:** Character Sets

**Pattern:**

`[^0-9]`

**Example:**

`[^A-Za-z]`

**Notes:**

Matches a character not in the set

---

## 20. OR / alternation

**Category:** Groups

**Pattern:**

`A|B`

**Example:**

`Entity|View`

**Notes:**

Matches either option

---

## 21. Capture group

**Category:** Groups

**Pattern:**

`(...)`

**Example:**

`get(\w+)View`

**Notes:**

Use `$1` in Replace

---

## 22. Non-capturing group

**Category:** Groups

**Pattern:**

`(?:...)`

**Example:**

`(?:View|Response)`

**Notes:**

Groups without capturing

---

## 23. Zero or more

**Category:** Quantifiers

**Pattern:**

`*`

**Example:**

`a*`

**Notes:**

Can match zero occurrences

---

## 24. One or more

**Category:** Quantifiers

**Pattern:**

`+`

**Example:**

`a+`

**Notes:**

Requires at least one occurrence

---

## 25. Zero or one

**Category:** Quantifiers

**Pattern:**

`?`

**Example:**

`a?`

**Notes:**

Optional

---

## 26. Exact count

**Category:** Quantifiers

**Pattern:**

`{n}`

**Example:**

`\d{4}`

**Notes:**

Example: exactly 4 digits

---

## 27. Minimum count

**Category:** Quantifiers

**Pattern:**

`{n,}`

**Example:**

`\d{3,}`

**Notes:**

3 or more

---

## 28. Range

**Category:** Quantifiers

**Pattern:**

`{n,m}`

**Example:**

`\d{2,5}`

**Notes:**

Between 2 and 5

---

## 29. Literal dot

**Category:** Escaping

**Pattern:**

`\.`

**Example:**

`file\.dart`

**Notes:**

`.` has a special Regex meaning

---

## 30. Literal opening parenthesis

**Category:** Escaping

**Pattern:**

`\(`

**Example:**

`method\(`

**Notes:**

Search for `(`

---

## 31. Literal closing parenthesis

**Category:** Escaping

**Pattern:**

`\)`

**Example:**

`\)`

**Notes:**

Search for `)`

---

## 32. Literal square brackets

**Category:** Escaping

**Pattern:**

`\[` / `\]`

**Example:**

`\[\w+\]`

**Notes:**

Search for the brackets themselves

---

## 33. Literal dollar sign

**Category:** Escaping

**Pattern:**

`\$`

**Example:**

`\$value`

**Notes:**

Search for `$` literally

---

## 34. Starts with get and ends with View

**Category:** Identifiers

**Pattern:**

`\bget\w*View\b`

**Example:**

`getTenantView`

**Notes:**

Also matches `getView`

---

## 35. get...View with content in between

**Category:** Identifiers

**Pattern:**

`\bget\w+View\b`

**Example:**

`getTenantView`

**Notes:**

Does not match `getView`

---

## 36. get + PascalCase + View

**Category:** Identifiers

**Pattern:**

`\bget[A-Z][A-Za-z0-9]*View\b`

**Example:**

`getTenantAccountView`

**Notes:**

More restrictive

---

## 37. Names starting with Super

**Category:** Identifiers

**Pattern:**

`\bSuper\w+\b`

**Example:**

`SuperTextTheme`

---

## 38. Super...View names

**Category:** Identifiers

**Pattern:**

`\bSuper\w*View\b`

**Example:**

`SuperConfirmView`

---

## 39. Tenant...Entity names

**Category:** Identifiers

**Pattern:**

`\bTenant\w*Entity\b`

**Example:**

`TenantAccountEntity`

---

## 40. Tenant...View names

**Category:** Identifiers

**Pattern:**

`\bTenant\w*View\b`

**Example:**

`TenantProductView`

---

## 41. Dart identifier

**Category:** Identifiers

**Pattern:**

`[A-Za-z_$][A-Za-z0-9_$]*`

**Example:**

`tenant_$value`

**Notes:**

General identifier pattern

---

## 42. Any class

**Category:** Dart Classes

**Pattern:**

`^\s*class\s+\w+`

**Example:**

`class TenantAccount`

---

## 43. Class ending in View

**Category:** Dart Classes

**Pattern:**

`^\s*class\s+\w+View\b`

**Example:**

`class TenantView`

---

## 44. Class ending in Entity

**Category:** Dart Classes

**Pattern:**

`^\s*class\s+\w+Entity\b`

**Example:**

`class TenantEntity`

---

## 45. Class ending in Response

**Category:** Dart Classes

**Pattern:**

`^\s*class\s+\w+Response\b`

**Example:**

`class SignInResponse`

---

## 46. Class ending in DTO

**Category:** Dart Classes

**Pattern:**

`^\s*class\s+\w+(Dto|DTO)\b`

**Example:**

`class UserDto`

---

## 47. Class ending in UseCase

**Category:** Dart Classes

**Pattern:**

`^\s*class\s+\w+UseCase\b`

**Example:**

`class GetTenantUseCase`

---

## 48. Abstract repository

**Category:** Dart Classes

**Pattern:**

`^\s*abstract\s+class\s+\w+Repository\b`

**Example:**

`abstract class AuthRepository`

---

## 49. Repository implementation

**Category:** Dart Classes

**Pattern:**

`\bclass\s+\w+RepositoryImpl\b`

**Example:**

`class AuthRepositoryImpl`

---

## 50. Methods starting with get

**Category:** Dart Methods

**Pattern:**

`\bget\w*\s*\(`

**Example:**

`getTenant(`

---

## 51. Methods starting with create

**Category:** Dart Methods

**Pattern:**

`\bcreate\w*\s*\(`

**Example:**

`createTenant(`

---

## 52. Methods starting with update

**Category:** Dart Methods

**Pattern:**

`\bupdate\w*\s*\(`

**Example:**

`updateTenant(`

---

## 53. Methods starting with delete

**Category:** Dart Methods

**Pattern:**

`\bdelete\w*\s*\(`

**Example:**

`deleteTenant(`

---

## 54. Dart getter

**Category:** Dart Methods

**Pattern:**

`\bget\s+\w+`

**Example:**

`get textTheme`

---

## 55. Function name ending in View

**Category:** Dart Methods

**Pattern:**

`\b\w+View\s*\(`

**Example:**

`buildDetailsView(`

---

## 56. Any View type

**Category:** Dart Types

**Pattern:**

`\b[A-Z]\w*View\b`

**Example:**

`TenantAccountView`

---

## 57. Any Entity type

**Category:** Dart Types

**Pattern:**

`\b[A-Z]\w*Entity\b`

**Example:**

`TenantAccountEntity`

---

## 58. Any Response type

**Category:** Dart Types

**Pattern:**

`\b[A-Z]\w*Response\b`

**Example:**

`SignInResponse`

---

## 59. Any Model type

**Category:** Dart Types

**Pattern:**

`\b[A-Z]\w*Model\b`

**Example:**

`TenantModel`

---

## 60. View or Response

**Category:** Dart Types

**Pattern:**

`\b[A-Z]\w*(?:View|Response)\b`

**Example:**

`TenantView` / `TenantResponse`

---

## 61. View, Response, or DTO

**Category:** Dart Types

**Pattern:**

`\b[A-Z]\w*(?:View|Response|Dto|DTO)\b`

**Example:**

`UserDTO`

---

## 62. Nullable type

**Category:** Dart Types

**Pattern:**

`\b[A-Z]\w*\?`

**Example:**

`String?`

---

## 63. Nullable TextTheme

**Category:** Dart Types

**Pattern:**

`\bTextTheme\?`

**Example:**

`TextTheme? textTheme`

---

## 64. Future<T>

**Category:** Dart Types

**Pattern:**

`\bFuture<[^>]+>`

**Example:**

`Future<TenantEntity>`

**Notes:**

Nested generics may require a more specific pattern

---

## 65. Future<void>

**Category:** Dart Types

**Pattern:**

`\bFuture<void>\b`

**Example:**

`Future<void>`

---

## 66. List<T>

**Category:** Dart Types

**Pattern:**

`\bList<[^>]+>`

**Example:**

`List<TenantEntity>`

---

## 67. Map<K,V>

**Category:** Dart Types

**Pattern:**

`\bMap<[^>]+>`

**Example:**

`Map<String, dynamic>`

---

## 68. Map<String, dynamic>

**Category:** Dart Types

**Pattern:**

`\bMap<String,\s*dynamic>\b`

**Example:**

`Map<String, dynamic>`

---

## 69. dynamic

**Category:** Dart Types

**Pattern:**

`\bdynamic\b`

**Example:**

`dynamic value`

---

## 70. required this.x

**Category:** Dart Fields

**Pattern:**

`\brequired\s+this\.\w+`

**Example:**

`required this.textTheme`

---

## 71. this.x

**Category:** Dart Fields

**Pattern:**

`\bthis\.\w+`

**Example:**

`this.value`

---

## 72. final

**Category:** Dart Fields

**Pattern:**

`^\s*final\s+`

**Example:**

`final value = 1;`

---

## 73. static

**Category:** Dart Fields

**Pattern:**

`^\s*static\s+`

**Example:**

`static value`

---

## 74. static final

**Category:** Dart Fields

**Pattern:**

`^\s*static\s+final\s+`

**Example:**

`static final value`

---

## 75. static const

**Category:** Dart Fields

**Pattern:**

`^\s*static\s+const\s+`

**Example:**

`static const value`

---

## 76. All imports

**Category:** Dart Imports

**Pattern:**

`^\s*import\s+['"].+['"];\s*$`

**Example:**

`import 'a.dart';`

---

## 77. Imports containing tenant_account

**Category:** Dart Imports

**Pattern:**

`^\s*import\s+['"][^'"]*tenant_account[^'"]*['"];\s*$`

**Example:**

`.../tenant_account/...`

---

## 78. Presentation imports

**Category:** Dart Imports

**Pattern:**

`import\s+['"][^'"]*/presentation/[^'"]*['"]`

**Example:**

`.../presentation/...`

---

## 79. Data imports

**Category:** Dart Imports

**Pattern:**

`import\s+['"][^'"]*/data/[^'"]*['"]`

**Example:**

`.../data/...`

---

## 80. Domain imports

**Category:** Dart Imports

**Pattern:**

`import\s+['"][^'"]*/domain/[^'"]*['"]`

**Example:**

`.../domain/...`

---

## 81. Import ending in _view.dart

**Category:** Dart Imports

**Pattern:**

`import\s+['"][^'"]*_view\.dart['"];`

**Example:**

`import 'tenant_view.dart';`

---

## 82. Import ending in response.dart

**Category:** Dart Imports

**Pattern:**

`import\s+['"][^'"]*response\.dart['"];`

**Example:**

`import 'response.dart';`

---

## 83. Imports under /models/

**Category:** Dart Imports

**Pattern:**

`import\s+['"][^'"]*/models/[^'"]*['"]`

**Example:**

`.../models/...`

---

## 84. Any part directive

**Category:** Dart Parts

**Pattern:**

`^\s*part\s+['"][^'"]+['"];\s*$`

**Example:**

`part 'entity.dart';`

---

## 85. Any part of directive

**Category:** Dart Parts

**Pattern:**

`^\s*part\s+of\s+.+;\s*$`

**Example:**

`part of 'domain.dart';`

---

## 86. Import appearing after part (approx.)

**Category:** Dart Parts

**Pattern:**

`part[^;]*;[\s\S]*?\n\s*import\s+`

**Example:**

Flags suspicious ordering

**Notes:**

Review results manually

---

## 87. View → Entity

**Category:** Refactoring

**Pattern:**

`\b([A-Z]\w*)View\b`

**Example:**

Replace: `$1Entity`

**Notes:**

Review Preview before Replace All

---

## 88. get...View → get...Entity

**Category:** Refactoring

**Pattern:**

`\bget(\w*)View\b`

**Example:**

Replace: `get$1Entity`

---

## 89. Remove View suffix

**Category:** Refactoring

**Pattern:**

`\b(\w+)View\b`

**Example:**

Replace: `$1`

---

## 90. Add Entity suffix to a specific name

**Category:** Refactoring

**Pattern:**

`\b(TenantAccount)\b`

**Example:**

Replace: `$1Entity`

---

## 91. ViewTenant → TenantView

**Category:** Refactoring

**Pattern:**

`\bView(\w+)\b`

**Example:**

Replace: `$1View`

---

## 92. Presentation depends on Data

**Category:** Clean Architecture

**Pattern:**

`import\s+['"][^'"]*/data/`

**Example:**

Include: `lib/**/presentation/**/*.dart`

**Notes:**

Usually a dependency violation

---

## 93. Presentation depends on Infrastructure

**Category:** Clean Architecture

**Pattern:**

`import\s+['"][^'"]*/infrastructure/`

**Example:**

Include: `lib/**/presentation/**/*.dart`

---

## 94. Domain depends on Data

**Category:** Clean Architecture

**Pattern:**

`import\s+['"][^'"]*/data/`

**Example:**

Include: `lib/**/domain/**/*.dart`

---

## 95. Domain depends on Presentation

**Category:** Clean Architecture

**Pattern:**

`import\s+['"][^'"]*/presentation/`

**Example:**

Include: `lib/**/domain/**/*.dart`

---

## 96. DTO/Response inside Presentation

**Category:** Clean Architecture

**Pattern:**

`\b\w+(?:Response|Dto|DTO)\b`

**Example:**

Include: `lib/**/presentation/**/*.dart`

---

## 97. TODO

**Category:** Comments

**Pattern:**

`\bTODO\b`

**Example:**

`// TODO:`

---

## 98. TODO or FIXME

**Category:** Comments

**Pattern:**

`\b(?:TODO|FIXME)\b`

**Example:**

`// FIXME:`

---

## 99. Single-line comment

**Category:** Comments

**Pattern:**

`^\s*//.*`

**Example:**

`// comment`

---

## 100. Blank line

**Category:** Comments

**Pattern:**

`^\s*$`

**Example:**

Blank line

---

## 101. 3 or more blank lines

**Category:** Comments

**Pattern:**

`(\r?\n\s*){3,}`

**Example:**

Replace with fewer line breaks

---

## 102. Single-quoted string

**Category:** Strings

**Pattern:**

`'[^']*'`

**Example:**

`'hello'`

---

## 103. Double-quoted string

**Category:** Strings

**Pattern:**

`"[^"]*"`

**Example:**

`"hello"`

---

## 104. Hard-coded URL

**Category:** Strings

**Pattern:**

`https?://[^\s'"]+`

**Example:**

`https://example.com`

---

## 105. Windows/Linux newline

**Category:** Line Endings

**Pattern:**

`\r?\n`

**Example:**

Windows `\r\n` or Linux `\n`

---

## 106. Multiline matching

**Category:** Multiline

**Pattern:**

`class\s+\w+[\s\S]*?extends\s+StatelessWidget`

**Example:**

Class through `extends`

**Notes:**

Use carefully

---

## 107. Greedy match

**Category:** Multiline

**Pattern:**

`".*"`

**Example:**

`"a" "b"` may match everything

**Notes:**

Largest possible match

---

## 108. Lazy match

**Category:** Multiline

**Pattern:**

`".*?"`

**Example:**

`"a"` then `"b"`

**Notes:**

Smallest possible match

---

## 109. Positive lookahead

**Category:** Lookaround

**Pattern:**

`Tenant(?=View)`

**Example:**

`TenantView` → matches Tenant

---

## 110. Negative lookahead

**Category:** Lookaround

**Pattern:**

`Tenant(?!View)`

**Example:**

`TenantEntity`

---

## 111. Positive lookbehind

**Category:** Lookaround

**Pattern:**

`(?<=Tenant)View`

**Example:**

`TenantView` → matches View

---

## 112. Negative lookbehind

**Category:** Lookaround

**Pattern:**

`(?<!Tenant)View`

**Example:**

`ProductView`

**Notes:**

Support can vary by Regex engine/context

---

## 113. Annotation

**Category:** Miscellaneous

**Pattern:**

`@\w+`

**Example:**

`@override`

---

## 114. override annotation

**Category:** Miscellaneous

**Pattern:**

`^\s*@override`

**Example:**

`@override`

---

## 115. if statement

**Category:** Miscellaneous

**Pattern:**

`\bif\s*\(`

**Example:**

`if (`

---

## 116. switch statement

**Category:** Miscellaneous

**Pattern:**

`\bswitch\s*\(`

**Example:**

`switch (`

---

## 117. try block

**Category:** Miscellaneous

**Pattern:**

`\btry\s*\{`

**Example:**

`try {`

---

## 118. catch block

**Category:** Miscellaneous

**Pattern:**

`\bcatch\s*\(`

**Example:**

`catch (`

---

## 119. throw

**Category:** Miscellaneous

**Pattern:**

`\bthrow\s+`

**Example:**

`throw Exception()`

---

## 120. print

**Category:** Miscellaneous

**Pattern:**

`\bprint\s*\(`

**Example:**

`print(value)`

---

## 121. debugPrint

**Category:** Miscellaneous

**Pattern:**

`\bdebugPrint\s*\(`

**Example:**

`debugPrint(value)`

---

## 122. == null

**Category:** Miscellaneous

**Pattern:**

`==\s*null`

**Example:**

`value == null`

---

## 123. != null

**Category:** Miscellaneous

**Pattern:**

`!=\s*null`

**Example:**

`value != null`

---

## 124. Cast using as

**Category:** Miscellaneous

**Pattern:**

`\s+as\s+\w+`

**Example:**

`value as TenantEntity`

---

## 125. Null assertion (approx.)

**Category:** Miscellaneous

**Pattern:**

`\w+!(?![=])`

**Example:**

`value!`

**Notes:**

Avoids `!=`

---

## 126. Deprecated annotation

**Category:** Miscellaneous

**Pattern:**

`@deprecated|@Deprecated`

**Example:**

`@Deprecated()`

---

## 127. IPv4-shaped address

**Category:** Data Formats

**Pattern:**

`\b(?:\d{1,3}\.){3}\d{1,3}\b`

**Example:**

`192.168.1.1`

**Notes:**

Does not validate each octet as 0..255

---

## 128. UUID

**Category:** Data Formats

**Pattern:**

`\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\b`

**Example:**

`550e8400-e29b-41d4-a716-446655440000`

---

## 129. Line containing only digits

**Category:** Data Formats

**Pattern:**

`^\s*\d+\s*$`

**Example:**

`12345`

---

## 130. Repeated words

**Category:** Data Formats

**Pattern:**

`\b(\w+)\s+\1\b`

**Example:**

`value value`

**Notes:**

Depends on backreference support

---

## 131. All Dart files

**Category:** Files to Include

**Pattern:**

`**/*.dart`

**Example:**

All Dart files

**Notes:**

Glob, not Regex

---

## 132. Dart files under lib

**Category:** Files to Include

**Pattern:**

`lib/**/*.dart`

**Example:**

All Dart files under `lib`

---

## 133. Presentation files

**Category:** Files to Include

**Pattern:**

`lib/**/presentation/**/*.dart`

**Example:**

All presentation files

---

## 134. Domain files

**Category:** Files to Include

**Pattern:**

`lib/**/domain/**/*.dart`

**Example:**

All domain files

---

## 135. Data files

**Category:** Files to Include

**Pattern:**

`lib/**/data/**/*.dart`

**Example:**

All data files

---

## 136. Use cases

**Category:** Files to Include

**Pattern:**

`lib/**/domain/usecases/**/*.dart`

**Example:**

All use cases

---

## 137. Entities

**Category:** Files to Include

**Pattern:**

`lib/**/domain/entities/**/*.dart`

**Example:**

All entities

---

## 138. Tests

**Category:** Files to Include

**Pattern:**

`test/**/*.dart`

**Example:**

All tests

---

## 139. Multiple extensions

**Category:** Files to Include

**Pattern:**

`**/*.{dart,yaml,json}`

**Example:**

Dart/YAML/JSON

---

## 140. Generated .g.dart files

**Category:** Files to Exclude

**Pattern:**

`**/*.g.dart`

**Example:**

Exclude generated code

---

## 141. Freezed files

**Category:** Files to Exclude

**Pattern:**

`**/*.freezed.dart`

**Example:**

Exclude Freezed output

---

## 142. Drift generated files

**Category:** Files to Exclude

**Pattern:**

`**/*.drift.dart`

**Example:**

Exclude Drift output

---

## 143. build directory

**Category:** Files to Exclude

**Pattern:**

`**/build/**`

**Example:**

Exclude build output

---

## 144. Common generated files

**Category:** Files to Exclude

**Pattern:**

`**/*.g.dart,**/*.freezed.dart,**/*.drift.dart,**/generated/**`

**Example:**

Exclude multiple generated patterns

---

## 145. Single path level

**Category:** Glob

**Pattern:**

`*`

**Example:**

`lib/*.dart`

**Notes:**

Does not cross directories

---

## 146. Any number of directories

**Category:** Glob

**Pattern:**

`**`

**Example:**

`lib/**/*.dart`

---

## 147. Single character

**Category:** Glob

**Pattern:**

`?`

**Example:**

`file?.dart`

---

## 148. Extension alternatives

**Category:** Glob

**Pattern:**

`{a,b}`

**Example:**

`**/*.{dart,json}`

---


# Replace Recipes

## View → Entity

Search:

```regex
\b([A-Z]\w*)View\b
```

Replace:

```text
$1Entity
```

Example:

```text
TenantAccountView
TenantProductView
```

becomes:

```text
TenantAccountEntity
TenantProductEntity
```

## get...View → get...Entity

Search:

```regex
\bget(\w*)View\b
```

Replace:

```text
get$1Entity
```

Example:

```text
getTenantView
getAccountDetailsView
```

becomes:

```text
getTenantEntity
getAccountDetailsEntity
```

## Remove the View suffix

Search:

```regex
\b(\w+)View\b
```

Replace:

```text
$1
```

## Files to Include examples

```glob
**/*.dart
```

```glob
lib/**/*.dart
```

```glob
lib/**/presentation/**/*.dart
```

```glob
lib/**/domain/**/*.dart
```

```glob
lib/**/data/**/*.dart
```

## Files to Exclude examples

```glob
**/*.g.dart,**/*.freezed.dart,**/*.drift.dart,**/generated/**
```

# Recommended Workflow

1. Run Search before Replace.
2. Review the result preview.
3. Restrict the search with **Files to Include**.
4. Exclude generated code.
5. Use word boundaries (`\b`) for identifier-level changes.
6. Commit your work before broad refactoring.
7. Run:

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
