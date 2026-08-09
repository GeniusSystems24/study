<div dir="rtl">

# قاموس الاستبدال في VS Code

مرجع عملي لعمليات Replace / Replace All في Visual Studio Code، ويشمل Capture Groups، وتحويلات Regex، وتغيير حالة الأحرف، وأمثلة refactoring في Dart/Flutter، والمسارات وعمليات التنظيف.

> يحتوي هذا الملف على **مرجع جدولي سريع** في البداية، ثم **الشرح التفصيلي الكامل** في القسم الثاني.

---

## الفهرس

- [المرجع الجدولي السريع](#المرجع-الجدولي-السريع)
- [الشرح التفصيلي](#الشرح-التفصيلي)

---

## المرجع الجدولي السريع

مرجع جدولي لعمليات **Replace / Replace All** في Visual Studio Code، مع Regex وأمثلة Dart / Flutter.

> فعّل **Use Regular Expression `.*`** عند استخدام Regex، وراجع Preview قبل تنفيذ **Replace All** على نطاق المشروع.

| # | العملية | Search | Replace | مثال | ملاحظات |
|---:|---|---|---|---|---|
| 1 | الفكرة الأساسية | — | — | قبل: TenantView → بعد: TenantEntity | — |
| 2 | أهم رموز Replace | — | راجع جدول رموز Replace أسفل الملف | — | ملاحظة: أوامر تغيير حالة الأحرف `\u`, `\l`, `\U`, `\L` مدعومة في VS Code Replace، لكن سلوكها قد يختلف في بعض البيئات أو الإضافات. |
| 3 | Capture Groups | `get(\w+)View` | `get$1Entity` | (...) → getTenantView | — |
| 4 | أكثر من Capture Group | `(\w+)_(\w+)` | `$2_$1` | tenant_account → $1 = tenant<br>$2 = account | — |
| 5 | جدول أساسيات الاستبدال | — | راجع جدول العمليات الأساسية أسفل الملف | — | — |
| 6 | View → Entity | `\b([A-Z]\w*)View\b` | `$1Entity` | قبل: TenantView<br>TenantAccountView<br>TenantProductView → بعد: TenantEntity<br>TenantAccountEntity<br>TenantProductEntity | — |
| 7 | get...View → get...Entity | `\bget(\w*)View\b` | `get$1Entity` | قبل: getTenantView<br>getAccountView<br>getProductDetailsView → بعد: getTenantEntity<br>getAccountEntity<br>getProductDetailsEntity | — |
| 8 | Response → Entity | `\b([A-Z]\w*)Response\b` | `$1Entity` | قبل: SignInResponse<br>TenantResponse<br>UserResponse → بعد: SignInEntity<br>TenantEntity<br>UserEntity | — |
| 9 | DTO → Entity | `\b([A-Z]\w*)(?:Dto\|DTO)\b` | `$1Entity` | قبل: UserDto<br>TenantDTO → بعد: UserEntity<br>TenantEntity | — |
| 10 | Model → Entity | `\b([A-Z]\w*)Model\b` | `$1Entity` | — | — |
| 11 | حذف Suffix | `\b(\w+)View\b` | `$1` | قبل: TenantAccountView → بعد: TenantAccount | — |
| 12 | إضافة Suffix | `\b(TenantAccount)\b` | `$1Entity` | قبل: TenantAccount → بعد: TenantAccountEntity | — |
| 13 | حذف Prefix | `\bSuper(\w+)\b` | `$1` | قبل: SuperTextTheme<br>SuperCard → بعد: TextTheme<br>Card | — |
| 14 | إضافة Prefix | `\b(TextTheme)\b` | `Super$1` | قبل: TextTheme → بعد: SuperTextTheme | — |
| 15 | إعادة ترتيب الكلمات | `\b(\w+)_(\w+)\b` | `$2_$1` | قبل: tenant_account → بعد: account_tenant | — |
| 16 | camelCase → Prefix جديد | `\bget([A-Z]\w*)\b` | `fetch$1` | قبل: getTenantAccount → بعد: fetchTenantAccount | — |
| 17 | create → add | `\bcreate([A-Z]\w*)\b` | `add$1` | قبل: createTenant<br>createAccount → بعد: addTenant<br>addAccount | — |
| 18 | update → edit | `\bupdate([A-Z]\w*)\b` | `edit$1` | — | — |
| 19 | delete → remove | `\bdelete([A-Z]\w*)\b` | `remove$1` | — | — |
| 20 | Rename Class مع الحفاظ على الاسم | `class\s+(\w+)View\b` | `class $1Entity` | قبل: class TenantView { → بعد: class TenantEntity { | — |
| 21 | Named Capture Groups | `(?<name>[A-Z]\w*)View` | `$<name>Entity` | قبل: TenantAccountView → بعد: TenantAccountEntity | — |
| 22 | إضافة النص المطابق نفسه باستخدام `$&` | `\bTenant\b` | `Super$&` | قبل: Tenant → بعد: SuperTenant | — |
| 23 | Duplicate النص المطابق | `\bTenant\b` | `$&$&` | بعد: TenantTenant | — |
| 24 | إضافة أقواس حول النص | `\b(TenantEntity)\b` | `($1)` | قبل: TenantEntity → بعد: (TenantEntity) | — |
| 25 | إضافة Quotes | `\b(TenantEntity)\b` | `'$1'` | قبل: TenantEntity → بعد: 'TenantEntity' | — |
| 26 | إزالة Quotes | `'([^']+)'` | `$1` | قبل: 'TenantEntity' → بعد: TenantEntity | — |
| 27 | Double Quote → Single Quote | `"([^"]*)"` | `'$1'` | قبل: "Tenant" → بعد: 'Tenant' | — |
| 28 | Single Quote → Double Quote | `'([^']*)'` | `"$1"` | — | — |
| 29 | إضافة فاصلة في نهاية السطر | `^(.+[^,])$` | `$1,` | قبل: Tenant<br>Account<br>Product → بعد: Tenant,<br>Account,<br>Product, | — |
| 30 | حذف فاصلة في نهاية السطر | `,\s*$` | `(فارغ)` | — | — |
| 31 | حذف نص | `\bView\b` | `(فارغ)` | — | — |
| 32 | حذف TODO | `^\s*//\s*TODO:?.*$` | — | — | — |
| 33 | حذف الأسطر الفارغة الزائدة | `(\r?\n\s*){3,}` | — | — | — |
| 34 | استبدال عدة مسافات بمسافة واحدة | `[ \t]{2,}` | — | — | — |
| 35 | إزالة المسافات في نهاية السطر | `[ \t]+$` | — | — | — |
| 36 | إزالة المسافات في بداية السطر | `^[ \t]+` | — | — | استخدم بحذر مع Dart لأن indentation مهم لقراءة الكود، وإن لم يكن مؤثراً نحوياً. |
| 37 | تحويل underscore-separated إلى ترتيب مختلف | `(\w+)_(\w+)_(\w+)` | `$3_$2_$1` | قبل: tenant_account_group → بعد: group_account_tenant | — |
| 38 | Prefix لكل سطر | `^(.+)$` | `- $1` | قبل: Tenant<br>Account<br>Product → بعد: - Tenant<br>- Account<br>- Product | — |
| 39 | تحويل قائمة إلى Markdown Checkbox | `^(.+)$` | `- [ ] $1` | — | — |
| 40 | تحويل قائمة إلى Quotes | `^(.+)$` | `'$1',` | قبل: tenant<br>account<br>product → بعد: 'tenant',<br>'account',<br>'product', | — |
| 41 | تحويل قائمة إلى Dart List Items | `^(.+)$` | `'$1',` | — | — |
| 42 | تحويل key=value إلى JSON-like | `^(\w+)=(.+)$` | `"$1": "$2",` | قبل: name=Tenant<br>type=Entity → بعد: "name": "Tenant",<br>"type": "Entity", | — |
| 43 | تحويل `key: value` إلى `key=value` | `^(\w+):\s*(.+)$` | `$1=$2` | — | — |
| 44 | إضافة `final` | `^(\s*)(\w+\s+\w+\s*=)` | `$1final $2` | — | Pattern تقريبي. راجع النتائج قبل Replace All. |
| 45 | إزالة `final` | `\bfinal\s+` | — | — | — |
| 46 | إزالة `const` | `\bconst\s+` | — | — | — |
| 47 | إضافة `const` أمام Constructor | `\b(TenantEntity)\(` | `const $1(` | — | — |
| 48 | استبدال Type مع الحفاظ على Nullable | `\bTenantView(\?)?` | `TenantEntity$1` | قبل: TenantView<br>TenantView? → بعد: TenantEntity<br>TenantEntity? | — |
| 49 | تحويل List<View> إلى List<Entity> | `List<([A-Z]\w*)View>` | `List<$1Entity>` | قبل: List<TenantView> → بعد: List<TenantEntity> | — |
| 50 | تحويل Future<View> إلى Future<Entity> | `Future<([A-Z]\w*)View>` | `Future<$1Entity>` | — | — |
| 51 | تحويل Generic View إلى Entity | `<([A-Z]\w*)View>` | `<$1Entity>` | — | — |
| 52 | تغيير اسم parameter | `\btenantView\b` | `tenantEntity` | — | — |
| 53 | تغيير PascalCase + camelCase معاً بشكل منفصل | — | — | TenantView<br>tenantView | — |
| 54 | تغيير Case للحرف الأول | `\b([A-Z])(\w*)\b` | `\l$1$2` | قبل: TenantAccount → بعد: tenantAccount | — |
| 55 | lowercase → Capitalized | `\b([a-z])(\w*)\b` | `\u$1$2` | قبل: tenantAccount → بعد: TenantAccount | — |
| 56 | تحويل Capture بالكامل إلى UPPERCASE | `\b(\w+)\b` | `\U$1` | tenant → TENANT | — |
| 57 | تحويل Capture بالكامل إلى lowercase | `\b(\w+)\b` | `\L$1` | TENANT → tenant | — |
| 58 | تحويل أول حرف فقط إلى uppercase | `\b([a-z])(\w*)\b` | `\u$1$2` | — | — |
| 59 | تحويل أول حرف فقط إلى lowercase | `\b([A-Z])(\w*)\b` | `\l$1$2` | — | — |
| 60 | snake_case → جزأين PascalCase | `\b([a-z]+)_([a-z]+)\b` | `\u$1\u$2` | قبل: tenant_account → بعد: TenantAccount | للأسماء ذات أكثر من جزأين ستحتاج Pattern أو تكراراً إضافياً. |
| 61 | جزأين snake_case → camelCase | `\b([a-z]+)_([a-z]+)\b` | `$1\u$2` | قبل: tenant_account → بعد: tenantAccount | — |
| 62 | استبدال import قديم بمسار جديد | `import 'package:app/features/tenant_account/(.*)';` | `import 'package:app/modules/features/tenant_account/$1';` | — | — |
| 63 | نقل `/features/` إلى `/modules/features/` داخل imports | `(package:[^'"]+)/features/` | `$1/modules/features/` | import 'package:app/features/tenant/domain/domain.dart'; → import 'package:app/modules/features/tenant/domain/domain.dart'; | — |
| 64 | استبدال `/infrastructure/` بـ `/data/` | `/infrastructure/` | `/data/` | — | — |
| 65 | استبدال مسار محدد مع الحفاظ على نهاية المسار | `lib/features/([^/]+)/infrastructure/(.*)` | `lib/features/$1/data/$2` | — | — |
| 66 | تغيير اسم ملف داخل import | `presentation\.dart` | `index.dart` | — | — |
| 67 | حذف import كامل | `^\s*import\s+['"][^'"]*response\.dart['"];\s*\r?\n?` | — | — | — |
| 68 | حذف `part of` محدد | `^\s*part\s+of\s+['"]domain\.dart['"];\s*\r?\n?` | — | — | — |
| 69 | استبدال `part of` بمسار آخر | `part of ['"]([^'"]*)application\.dart['"];` | `part of '$1domain.dart';` | — | — |
| 70 | إعادة تسمية Repository | `\b([A-Z]\w*)RepositoryImpl\b` | `$1Repository` | — | — |
| 71 | إضافة UseCase suffix | `\bclass\s+([A-Z]\w*)(?<!UseCase)\b` | `class $1UseCase` | — | Pattern عام وقد يطابق Classes لا تريد تعديلها. استخدم Files to Include للمجلد `domain/usecases`. |
| 72 | UseCase class داخل مجلد محدد | `\bclass\s+([A-Z]\w+)\b` | `class $1UseCase` | — | لا تستخدمه إذا كان الاسم يحتوي `UseCase` مسبقاً. Files to include: lib/**/domain/usecases/**/*.dart |
| 73 | إزالة كلمة Response من متغير | `\b(\w+)Response\b` | `$1` | قبل: signInResponse → بعد: signIn | — |
| 74 | response → entity في camelCase | `\b(\w+)Response\b` | `$1Entity` | قبل: signInResponse → بعد: signInEntity | — |
| 75 | View → Entity مع PascalCase/camelCase | `\b(\w+)View\b` | `$1Entity` | TenantView<br>tenantView<br>getTenantView → getTenantView | هذا مفيد أحياناً، لكنه واسع. استخدمه بحذر. |
| 76 | استبدال كلمة فقط دون جزء من كلمة | `\bView\b` | `Entity` | TenantView | — |
| 77 | استبدال suffix داخل identifier | `View\b` | `Entity` | TenantView<br>tenantView<br>getTenantView → TenantEntity<br>tenantEntity<br>getTenantEntity | — |
| 78 | استبدال prefix داخل identifier | `\bget` | `fetch` | getTenant<br>getAccount → fetchTenant<br>fetchAccount | — |
| 79 | إضافة كلمة بعد Prefix | `\bget([A-Z])` | `getCurrent$1` | قبل: getTenant → بعد: getCurrentTenant | — |
| 80 | إدخال نص بين جزأين | `\bTenant(View)\b` | `TenantAccount$1` | قبل: TenantView → بعد: TenantAccountView | — |
| 81 | إزالة كلمة وسط الاسم | `\bTenantAccount(View\|Entity)\b` | `Tenant$1` | قبل: TenantAccountView<br>TenantAccountEntity → بعد: TenantView<br>TenantEntity | — |
| 82 | استبدال أكثر من suffix بنفس Entity | `\b([A-Z]\w*)(?:View\|Response\|DTO\|Dto\|Model)\b` | `$1Entity` | قبل: TenantView<br>UserResponse<br>ProductDto<br>AccountModel → بعد: TenantEntity<br>UserEntity<br>ProductEntity<br>AccountEntity | — |
| 83 | إضافة `required` | `^(\s*)(this\.\w+,)$` | `$1required $2` | قبل: this.textTheme, → بعد: required this.textTheme, | استخدم فقط داخل constructor parameters. |
| 84 | إزالة `required` | `\brequired\s+` | `(فارغ)` | — | — |
| 85 | تحويل parameter إلى `required this.x` | `^(\s*)this\.(\w+),$` | `$1required this.$2,` | — | — |
| 86 | إضافة nullable `?` | `\b(TenantEntity)\b` | `$1?` | — | — |
| 87 | إزالة nullable `?` | `\b(TenantEntity)\?` | `$1` | — | — |
| 88 | تحويل Type nullable إلى non-nullable مع الحفاظ على الاسم | `\b([A-Z]\w*)\?` | `$1` | — | واسع جداً. قيد Files to Include أو النوع المستهدف. |
| 89 | إضافة generic wrapper | `\b(TenantEntity)\b` | `List<$1>` | — | — |
| 90 | إزالة List wrapper | `List<([^>]+)>` | `$1` | — | — |
| 91 | Future<T> → T | `Future<([^>]+)>` | `$1` | — | قد لا يناسب nested generics. |
| 92 | T → Future<T> | `\b(TenantEntity)\b` | `Future<$1>` | — | — |
| 93 | إضافة `await` | `^(\s*)(repository\.\w+\()` | `$1await $2` | — | راجع النتائج يدوياً. |
| 94 | إزالة `await` | `\bawait\s+` | `(فارغ)` | — | — |
| 95 | إضافة `return` | `^(\s*)(repository\.\w+\(.*\);)$` | `$1return $2` | — | — |
| 96 | إزالة `return` | `\breturn\s+` | `(فارغ)` | — | — |
| 97 | إضافة `const` لكل Widget معين | `\b(SizedBox\|EdgeInsets\|Duration)\(` | `const $1(` | — | قد ينتج `const const` إذا كانت بعض النتائج تحتوي const مسبقاً. |
| 98 | تجنب const الموجود مسبقاً | `(?<!const\s)\b(SizedBox\|Duration)\(` | `const $1(` | — | يعتمد على دعم Lookbehind في وضع البحث المستخدم. |
| 99 | إعادة ترتيب Function parameters نصياً | `foo\(([^,]+),\s*([^)]+)\)` | `foo($2, $1)` | قبل: foo(name, id) → بعد: foo(id, name) | — |
| 100 | إعادة ترتيب Constructor named parameters | `Tenant\(name:\s*([^,]+),\s*id:\s*([^)]+)\)` | `Tenant(id: $2, name: $1)` | قبل: Tenant(name: name, id: id) | — |
| 101 | فصل camelCase بصورة بسيطة | `([a-z])([A-Z])` | `$1 $2` | قبل: tenantAccountGroup → بعد: tenant Account Group | — |
| 102 | PascalCase → كلمات مفصولة | `([a-z0-9])([A-Z])` | `$1 $2` | — | — |
| 103 | استبدال المسافة بـ underscore | `\s+` | `_` | قبل: tenant account group → بعد: tenant_account_group | — |
| 104 | underscore → space | `_` | — | — | — |
| 105 | dash → underscore | `-` | `_` | — | — |
| 106 | underscore → dash | `_` | `-` | — | — |
| 107 | حذف رقم suffix | `\b(\w+)\d+\b` | `$1` | قبل: TenantView2 → بعد: TenantView | — |
| 108 | إضافة رقم suffix | `\b(TenantView)\b` | `$1V2` | — | — |
| 109 | حذف أقواس حول قيمة | `\(([^()]+)\)` | `$1` | — | Pattern بسيط ولا يناسب nested parentheses. |
| 110 | إضافة `this.` | `\b(value)\b` | `this.$1` | — | — |
| 111 | إزالة `this.` | `\bthis\.(\w+)` | `$1` | — | — |
| 112 | `Map<String, dynamic>` → typedef مخصص | `\bMap<String,\s*dynamic>\b` | `JsonMap` | — | — |
| 113 | `dynamic` → Object? | `\bdynamic\b` | `Object?` | — | لا تستخدم Replace All دون مراجعة المعنى. |
| 114 | `print` → `debugPrint` | `\bprint\s*\(` | `debugPrint(` | — | — |
| 115 | `debugPrint` → logger | `\bdebugPrint\s*\((.*)\);` | `logger.debug($1);` | — | إذا احتوى التعبير الداخلي أقواساً أو أسطر متعددة فقد تحتاج Pattern أدق. |
| 116 | إضافة تعليق قبل كل تطابق | `^(\s*)(class\s+\w+View.*)$` | `$1// TODO: migrate View to Entity<br>$1$2` | — | يمكن إدخال سطر جديد مباشرة في مربع Replace. في بعض البيئات قد تحتاج استخدام Enter/Shift+Enter حسب واجهة VS Code. |
| 117 | إضافة سطر بعد كل تطابق | `^(.*TODO.*)$` | `$1` | — | — |
| 118 | تحويل import إلى export | `^\s*import\s+(['"][^'"]+['"]);\s*$` | `export $1;` | — | — |
| 119 | تحويل export إلى import | `^\s*export\s+(['"][^'"]+['"]);\s*$` | `import $1;` | — | — |
| 120 | تغيير quotes في imports فقط | `import\s+"([^"]+)";` | `import '$1';` | — | — |
| 121 | إزالة `.dart` من نصوص المسارات | `\.dart\b` | `(فارغ)` | — | — |
| 122 | إضافة `.dart` | `\b([\w/]+)(?<!\.dart)\b` | `$1.dart` | — | Pattern عام جداً، يفضّل استخدامه على قائمة مسارات فقط. |
| 123 | استبدال package name | `package:old_app/` | `package:new_app/` | — | — |
| 124 | نقل feature path مع Capture | `package:app/features/([^/]+)/(.*)` | `package:app/modules/features/$1/$2` | — | — |
| 125 | الحفاظ على indentation | `^(\s*)oldText` | `$1newText` | — | — |
| 126 | الحفاظ على نهاية السطر | `^(\s*)(.+);$` | `$1$2,` | final a = 1; → final a = 1, | — |
| 127 | Wrap النص داخل function | `\b(TenantEntity)\b` | `wrap($1)` | — | — |
| 128 | Wrap التعبير بالكامل | `repository\.\w+\([^;]*\)` | `await $&` | — | — |
| 129 | استخدام Named Groups لإعادة ترتيب أوضح | `(?<first>\w+)_(?<second>\w+)` | `$<second>_$<first>` | قبل: tenant_account → بعد: account_tenant | — |
| 130 | Replace All آمن لنوع محدد | — | `TenantProductEntity` | \b(\w+)View\b → \bTenantProductView\b | — |
| 131 | جدول Cheat Sheet سريع | — | راجع Cheat Sheet أسفل الملف | — | — |
| 132 | قواعد مهمة جداً قبل Replace All | — | قواعد أمان قبل Replace All | — | — |
| 133 | مثال عملي قريب من بحثك الحالي | `\bget[A-Za-z0-9_]*View\b` | `getTenantView<br>getAccountView<br>getProductDetailsView` | \bget[A-Za-z0-9_]*View\b → getTenantView<br>getAccountView<br>getProductDetailsView | ضع الجزء الأوسط داخل Capture Group ثم أعد استخدامه عبر `$1`. |

---

## رموز Replace الأساسية

| الرمز | المعنى | مثال |
|---|---|---|
| `$1` | محتوى Capture Group رقم 1 | `get(\w+)View` → `get$1Entity` |
| `$2` | محتوى Capture Group رقم 2 | `(\w+)_(\w+)` → `$2_$1` |
| `$3` | محتوى Capture Group رقم 3 | يستخدم عند وجود 3 مجموعات أو أكثر |
| `$&` | كامل النص المطابق | `Tenant` → `Super$&` |
| `$$` | علامة `$` حرفية | `value` → `$$value` |
| `$<name>` | Named Capture Group | `(?<name>\w+)View` → `$<name>Entity` |
| `\u` | Uppercase للحرف التالي | `\u$1` |
| `\l` | lowercase للحرف التالي | `\l$1` |
| `\U` | UPPERCASE لما يلي | `\U$1` |
| `\L` | lowercase لما يلي | `\L$1` |

## Cheat Sheet سريع

| المطلوب | Search | Replace |
|---|---|---|
| `View → Entity` | `\b([A-Z]\w*)View\b` | `$1Entity` |
| `get...View → get...Entity` | `\bget(\w*)View\b` | `get$1Entity` |
| `Response → Entity` | `\b([A-Z]\w*)Response\b` | `$1Entity` |
| `DTO → Entity` | `\b([A-Z]\w*)(?:Dto\|DTO)\b` | `$1Entity` |
| `Model → Entity` | `\b([A-Z]\w*)Model\b` | `$1Entity` |
| حذف `View` | `\b(\w+)View\b` | `$1` |
| حذف `Super` | `\bSuper(\w+)\b` | `$1` |
| تبديل جزأين | `(\w+)_(\w+)` | `$2_$1` |
| Uppercase أول حرف | `\b([a-z])(\w*)\b` | `\u$1$2` |
| Lowercase أول حرف | `\b([A-Z])(\w*)\b` | `\l$1$2` |
| إزالة `this.` | `\bthis\.(\w+)` | `$1` |
| `print → debugPrint` | `\bprint\s*\(` | `debugPrint(` |
| تغيير package | `package:old_app/` | `package:new_app/` |

---

## الشرح التفصيلي

دليل عملي لشرح **Replace / Replace All** في Visual Studio Code، مع التركيز على استخدام **Regular Expressions (Regex)** في عمليات إعادة التسمية، إعادة ترتيب النصوص، حذف أجزاء من النص، وإعادة هيكلة أسماء Dart / Flutter.

> عند استخدام أي Search يحتوي Regex، فعّل زر **Use Regular Expression `.*`** في مربع البحث.

---

## 1) الفكرة الأساسية

في VS Code لديك خانتان:

| الحقل | الوظيفة |
|---|---|
| **Search** | يحدد النص أو النمط الذي تريد العثور عليه |
| **Replace** | يحدد النص الجديد الذي سيحل محل كل تطابق |

مثال بسيط:

| Search | Replace |
|---|---|
| `TenantView` | `TenantEntity` |

قبل:

```text
TenantView
```

بعد:

```text
TenantEntity
```

---

# 2) أهم رموز Replace

| الرمز في Replace | المعنى | مثال |
|---|---|---|
| `$1` | محتوى Capture Group رقم 1 | `get(\w+)View` → `get$1Entity` |
| `$2` | محتوى Capture Group رقم 2 | `(\w+)_(\w+)` → `$2_$1` |
| `$3` | محتوى Capture Group رقم 3 | حسب عدد المجموعات |
| `$&` | كامل النص المطابق | `Tenant` → `Super$&` |
| `$$` | علامة `$` حرفية | Replace بـ `$$value` لإنتاج `$value` |
| `$<name>` | Named Capture Group | `(?<name>\w+)View` → `$<name>Entity` |
| `\u` | تحويل الحرف التالي إلى Uppercase | `\u$1` |
| `\l` | تحويل الحرف التالي إلى lowercase | `\l$1` |
| `\U` | تحويل ما يلي إلى UPPERCASE | `\U$1` |
| `\L` | تحويل ما يلي إلى lowercase | `\L$1` |

> ملاحظة: أوامر تغيير حالة الأحرف `\u`, `\l`, `\U`, `\L` مدعومة في VS Code Replace، لكن سلوكها قد يختلف في بعض البيئات أو الإضافات.

---

# 3) Capture Groups

Capture Group هي أي جزء داخل:

```regex
(...)
```

مثال:

Search:

```regex
get(\w+)View
```

النص:

```text
getTenantView
```

تكون:

```text
$1 = Tenant
```

Replace:

```text
get$1Entity
```

النتيجة:

```text
getTenantEntity
```

---

# 4) أكثر من Capture Group

Search:

```regex
(\w+)_(\w+)
```

النص:

```text
tenant_account
```

القيم:

```text
$1 = tenant
$2 = account
```

Replace:

```text
$2_$1
```

النتيجة:

```text
account_tenant
```

---

# 5) جدول أساسيات الاستبدال

| المطلوب | Search | Replace | قبل | بعد |
|---|---|---|---|---|
| استبدال نص مباشر | `View` | `Entity` | `TenantView` | `TenantEntity` |
| إضافة Prefix | `(Tenant)` | `Super$1` | `Tenant` | `SuperTenant` |
| إضافة Suffix | `(Tenant)` | `$1Entity` | `Tenant` | `TenantEntity` |
| حذف Prefix | `Super(\w+)` | `$1` | `SuperTenant` | `Tenant` |
| حذف Suffix | `(\w+)View` | `$1` | `TenantView` | `Tenant` |
| إعادة ترتيب جزأين | `(\w+)_(\w+)` | `$2_$1` | `tenant_account` | `account_tenant` |
| الاحتفاظ بالتطابق كاملاً | `Tenant` | `Super$&` | `Tenant` | `SuperTenant` |
| إنتاج `$` حرفية | `value` | `$$value` | `value` | `$value` |

---

# 6) View → Entity

Search:

```regex
\b([A-Z]\w*)View\b
```

Replace:

```text
$1Entity
```

قبل:

```text
TenantView
TenantAccountView
TenantProductView
```

بعد:

```text
TenantEntity
TenantAccountEntity
TenantProductEntity
```

---

# 7) get...View → get...Entity

Search:

```regex
\bget(\w*)View\b
```

Replace:

```text
get$1Entity
```

قبل:

```text
getTenantView
getAccountView
getProductDetailsView
```

بعد:

```text
getTenantEntity
getAccountEntity
getProductDetailsEntity
```

---

# 8) Response → Entity

Search:

```regex
\b([A-Z]\w*)Response\b
```

Replace:

```text
$1Entity
```

قبل:

```text
SignInResponse
TenantResponse
UserResponse
```

بعد:

```text
SignInEntity
TenantEntity
UserEntity
```

---

# 9) DTO → Entity

Search:

```regex
\b([A-Z]\w*)(?:Dto|DTO)\b
```

Replace:

```text
$1Entity
```

قبل:

```text
UserDto
TenantDTO
```

بعد:

```text
UserEntity
TenantEntity
```

---

# 10) Model → Entity

Search:

```regex
\b([A-Z]\w*)Model\b
```

Replace:

```text
$1Entity
```

---

# 11) حذف Suffix

Search:

```regex
\b(\w+)View\b
```

Replace:

```text
$1
```

قبل:

```text
TenantAccountView
```

بعد:

```text
TenantAccount
```

---

# 12) إضافة Suffix

Search:

```regex
\b(TenantAccount)\b
```

Replace:

```text
$1Entity
```

قبل:

```text
TenantAccount
```

بعد:

```text
TenantAccountEntity
```

---

# 13) حذف Prefix

Search:

```regex
\bSuper(\w+)\b
```

Replace:

```text
$1
```

قبل:

```text
SuperTextTheme
SuperCard
```

بعد:

```text
TextTheme
Card
```

---

# 14) إضافة Prefix

Search:

```regex
\b(TextTheme)\b
```

Replace:

```text
Super$1
```

قبل:

```text
TextTheme
```

بعد:

```text
SuperTextTheme
```

---

# 15) إعادة ترتيب الكلمات

Search:

```regex
\b(\w+)_(\w+)\b
```

Replace:

```text
$2_$1
```

قبل:

```text
tenant_account
```

بعد:

```text
account_tenant
```

---

# 16) camelCase → Prefix جديد

Search:

```regex
\bget([A-Z]\w*)\b
```

Replace:

```text
fetch$1
```

قبل:

```text
getTenantAccount
```

بعد:

```text
fetchTenantAccount
```

---

# 17) create → add

Search:

```regex
\bcreate([A-Z]\w*)\b
```

Replace:

```text
add$1
```

قبل:

```text
createTenant
createAccount
```

بعد:

```text
addTenant
addAccount
```

---

# 18) update → edit

Search:

```regex
\bupdate([A-Z]\w*)\b
```

Replace:

```text
edit$1
```

---

# 19) delete → remove

Search:

```regex
\bdelete([A-Z]\w*)\b
```

Replace:

```text
remove$1
```

---

# 20) Rename Class مع الحفاظ على الاسم

Search:

```regex
class\s+(\w+)View\b
```

Replace:

```text
class $1Entity
```

قبل:

```dart
class TenantView {
```

بعد:

```dart
class TenantEntity {
```

---

# 21) Named Capture Groups

Search:

```regex
(?<name>[A-Z]\w*)View
```

Replace:

```text
$<name>Entity
```

قبل:

```text
TenantAccountView
```

بعد:

```text
TenantAccountEntity
```

---

# 22) إضافة النص المطابق نفسه باستخدام `$&`

Search:

```regex
\bTenant\b
```

Replace:

```text
Super$&
```

قبل:

```text
Tenant
```

بعد:

```text
SuperTenant
```

---

# 23) Duplicate النص المطابق

Search:

```regex
\bTenant\b
```

Replace:

```text
$&$&
```

بعد:

```text
TenantTenant
```

---

# 24) إضافة أقواس حول النص

Search:

```regex
\b(TenantEntity)\b
```

Replace:

```text
($1)
```

قبل:

```text
TenantEntity
```

بعد:

```text
(TenantEntity)
```

---

# 25) إضافة Quotes

Search:

```regex
\b(TenantEntity)\b
```

Replace:

```text
'$1'
```

قبل:

```text
TenantEntity
```

بعد:

```text
'TenantEntity'
```

---

# 26) إزالة Quotes

Search:

```regex
'([^']+)'
```

Replace:

```text
$1
```

قبل:

```text
'TenantEntity'
```

بعد:

```text
TenantEntity
```

---

# 27) Double Quote → Single Quote

Search:

```regex
"([^"]*)"
```

Replace:

```text
'$1'
```

قبل:

```text
"Tenant"
```

بعد:

```text
'Tenant'
```

---

# 28) Single Quote → Double Quote

Search:

```regex
'([^']*)'
```

Replace:

```text
"$1"
```

---

# 29) إضافة فاصلة في نهاية السطر

Search:

```regex
^(.+[^,])$
```

Replace:

```text
$1,
```

قبل:

```text
Tenant
Account
Product
```

بعد:

```text
Tenant,
Account,
Product,
```

---

# 30) حذف فاصلة في نهاية السطر

Search:

```regex
,\s*$
```

Replace:

```text

```

أي اجعل Replace فارغاً.

---

# 31) حذف نص

أي Search يمكن حذفه بجعل Replace فارغاً.

مثال:

Search:

```regex
\bView\b
```

Replace:

```text

```

---

# 32) حذف TODO

Search:

```regex
^\s*//\s*TODO:?.*$
```

Replace:

```text

```

---

# 33) حذف الأسطر الفارغة الزائدة

Search:

```regex
(\r?\n\s*){3,}
```

Replace:

```text


```

أي ضع سطرين فقط حسب النتيجة المطلوبة.

---

# 34) استبدال عدة مسافات بمسافة واحدة

Search:

```regex
[ \t]{2,}
```

Replace:

```text

```

---

# 35) إزالة المسافات في نهاية السطر

Search:

```regex
[ \t]+$
```

Replace:

```text

```

---

# 36) إزالة المسافات في بداية السطر

Search:

```regex
^[ \t]+
```

Replace:

```text

```

> استخدم بحذر مع Dart لأن indentation مهم لقراءة الكود، وإن لم يكن مؤثراً نحوياً.

---

# 37) تحويل underscore-separated إلى ترتيب مختلف

Search:

```regex
(\w+)_(\w+)_(\w+)
```

Replace:

```text
$3_$2_$1
```

قبل:

```text
tenant_account_group
```

بعد:

```text
group_account_tenant
```

---

# 38) Prefix لكل سطر

Search:

```regex
^(.+)$
```

Replace:

```text
- $1
```

قبل:

```text
Tenant
Account
Product
```

بعد:

```text
- Tenant
- Account
- Product
```

---

# 39) تحويل قائمة إلى Markdown Checkbox

Search:

```regex
^(.+)$
```

Replace:

```text
- [ ] $1
```

---

# 40) تحويل قائمة إلى Quotes

Search:

```regex
^(.+)$
```

Replace:

```text
'$1',
```

قبل:

```text
tenant
account
product
```

بعد:

```text
'tenant',
'account',
'product',
```

---

# 41) تحويل قائمة إلى Dart List Items

Search:

```regex
^(.+)$
```

Replace:

```text
  '$1',
```

---

# 42) تحويل key=value إلى JSON-like

Search:

```regex
^(\w+)=(.+)$
```

Replace:

```text
"$1": "$2",
```

قبل:

```text
name=Tenant
type=Entity
```

بعد:

```text
"name": "Tenant",
"type": "Entity",
```

---

# 43) تحويل `key: value` إلى `key=value`

Search:

```regex
^(\w+):\s*(.+)$
```

Replace:

```text
$1=$2
```

---

# 44) إضافة `final`

Search:

```regex
^(\s*)(\w+\s+\w+\s*=)
```

Replace:

```text
$1final $2
```

> Pattern تقريبي. راجع النتائج قبل Replace All.

---

# 45) إزالة `final`

Search:

```regex
\bfinal\s+
```

Replace:

```text

```

---

# 46) إزالة `const`

Search:

```regex
\bconst\s+
```

Replace:

```text

```

---

# 47) إضافة `const` أمام Constructor

Search:

```regex
\b(TenantEntity)\(
```

Replace:

```text
const $1(
```

---

# 48) استبدال Type مع الحفاظ على Nullable

Search:

```regex
\bTenantView(\?)?
```

Replace:

```text
TenantEntity$1
```

قبل:

```dart
TenantView
TenantView?
```

بعد:

```dart
TenantEntity
TenantEntity?
```

---

# 49) تحويل List<View> إلى List<Entity>

Search:

```regex
List<([A-Z]\w*)View>
```

Replace:

```text
List<$1Entity>
```

قبل:

```dart
List<TenantView>
```

بعد:

```dart
List<TenantEntity>
```

---

# 50) تحويل Future<View> إلى Future<Entity>

Search:

```regex
Future<([A-Z]\w*)View>
```

Replace:

```text
Future<$1Entity>
```

---

# 51) تحويل Generic View إلى Entity

Search:

```regex
<([A-Z]\w*)View>
```

Replace:

```text
<$1Entity>
```

---

# 52) تغيير اسم parameter

Search:

```regex
\btenantView\b
```

Replace:

```text
tenantEntity
```

---

# 53) تغيير PascalCase + camelCase معاً بشكل منفصل

الأسماء التالية:

```text
TenantView
tenantView
```

تحتاج غالباً عمليتي Replace منفصلتين:

| Search | Replace |
|---|---|
| `\bTenantView\b` | `TenantEntity` |
| `\btenantView\b` | `tenantEntity` |

هذا أكثر أماناً من Pattern عام.

---

# 54) تغيير Case للحرف الأول

Search:

```regex
\b([A-Z])(\w*)\b
```

Replace:

```text
\l$1$2
```

قبل:

```text
TenantAccount
```

بعد:

```text
tenantAccount
```

---

# 55) lowercase → Capitalized

Search:

```regex
\b([a-z])(\w*)\b
```

Replace:

```text
\u$1$2
```

قبل:

```text
tenantAccount
```

بعد:

```text
TenantAccount
```

---

# 56) تحويل Capture بالكامل إلى UPPERCASE

Search:

```regex
\b(\w+)\b
```

Replace:

```text
\U$1
```

مثال:

```text
tenant
```

إلى:

```text
TENANT
```

---

# 57) تحويل Capture بالكامل إلى lowercase

Search:

```regex
\b(\w+)\b
```

Replace:

```text
\L$1
```

مثال:

```text
TENANT
```

إلى:

```text
tenant
```

---

# 58) تحويل أول حرف فقط إلى uppercase

Search:

```regex
\b([a-z])(\w*)\b
```

Replace:

```text
\u$1$2
```

---

# 59) تحويل أول حرف فقط إلى lowercase

Search:

```regex
\b([A-Z])(\w*)\b
```

Replace:

```text
\l$1$2
```

---

# 60) snake_case → جزأين PascalCase

Search:

```regex
\b([a-z]+)_([a-z]+)\b
```

Replace:

```text
\u$1\u$2
```

قبل:

```text
tenant_account
```

بعد:

```text
TenantAccount
```

> للأسماء ذات أكثر من جزأين ستحتاج Pattern أو تكراراً إضافياً.

---

# 61) جزأين snake_case → camelCase

Search:

```regex
\b([a-z]+)_([a-z]+)\b
```

Replace:

```text
$1\u$2
```

قبل:

```text
tenant_account
```

بعد:

```text
tenantAccount
```

---

# 62) استبدال import قديم بمسار جديد

Search:

```regex
import 'package:app/features/tenant_account/(.*)';
```

Replace:

```text
import 'package:app/modules/features/tenant_account/$1';
```

---

# 63) نقل `/features/` إلى `/modules/features/` داخل imports

Search:

```regex
(package:[^'"]+)/features/
```

Replace:

```text
$1/modules/features/
```

مثال:

```dart
import 'package:app/features/tenant/domain/domain.dart';
```

يصبح:

```dart
import 'package:app/modules/features/tenant/domain/domain.dart';
```

---

# 64) استبدال `/infrastructure/` بـ `/data/`

Search:

```regex
/infrastructure/
```

Replace:

```text
/data/
```

---

# 65) استبدال مسار محدد مع الحفاظ على نهاية المسار

Search:

```regex
lib/features/([^/]+)/infrastructure/(.*)
```

Replace:

```text
lib/features/$1/data/$2
```

---

# 66) تغيير اسم ملف داخل import

Search:

```regex
presentation\.dart
```

Replace:

```text
index.dart
```

---

# 67) حذف import كامل

Search:

```regex
^\s*import\s+['"][^'"]*response\.dart['"];\s*\r?\n?
```

Replace:

```text

```

---

# 68) حذف `part of` محدد

Search:

```regex
^\s*part\s+of\s+['"]domain\.dart['"];\s*\r?\n?
```

Replace:

```text

```

---

# 69) استبدال `part of` بمسار آخر

Search:

```regex
part of ['"]([^'"]*)application\.dart['"];
```

Replace:

```text
part of '$1domain.dart';
```

---

# 70) إعادة تسمية Repository

Search:

```regex
\b([A-Z]\w*)RepositoryImpl\b
```

Replace:

```text
$1Repository
```

---

# 71) إضافة UseCase suffix

Search:

```regex
\bclass\s+([A-Z]\w*)(?<!UseCase)\b
```

Replace:

```text
class $1UseCase
```

> Pattern عام وقد يطابق Classes لا تريد تعديلها. استخدم Files to Include للمجلد `domain/usecases`.

---

# 72) UseCase class داخل مجلد محدد

Files to include:

```glob
lib/**/domain/usecases/**/*.dart
```

Search:

```regex
\bclass\s+([A-Z]\w+)\b
```

Replace:

```text
class $1UseCase
```

> لا تستخدمه إذا كان الاسم يحتوي `UseCase` مسبقاً.

---

# 73) إزالة كلمة Response من متغير

Search:

```regex
\b(\w+)Response\b
```

Replace:

```text
$1
```

قبل:

```text
signInResponse
```

بعد:

```text
signIn
```

---

# 74) response → entity في camelCase

Search:

```regex
\b(\w+)Response\b
```

Replace:

```text
$1Entity
```

قبل:

```text
signInResponse
```

بعد:

```text
signInEntity
```

---

# 75) View → Entity مع PascalCase/camelCase

Search:

```regex
\b(\w+)View\b
```

Replace:

```text
$1Entity
```

يطابق:

```text
TenantView
tenantView
getTenantView
```

لكن سيحوّل:

```text
getTenantView
```

إلى:

```text
getTenantEntity
```

> هذا مفيد أحياناً، لكنه واسع. استخدمه بحذر.

---

# 76) استبدال كلمة فقط دون جزء من كلمة

Search:

```regex
\bView\b
```

Replace:

```text
Entity
```

لن يغير:

```text
TenantView
```

لأن `View` جزء من identifier واحد.

---

# 77) استبدال suffix داخل identifier

Search:

```regex
View\b
```

Replace:

```text
Entity
```

سيغير:

```text
TenantView
tenantView
getTenantView
```

إلى:

```text
TenantEntity
tenantEntity
getTenantEntity
```

---

# 78) استبدال prefix داخل identifier

Search:

```regex
\bget
```

Replace:

```text
fetch
```

سيغير:

```text
getTenant
getAccount
```

إلى:

```text
fetchTenant
fetchAccount
```

---

# 79) إضافة كلمة بعد Prefix

Search:

```regex
\bget([A-Z])
```

Replace:

```text
getCurrent$1
```

قبل:

```text
getTenant
```

بعد:

```text
getCurrentTenant
```

---

# 80) إدخال نص بين جزأين

Search:

```regex
\bTenant(View)\b
```

Replace:

```text
TenantAccount$1
```

قبل:

```text
TenantView
```

بعد:

```text
TenantAccountView
```

---

# 81) إزالة كلمة وسط الاسم

Search:

```regex
\bTenantAccount(View|Entity)\b
```

Replace:

```text
Tenant$1
```

قبل:

```text
TenantAccountView
TenantAccountEntity
```

بعد:

```text
TenantView
TenantEntity
```

---

# 82) استبدال أكثر من suffix بنفس Entity

Search:

```regex
\b([A-Z]\w*)(?:View|Response|DTO|Dto|Model)\b
```

Replace:

```text
$1Entity
```

قبل:

```text
TenantView
UserResponse
ProductDto
AccountModel
```

بعد:

```text
TenantEntity
UserEntity
ProductEntity
AccountEntity
```

---

# 83) إضافة `required`

Search:

```regex
^(\s*)(this\.\w+,)$
```

Replace:

```text
$1required $2
```

قبل:

```dart
this.textTheme,
```

بعد:

```dart
required this.textTheme,
```

> استخدم فقط داخل constructor parameters.

---

# 84) إزالة `required`

Search:

```regex
\brequired\s+
```

Replace فارغ.

---

# 85) تحويل parameter إلى `required this.x`

Search:

```regex
^(\s*)this\.(\w+),$
```

Replace:

```text
$1required this.$2,
```

---

# 86) إضافة nullable `?`

Search:

```regex
\b(TenantEntity)\b
```

Replace:

```text
$1?
```

---

# 87) إزالة nullable `?`

Search:

```regex
\b(TenantEntity)\?
```

Replace:

```text
$1
```

---

# 88) تحويل Type nullable إلى non-nullable مع الحفاظ على الاسم

Search:

```regex
\b([A-Z]\w*)\?
```

Replace:

```text
$1
```

> واسع جداً. قيد Files to Include أو النوع المستهدف.

---

# 89) إضافة generic wrapper

Search:

```regex
\b(TenantEntity)\b
```

Replace:

```text
List<$1>
```

---

# 90) إزالة List wrapper

Search:

```regex
List<([^>]+)>
```

Replace:

```text
$1
```

---

# 91) Future<T> → T

Search:

```regex
Future<([^>]+)>
```

Replace:

```text
$1
```

> قد لا يناسب nested generics.

---

# 92) T → Future<T>

Search:

```regex
\b(TenantEntity)\b
```

Replace:

```text
Future<$1>
```

---

# 93) إضافة `await`

Search:

```regex
^(\s*)(repository\.\w+\()
```

Replace:

```text
$1await $2
```

> راجع النتائج يدوياً.

---

# 94) إزالة `await`

Search:

```regex
\bawait\s+
```

Replace فارغ.

---

# 95) إضافة `return`

Search:

```regex
^(\s*)(repository\.\w+\(.*\);)$
```

Replace:

```text
$1return $2
```

---

# 96) إزالة `return`

Search:

```regex
\breturn\s+
```

Replace فارغ.

---

# 97) إضافة `const` لكل Widget معين

Search:

```regex
\b(SizedBox|EdgeInsets|Duration)\(
```

Replace:

```text
const $1(
```

> قد ينتج `const const` إذا كانت بعض النتائج تحتوي const مسبقاً.

---

# 98) تجنب const الموجود مسبقاً

Search:

```regex
(?<!const\s)\b(SizedBox|Duration)\(
```

Replace:

```text
const $1(
```

> يعتمد على دعم Lookbehind في وضع البحث المستخدم.

---

# 99) إعادة ترتيب Function parameters نصياً

قبل:

```text
foo(name, id)
```

Search:

```regex
foo\(([^,]+),\s*([^)]+)\)
```

Replace:

```text
foo($2, $1)
```

بعد:

```text
foo(id, name)
```

---

# 100) إعادة ترتيب Constructor named parameters

قبل:

```text
Tenant(name: name, id: id)
```

Search:

```regex
Tenant\(name:\s*([^,]+),\s*id:\s*([^)]+)\)
```

Replace:

```text
Tenant(id: $2, name: $1)
```

---

# 101) فصل camelCase بصورة بسيطة

Search:

```regex
([a-z])([A-Z])
```

Replace:

```text
$1 $2
```

قبل:

```text
tenantAccountGroup
```

بعد:

```text
tenant Account Group
```

---

# 102) PascalCase → كلمات مفصولة

Search:

```regex
([a-z0-9])([A-Z])
```

Replace:

```text
$1 $2
```

---

# 103) استبدال المسافة بـ underscore

Search:

```regex
\s+
```

Replace:

```text
_
```

قبل:

```text
tenant account group
```

بعد:

```text
tenant_account_group
```

---

# 104) underscore → space

Search:

```regex
_
```

Replace:

```text

```

---

# 105) dash → underscore

Search:

```regex
-
```

Replace:

```text
_
```

---

# 106) underscore → dash

Search:

```regex
_
```

Replace:

```text
-
```

---

# 107) حذف رقم suffix

Search:

```regex
\b(\w+)\d+\b
```

Replace:

```text
$1
```

قبل:

```text
TenantView2
```

بعد:

```text
TenantView
```

---

# 108) إضافة رقم suffix

Search:

```regex
\b(TenantView)\b
```

Replace:

```text
$1V2
```

---

# 109) حذف أقواس حول قيمة

Search:

```regex
\(([^()]+)\)
```

Replace:

```text
$1
```

> Pattern بسيط ولا يناسب nested parentheses.

---

# 110) إضافة `this.`

Search:

```regex
\b(value)\b
```

Replace:

```text
this.$1
```

---

# 111) إزالة `this.`

Search:

```regex
\bthis\.(\w+)
```

Replace:

```text
$1
```

---

# 112) `Map<String, dynamic>` → typedef مخصص

Search:

```regex
\bMap<String,\s*dynamic>\b
```

Replace:

```text
JsonMap
```

---

# 113) `dynamic` → Object?

Search:

```regex
\bdynamic\b
```

Replace:

```text
Object?
```

> لا تستخدم Replace All دون مراجعة المعنى.

---

# 114) `print` → `debugPrint`

Search:

```regex
\bprint\s*\(
```

Replace:

```text
debugPrint(
```

---

# 115) `debugPrint` → logger

Search:

```regex
\bdebugPrint\s*\((.*)\);
```

Replace:

```text
logger.debug($1);
```

> إذا احتوى التعبير الداخلي أقواساً أو أسطر متعددة فقد تحتاج Pattern أدق.

---

# 116) إضافة تعليق قبل كل تطابق

Search:

```regex
^(\s*)(class\s+\w+View.*)$
```

Replace:

```text
$1// TODO: migrate View to Entity
$1$2
```

> يمكن إدخال سطر جديد مباشرة في مربع Replace. في بعض البيئات قد تحتاج استخدام Enter/Shift+Enter حسب واجهة VS Code.

---

# 117) إضافة سطر بعد كل تطابق

Search:

```regex
^(.*TODO.*)$
```

Replace:

```text
$1

```

---

# 118) تحويل import إلى export

Search:

```regex
^\s*import\s+(['"][^'"]+['"]);\s*$
```

Replace:

```text
export $1;
```

---

# 119) تحويل export إلى import

Search:

```regex
^\s*export\s+(['"][^'"]+['"]);\s*$
```

Replace:

```text
import $1;
```

---

# 120) تغيير quotes في imports فقط

Search:

```regex
import\s+"([^"]+)";
```

Replace:

```text
import '$1';
```

---

# 121) إزالة `.dart` من نصوص المسارات

Search:

```regex
\.dart\b
```

Replace فارغ.

---

# 122) إضافة `.dart`

Search:

```regex
\b([\w/]+)(?<!\.dart)\b
```

Replace:

```text
$1.dart
```

> Pattern عام جداً، يفضّل استخدامه على قائمة مسارات فقط.

---

# 123) استبدال package name

Search:

```regex
package:old_app/
```

Replace:

```text
package:new_app/
```

---

# 124) نقل feature path مع Capture

Search:

```regex
package:app/features/([^/]+)/(.*)
```

Replace:

```text
package:app/modules/features/$1/$2
```

---

# 125) الحفاظ على indentation

Search:

```regex
^(\s*)oldText
```

Replace:

```text
$1newText
```

`$1` هنا يحفظ المسافات الموجودة في بداية السطر.

---

# 126) الحفاظ على نهاية السطر

Search:

```regex
^(\s*)(.+);$
```

Replace:

```text
$1$2,
```

يحوّل:

```dart
final a = 1;
```

إلى:

```dart
final a = 1,
```

---

# 127) Wrap النص داخل function

Search:

```regex
\b(TenantEntity)\b
```

Replace:

```text
wrap($1)
```

---

# 128) Wrap التعبير بالكامل

Search:

```regex
repository\.\w+\([^;]*\)
```

Replace:

```text
await $&
```

`$&` يعني كامل النص المطابق.

---

# 129) استخدام Named Groups لإعادة ترتيب أوضح

Search:

```regex
(?<first>\w+)_(?<second>\w+)
```

Replace:

```text
$<second>_$<first>
```

قبل:

```text
tenant_account
```

بعد:

```text
account_tenant
```

---

# 130) Replace All آمن لنوع محدد

بدلاً من:

```regex
\b(\w+)View\b
```

استخدم:

```regex
\bTenantProductView\b
```

Replace:

```text
TenantProductEntity
```

هذا أقل مرونة لكنه أكثر أماناً عند refactoring كبير.

---

# 131) جدول Cheat Sheet سريع

| المطلوب | Search | Replace |
|---|---|---|
| View → Entity | `\b([A-Z]\w*)View\b` | `$1Entity` |
| get...View → get...Entity | `\bget(\w*)View\b` | `get$1Entity` |
| Response → Entity | `\b([A-Z]\w*)Response\b` | `$1Entity` |
| DTO → Entity | `\b([A-Z]\w*)(?:Dto|DTO)\b` | `$1Entity` |
| Model → Entity | `\b([A-Z]\w*)Model\b` | `$1Entity` |
| حذف View | `\b(\w+)View\b` | `$1` |
| إضافة Entity | `\b(Tenant)\b` | `$1Entity` |
| حذف Super | `\bSuper(\w+)\b` | `$1` |
| إضافة Super | `\b(TextTheme)\b` | `Super$1` |
| تبديل جزأين | `(\w+)_(\w+)` | `$2_$1` |
| كامل التطابق | `Tenant` | `Super$&` |
| `$` حرفية | `value` | `$$value` |
| Uppercase أول حرف | `\b([a-z])(\w*)\b` | `\u$1$2` |
| Lowercase أول حرف | `\b([A-Z])(\w*)\b` | `\l$1$2` |
| UPPERCASE الكل | `\b(\w+)\b` | `\U$1` |
| lowercase الكل | `\b(\w+)\b` | `\L$1` |
| حذف مسافات نهاية السطر | `[ \t]+$` | فارغ |
| دمج مسافات | `[ \t]{2,}` | مسافة واحدة |
| إضافة Prefix لكل سطر | `^(.+)$` | `- $1` |
| Quotes لكل سطر | `^(.+)$` | `'$1',` |
| import → export | `^\s*import\s+(['"][^'"]+['"]);\s*$` | `export $1;` |
| package rename | `package:old_app/` | `package:new_app/` |
| this.x → x | `\bthis\.(\w+)` | `$1` |
| print → debugPrint | `\bprint\s*\(` | `debugPrint(` |

---

# 132) قواعد مهمة جداً قبل Replace All

| # | القاعدة |
|---:|---|
| 1 | راجع Preview للنتائج قبل تنفيذ Replace All. |
| 2 | استخدم `Files to include` لتقييد نطاق التعديل. |
| 3 | استبعد generated files مثل `*.g.dart`, `*.freezed.dart`, `*.drift.dart`. |
| 4 | استخدم `\b` لمنع مطابقة أجزاء من أسماء أكبر. |
| 5 | استخدم Capture Groups عندما تريد الحفاظ على أجزاء من الاسم. |
| 6 | استخدم `$1`, `$2` بترتيب المجموعات الموجودة في Search. |
| 7 | إذا أردت `$` حرفية فاستخدم `$$`. |
| 8 | تجنب Regex واسع مثل `\w+` على كامل المشروع دون تقييد الملفات. |
| 9 | أنشئ Git commit قبل أي refactor واسع. |
| 10 | بعد الاستبدال شغّل `dart format .` ثم `dart analyze` أو `flutter analyze`. |

---

# 133) مثال عملي قريب من بحثك الحالي

إذا كان Search لديك:

```regex
\bget[A-Za-z0-9_]*View\b
```

فهو يجد:

```text
getTenantView
getAccountView
getProductDetailsView
```

لكن بما أنك لم تضع Capture Group، لا يمكنك معرفة الجزء الأوسط مباشرة في Replace.

الأفضل:

```regex
\bget([A-Za-z0-9_]*)View\b
```

ثم Replace:

```text
get$1Entity
```

فتصبح:

```text
getTenantEntity
getAccountEntity
getProductDetailsEntity
```

وهذه من أهم قواعد الاستبدال:

```text
(...)  → يحفظ الجزء
$1     → يعيد استخدام الجزء المحفوظ
```
