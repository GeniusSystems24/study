<div dir="rtl">

# قاموس البحث و Regex في VS Code

مرجع عملي للبحث في Visual Studio Code باستخدام النص العادي، والتعبيرات النمطية Regex، وأنماط الملفات Glob، وأمثلة Dart/Flutter، وفحوصات Clean Architecture.

> يحتوي هذا الملف على **مرجع جدولي سريع** في البداية، ثم **الشرح التفصيلي الكامل** في القسم الثاني.

---

## الفهرس

- [المرجع الجدولي السريع](#المرجع-الجدولي-السريع)
- [الشرح التفصيلي](#الشرح-التفصيلي)

---

## المرجع الجدولي السريع

هذا الملف يحول القواعد إلى **جدول مرجعي سريع** ليسهل البحث والنسخ.

> عند استخدام Regex فعّل زر **Use Regular Expression `.*`** في VS Code.  
> بالنسبة إلى أنماط `Files to include / exclude` فهي **Glob patterns** وليست Regex.

| التصنيف | المطلوب | صيغة البحث / النمط | مثال | ملاحظات |
|---|---|---|---|---|
| VS Code | مطابقة حالة الأحرف | `Aa` | `TenantView` يختلف عن `tenantView` | فعّل Match Case |
| VS Code | مطابقة الكلمة كاملة | `ab` | `View` لا يطابق `TenantView` | فعّل Match Whole Word |
| VS Code | تفعيل Regex | `.*` | استخدم `\bget\w*View\b` | فعّل Use Regular Expression |
| Regex أساسي | أي حرف واحد | `.` | `get.View` → `getAView` | يمثل حرفاً واحداً |
| Regex أساسي | أي عدد من الأحرف | `.*` | `get.*View` | صفر أو أكثر |
| Regex أساسي | حرف واحد أو أكثر | `.+` | `get.+View` | لا يطابق `getView` |
| Regex أساسي | صفر أو حرف واحد | `.?` | `get.?View` | يطابق `getView` و `getAView` |
| Regex أساسي | حد كلمة | `\b` | `\bView\b` | لمنع مطابقة جزء من اسم أكبر |
| Regex أساسي | بداية السطر | `^` | `^import` | يطابق بداية السطر |
| Regex أساسي | نهاية السطر | `$` | `;$` | يطابق نهاية السطر |
| Regex أساسي | مسافات بيضاء | `\s` | `^\s*import` | مسافة أو Tab أو سطر جديد حسب السياق |
| Regex أساسي | غير مسافة | `\S` | `\S+` | أي حرف غير whitespace |
| Regex أساسي | رقم | `\d` | `id\d+` | يعادل غالباً `[0-9]` |
| Regex أساسي | غير رقم | `\D` | `\D+` | أي حرف ليس رقماً |
| Regex أساسي | حرف/رقم/underscore | `\w` | `get\w*View` | مفيد للأسماء البرمجية |
| Regex أساسي | غير حرف/رقم/underscore | `\W` | `\W+` | عكس `\w` |
| المجموعات | مجموعة أحرف | `[abc]` | `[A-Z]` | يطابق حرفاً واحداً من المجموعة |
| المجموعات | مدى حروف | `[a-z]` | `[A-Za-z0-9_]` | مفيد للـ identifiers |
| المجموعات | نفي مجموعة | `[^0-9]` | `[^A-Za-z]` | أي حرف غير الموجود داخل المجموعة |
| المجموعات | OR | `A\|B` | `Entity\|View` | يطابق أحد الخيارين |
| المجموعات | Capture Group | `(...)` | `get(\w+)View` | استخدم `$1` في Replace |
| المجموعات | Non-capture Group | `(?:...)` | `(?:View\|Response)` | للتجميع بدون Capture |
| التكرار | صفر أو أكثر | `*` | `a*` | قد يطابق صفراً |
| التكرار | واحد أو أكثر | `+` | `a+` | يتطلب تكراراً واحداً على الأقل |
| التكرار | صفر أو واحد | `?` | `a?` | اختياري |
| التكرار | عدد ثابت | `{n}` | `\d{4}` | مثال: 4 أرقام |
| التكرار | حد أدنى | `{n,}` | `\d{3,}` | 3 أو أكثر |
| التكرار | مدى | `{n,m}` | `\d{2,5}` | بين 2 و5 |
| Escape | نقطة حرفية | `\.` | `file\.dart` | لأن `.` له معنى خاص |
| Escape | قوس فتح حرفي | `\(` | `method\(` | للبحث عن `(` |
| Escape | قوس إغلاق حرفي | `\)` | `\)` | للبحث عن `)` |
| Escape | قوس مربع | `\[` / `\]` | `\[\w+\]` | للبحث عن الأقواس نفسها |
| Escape | علامة الدولار | `\$` | `\$value` | للبحث عن `$` حرفياً |
| الكلمات | يبدأ بـ get وينتهي بـ View | `\bget\w*View\b` | `getTenantView` | يطابق أيضاً `getView` |
| الكلمات | get...View مع شيء بينهما | `\bget\w+View\b` | `getTenantView` | لا يطابق `getView` |
| الكلمات | get + PascalCase + View | `\bget[A-Z][A-Za-z0-9]*View\b` | `getTenantAccountView` | أكثر تشدداً |
| الكلمات | كل اسم يبدأ بـ Super | `\bSuper\w+\b` | `SuperTextTheme` |  |
| الكلمات | كل Super...View | `\bSuper\w*View\b` | `SuperConfirmView` |  |
| الكلمات | كل Tenant...Entity | `\bTenant\w*Entity\b` | `TenantAccountEntity` |  |
| الكلمات | كل Tenant...View | `\bTenant\w*View\b` | `TenantProductView` |  |
| الكلمات | Identifier في Dart | `[A-Za-z_$][A-Za-z0-9_$]*` | `tenant_$value` | صيغة عامة للأسماء |
| Dart Classes | أي class | `^\s*class\s+\w+` | `class TenantAccount` |  |
| Dart Classes | Class ينتهي بـ View | `^\s*class\s+\w+View\b` | `class TenantView` |  |
| Dart Classes | Class ينتهي بـ Entity | `^\s*class\s+\w+Entity\b` | `class TenantEntity` |  |
| Dart Classes | Class ينتهي بـ Response | `^\s*class\s+\w+Response\b` | `class SignInResponse` |  |
| Dart Classes | Class ينتهي بـ DTO | `^\s*class\s+\w+(Dto\|DTO)\b` | `class UserDto` |  |
| Dart Classes | Class ينتهي بـ UseCase | `^\s*class\s+\w+UseCase\b` | `class GetTenantUseCase` |  |
| Dart Classes | Abstract Repository | `^\s*abstract\s+class\s+\w+Repository\b` | `abstract class AuthRepository` |  |
| Dart Classes | RepositoryImpl | `\bclass\s+\w+RepositoryImpl\b` | `class AuthRepositoryImpl` |  |
| Dart Methods | Methods تبدأ بـ get | `\bget\w*\s*\(` | `getTenant(` |  |
| Dart Methods | Methods تبدأ بـ create | `\bcreate\w*\s*\(` | `createTenant(` |  |
| Dart Methods | Methods تبدأ بـ update | `\bupdate\w*\s*\(` | `updateTenant(` |  |
| Dart Methods | Methods تبدأ بـ delete | `\bdelete\w*\s*\(` | `deleteTenant(` |  |
| Dart Methods | Getter في Dart | `\bget\s+\w+` | `get textTheme` |  |
| Dart Methods | اسم function ينتهي بـ View | `\b\w+View\s*\(` | `buildDetailsView(` |  |
| Dart Types | كل نوع View | `\b[A-Z]\w*View\b` | `TenantAccountView` |  |
| Dart Types | كل نوع Entity | `\b[A-Z]\w*Entity\b` | `TenantAccountEntity` |  |
| Dart Types | كل نوع Response | `\b[A-Z]\w*Response\b` | `SignInResponse` |  |
| Dart Types | كل نوع Model | `\b[A-Z]\w*Model\b` | `TenantModel` |  |
| Dart Types | View أو Response | `\b[A-Z]\w*(?:View\|Response)\b` | `TenantView` / `TenantResponse` |  |
| Dart Types | View أو Response أو DTO | `\b[A-Z]\w*(?:View\|Response\|Dto\|DTO)\b` | `UserDTO` |  |
| Dart Types | Nullable type | `\b[A-Z]\w*\?` | `String?` |  |
| Dart Types | TextTheme nullable | `\bTextTheme\?` | `TextTheme? textTheme` |  |
| Dart Types | Future<T> | `\bFuture<[^>]+>` | `Future<TenantEntity>` | للـ nested generics قد تحتاج صيغة أدق |
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
| Dart Imports | جميع imports | `^\s*import\s+['\"].+['\"];\s*$` | `import 'a.dart';` |  |
| Dart Imports | imports تحتوي tenant_account | `^\s*import\s+['\"][^'\"]*tenant_account[^'\"]*['\"];\s*$` | `.../tenant_account/...` |  |
| Dart Imports | presentation imports | `import\s+['\"][^'\"]*/presentation/[^'\"]*['\"]` | `.../presentation/...` |  |
| Dart Imports | data imports | `import\s+['\"][^'\"]*/data/[^'\"]*['\"]` | `.../data/...` |  |
| Dart Imports | domain imports | `import\s+['\"][^'\"]*/domain/[^'\"]*['\"]` | `.../domain/...` |  |
| Dart Imports | import ينتهي بـ _view.dart | `import\s+['\"][^'\"]*_view\.dart['\"];` | `import 'tenant_view.dart';` |  |
| Dart Imports | import ينتهي بـ response.dart | `import\s+['\"][^'\"]*response\.dart['\"];` | `import 'response.dart';` |  |
| Dart Imports | imports داخل /models/ | `import\s+['\"][^'\"]*/models/[^'\"]*['\"]` | `.../models/...` |  |
| Dart Parts | أي part | `^\s*part\s+['\"][^'\"]+['\"];\s*$` | `part 'entity.dart';` |  |
| Dart Parts | أي part of | `^\s*part\s+of\s+.+;\s*$` | `part of 'domain.dart';` |  |
| Dart Parts | import بعد part تقريبياً | `part[^;]*;[\s\S]*?\n\s*import\s+` | يكشف ترتيباً مشبوهاً | راجع النتائج يدوياً |
| Refactor | View → Entity | `\b([A-Z]\w*)View\b` | Replace: `$1Entity` | راجع Preview قبل Replace All |
| Refactor | get...View → get...Entity | `\bget(\w*)View\b` | Replace: `get$1Entity` |  |
| Refactor | حذف suffix View | `\b(\w+)View\b` | Replace: `$1` |  |
| Refactor | إضافة Entity لاسم محدد | `\b(TenantAccount)\b` | Replace: `$1Entity` |  |
| Refactor | ViewTenant → TenantView | `\bView(\w+)\b` | Replace: `$1View` |  |
| Clean Architecture | Presentation يعتمد على Data | `import\s+['\"][^'\"]*/data/` | Include: `lib/**/presentation/**/*.dart` | غالباً dependency violation |
| Clean Architecture | Presentation يعتمد على Infrastructure | `import\s+['\"][^'\"]*/infrastructure/` | Include: `lib/**/presentation/**/*.dart` |  |
| Clean Architecture | Domain يعتمد على Data | `import\s+['\"][^'\"]*/data/` | Include: `lib/**/domain/**/*.dart` |  |
| Clean Architecture | Domain يعتمد على Presentation | `import\s+['\"][^'\"]*/presentation/` | Include: `lib/**/domain/**/*.dart` |  |
| Clean Architecture | DTO/Response داخل Presentation | `\b\w+(?:Response\|Dto\|DTO)\b` | Include: `lib/**/presentation/**/*.dart` |  |
| Comments | TODO | `\bTODO\b` | `// TODO:` |  |
| Comments | TODO أو FIXME | `\b(?:TODO\|FIXME)\b` | `// FIXME:` |  |
| Comments | تعليق سطر واحد | `^\s*//.*` | `// comment` |  |
| Comments | سطر فارغ | `^\s*$` | سطر فارغ |  |
| Comments | 3 أسطر فارغة أو أكثر | `(\r?\n\s*){3,}` | Replace بعدد أقل |  |
| Strings | Single quoted string | `'[^']*'` | `'hello'` |  |
| Strings | Double quoted string | `\"[^\"]*\"` | `"hello"` |  |
| Strings | Hard-coded URL | `https?://[^\s'\"]+` | `https://example.com` |  |
| Line endings | Windows/Linux newline | `\r?\n` | Windows `\r\n` أو Linux `\n` |  |
| Multiline | مطابقة متعددة الأسطر | `class\s+\w+[\s\S]*?extends\s+StatelessWidget` | Class حتى extends | استخدم بحذر |
| Multiline | Greedy | `\".*\"` | `"a" "b"` قد يلتقط الكل | أكبر تطابق ممكن |
| Multiline | Lazy | `\".*?\"` | `"a"` ثم `"b"` | أقصر تطابق ممكن |
| Lookaround | Positive Lookahead | `Tenant(?=View)` | `TenantView` → يطابق Tenant |  |
| Lookaround | Negative Lookahead | `Tenant(?!View)` | `TenantEntity` |  |
| Lookaround | Positive Lookbehind | `(?<=Tenant)View` | `TenantView` → يطابق View |  |
| Lookaround | Negative Lookbehind | `(?<!Tenant)View` | `ProductView` | قد يختلف الدعم حسب محرك البحث |
| Misc | Annotation | `@\w+` | `@override` |  |
| Misc | override | `^\s*@override` | `@override` |  |
| Misc | if | `\bif\s*\(` | `if (` |  |
| Misc | switch | `\bswitch\s*\(` | `switch (` |  |
| Misc | try | `\btry\s*\{` | `try {` |  |
| Misc | catch | `\bcatch\s*\(` | `catch (` |  |
| Misc | throw | `\bthrow\s+` | `throw Exception()` |  |
| Misc | print | `\bprint\s*\(` | `print(value)` |  |
| Misc | debugPrint | `\bdebugPrint\s*\(` | `debugPrint(value)` |  |
| Misc | == null | `==\s*null` | `value == null` |  |
| Misc | != null | `!=\s*null` | `value != null` |  |
| Misc | Cast باستخدام as | `\s+as\s+\w+` | `value as TenantEntity` |  |
| Misc | Null assertion تقريبياً | `\w+!(?![=])` | `value!` | يتجنب `!=` |
| Misc | Deprecated | `@deprecated\|@Deprecated` | `@Deprecated()` |  |
| Data formats | IPv4 شكلياً | `\b(?:\d{1,3}\.){3}\d{1,3}\b` | `192.168.1.1` | لا يتحقق من 0..255 |
| Data formats | UUID | `\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\b` | `550e8400-e29b-41d4-a716-446655440000` |  |
| Data formats | سطر يحتوي أرقاماً فقط | `^\s*\d+\s*$` | `12345` |  |
| Data formats | كلمات مكررة | `\b(\w+)\s+\1\b` | `value value` | يعتمد على دعم backreference |
| Files to include | كل Dart | `**/*.dart` | جميع ملفات Dart | Glob وليس Regex |
| Files to include | Dart داخل lib | `lib/**/*.dart` | كل Dart داخل lib |  |
| Files to include | Presentation | `lib/**/presentation/**/*.dart` | كل ملفات presentation |  |
| Files to include | Domain | `lib/**/domain/**/*.dart` | كل ملفات domain |  |
| Files to include | Data | `lib/**/data/**/*.dart` | كل ملفات data |  |
| Files to include | Use Cases | `lib/**/domain/usecases/**/*.dart` | كل usecases |  |
| Files to include | Entities | `lib/**/domain/entities/**/*.dart` | كل entities |  |
| Files to include | Tests | `test/**/*.dart` | كل الاختبارات |  |
| Files to include | عدة امتدادات | `**/*.{dart,yaml,json}` | Dart/YAML/JSON |  |
| Files to exclude | Generated .g.dart | `**/*.g.dart` | استبعاد generated |  |
| Files to exclude | Freezed | `**/*.freezed.dart` | استبعاد Freezed |  |
| Files to exclude | Drift | `**/*.drift.dart` | استبعاد Drift generated |  |
| Files to exclude | build | `**/build/**` | استبعاد build |  |
| Files to exclude | مجموعة generated | `**/*.g.dart,**/*.freezed.dart,**/*.drift.dart,**/generated/**` | استبعاد عدة أنماط |  |
| Glob | مستوى واحد | `*` | `lib/*.dart` | لا يعبر المجلدات |
| Glob | أي عدد من المجلدات | `**` | `lib/**/*.dart` |  |
| Glob | حرف واحد | `?` | `file?.dart` |  |
| Glob | مجموعة امتدادات | `{a,b}` | `**/*.{dart,json}` |  |

---

## أمثلة سريعة لعمليات Replace

| العملية | Search | Replace | مثال قبل | مثال بعد |
|---|---|---|---|---|
| `View → Entity` | `\b([A-Z]\w*)View\b` | `$1Entity` | `TenantAccountView` | `TenantAccountEntity` |
| `get...View → get...Entity` | `\bget(\w*)View\b` | `get$1Entity` | `getTenantView` | `getTenantEntity` |
| حذف `View` | `\b(\w+)View\b` | `$1` | `TenantView` | `Tenant` |
| إضافة `Entity` | `\b(TenantAccount)\b` | `$1Entity` | `TenantAccount` | `TenantAccountEntity` |
| إعادة ترتيب `ViewTenant` | `\bView(\w+)\b` | `$1View` | `ViewTenant` | `TenantView` |

## أكثر القواعد استخداماً

| المطلوب | Regex |
|---|---|
| يبدأ بـ `get` وينتهي بـ `View` | `\bget\w*View\b` |
| يبدأ بـ `get` وينتهي بـ `View` ويجب أن يكون بينهما شيء | `\bget\w+View\b` |
| كل `Class` ينتهي بـ `View` | `^\s*class\s+\w+View\b` |
| كل نوع ينتهي بـ `View` | `\b[A-Z]\w*View\b` |
| كل نوع ينتهي بـ `Entity` | `\b[A-Z]\w*Entity\b` |
| كل `Response` | `\b[A-Z]\w*Response\b` |
| `View` أو `Response` أو `DTO` | `\b[A-Z]\w*(?:View|Response|Dto|DTO)\b` |
| أي `import` | `^\s*import\s+.+;\s*$` |
| أي `part of` | `^\s*part\s+of\s+.+;\s*$` |
| سطر فارغ | `^\s*$` |
| `TODO` أو `FIXME` | `\b(?:TODO|FIXME)\b` |
| Dart identifier | `[A-Za-z_$][A-Za-z0-9_$]*` |

## نصائح قبل Replace All

| # | القاعدة |
|---:|---|
| 1 | نفّذ Search أولاً وراجع النتائج. |
| 2 | قيد النطاق باستخدام `Files to include`. |
| 3 | استبعد ملفات `*.g.dart` و`*.freezed.dart` و`*.drift.dart`. |
| 4 | استخدم `\b` عندما تريد مطابقة اسم كامل. |
| 5 | استخدم Capture Groups مثل `(...)` ثم `$1`, `$2` في Replace. |
| 6 | أنشئ Git commit قبل أي refactor واسع. |
| 7 | بعد التعديل شغّل `dart format .` ثم `dart analyze` أو `flutter analyze`. |

---

## الشرح التفصيلي

دليل عملي شامل لأهم قواعد البحث والاستبدال في **Visual Studio Code**، مع أمثلة جاهزة للنسخ.

> ملاحظة: عند استخدام التعبيرات النمطية Regex فعّل زر **Use Regular Expression `.*`** في مربع البحث.

---

# 1. أوضاع البحث الأساسية في VS Code

في مربع البحث توجد ثلاثة خيارات مهمة:

| الخيار | الرمز | الوظيفة |
|---|---:|---|
| Match Case | `Aa` | مطابقة حالة الأحرف |
| Match Whole Word | `ab` | مطابقة الكلمة كاملة |
| Use Regular Expression | `.*` | استخدام Regular Expressions |

مثال:

```text
TenantView
```

مع تفعيل **Match Case** لن يطابق:

```text
tenantView
TENANTVIEW
```

---

# 2. البحث العادي Plain Text

للبحث عن نص كما هو:

```text
getTenantView
```

يبحث عن جميع المواضع التي تحتوي هذا النص.

مثال آخر:

```text
TenantAccountEntity
```

---

# 3. أهم رموز Regex

## `.` أي حرف واحد

```regex
get.View
```

يطابق مثلاً:

```text
getAView
get1View
get_View
```

ولا يطابق:

```text
getAccountView
```

لأن `.` يمثل حرفاً واحداً فقط.

---

## `.*` أي عدد من الأحرف

```regex
get.*View
```

يطابق:

```text
getView
getTenantView
getTenantAccountView
getProductDetailsView
```

لكن قد يطابق نصاً أكثر مما تريد إذا كان السطر طويلاً.

---

## `.+` حرف واحد أو أكثر

```regex
get.+View
```

يطابق:

```text
getTenantView
getAccountView
```

ولا يطابق:

```text
getView
```

---

## `.?` صفر أو حرف واحد

```regex
get.?View
```

يطابق:

```text
getView
getAView
```

ولا يطابق:

```text
getABView
```

---

# 4. البحث عن الكلمات التي تبدأ وتنتهي بنص معين

مثالك:

> كل الكلمات التي تبدأ بـ `get` وتنتهي بـ `View`

استخدم:

```regex
\bget[A-Za-z0-9_]*View\b
```

أمثلة مطابقة:

```text
getTenantView
getAccountView
getProductDetailsView
getView
```

---

## أسماء Dart identifiers

يمكن استخدام:

```regex
\bget\w*View\b
```

يطابق الأحرف والأرقام و `_`.

مثال:

```text
getTenant_View
getTenant2View
```

---

# 5. حدود الكلمات `\b`

`\b` تعني بداية أو نهاية كلمة.

```regex
\bView\b
```

يطابق:

```text
View
```

ولا يطابق:

```text
TenantView
ViewModel
Preview
```

مثال:

```regex
\bget\w*View\b
```

يمنع مطابقة أجزاء من أسماء أكبر قدر الإمكان.

---

# 6. بداية السطر `^`

```regex
^import
```

يجد الأسطر التي تبدأ بـ:

```dart
import
```

مثال:

```dart
import 'package:flutter/material.dart';
```

---

## تجاهل المسافات في بداية السطر

```regex
^\s*import
```

يطابق:

```dart
import 'a.dart';
    import 'b.dart';
```

---

# 7. نهاية السطر `$`

```regex
;$ 
```

ولكن بدون المسافة:

```regex
;$
```

يجد الأسطر التي تنتهي بـ `;`.

مثال:

```dart
final value = 10;
```

---

# 8. بداية ونهاية السطر معاً

```regex
^class.*View$
```

يبحث عن سطر يبدأ بـ `class` وينتهي بـ `View`.

غالباً في Dart ستحتاج صيغة أكثر واقعية مثل:

```regex
^\s*class\s+\w+View\b
```

مثال:

```dart
class TenantView extends StatelessWidget {
```

---

# 9. مجموعة أحرف `[]`

## حرف واحد من مجموعة

```regex
[abc]
```

يطابق:

```text
a
b
c
```

---

## حروف إنجليزية صغيرة

```regex
[a-z]
```

---

## حروف إنجليزية كبيرة

```regex
[A-Z]
```

---

## أرقام

```regex
[0-9]
```

---

## حروف وأرقام و underscore

```regex
[A-Za-z0-9_]
```

مثال:

```regex
get[A-Za-z0-9_]*View
```

---

# 10. نفي مجموعة أحرف `[^...]`

```regex
[^0-9]
```

يطابق أي حرف ليس رقماً.

مثال:

```regex
[^A-Za-z]
```

يطابق أي حرف ليس حرفاً إنجليزياً.

---

# 11. الاختصارات المهمة

| Regex | المعنى |
|---|---|
| `\d` | رقم |
| `\D` | ليس رقماً |
| `\w` | حرف أو رقم أو `_` |
| `\W` | ليس حرفاً/رقماً/`_` |
| `\s` | whitespace |
| `\S` | ليس whitespace |
| `\b` | حد كلمة |

مثال:

```regex
id\d+
```

يطابق:

```text
id1
id20
id999
```

---

# 12. التكرار

## `*` صفر أو أكثر

```regex
a*
```

---

## `+` واحد أو أكثر

```regex
a+
```

---

## `?` صفر أو واحد

```regex
a?
```

---

## `{n}` عدد محدد

```regex
\d{4}
```

يطابق أربعة أرقام:

```text
2026
1234
```

---

## `{n,}` على الأقل

```regex
\d{3,}
```

يطابق 3 أرقام أو أكثر.

---

## `{n,m}` بين عددين

```regex
\d{2,5}
```

يطابق من رقمين إلى خمسة أرقام.

---

# 13. OR باستخدام `|`

```regex
Entity|View
```

يطابق:

```text
Entity
View
```

مثال:

```regex
TenantAccount(Entity|View)
```

يطابق:

```text
TenantAccountEntity
TenantAccountView
```

---

# 14. المجموعات `()`

```regex
get(Tenant|User)View
```

يطابق:

```text
getTenantView
getUserView
```

---

# 15. مجموعة بدون Capture

```regex
(?:Tenant|User)
```

مفيدة عندما تحتاج التجميع فقط بدون استخدامها لاحقاً في Replace.

مثال:

```regex
get(?:Tenant|User)View
```

---

# 16. Capture Groups

بحث:

```regex
get(\w+)View
```

إذا كان النص:

```text
getTenantView
```

فإن المجموعة الأولى `$1` هي:

```text
Tenant
```

يمكن استخدامها أثناء Replace.

---

# 17. الاستبدال باستخدام Groups

لديك:

```text
getTenantView
getAccountView
getProductView
```

Search:

```regex
get(\w+)View
```

Replace:

```text
get$1Entity
```

النتيجة:

```text
getTenantEntity
getAccountEntity
getProductEntity
```

---

# 18. أكثر من Capture Group

لديك:

```text
TenantView
AccountView
```

Search:

```regex
(\w+)(View)
```

Replace:

```text
$1Entity
```

النتيجة:

```text
TenantEntity
AccountEntity
```

---

# 19. Escape للأحرف الخاصة

الأحرف التالية لها معنى خاص في Regex:

```text
. * + ? ^ $ { } ( ) | [ ] \
```

إذا أردت البحث عنها حرفياً استخدم `\`.

مثلاً للبحث عن:

```text
file.dart
```

يمكنك كتابة:

```regex
file\.dart
```

---

## البحث عن `.`

```regex
\.
```

---

## البحث عن `(`

```regex
\(
```

---

## البحث عن `)`

```regex
\)
```

---

## البحث عن `[` و `]`

```regex
\[
```

```regex
\]
```

---

## البحث عن `$`

```regex
\$
```

---

# 20. البحث عن Dart imports

جميع imports:

```regex
^\s*import\s+['"].+['"];\s*$
```

---

## imports لمجلد معين

```regex
^\s*import\s+['"][^'"]*\/presentation\/[^'"]*['"];\s*$
```

---

## imports تحتوي `tenant_account`

```regex
^\s*import\s+['"][^'"]*tenant_account[^'"]*['"];\s*$
```

---

# 21. البحث عن `part`

```regex
^\s*part\s+['"][^'"]+['"];\s*$
```

مثال:

```dart
part 'entity.dart';
```

---

# 22. البحث عن `part of`

```regex
^\s*part\s+of\s+.+;\s*$
```

مثال:

```dart
part of 'domain.dart';
```

---

# 23. البحث عن class

```regex
^\s*class\s+\w+
```

أمثلة:

```dart
class TenantAccount
class TenantAccountEntity
```

---

# 24. البحث عن Classes تنتهي بـ View

```regex
^\s*class\s+\w+View\b
```

مثال:

```dart
class TenantAccountView
class ProductView
```

---

# 25. Classes تنتهي بـ Response

```regex
^\s*class\s+\w+Response\b
```

---

# 26. Classes تنتهي بـ Entity

```regex
^\s*class\s+\w+Entity\b
```

---

# 27. Classes تنتهي بـ DTO

```regex
^\s*class\s+\w+(Dto|DTO)\b
```

---

# 28. Classes تنتهي بـ UseCase

```regex
^\s*class\s+\w+UseCase\b
```

---

# 29. العثور على UseCase لا ينتهي اسمها بـ UseCase

مثال تقريبي مفيد:

```regex
^\s*class\s+(?!\w*UseCase\b)\w+
```

> Negative Lookahead قد يعتمد دعمه على سياق البحث وإصدار VS Code/محرك Regex المستخدم.

---

# 30. البحث عن أسماء Methods تبدأ بـ get

```regex
\bget\w*\s*\(
```

يطابق مثلاً:

```dart
getTenant(
getProducts(
getAccountById(
```

---

# 31. Methods تبدأ بـ create

```regex
\bcreate\w*\s*\(
```

---

# 32. Methods تبدأ بـ update

```regex
\bupdate\w*\s*\(
```

---

# 33. Methods تبدأ بـ delete

```regex
\bdelete\w*\s*\(
```

---

# 34. البحث عن Getter في Dart

```regex
\bget\s+\w+
```

مثال:

```dart
get textTheme
get tenant
get value
```

---

# 35. البحث عن Type معين

مثلاً كل استخدامات:

```dart
TenantAccountView
```

استخدم:

```regex
\bTenantAccountView\b
```

---

# 36. كل الأنواع المنتهية بـ View

```regex
\b[A-Z]\w*View\b
```

يطابق:

```text
TenantView
TenantAccountView
ProductDetailsView
```

---

# 37. كل الأنواع المنتهية بـ Entity

```regex
\b[A-Z]\w*Entity\b
```

---

# 38. كل الأنواع المنتهية بـ Response

```regex
\b[A-Z]\w*Response\b
```

---

# 39. كل الأنواع المنتهية بـ Model

```regex
\b[A-Z]\w*Model\b
```

---

# 40. البحث عن Nullable Types

```regex
\b[A-Z]\w*\?
```

مثال:

```dart
TenantEntity?
String?
DateTime?
```

---

# 41. البحث عن `TextTheme?`

```regex
\bTextTheme\?
```

مثال:

```dart
TextTheme? textTheme
TextTheme? primaryTextTheme
```

---

# 42. البحث عن Constructor parameters

كل `required`:

```regex
\brequired\s+this\.\w+
```

مثال:

```dart
required this.textTheme
required this.color
```

---

# 43. البحث عن Parameters غير required

مثال تقريبي:

```regex
\bthis\.\w+
```

ثم يمكن مراجعة النتائج يدوياً.

---

# 44. البحث عن `final`

```regex
^\s*final\s+
```

---

# 45. البحث عن `static`

```regex
^\s*static\s+
```

---

# 46. البحث عن `static final`

```regex
^\s*static\s+final\s+
```

---

# 47. البحث عن `static const`

```regex
^\s*static\s+const\s+
```

---

# 48. البحث عن TODO

```regex
\bTODO\b
```

أو:

```regex
TODO:
```

---

# 49. البحث عن TODO و FIXME معاً

```regex
\b(?:TODO|FIXME)\b
```

---

# 50. البحث عن comments ذات سطر واحد

```regex
^\s*//.*
```

---

# 51. البحث عن السطور الفارغة

```regex
^\s*$
```

مفيد جداً عند تنظيف الملفات.

---

# 52. البحث عن أكثر من سطر فارغ متتالي

في البحث متعدد الأسطر:

```regex
(\r?\n\s*){3,}
```

يمكن استبدالها بعدد أقل من الأسطر.

---

# 53. Windows و Linux line endings

للتعامل مع:

- Windows: `\r\n`
- Linux/macOS: `\n`

استخدم:

```regex
\r?\n
```

---

# 54. البحث متعدد الأسطر

مثال:

```regex
class\s+\w+[\s\S]*?extends\s+StatelessWidget
```

لكن استخدم البحث متعدد الأسطر بحذر، لأن النتائج قد تصبح واسعة جداً.

---

# 55. Greedy و Lazy

## Greedy

```regex
".*"
```

قد يلتقط أكبر نص ممكن بين علامتي اقتباس.

---

## Lazy

```regex
".*?"
```

يلتقط أقصر نص ممكن.

مثال:

```text
"a" "b"
```

مع:

```regex
".*?"
```

تحصل على:

```text
"a"
"b"
```

---

# 56. البحث داخل علامات الاقتباس

## Single quote

```regex
'[^']*'
```

---

## Double quote

```regex
"[^"]*"
```

---

## النوعان

```regex
(['"])[^'"]*\1
```

> بعض ميزات الـ backreference قد تختلف حسب محرك البحث والسياق. الصيغة الأبسط غالباً أكثر أماناً.

---

# 57. البحث عن مسار Dart

```regex
lib\/[\w\/]+\.dart
```

مثال:

```text
lib/features/tenant_account/domain/entity.dart
```

---

# 58. البحث عن ملفات داخل feature معين من imports

```regex
['"][^'"]*features\/tenant_account\/[^'"]*['"]
```

---

# 59. البحث عن presentation imports

```regex
['"][^'"]*\/presentation\/[^'"]*['"]
```

---

# 60. البحث عن data imports

```regex
['"][^'"]*\/data\/[^'"]*['"]
```

---

# 61. البحث عن domain imports

```regex
['"][^'"]*\/domain\/[^'"]*['"]
```

---

# 62. اكتشاف خرق Clean Architecture

مثلاً البحث داخل ملفات `presentation` عن imports من `data`.

في **Files to include**:

```glob
lib/**/presentation/**/*.dart
```

وفي Search:

```regex
import\s+['"][^'"]*\/data\/
```

هذا مفيد لاكتشاف اعتماد Presentation على Data.

---

# 63. Files to Include

يمكن حصر البحث في ملفات معينة.

مثال:

```glob
*.dart
```

---

## جميع Dart files داخل lib

```glob
lib/**/*.dart
```

---

## جميع ملفات feature معين

```glob
lib/modules/features/tenant_account/**/*.dart
```

---

## ملفات presentation فقط

```glob
lib/**/presentation/**/*.dart
```

---

## ملفات domain فقط

```glob
lib/**/domain/**/*.dart
```

---

## ملفات data فقط

```glob
lib/**/data/**/*.dart
```

---

# 64. Files to Exclude

مثال:

```glob
**/*.g.dart
```

---

## استثناء generated Dart

```glob
**/*.g.dart,**/*.freezed.dart
```

---

## استثناء build

```glob
**/build/**
```

---

## استثناء ملفات generated متعددة

```glob
**/*.g.dart,**/*.freezed.dart,**/*.drift.dart
```

---

# 65. Glob Patterns

## `*`

يمثل أي أحرف ضمن نفس مستوى المسار.

```glob
lib/*.dart
```

---

## `**`

يمثل أي عدد من المجلدات.

```glob
lib/**/*.dart
```

---

## `?`

يمثل حرفاً واحداً.

```glob
file?.dart
```

يطابق:

```text
file1.dart
fileA.dart
```

---

## `{a,b}`

اختيار أكثر من نمط:

```glob
**/*.{dart,yaml,json}
```

يطابق:

```text
.dart
.yaml
.json
```

---

# 66. أمثلة Include مفيدة لمشروع Flutter

كل Dart:

```glob
**/*.dart
```

Domain:

```glob
lib/**/domain/**/*.dart
```

Use Cases:

```glob
lib/**/domain/usecases/**/*.dart
```

Entities:

```glob
lib/**/domain/entities/**/*.dart
```

Repositories:

```glob
lib/**/repositories/**/*.dart
```

Presentation:

```glob
lib/**/presentation/**/*.dart
```

Tests:

```glob
test/**/*.dart
```

---

# 67. استبعاد Generated Code

ضع في **Files to Exclude**:

```glob
**/*.g.dart,**/*.freezed.dart,**/*.drift.dart,**/generated/**
```

---

# 68. البحث عن import قديم واستبداله

قبل:

```dart
import 'package:app/features/tenant_account/presentation/presentation.dart';
```

Search:

```regex
import\s+['"]([^'"]*)\/presentation\/presentation\.dart['"];
```

ثم راجع النتائج قبل الاستبدال لأن الـ barrel imports قد تحتاج أكثر من import بديل.

---

# 69. البحث عن أسماء View لتحويلها إلى Entity

Search:

```regex
\b([A-Z]\w*)View\b
```

Replace:

```text
$1Entity
```

مثال:

```text
TenantAccountView
TenantProductView
```

تصبح:

```text
TenantAccountEntity
TenantProductEntity
```

> لا تستخدم Replace All مباشرة قبل التأكد أن كل View لها Entity مقابلة.

---

# 70. تحويل get...View إلى get...Entity

Search:

```regex
\bget(\w*)View\b
```

Replace:

```text
get$1Entity
```

مثال:

```text
getTenantView
getAccountDetailsView
```

يصبح:

```text
getTenantEntity
getAccountDetailsEntity
```

---

# 71. البحث عن View أو Response

```regex
\b[A-Z]\w*(?:View|Response)\b
```

---

# 72. البحث عن View أو Response أو DTO

```regex
\b[A-Z]\w*(?:View|Response|Dto|DTO)\b
```

---

# 73. البحث عن أنواع Data Layer داخل Presentation

في **Files to include**:

```glob
lib/**/presentation/**/*.dart
```

Search:

```regex
\b[A-Z]\w*(?:Dto|DTO|Response|Model|View)\b
```

ثم راجع النتائج.

---

# 74. البحث عن Repository classes

```regex
\bclass\s+\w+Repository(?:Impl)?\b
```

يطابق:

```text
class TenantRepository
class TenantRepositoryImpl
```

---

# 75. البحث عن RepositoryImpl

```regex
\bclass\s+\w+RepositoryImpl\b
```

---

# 76. البحث عن abstract repositories

```regex
^\s*abstract\s+class\s+\w+Repository\b
```

---

# 77. البحث عن Future return types

```regex
\bFuture<[^>]+>
```

أمثلة:

```dart
Future<void>
Future<TenantEntity>
Future<List<TenantEntity>>
```

لـ nested generics المعقدة قد تحتاج Regex أكثر تخصصاً.

---

# 78. البحث عن `Future<void>`

```regex
\bFuture<void>\b
```

---

# 79. البحث عن Lists

```regex
\bList<[^>]+>
```

---

# 80. البحث عن Maps

```regex
\bMap<[^>]+>
```

---

# 81. البحث عن nullable field declarations

مثال تقريبي:

```regex
^\s*(?:final\s+)?[\w<>?, ]+\?\s+\w+\s*;
```

راجع النتائج لأن Generic types قد تكون معقدة.

---

# 82. البحث عن `dynamic`

```regex
\bdynamic\b
```

مفيد لتقليل الاستخدام غير الضروري لـ `dynamic`.

---

# 83. البحث عن `Map<String, dynamic>`

```regex
\bMap<String,\s*dynamic>\b
```

---

# 84. البحث عن casts

```regex
\s+as\s+\w+
```

مثال:

```dart
value as TenantEntity
```

---

# 85. البحث عن null assertion `!`

البحث الشامل عن `!` غير دقيق لأنه قد يعني `!=`.

للبحث التقريبي عن null assertion:

```regex
\w+!(?![=])
```

---

# 86. البحث عن `== null`

```regex
==\s*null
```

---

# 87. البحث عن `!= null`

```regex
!=\s*null
```

---

# 88. البحث عن deprecated comments

```regex
@deprecated|@Deprecated
```

---

# 89. البحث عن annotations

```regex
@\w+
```

أمثلة:

```dart
@override
@immutable
@Deprecated
```

---

# 90. البحث عن override

```regex
^\s*@override
```

---

# 91. البحث عن `switch`

```regex
\b switch\s*\(
```

والأصح عادة:

```regex
\bswitch\s*\(
```

---

# 92. البحث عن `if`

```regex
\bif\s*\(
```

---

# 93. البحث عن `try/catch`

```regex
\btry\s*\{
```

أو:

```regex
\bcatch\s*\(
```

---

# 94. البحث عن throw

```regex
\bthrow\s+
```

---

# 95. البحث عن print في Flutter/Dart

```regex
\bprint\s*\(
```

يمكن استخدامه لاكتشاف debug statements.

---

# 96. البحث عن debugPrint

```regex
\bdebugPrint\s*\(
```

---

# 97. البحث عن hard-coded URLs

```regex
https?:\/\/[^\s'"]+
```

مثال:

```text
https://example.com/api
```

---

# 98. البحث عن أرقام IP

```regex
\b(?:\d{1,3}\.){3}\d{1,3}\b
```

هذه تتحقق من الشكل، وليس من أن كل جزء بين 0 و255.

---

# 99. البحث عن UUID

```regex
\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\b
```

---

# 100. البحث عن أرقام فقط في سطر

```regex
^\s*\d+\s*$
```

---

# 101. البحث عن كلمات مكررة

```regex
\b(\w+)\s+\1\b
```

مثال:

```text
the the
value value
```

> Backreferences قد تختلف في بعض أوضاع بحث workspace حسب محرك Regex.

---

# 102. Positive Lookahead

مثال: كلمة `Tenant` فقط عندما يليها `View`:

```regex
Tenant(?=View)
```

في:

```text
TenantView
```

يطابق فقط:

```text
Tenant
```

---

# 103. Negative Lookahead

`Tenant` عندما لا يليها `View`:

```regex
Tenant(?!View)
```

---

# 104. Positive Lookbehind

مثال: `View` عندما يسبقها `Tenant`:

```regex
(?<=Tenant)View
```

---

# 105. Negative Lookbehind

```regex
(?<!Tenant)View
```

> دعم Lookaround يعتمد على وضع البحث ومحرك Regex الذي يستخدمه إصدار VS Code. إذا لم يعمل، استخدم صيغة أبسط أو قيد البحث بالملفات.

---

# 106. Recipe: كل getter ينتهي بـ Theme

```regex
\bget\s+\w*Theme\b
```

مثال:

```dart
get textTheme
get materialTheme
```

---

# 107. Recipe: كل متغير ينتهي بـ Theme

```regex
\b\w*Theme\b
```

---

# 108. Recipe: كل أسماء تبدأ بـ Super

```regex
\bSuper\w+\b
```

أمثلة:

```text
SuperTextTheme
SuperCard
SuperFieldView
```

---

# 109. Recipe: كل Classes تبدأ بـ Super

```regex
^\s*class\s+Super\w+
```

---

# 110. Recipe: جميع `Super...View`

```regex
\bSuper\w*View\b
```

---

# 111. Recipe: جميع `Tenant...Entity`

```regex
\bTenant\w*Entity\b
```

---

# 112. Recipe: جميع `Tenant...View`

```regex
\bTenant\w*View\b
```

---

# 113. Recipe: get + أي شيء + View

```regex
\bget\w*View\b
```

وهي الصيغة المختصرة لمثالك الأساسي.

أمثلة:

```text
getView
getTenantView
getTenantAccountView
getProductDetailsView
```

---

# 114. Recipe: get + حرف واحد على الأقل + View

إذا كنت لا تريد مطابقة `getView`:

```regex
\bget\w+View\b
```

يطابق:

```text
getTenantView
getAccountView
```

ولا يطابق:

```text
getView
```

---

# 115. Recipe: get + PascalCase + View

صيغة أكثر تشدداً:

```regex
\bget[A-Z][A-Za-z0-9]*View\b
```

يطابق:

```text
getTenantView
getTenantAccountView
```

ولا يطابق:

```text
gettenantView
get_View
```

---

# 116. Recipe: جميع أسماء Functions التي تعيد View

كمطابقة اسم فقط:

```regex
\b\w+View\s*\(
```

مثال:

```dart
createTenantView(
getTenantView(
buildDetailsView(
```

---

# 117. Recipe: جميع ملفات import المنتهية بـ `_view.dart`

```regex
import\s+['"][^'"]*_view\.dart['"];
```

---

# 118. Recipe: جميع imports المنتهية بـ `response.dart`

```regex
import\s+['"][^'"]*response\.dart['"];
```

---

# 119. Recipe: جميع imports التي تحتوي `/models/`

```regex
import\s+['"][^'"]*\/models\/[^'"]*['"];
```

---

# 120. Recipe: Data dependency داخل Domain

ضع في **Files to include**:

```glob
lib/**/domain/**/*.dart
```

Search:

```regex
import\s+['"][^'"]*\/data\/
```

النتائج المحتملة تشير إلى خرق dependency rule.

---

# 121. Recipe: Presentation dependency داخل Domain

Files to include:

```glob
lib/**/domain/**/*.dart
```

Search:

```regex
import\s+['"][^'"]*\/presentation\/
```

---

# 122. Recipe: Infrastructure/Data داخل Presentation

Files to include:

```glob
lib/**/presentation/**/*.dart
```

Search:

```regex
import\s+['"][^'"]*\/(?:data|infrastructure)\/
```

---

# 123. Recipe: imports بعد `part`

إذا كنت تبحث عن ملف يحتوي `part` ثم `import` بعده، فهذه حالة متعددة الأسطر وقد يكون البحث التقريبي:

```regex
part[^;]*;[\s\S]*?\n\s*import\s+
```

راجع النتائج يدوياً.

---

# 124. Recipe: أسماء غير مرغوبة في Presentation

Files to include:

```glob
lib/**/presentation/**/*.dart
```

Search:

```regex
\b\w+(?:Response|Dto|DTO)\b
```

---

# 125. Recipe: استبدال `View` بـ `Entity` في اسم معين فقط

Search:

```regex
\bTenantProductView\b
```

Replace:

```text
TenantProductEntity
```

هذا أكثر أماناً من الاستبدال العام.

---

# 126. Recipe: حذف suffix من الاسم

لديك:

```text
TenantAccountView
```

Search:

```regex
\b(\w+)View\b
```

Replace:

```text
$1
```

النتيجة:

```text
TenantAccount
```

---

# 127. Recipe: إضافة suffix

لديك:

```text
TenantAccount
```

Search:

```regex
\b(TenantAccount)\b
```

Replace:

```text
$1Entity
```

---

# 128. Recipe: إعادة ترتيب جزأين

لديك:

```text
ViewTenant
```

Search:

```regex
\bView(\w+)\b
```

Replace:

```text
$1View
```

النتيجة:

```text
TenantView
```

---

# 129. Regex آمن لأسماء Dart identifiers

بشكل عام:

```regex
[A-Za-z_$][A-Za-z0-9_$]*
```

مثال لاستخدامه بين `get` و `View`:

```regex
\bget[A-Za-z0-9_$]*View\b
```

---

# 130. نصائح مهمة قبل Replace All

1. استخدم Search أولاً وشاهد جميع النتائج.
2. قيد البحث باستخدام **Files to include**.
3. استبعد generated files.
4. استخدم `\b` لتجنب تغيير أجزاء من أسماء أكبر.
5. استخدم Capture Groups بدلاً من عمليات Replace متعددة.
6. نفّذ Commit قبل refactor واسع.
7. شغّل بعد التعديل:

```bash
dart format .
```

ثم:

```bash
dart analyze
```

وفي Flutter:

```bash
flutter analyze
```

---

# Cheat Sheet سريع

| المطلوب | Regex |
|---|---|
| يبدأ بـ get وينتهي بـ View | `\bget\w*View\b` |
| يبدأ بـ get وينتهي بـ View وبينهما شيء | `\bget\w+View\b` |
| كل Class ينتهي بـ View | `^\s*class\s+\w+View\b` |
| كل نوع ينتهي بـ View | `\b[A-Z]\w*View\b` |
| كل Entity | `\b[A-Z]\w*Entity\b` |
| كل Response | `\b[A-Z]\w*Response\b` |
| View أو Response | `\b[A-Z]\w*(?:View|Response)\b` |
| أي import | `^\s*import\s+.+;\s*$` |
| أي part | `^\s*part\s+.+;\s*$` |
| أي part of | `^\s*part\s+of\s+.+;\s*$` |
| سطر فارغ | `^\s*$` |
| TODO/FIXME | `\b(?:TODO|FIXME)\b` |
| URL | `https?:\/\/[^\s'"]+` |
| Dart identifier | `[A-Za-z_$][A-Za-z0-9_$]*` |
| أي رقم | `\d+` |
| حد كلمة | `\b` |
| بداية سطر | `^` |
| نهاية سطر | `$` |
| أي حرف | `.` |
| صفر أو أكثر | `*` |
| واحد أو أكثر | `+` |
| صفر أو واحد | `?` |
| OR | `|` |
| Capture Group | `(...)` |
| Non-capture Group | `(?:...)` |

---

# أهم Patterns لمشروع Flutter / Dart

## View → Entity

```regex
\b([A-Z]\w*)View\b
```

Replace:

```text
$1Entity
```

---

## get...View → get...Entity

```regex
\bget(\w*)View\b
```

Replace:

```text
get$1Entity
```

---

## Presentation يعتمد على Data

Files:

```glob
lib/**/presentation/**/*.dart
```

Search:

```regex
import\s+['"][^'"]*\/data\/
```

---

## Domain يعتمد على Data

Files:

```glob
lib/**/domain/**/*.dart
```

Search:

```regex
import\s+['"][^'"]*\/data\/
```

---

## جميع View/Response/DTO في Presentation

Files:

```glob
lib/**/presentation/**/*.dart
```

Search:

```regex
\b[A-Z]\w*(?:View|Response|Dto|DTO)\b
```

---

## جميع get...View

```regex
\bget[A-Za-z0-9_$]*View\b
```

---

# الخلاصة

للبحث العادي لا تحتاج Regex.

للبحث الهيكلي استخدم:

```text
^ $ . * + ? [] () {} | \b \d \w \s
```

ولعمليات refactoring استخدم **Capture Groups**:

```regex
(...)
```

ثم في Replace:

```text
$1
$2
$3
```

وأهم قاعدة: قبل استخدام **Replace All** على المشروع كاملاً، قيد نطاق الملفات وراجع Preview للنتائج.
