---
title: "الدليل العملي الشامل لـ Clean Architecture وFeature-Based Pattern وSOLID في JavaScript"
language: "ar"
direction: "rtl"
runtime: "Node.js 20+ / ES Modules"
version: "1.0"
author: "م. أنور السياري"
---
<div dir="rtl">

# الدليل العملي الشامل: Clean Architecture + Feature-Based Pattern + SOLID في JavaScript

[English language](Readme.md)
[For Dart developers](../dart/Readme_ar.md)

> مرجع عربي طويل يجمع **الجزء الأول** الخاص بـClean Architecture وFeature-Based Pattern، و**الجزء الثاني** الخاص بتطبيق مبادئ SOLID داخل هذه البنية، مع مخططات Mermaid وأكواد واختبارات وقوائم فحص.

## نطاق الدليل

هذا الإصدار مختص بـJavaScript الحديثة. يستخدم Node.js وES Modules، ويعامل Express كـDelivery Adapter فقط. تبقى Domain مستقلة ويمكن تبديل Express أوقاعدة البيانات دون تغيير UseCases.

## طريقة القراءة

1. اقرأ الأسس قبل نسخ أي كود.
2. نفّذ دراسة الحالة ملفًا بعد ملف.
3. استخدم فصول SOLID لمراجعة التصميم.
4. شغّل الاختبارات بعد كل خطوة.
5. راجع قوائم الفحص قبل Pull Request.

## اصطلاحات

- أسماء المفاهيم والرموز البرمجية تبقى بالإنجليزية.
- الشرح باللغة العربية.
- السهم المتجه للداخل يعني اعتماد التفاصيل على السياسات.
- Feature تعني وحدة أعمال رأسية مثل `auth` و`orders`.
- Contract يصف السلوك دون ربطه بتنفيذ.
- Adapter يترجم بين النظام وتفصيل خارجي.

## فهرس مختصر

- [القسم الأول: الأسس](#القسم-الأول-الأسس)
- [القسم الثاني: طبقات Clean Architecture](#القسم-الثاني-طبقات-clean-architecture)
- [القسم الثالث: Feature-Based Pattern](#القسم-الثالث-feature-based-pattern)
- [القسم الرابع: تدفق البيانات والاعتماديات](#القسم-الرابع-تدفق-البيانات-والاعتماديات)
- [القسم الخامس: دراسة حالة متكاملة](#القسم-الخامس-دراسة-حالة-متكاملة)
- [القسم السادس: مبادئ SOLID](#القسم-السادس-مبادئ-solid)
- [القسم السابع: الاختبارات والجودة](#القسم-السابع-الاختبارات-والجودة)
- [القسم الثامن: الأمن والأداء والمراقبة](#القسم-الثامن-الأمن-والأداء-والمراقبة)
- [القسم التاسع: الهجرة من مشروع تقليدي](#القسم-التاسع-الهجرة-من-مشروع-تقليدي)
- [القسم العاشر: القوائم والقاموس والتمارين](#القسم-العاشر-القوائم-والقاموس-والتمارين)

## القسم الأول: الأسس

### 1. لماذا نحتاج Architecture؟

في المشروع الصغير قد يبدو وضع UI وHTTP وSQL وقواعد الأعمال في ملف واحد أسرع. لكن هذه السرعة مؤقتة؛ لأن أي تغيير صغير يلمس أجزاء عديدة، ويصبح الاختبار بطيئًا، وتنتشر تفاصيل Framework داخل كل مكان.

الهدف الحقيقي من Architecture هو **تقليل تكلفة التغيير**. البنية الجيدة تجعل أثر القرار محليًا، وتمنع التفاصيل المتقلبة من السيطرة على السياسات المستقرة.

- تغيير قاعدة البيانات دون إعادة كتابة UseCases.
- تغيير UI أوFramework دون تغيير Domain.
- اختبار قواعد الأعمال دون شبكة أوتخزين.
- تقسيم العمل حسب Features مستقلة.
- قراءة مسار العملية من أسماء الملفات وحدودها.

```mermaid
flowchart LR
  User[User] --> UI[Presentation]
  UI --> UC[Use Case]
  UC --> C[Contract]
  Adapter[Repository Adapter] --> C
  Adapter --> DB[(Database/API)]
  UC --> E[Entity]
```

### 2. Clean Code مقابل Clean Architecture

| المحور | Clean Code | Clean Architecture |
| --- | --- | --- |
| النطاق | دالة أوClass | نظام وحدود واعتماديات |
| السؤال | هل الكود واضح؟ | هل اتجاه الاعتماد صحيح؟ |
| الأداة | أسماء ودوال صغيرة | طبقات وعقود وAdapters |
| الفشل | تعقيد محلي | تسرب Framework وتداخل المسؤوليات |
| الاختبار | Unit صغيرة | اختبار السياسات بمعزل عن التفاصيل |

> **قاعدة:** الشيفرة النظيفة لا تعوّض بنية سيئة، والبنية الجيدة لا تبرر شيفرة محلية رديئة.

### 3. Dependency Rule

الاعتماديات تتجه نحو الداخل. الطبقة الداخلية لا تعرف أسماء Frameworks أوSDKs أوSQL. الخارج يعرف الداخل وينفذ العقود التي يحددها الداخل.

```mermaid
flowchart TB
  P[Presentation] --> U[Use Cases]
  U --> D[Domain]
  U --> R[Repository Contract]
  RI[RepositoryImpl] --> R
  RI --> X[External System]
```

- Entity لا تستورد Controller.
- UseCase لا تستورد HTTP client.
- RepositoryImpl يستورد Contract لأنه ينفذه.
- Composition Root يعرف كل التفاصيل لأنه يربطها.
- Framework يبقى في الحافة الخارجية.

### 4. السياسات والتفاصيل

| سياسة | تفصيل |
| --- | --- |
| تسجيل مستخدم وفق قواعد النظام | POST إلى endpoint |
| حساب خصم | قراءة صف من قاعدة البيانات |
| تحديد صلاحية أمر | فحص JWT بمكتبة محددة |
| إصدار إشعار | مزود Email أوSMS |
| إدارة مخزون | Redis كCache |

### 5. Boundaries

Boundary يفصل سببين مختلفين للتغيير. إذا كان ملف يتغير بسبب متطلبات الأعمال وملف آخر بسبب SDK خارجي فهما يستحقان حدًا واضحًا. نجاح الحد يُقاس بقدرته على احتواء التغيير.

- حد بين UI وUseCase.
- حد بين UseCase وRepository.
- حد بين Entity وDTO.
- حد بين التطبيق ومزود خارجي.
- حد بين Feature وأخرى.

### 6. متى تكون البنية مبالغة؟

صفحة ثابتة أوأداة قصيرة لا تحتاج عشرات العقود. استخدم الحدود عندما توجد قواعد أعمال أوعمر طويل أومصادر بيانات متعددة أوحاجة قوية للاختبار. أضف طبقة عندما تعزل تقلبًا حقيقيًا، لا لمجرد تقليد مخطط.

## القسم الثاني: طبقات Clean Architecture

### 7. Domain

لغة النظام الداخلية: Entities وValue Objects وقواعد الأعمال والعقود.

- لا يعرف UI.
- لا يعرف JSON.
- لا يعرف قاعدة البيانات.
- يحمي invariants.

### 8. Entities

كائنات لها هوية وسلوك مستمر عبر الزمن.

- تحمي حالتها.
- تتحقق من الانتقالات.
- لا تعيد DTO.
- تستخدم Value Objects.

### 9. Value Objects

قيم تُعرف بخصائصها مثل Email وMoney.

- إنشاء صالح أوFailure.
- مساواة بالقيمة.
- غير قابلة للتعديل قدر الإمكان.
- تقلل تكرار validation.

### 10. Use Cases

هدف واحد للمستخدم أوالنظام.

- اسمها فعل واضح.
- تنظم العملية.
- لا تنشئ Infrastructure.
- تعيد Result واضحًا.

### 11. Repository Contracts

ما يحتاجه Domain من البيانات بلغة الأعمال.

- لا تكشف ORM.
- لا تعيد Data Model.
- أسماء مثل findByEmail.
- أخطاء مفهومة.

### 12. Data Layer

تنفذ Contracts وتدير Data Sources وMapping.

- إخفاء HTTP/DB.
- ترجمة الأخطاء.
- Cache policy.
- Mapping صريح.

### 13. Presentation

تستقبل input وتدير state أوprotocol ثم تستدعي UseCase.

- لا تحتوي Business Rules.
- لا تستدعي Impl مباشرة.
- تحول النتيجة للعرض.
- تدير loading/error.

### 14. Core / Shared

مشتركات مستقرة فعلًا، لا سلة مهملات.

- Result وFailure.
- Clock وIdGenerator.
- Logging contracts.
- Utilities قليلة.

```mermaid
flowchart LR
  P[Presentation] --> U[Use Cases]
  U --> E[Entities]
  U --> C[Contracts]
  I[Implementations] --> C
  I --> S[Data Sources]
  S --> O[Outside World]
```

### 15. DTO وModel وEntity

| النوع | الدور | دورة التغيير |
| --- | --- | --- |
| DTO | شكل النقل الخارجي | يتغير مع API |
| Data Model | شكل التخزين | يتغير مع DB |
| Entity | قواعد الأعمال | يتغير مع المجال |

```mermaid
flowchart LR
  JSON --> DTO --> Mapper --> Model --> DomainMapper --> Entity
```

### 16. Result وFailure

| Failure | المعنى | المعالجة |
| --- | --- | --- |
| ValidationFailure | مدخل غير صالح | رسالة للحقل |
| UnauthorizedFailure | رفض مصادقة | رسالة عامة |
| ConflictFailure | تعارض حالة | 409 أوState مناسب |
| NetworkFailure | فشل مؤقت | Retry محسوب |
| UnexpectedFailure | خطأ غير متوقع | Log + رسالة عامة |

### 17. Composition Root

المكان الوحيد الذي ينشئ Adapters وRepositories وUseCases وControllers ويربطها. يمنع انتشار إنشاء التفاصيل داخل الطبقات.

```mermaid
flowchart TD
  CR[Composition Root] --> Client
  CR --> DS[Data Source]
  CR --> Repo[RepositoryImpl]
  CR --> UC[UseCase]
  CR --> UI[Controller/Notifier]
  Client --> DS --> Repo --> UC --> UI
```

## القسم الثالث: Feature-Based Pattern

### 18. لماذا Feature-First؟

التنظيم حسب نوع الملف يجعل تعديل ميزة واحدة يتطلب التنقل بين مجلدات عامة كثيرة. التنظيم حسب Feature يجمع السياق المتغير معًا ويحافظ داخليًا على الطبقات.

| Layer-First | Feature-First |
| --- | --- |
| كل controllers معًا | Controller داخل Feature |
| توسع أفقي | توسع رأسي |
| ملكية غير واضحة | ملكية أوضح |
| حذف Feature صعب | حذفها أكثر أمانًا |

### 19. الهيكل الهجين

```text
src-or-lib/
  core/
  features/
    auth/
      domain/
      data/
      presentation/
    products/
      domain/
      data/
      presentation/
  composition/
  main
```

### 20. ملكية الملفات

| الملف | المكان | السبب |
| --- | --- | --- |
| AuthRepositoryImpl | auth/data | تفصيل خاص بالميزة |
| LoginUseCase | auth/domain | هدف أعمال |
| LoginPage/Route | auth/presentation | واجهة الميزة |
| Money | core/domain | مفهوم مشترك مستقر |
| HttpClient | core/network | بنية مشتركة |

### 21. التواصل بين Features

تجنب استيراد internals من Feature أخرى. استخدم Public API أوContract مشتركًا أوDomain Event. مثال: تعتمد orders على CurrentUserProvider بدل AuthRepositoryImpl.

```mermaid
flowchart LR
  Orders --> CurrentUserProvider
  AuthAdapter --> CurrentUserProvider
  AuthAdapter --> SessionStore
```

### 22. Public API للFeature

- صدّر UseCases أوFacades المطلوبة.
- لا تصدّر Models التخزين.
- لا تصدّر UI internals.
- وثق الأخطاء والتوقعات.
- استخدم Contract Tests.

### 23. متى ننقل إلى Core؟

1. هل الاسم مفهوم خارج Feature؟
2. هل السلوك واحد في كل Features؟
3. هل دورة تغييره أبطأ؟
4. هل نقله يقلل coupling؟
5. هل يمكن اختباره دون سياق خاص؟

## القسم الرابع: تدفق البيانات والاعتماديات

### 24. تدفق طلب

```mermaid
sequenceDiagram
  actor User
  participant UI
  participant UC as UseCase
  participant R as Repository Contract
  participant RI as RepositoryImpl
  participant DS as DataSource
  User->>UI: Action
  UI->>UC: Input
  UC->>R: Request
  R->>RI: Dispatch
  RI->>DS: I/O
  DS-->>RI: Raw data
  RI-->>UC: Entity/Failure
  UC-->>UI: Output
  UI-->>User: View/State
```

### 25. Command وQuery

| النوع | أمثلة | ملاحظة |
| --- | --- | --- |
| Command | RegisterUser, PlaceOrder | يغير الحالة |
| Query | GetProfile, ListProducts | قراءة دون أثر جانبي |
| Policy | CalculateDiscount | قانون نقي |
| Gateway | PaymentGateway | عقد خارجي |

### 26. Validation حسب المستوى

| المستوى | المسؤولية | مثال |
| --- | --- | --- |
| Presentation | صيغة الحقل | مطلوب |
| Value Object | صلاحية القيمة | Email صالح |
| UseCase | قاعدة السياق | Email غير مستخدم |
| Database | قيد نهائي | Unique index |
| External API | قيد المزود | عملة مدعومة |

### 27. Transaction Boundary

ضع المعاملة عند العملية التجارية التي يجب أن تنجح أوتفشل كوحدة. لا تجعل Controller يقرر transaction إذا كانت القاعدة تخص UseCase.

```mermaid
flowchart TD
  PlaceOrder --> UnitOfWork
  UnitOfWork --> OrdersRepo
  UnitOfWork --> InventoryRepo
  UnitOfWork --> PaymentRecordRepo
```

### 28. Domain Events

```mermaid
flowchart LR
  RegisterUser --> UserRegistered
  UserRegistered --> WelcomeEmail
  UserRegistered --> Analytics
  UserRegistered --> Audit
```

> **تحذير:** إذا كان المستهلك ضروريًا لنجاح العملية فلا تخفِه كحدث غير موثوق؛ استخدم اعتمادًا صريحًا أوOutbox.

### 29. Cache

```mermaid
flowchart TD
  UC --> Contract
  Impl --> Contract
  Impl --> Cache
  Impl --> Network
  Cache -->|hit| Impl
  Network -->|miss| Impl
```

### 30. Retry وIdempotency

- Retry للعمليات الآمنة أوالمحمية بمفتاح idempotency.
- لا تعِد محاولة الدفع عشوائيًا.
- ضع backoff في Adapter.
- ميّز permanent عن transient failure.
- سجل correlation id.

## القسم الخامس: دراسة حالة متكاملة

### 31. افتراضات JavaScript

- Node.js 20+ وES Modules.
- Domain لا تعتمد على Express.
- Express Delivery Adapter فقط.
- node:test للاختبارات.
- In-Memory storage قابل للاستبدال.
- الربط في Composition Root.

### 32. شجرة المشروع

```text
src/
  core/
    failure.js
    result.js
    clock.js
  features/
    auth/
      domain/
        entities/user.js
        value-objects/email.js
        contracts/auth-repository.js
        use-cases/register-user.js
        use-cases/login-user.js
      data/
        models/user-model.js
        mappers/user-mapper.js
        data-sources/in-memory-user-data-source.js
        repositories/auth-repository-impl.js
      presentation/
        http/auth-controller.js
        http/auth-routes.js
  composition/container.js
  server.js
test/
  unit/
  contract/
  integration/
```

### 33. Failure وResult

```javascript
// src/core/failure.js
export class Failure extends Error {
  constructor(code, message, details = undefined) {
    super(message);
    this.name = "Failure";
    this.code = code;
    this.details = details;
  }
}

export class ValidationFailure extends Failure {
  constructor(message, details) {
    super("VALIDATION", message, details);
  }
}

export class ConflictFailure extends Failure {
  constructor(message, details) {
    super("CONFLICT", message, details);
  }
}

export class UnauthorizedFailure extends Failure {
  constructor(message = "Invalid credentials") {
    super("UNAUTHORIZED", message);
  }
}

export class UnexpectedFailure extends Failure {
  constructor(message = "Unexpected error", details) {
    super("UNEXPECTED", message, details);
  }
}
```

```javascript
// src/core/result.js
export class Result {
  static ok(value) {
    return new Result(true, value, undefined);
  }

  static fail(failure) {
    return new Result(false, undefined, failure);
  }

  constructor(ok, value, failure) {
    this.ok = ok;
    this.value = value;
    this.failure = failure;
    Object.freeze(this);
  }

  map(fn) {
    return this.ok ? Result.ok(fn(this.value)) : this;
  }

  flatMap(fn) {
    return this.ok ? fn(this.value) : this;
  }
}
```

### 34. Email Value Object

```javascript
import { Result } from "../../../../core/result.js";
import { ValidationFailure } from "../../../../core/failure.js";

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export class Email {
  static create(raw) {
    const value = String(raw ?? "").trim().toLowerCase();

    if (!EMAIL_PATTERN.test(value)) {
      return Result.fail(
        new ValidationFailure("Email is invalid", { field: "email" }),
      );
    }

    return Result.ok(new Email(value));
  }

  constructor(value) {
    this.value = value;
    Object.freeze(this);
  }

  equals(other) {
    return other instanceof Email && other.value === this.value;
  }

  toString() {
    return this.value;
  }
}
```

### 35. User Entity

```javascript
export class User {
  constructor({ id, email, displayName, passwordHash, createdAt }) {
    if (!id) throw new Error("User id is required");
    if (!email) throw new Error("Email is required");
    if (!passwordHash) throw new Error("Password hash is required");

    this.id = id;
    this.email = email;
    this.displayName = displayName;
    this.passwordHash = passwordHash;
    this.createdAt = createdAt;
  }

  rename(nextName) {
    const name = String(nextName ?? "").trim();
    if (name.length < 2) {
      throw new Error("Display name is too short");
    }
    this.displayName = name;
  }

  snapshot() {
    return Object.freeze({
      id: this.id,
      email: this.email.toString(),
      displayName: this.displayName,
      createdAt: this.createdAt,
    });
  }
}
```

### 36. AuthRepository Contract

```javascript
export class AuthRepository {
  async findByEmail(_email) {
    throw new Error("findByEmail must be implemented");
  }

  async save(_user) {
    throw new Error("save must be implemented");
  }

  async verifyPassword(_user, _plainPassword) {
    throw new Error("verifyPassword must be implemented");
  }
}
```

### 37. RegisterUser UseCase

```javascript
import { Email } from "../value-objects/email.js";
import { User } from "../entities/user.js";
import { Result } from "../../../../core/result.js";
import {
  ConflictFailure,
  ValidationFailure,
  UnexpectedFailure,
} from "../../../../core/failure.js";

export class RegisterUser {
  constructor({ authRepository, passwordHasher, idGenerator, clock }) {
    this.authRepository = authRepository;
    this.passwordHasher = passwordHasher;
    this.idGenerator = idGenerator;
    this.clock = clock;
  }

  async execute(input) {
    const emailResult = Email.create(input.email);
    if (!emailResult.ok) return emailResult;

    const displayName = String(input.displayName ?? "").trim();
    if (displayName.length < 2) {
      return Result.fail(
        new ValidationFailure("Display name is too short"),
      );
    }

    const password = String(input.password ?? "");
    if (password.length < 10) {
      return Result.fail(
        new ValidationFailure("Password is too short"),
      );
    }

    const existing =
      await this.authRepository.findByEmail(emailResult.value);

    if (existing) {
      return Result.fail(
        new ConflictFailure("Email is already in use"),
      );
    }

    try {
      const user = new User({
        id: this.idGenerator.next(),
        email: emailResult.value,
        displayName,
        passwordHash: await this.passwordHasher.hash(password),
        createdAt: this.clock.now(),
      });

      await this.authRepository.save(user);
      return Result.ok(user.snapshot());
    } catch (error) {
      return Result.fail(
        new UnexpectedFailure("Could not register user", {
          cause: error,
        }),
      );
    }
  }
}
```

### 38. LoginUser UseCase

```javascript
import { Email } from "../value-objects/email.js";
import { Result } from "../../../../core/result.js";
import { UnauthorizedFailure } from "../../../../core/failure.js";

export class LoginUser {
  constructor({ authRepository, tokenIssuer }) {
    this.authRepository = authRepository;
    this.tokenIssuer = tokenIssuer;
  }

  async execute(input) {
    const emailResult = Email.create(input.email);
    if (!emailResult.ok) return emailResult;

    const user =
      await this.authRepository.findByEmail(emailResult.value);

    if (!user) {
      return Result.fail(new UnauthorizedFailure());
    }

    const matches =
      await this.authRepository.verifyPassword(
        user,
        String(input.password ?? ""),
      );

    if (!matches) {
      return Result.fail(new UnauthorizedFailure());
    }

    const accessToken = await this.tokenIssuer.issue({
      subject: user.id,
      email: user.email.toString(),
    });

    return Result.ok({
      accessToken,
      user: user.snapshot(),
    });
  }
}
```

### 39. Data Model وMapper

```javascript
export class UserModel {
  constructor({
    id,
    email,
    display_name,
    password_hash,
    created_at,
  }) {
    this.id = id;
    this.email = email;
    this.display_name = display_name;
    this.password_hash = password_hash;
    this.created_at = created_at;
  }
}
```

```javascript
import { User } from "../../domain/entities/user.js";
import { Email } from "../../domain/value-objects/email.js";
import { UserModel } from "../models/user-model.js";

export class UserMapper {
  static toDomain(model) {
    const email = Email.create(model.email);
    if (!email.ok) throw email.failure;

    return new User({
      id: model.id,
      email: email.value,
      displayName: model.display_name,
      passwordHash: model.password_hash,
      createdAt: new Date(model.created_at),
    });
  }

  static toModel(entity) {
    return new UserModel({
      id: entity.id,
      email: entity.email.toString(),
      display_name: entity.displayName,
      password_hash: entity.passwordHash,
      created_at: entity.createdAt.toISOString(),
    });
  }
}
```

### 40. Data Source

```javascript
export class InMemoryUserDataSource {
  constructor() {
    this.rows = new Map();
  }

  async findByEmail(email) {
    for (const row of this.rows.values()) {
      if (row.email === email) return structuredClone(row);
    }
    return null;
  }

  async insert(row) {
    if (await this.findByEmail(row.email)) {
      const error = new Error("Unique constraint");
      error.code = "CONFLICT";
      throw error;
    }

    this.rows.set(row.id, structuredClone(row));
  }
}
```

### 41. AuthRepositoryImpl

```javascript
import { AuthRepository } from "../../domain/contracts/auth-repository.js";
import { UserMapper } from "../mappers/user-mapper.js";

export class AuthRepositoryImpl extends AuthRepository {
  constructor({ userDataSource, passwordHasher }) {
    super();
    this.userDataSource = userDataSource;
    this.passwordHasher = passwordHasher;
  }

  async findByEmail(email) {
    const row =
      await this.userDataSource.findByEmail(email.toString());
    return row ? UserMapper.toDomain(row) : null;
  }

  async save(user) {
    await this.userDataSource.insert(UserMapper.toModel(user));
  }

  async verifyPassword(user, plainPassword) {
    return this.passwordHasher.verify(
      plainPassword,
      user.passwordHash,
    );
  }
}
```

### 42. AuthController

```javascript
export class AuthController {
  constructor({ registerUser, loginUser }) {
    this.registerUser = registerUser;
    this.loginUser = loginUser;
  }

  register = async (req, res) => {
    const result = await this.registerUser.execute(req.body);
    return this.#toHttp(result, res, 201);
  };

  login = async (req, res) => {
    const result = await this.loginUser.execute(req.body);
    return this.#toHttp(result, res, 200);
  };

  #toHttp(result, res, successStatus) {
    if (result.ok) {
      return res.status(successStatus).json({
        data: result.value,
      });
    }

    const statusByCode = {
      VALIDATION: 400,
      UNAUTHORIZED: 401,
      CONFLICT: 409,
      UNEXPECTED: 500,
    };

    return res.status(
      statusByCode[result.failure.code] ?? 500,
    ).json({
      error: {
        code: result.failure.code,
        message: result.failure.message,
        details: result.failure.details,
      },
    });
  }
}
```

### 43. Routes

```javascript
import { Router } from "express";

export function createAuthRouter(controller) {
  const router = Router();

  router.post("/register", controller.register);
  router.post("/login", controller.login);

  return router;
}
```

### 44. Composition Root

```javascript
import { RegisterUser } from "../features/auth/domain/use-cases/register-user.js";
import { LoginUser } from "../features/auth/domain/use-cases/login-user.js";
import { InMemoryUserDataSource } from "../features/auth/data/data-sources/in-memory-user-data-source.js";
import { AuthRepositoryImpl } from "../features/auth/data/repositories/auth-repository-impl.js";
import { AuthController } from "../features/auth/presentation/http/auth-controller.js";

export function buildContainer({
  passwordHasher,
  tokenIssuer,
  clock,
  idGenerator,
}) {
  const userDataSource = new InMemoryUserDataSource();

  const authRepository = new AuthRepositoryImpl({
    userDataSource,
    passwordHasher,
  });

  const registerUser = new RegisterUser({
    authRepository,
    passwordHasher,
    idGenerator,
    clock,
  });

  const loginUser = new LoginUser({
    authRepository,
    tokenIssuer,
  });

  return {
    authController: new AuthController({
      registerUser,
      loginUser,
    }),
    registerUser,
    loginUser,
    authRepository,
  };
}
```

### 45. Server Adapter

```javascript
import express from "express";
import { buildContainer } from "./composition/container.js";
import { createAuthRouter } from "./features/auth/presentation/http/auth-routes.js";

const app = express();
app.use(express.json());

const container = buildContainer({
  passwordHasher: createPasswordHasher(),
  tokenIssuer: createTokenIssuer(),
  clock: { now: () => new Date() },
  idGenerator: { next: () => crypto.randomUUID() },
});

app.use(
  "/auth",
  createAuthRouter(container.authController),
);

app.listen(3000, () => {
  console.log("Listening on http://localhost:3000");
});
```

### 46. Unit Test

```javascript
import test from "node:test";
import assert from "node:assert/strict";
import { RegisterUser } from "../../src/features/auth/domain/use-cases/register-user.js";

class FakeAuthRepository {
  constructor() {
    this.saved = [];
  }

  async findByEmail() {
    return null;
  }

  async save(user) {
    this.saved.push(user);
  }
}

test("registers a valid user", async () => {
  const repo = new FakeAuthRepository();

  const useCase = new RegisterUser({
    authRepository: repo,
    passwordHasher: { hash: async () => "hash" },
    idGenerator: { next: () => "user-1" },
    clock: {
      now: () => new Date("2026-01-01T00:00:00Z"),
    },
  });

  const result = await useCase.execute({
    email: "USER@example.com",
    displayName: "Anwar",
    password: "very-strong-password",
  });

  assert.equal(result.ok, true);
  assert.equal(result.value.email, "user@example.com");
  assert.equal(repo.saved.length, 1);
});
```

### 47. Contract Test

```javascript
export function authRepositoryContract(
  name,
  createRepository,
) {
  test(`${name}: missing user returns null`, async () => {
    const repository = await createRepository();
    const email = Email.create("missing@example.com").value;

    const result = await repository.findByEmail(email);

    assert.equal(result, null);
  });

  test(`${name}: save then find returns same identity`, async () => {
    const repository = await createRepository();
    const email = Email.create("a@example.com").value;
    const user = createUser({ id: "1", email });

    await repository.save(user);
    const loaded = await repository.findByEmail(email);

    assert.equal(loaded.id, "1");
  });
}
```

### 48. Integration Test

```javascript
test("POST /auth/register returns 201", async () => {
  const response = await fetch(
    "http://localhost:3000/auth/register",
    {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({
        email: "new@example.com",
        displayName: "New User",
        password: "a-secure-password",
      }),
    },
  );

  assert.equal(response.status, 201);

  const body = await response.json();
  assert.equal(body.data.email, "new@example.com");
});
```

## القسم السادس: مبادئ SOLID

### 49. نظرة عامة

| المبدأ | السؤال | الأثر |
| --- | --- | --- |
| SRP | كم سببًا لتغيير المكوّن؟ | مسؤوليات وحدود أوضح |
| OCP | هل أضيف سلوكًا دون تعديل المستقر؟ | Extensions خلف Contracts |
| LSP | هل التنفيذ قابل للاستبدال؟ | عقود صادقة |
| ISP | هل العميل يرى طرقًا لا يحتاجها؟ | واجهات صغيرة |
| DIP | هل السياسة تعتمد على التفاصيل؟ | اعتماد على Abstractions |

```mermaid
mindmap
  root((SOLID))
    SRP
      One reason to change
    OCP
      Extend stable code
    LSP
      Safe substitution
    ISP
      Focused interfaces
    DIP
      Depend on abstractions
```

### 50. SRP — Single Responsibility Principle

SRP لا يعني method واحدة لكل Class، بل سببًا واحدًا للتغيير. في Feature-Based Pattern يطبق على الطبقات والملفات معًا.

#### مثال سيئ

```javascript
export async function register(req, res) {
  if (!req.body.email?.includes("@")) {
    return res.status(400).json({ error: "Invalid email" });
  }

  const existing = await db.query(
    "select id from users where email = $1",
    [req.body.email],
  );

  if (existing.rowCount > 0) {
    return res.status(409).json({ error: "Email exists" });
  }

  const hash = await bcrypt.hash(req.body.password, 12);

  const row = await db.query(
    "insert into users(email, password_hash) values($1, $2) returning *",
    [req.body.email, hash],
  );

  await mailer.sendWelcome(req.body.email);
  return res.status(201).json(row.rows[0]);
}
```

- يتغير مع HTTP.
- يتغير مع SQL.
- يتغير مع password policy.
- يتغير مع مزود البريد.
- يتطلب Infrastructure كاملة للاختبار.

#### تفكيك المسؤوليات

```mermaid
flowchart LR
  Route --> Controller
  Controller --> RegisterUser
  RegisterUser --> AuthRepository
  RegisterUser --> PasswordHasher
  UserRegistered --> WelcomeEmailHandler
```

```javascript
export class RegisterController {
  constructor(registerUser) {
    this.registerUser = registerUser;
  }

  handle = async (req, res) => {
    const result =
      await this.registerUser.execute(req.body);

    return presentResult(result, res);
  };
}
```

#### أسئلة SRP

- هل يمكن وصف مسؤولية الملف دون كلمة و؟
- هل imports تأتي من محاور تقلب مختلفة؟
- هل الاختبار يحتاج إعدادًا لا يخص دوره؟
- هل تغيير UI يفرض تعديل Domain؟
- هل تغيير DB يفرض تعديل Controller؟

### 51. OCP — Open/Closed Principle

المكوّن مفتوح للتوسعة ومغلق للتعديل. يتحقق ذلك عبر Contracts وStrategies وComposition، لا عبر if/else تتضخم.

```javascript
export async function sendNotification(
  type,
  message,
  target,
) {
  if (type === "email") {
    return emailSdk.send(target, message);
  }

  if (type === "sms") {
    return smsSdk.send(target, message);
  }

  if (type === "push") {
    return pushSdk.send(target, message);
  }

  throw new Error("Unsupported channel");
}
```

```javascript
export class NotificationSender {
  async send(_notification) {
    throw new Error("send must be implemented");
  }
}

export class EmailNotificationSender
    extends NotificationSender {
  constructor(client) {
    super();
    this.client = client;
  }

  send(notification) {
    return this.client.send({
      to: notification.target,
      subject: notification.subject,
      body: notification.body,
    });
  }
}

export class PushNotificationSender
    extends NotificationSender {
  constructor(client) {
    super();
    this.client = client;
  }

  send(notification) {
    return this.client.push({
      deviceToken: notification.target,
      message: notification.body,
    });
  }
}
```

```mermaid
classDiagram
  class NotificationSender {
    <<interface>>
    +send(notification)
  }
  NotificationSender <|.. EmailNotificationSender
  NotificationSender <|.. SmsNotificationSender
  NotificationSender <|.. PushNotificationSender
```

> **مقايضة:** لا تنشئ abstraction بلا محور تغير حقيقي. OCP أداة لحماية الكود المستقر من توسعات متوقعة.

### 52. LSP — Liskov Substitution Principle

التنفيذ البديل يجب أن يحافظ على توقيع العقد وسلوكه وأخطائه وشروطه المسبقة واللاحقة.

```javascript
// خرق LSP
class ReadOnlyUserRepository extends AuthRepository {
  async save() {
    throw new Error(
      "UnsupportedOperationException",
    );
  }
}
```

```javascript
export class UserReader {
  async findByEmail(_email) {
    throw new Error("Not implemented");
  }
}

export class UserWriter {
  async save(_user) {
    throw new Error("Not implemented");
  }
}
```

```javascript
export function userReaderContract(
  name,
  createReader,
) {
  test(`${name}: missing user returns null`, async () => {
    const reader = await createReader();
    const email =
      Email.create("missing@example.com").value;

    assert.equal(
      await reader.findByEmail(email),
      null,
    );
  });
}
```

- لا تشدد الشروط المسبقة.
- لا تضعف الضمانات اللاحقة.
- حافظ على معنى null وFailure.
- لا تضف استثناءات مفاجئة.
- شغّل نفس Contract Test على كل تنفيذ.

### 53. ISP — Interface Segregation Principle

لا تجبر العميل على الاعتماد على methods لا يستخدمها. في JavaScript يمكن تمثيل العقود الصغيرة بكلاسات مجردة اصطلاحيًا أوJSDoc types.

```javascript
// عقد ضخم
export class UserRepository {
  findById() {}
  findByEmail() {}
  save() {}
  delete() {}
  search() {}
  exportCsv() {}
  resetPassword() {}
  updateAvatar() {}
}
```

```javascript
export class UserReader {
  findById(_id) {}
  findByEmail(_email) {}
}

export class UserWriter {
  save(_user) {}
}

export class PasswordResetGateway {
  sendReset(_user) {}
}

export class AvatarStore {
  upload(_userId, _bytes) {}
}
```

```mermaid
flowchart LR
  Login --> UserReader
  Register --> UserReader
  Register --> UserWriter
  ResetPassword --> PasswordResetGateway
  UpdateAvatar --> AvatarStore
```

> **علامة خطر:** إذا كانت Fakes تحتوي methods فارغة فقط لإرضاء العقد، فالعقد كبير أكثر من اللازم.

### 54. DIP — Dependency Inversion Principle

الوحدات عالية المستوى ومنخفضة المستوى تعتمد على Abstractions. في JavaScript يطبق ذلك بالحقن عبر constructor والربط في Composition Root.

```javascript
// خطأ
import { MongoAuthRepository }
  from "../../data/mongo-auth-repository.js";

export class LoginUser {
  constructor() {
    this.repository =
      new MongoAuthRepository();
  }
}
```

```javascript
// أفضل
export class LoginUser {
  constructor({
    authRepository,
    tokenIssuer,
  }) {
    this.authRepository = authRepository;
    this.tokenIssuer = tokenIssuer;
  }
}

const authRepository =
  new MongoAuthRepository(mongoClient);

const loginUser = new LoginUser({
  authRepository,
  tokenIssuer,
});
```

```mermaid
flowchart LR
  LoginUser --> AuthRepositoryContract
  MongoAuthRepository --> AuthRepositoryContract
  PostgresAuthRepository --> AuthRepositoryContract
  FakeAuthRepository --> AuthRepositoryContract
```

- العقد يملكه الداخل.
- الخارج ينفذ العقد.
- Composition Root يختار التنفيذ.
- الاختبار يحقن Fake.
- UseCase لا تعرف SDK.

## القسم السابع: الاختبارات والجودة

### 55. هرم الاختبارات

```mermaid
flowchart TB
  E2E[E2E - قليل]
  I[Integration - متوسط]
  C[Contract - متوسط]
  U[Unit - كثير]
  E2E --> I --> C --> U
```

| النوع | ما يختبره | السرعة | مثال |
| --- | --- | --- | --- |
| Unit | Entity/UseCase | سريع | حساب أوتسجيل |
| Contract | سلوك كل implementation | سريع/متوسط | Repository |
| Integration | Adapter مع DB/API | متوسط | Mapping وSQL |
| Presentation | UI/HTTP adapter | متوسط | state/status |
| E2E | تدفق كامل | بطيء | login ثم home |

### 56. Mocks وFakes

- استخدم Fake بسيطًا للعقود الداخلية.
- استخدم Mock لتفاعل مهم لا لكل call.
- لا تعمل Mock لـEntity.
- اختبر Adapters الحقيقية بـIntegration.
- استخدم Contract Tests لمنع اختلاف Fake عن الإنتاج.

### 57. خصائص الاختبار الجيد

1. يصف سلوكًا لا implementation.
2. يفشل لسبب واحد.
3. لا يعتمد على ترتيب.
4. يضبط الوقت والـIDs.
5. يختبر النجاح والفشل.
6. لا يكرر منطق الإنتاج.

### 58. Architecture Review

- هل Domain تستورد Framework؟
- هل Repository يعيد DTO؟
- هل UseCase تنشئ concrete dependency؟
- هل يوجد cross-feature import عميق؟
- هل failure مترجمة عند الحد؟
- هل العقد صغير وصادق؟
- هل Contract Tests موجودة؟
- هل Composition Root واضح؟

### 59. Metrics

| القياس | يكشف | التحذير |
| --- | --- | --- |
| Coupling | تسرب الحدود | لا تفسره منفردًا |
| حجم الملفات | تضخم محتمل | الطول ليس خطأ دائمًا |
| زمن الاختبار | Infrastructure زائد | Integration قد تكون ضرورية |
| Coverage | مساحات بلا اختبار | لا تقيس جودة assertions |
| Co-change | حدود غير مناسبة | يحتاج تاريخ Git |

### 60. Fitness Functions

```text
قواعد آلية مقترحة:
- domain/** لا يستورد data/**
- domain/** لا يستورد presentation/**
- domain/** لا يستورد framework packages
- presentation/** لا يستورد *RepositoryImpl
- feature A لا يستورد internals من feature B
```

### 61. Definition of Done

1. UseCase موثقة.
2. Domain بلا Framework.
3. Contracts في الداخل.
4. Mapping صريح.
5. Unit tests.
6. Contract tests.
7. Integration tests للحدود.
8. Security review.
9. Observability.
10. ADR للقرار طويل الأثر.

## القسم الثامن: الأمن والأداء والمراقبة

### 62. Security Boundaries

- لا تعيد passwordHash.
- authorization داخل UseCase أوPolicy.
- rate limiting في Delivery Adapter.
- لا تسجل tokens.
- ترجم auth failures إلى رسالة عامة.
- اعتبر external IDs غير موثوقة.
- استخدم مكتبات hashing موثوقة.
- افصل secrets عن source code.

```mermaid
flowchart LR
  Request --> RateLimit
  RateLimit --> Authentication
  Authentication --> AuthorizationPolicy
  AuthorizationPolicy --> UseCase
  UseCase --> AuditEvent
```

### 63. إدارة الأسرار

- الأسرار لا تدخل Git.
- Configuration تقرأ في Composition Root.
- Domain لا تقرأ environment.
- دوّر المفاتيح دون تعديل UseCases.
- افصل test secrets عن production.
- سجّل اسم النسخة لا السر.

### 64. الأداء دون كسر الحدود

| المشكلة | المكان | الحل |
| --- | --- | --- |
| N+1 | RepositoryImpl | Batch/Join |
| JSON ضخم | DTO/Presenter | Projection/Pagination |
| حساب مكلف | Domain Service | Memoization |
| شبكة بطيئة | Data Source | Timeout/Retry |
| قراءة متكررة | Data Layer | Cache |
| UI يعاد بناؤها | Presentation | State slicing |

### 65. Logging وTracing

- مرر correlationId.
- Adapters تضيف التفاصيل التقنية.
- لا تخلط logging مع result.
- استخدم مستويات ثابتة.
- أخفِ PII.
- اربط trace بالحدث التجاري.

```mermaid
sequenceDiagram
  participant UI
  participant UC
  participant Repo
  participant External
  UI->>UC: request(correlationId)
  UC->>Repo: operation(context)
  Repo->>External: call(traceId)
  External-->>Repo: response
  Repo-->>UC: result
  UC-->>UI: output
```

### 66. Resilience

- Timeout لكل اتصال.
- Circuit Breaker للفشل المتكرر.
- Retry مع backoff وjitter.
- Bulkhead لعزل الموارد.
- Fallback صحيح تجاريًا فقط.
- Outbox للأحداث المهمة.

## القسم التاسع: الهجرة من مشروع تقليدي

### 67. Strangler Pattern

لا تعِد كتابة المشروع دفعة واحدة. ضع Facade أمام التنفيذ القديم، ثم انقل Feature أوUseCase تدريجيًا خلف Contract جديد.

```mermaid
flowchart LR
  UI --> Facade
  Facade --> Legacy
  Facade --> NewFeature
  Legacy -. يتناقص .-> NewFeature
```

### 68. خطوات الهجرة

1. ارسم التدفق الحالي.
2. اكتب characterization tests.
3. استخرج UseCase.
4. أنشئ Contract.
5. غلّف القديم في Adapter.
6. انقل Mapping.
7. أنشئ Composition Root.
8. أضف implementation جديدًا.
9. حوّل traffic تدريجيًا.
10. احذف المسار القديم.

### 69. Characterization Tests

تثبت السلوك الحالي أثناء الاستخراج. بعد الاستقرار حوّلها إلى اختبارات سلوكية، ولا تجعلها تحفظ bugs إلى الأبد.

### 70. إشارات حدود خاطئة

- Domain تستورد Framework.
- Core سلة helpers.
- كل اختبار يحتاج DB.
- Feature تستورد internals لأخرى.
- Repository تعيد Models خام.
- UseCase تمرر request/response.
- Composition موزعة في UI.
- واجهة واحدة ضخمة.

### 71. خطة 30 يومًا

| الأسبوع | الهدف | المخرج |
| --- | --- | --- |
| 1 | خريطة وتغطية حالية | Diagram + risks |
| 2 | استخراج Feature | Domain + Contract + Adapter |
| 3 | Tests + Composition | CI rules |
| 4 | تعميم وتوثيق | Playbook + ADRs |

### 72. Architecture Decision Records

#### ADR-001: Feature-First

**الحالة:** مقبول

**السياق:** المجلدات العامة ضخمة.

**القرار:** التنظيم حسب Feature مع طبقات داخلية.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-002: Domain بلا Framework

**الحالة:** مقبول

**السياق:** الاختبارات بطيئة.

**القرار:** منع imports خارجية في Domain.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-003: Result

**الحالة:** مقبول

**السياق:** الاستثناءات غير موثقة.

**القرار:** Result للأخطاء المتوقعة.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-004: Contract Tests

**الحالة:** مقبول

**السياق:** التنفيذات مختلفة.

**القرار:** Suite مشتركة لكل implementation.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-005: Composition Root

**الحالة:** مقبول

**السياق:** new موزعة.

**القرار:** ربط مركزي.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-006: Domain Events

**الحالة:** مقبول

**السياق:** عمليات ثانوية مترابطة.

**القرار:** Events بعد نجاح UseCase.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-007: DTO خارج Domain

**الحالة:** مقبول

**السياق:** API تكسر Entities.

**القرار:** Mapping صريح.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-008: Interfaces صغيرة

**الحالة:** مقبول

**السياق:** Mocks معقدة.

**القرار:** تقسيم حسب القدرات.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-009: Cache في Data

**الحالة:** مقبول

**السياق:** UseCases تعرف Redis.

**القرار:** إخفاء cache خلف Repository.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

#### ADR-010: Clock وIDs

**الحالة:** مقبول

**السياق:** اختبارات غير حتمية.

**القرار:** حقن Clock وIdGenerator.

**الإيجابيات:** حدود أوضح واختبارات أسهل.

**المقايضات:** ملفات وربط إضافي يحتاجان انضباطًا.

### 73. كتالوج Anti-Patterns

#### 1. God Controller

- **العرض:** HTTP وSQL وقواعد في ملف واحد.
- **المعالجة:** استخرج UseCase وRepository.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 2. Anemic Domain

- **العرض:** Entities مجرد حقول.
- **المعالجة:** انقل invariants إلى Domain.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 3. Framework Leakage

- **العرض:** Domain تستورد Framework.
- **المعالجة:** استخدم Adapter.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 4. Generic Repository

- **العرض:** CRUD عام لكل شيء.
- **المعالجة:** عقد بلغة الأعمال.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 5. Fat Interface

- **العرض:** طرق كثيرة غير لازمة.
- **المعالجة:** طبّق ISP.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 6. Service Locator

- **العرض:** dependencies من global.
- **المعالجة:** constructor injection.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 7. Hidden I/O

- **العرض:** getter ينفذ شبكة.
- **المعالجة:** اجعل I/O صريحًا.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 8. DTO Everywhere

- **العرض:** DTO تصل إلى Domain/UI.
- **المعالجة:** Mapping عند الحدود.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 9. Shared Dump

- **العرض:** كل شيء في shared.
- **المعالجة:** معيار صارم لـCore.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 10. Cross-Import

- **العرض:** Features تعتمد على internals.
- **المعالجة:** Public API.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 11. Exception Soup

- **العرض:** أخطاء SDK تصعد.
- **المعالجة:** ترجمة Failure.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 12. Boolean Blindness

- **العرض:** booleans كثيرة.
- **المعالجة:** enum/strategy.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 13. Temporal Coupling

- **العرض:** ترتيب calls مخفي.
- **المعالجة:** UseCase واحدة.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 14. Primitive Obsession

- **العرض:** Email مجرد String.
- **المعالجة:** Value Object.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 15. Shotgun Surgery

- **العرض:** تعديل عشرات الملفات.
- **المعالجة:** راجع Boundary.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 16. Golden Hammer

- **العرض:** Repository لكل شيء.
- **المعالجة:** Domain Service عند الحاجة.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 17. Over-Abstraction

- **العرض:** Interface لكل class.
- **المعالجة:** احذف غير المفيد.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 18. Under-Abstraction

- **العرض:** UseCase تعتمد على SDK.
- **المعالجة:** Gateway Contract.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 19. Mixed Validation

- **العرض:** قواعد مكررة.
- **المعالجة:** وزع حسب المستوى.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 20. Leaky Cache

- **العرض:** UseCase تعرف cache keys.
- **المعالجة:** Data policy.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 21. Test-only Design

- **العرض:** API غريبة للمocks.
- **المعالجة:** صمم للعقد الحقيقي.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 22. Massive Mapper

- **العرض:** Mapper فيه business rules.
- **المعالجة:** انقلها للDomain.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 23. Circular Dependency

- **العرض:** Features دائرية.
- **المعالجة:** Event/Facade.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 24. Global Mutable State

- **العرض:** session عالمية.
- **المعالجة:** Scope واضح.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 25. Retry Everywhere

- **العرض:** retry في كل طبقة.
- **المعالجة:** Policy واحدة.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 26. Silent Failure

- **العرض:** كل خطأ يصبح null.
- **المعالجة:** ميّز failures.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 27. Inconsistent Result

- **العرض:** أشكال نتائج عشوائية.
- **المعالجة:** Convention موحدة.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 28. Infrastructure Entity

- **العرض:** ORM model هي Entity.
- **المعالجة:** افصل mapping.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 29. Route-driven Domain

- **العرض:** UseCases باسم endpoint.
- **المعالجة:** لغة الأعمال.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

#### 30. Premature Microservices

- **العرض:** شبكة قبل الحدود.
- **المعالجة:** Modular monolith.
- **اختبار:** أثبت أن تبديل التفصيل لا يغير السياسة.
- **مراجعة:** افحص اتجاه import وحدود Feature.

## القسم العاشر: القوائم والقاموس والتمارين

### 74. Checklist إنشاء Feature

- [ ] 01. هدف تجاري بجملة.
- [ ] 02. Actor أوtrigger.
- [ ] 03. UseCase input مستقل عن protocol.
- [ ] 04. Entities وValue Objects.
- [ ] 05. Invariants.
- [ ] 06. Failures المتوقعة.
- [ ] 07. Contract حسب الحاجة.
- [ ] 08. Implementation في Data.
- [ ] 09. Mapper صريح.
- [ ] 10. Transaction boundary.
- [ ] 11. Authorization policy.
- [ ] 12. Idempotency.
- [ ] 13. Timeout.
- [ ] 14. Cache policy.
- [ ] 15. Unit tests.
- [ ] 16. Contract tests.
- [ ] 17. Integration tests.
- [ ] 18. Presentation test.
- [ ] 19. Logging.
- [ ] 20. Tracing.
- [ ] 21. Security review.
- [ ] 22. ADR.
- [ ] 23. Import review.
- [ ] 24. SOLID review.
- [ ] 25. Deletion path.

### 75. Checklist SOLID

#### SRP

- [ ] سبب واحد للتغيير؟
- [ ] يخلط protocol وbusiness؟
- [ ] اختباره يحتاج إعدادًا زائدًا؟
- [ ] الاسم يصف دورًا واحدًا؟
- [ ] imports من محاور كثيرة؟

#### OCP

- [ ] إضافة مزود تعدل المستقر؟
- [ ] if/else تنمو؟
- [ ] محور التوسع معروف؟
- [ ] Strategy مناسبة؟
- [ ] abstraction تبرر كلفتها؟

#### LSP

- [ ] التنفيذ يفي بالعقد؟
- [ ] الأخطاء متسقة؟
- [ ] null بنفس المعنى؟
- [ ] الشروط متسقة؟
- [ ] Contract tests؟

#### ISP

- [ ] طرق غير مستخدمة؟
- [ ] Fake methods فارغة؟
- [ ] عمليات غير مترابطة؟
- [ ] تقسيم capabilities؟
- [ ] العقود مفهومة؟

#### DIP

- [ ] new داخل UseCase؟
- [ ] Domain تستورد SDK؟
- [ ] العقد يملكه الداخل؟
- [ ] Composition واضح؟
- [ ] Fake سهل؟

### 76. قاموس المصطلحات

- **Abstraction:** سلوك مطلوب دون تنفيذ محدد.
- **Adapter:** مترجم بين النظام والخارج.
- **Boundary:** حد يفصل أسباب تغيير.
- **Business Rule:** قاعدة مجال.
- **Cache:** نسخة مؤقتة.
- **Command:** نية تغيير حالة.
- **Composition Root:** مكان الربط.
- **Contract:** اتفاق سلوكي.
- **Controller:** Adapter للطلب.
- **Coupling:** درجة اعتماد.
- **CQRS:** فصل القراءة والكتابة.
- **Data Source:** اتصال مباشر بالخارج.
- **Dependency Injection:** تزويد الاعتماد من الخارج.
- **Domain:** قواعد ونموذج المجال.
- **Domain Event:** حقيقة حدثت.
- **DTO:** شكل نقل.
- **Entity:** كائن له هوية.
- **Facade:** واجهة مبسطة.
- **Failure:** خطأ متوقع مترجم.
- **Feature:** وحدة أعمال رأسية.
- **Gateway:** عقد لنظام خارجي.
- **Idempotency:** إعادة آمنة.
- **Infrastructure:** تفاصيل تقنية.
- **Invariant:** شرط دائم.
- **Mapper:** تحويل أشكال.
- **Model:** تمثيل طبقة.
- **Policy:** قرار أعمال.
- **Presenter:** تحويل output للعرض.
- **Public API:** سطح مسموح.
- **Query:** قراءة دون أثر.
- **Repository:** وصول إلى Domain objects.
- **Result:** نجاح أوFailure.
- **Strategy:** خوارزمية قابلة للتبديل.
- **Transaction:** تغييرات ذرية.
- **UseCase:** هدف مستخدم.
- **Value Object:** قيمة بلا هوية.
- **ViewModel:** بيانات عرض.
- **Unit of Work:** تنسيق transaction.
- **Outbox:** ضمان أحداث بعد commit.
- **Circuit Breaker:** إيقاف مؤقت عند الفشل.
- **Bulkhead:** عزل الموارد.
- **Correlation ID:** ربط سجلات الطلب.
- **Contract Test:** Suite لكل implementations.
- **Characterization Test:** تثبيت السلوك الحالي.
- **Fitness Function:** قاعدة معمارية آلية.
- **Modular Monolith:** تطبيق واحد بوحدات.
- **Anti-Corruption Layer:** عزل نموذج خارجي.
- **Read Model:** نموذج مخصص للقراءة.
- **Aggregate:** حد اتساق Domain.
- **Port:** اسم آخر للعقد الحدّي.

### 77. تمارين

#### تمرين 1: Google Login

- **المطلوب:** أضف Gateway دون تعديل UseCase.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 2: Profile Cache

- **المطلوب:** أخفِ cache خلف Repository.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 3: Read-only Repository

- **المطلوب:** لا تخرق LSP.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 4: GraphQL

- **المطلوب:** بدّل Delivery Adapter.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 5: Payment Provider

- **المطلوب:** طبّق OCP.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 6: Authorization

- **المطلوب:** Policy مستقلة.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 7: Split Repository

- **المطلوب:** طبّق ISP.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 8: Offline-first

- **المطلوب:** نسق Local/Remote.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 9: OrderPlaced

- **المطلوب:** Domain Event.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 10: Legacy Adapter

- **المطلوب:** Strangler migration.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 11: Cancel Order

- **المطلوب:** State transitions.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 12: Money

- **المطلوب:** Value Object.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 13: Pagination

- **المطلوب:** افصل HTTP query.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 14: Avatar

- **المطلوب:** AvatarStore contract.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 15: Clock

- **المطلوب:** FakeClock.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 16: Multi-currency

- **المطلوب:** ExchangeRateGateway.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 17: Retry Payment

- **المطلوب:** Idempotency.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 18: Audit

- **المطلوب:** Event أوPort.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 19: Product Search

- **المطلوب:** Query Service.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

#### تمرين 20: Analytics

- **المطلوب:** Handler منفصل.
- **المخرجات:** Mermaid + Contract + UseCase + tests.
- **السؤال:** ما التفصيل القابل للتبديل؟
- **المراجعة:** ما مبادئ SOLID ذات الصلة؟

### 78. أسئلة مراجعة

1. اشرح Dependency Rule.
2. متى يصبح Repository مبالغة؟
3. الفرق بين DTO وEntity؟
4. أين تضع validation؟
5. كيف تختبر implementations؟
6. الفرق بين DIP وDI؟
7. كيف تكتشف LSP violation؟
8. متى تستخدم Domain Event؟
9. كيف تمنع cross-feature coupling؟
10. ما دور Composition Root؟
11. كيف تطبق OCP دون over-engineering؟
12. لماذا Generic Repository قد يكون سيئًا؟
13. كيف تعزل cache؟
14. أين تترجم exceptions؟
15. ما Public API للFeature؟
16. كيف تهاجر legacy؟
17. متى تستخدم Query Service؟
18. كيف تعزل الوقت؟
19. كيف تمنع Framework leakage؟
20. الفرق بين unit وcontract test؟

### 79. خاتمة

Clean Architecture ليست شكل مجلدات ثابتًا، وFeature-Based Pattern ليست نقل ملفات فقط، وSOLID ليست شعارات. تعمل معًا عندما يكون اتجاه الاعتماد واضحًا، والعقود صغيرة وصادقة، والتفاصيل في Adapters، وقواعد الأعمال قابلة للاختبار.

ابدأ من التدفق التجاري، صمم الداخل أولًا، ثم اسمح للخارج بتنفيذ ما يحتاجه الداخل.

### 80. بطاقات مراجعة إضافية

#### بطاقة 1: تغيرت قاعدة البيانات

- **التشخيص:** يجب أن يتغير Adapter لا UseCase.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 2: API أضاف حقلًا

- **التشخيص:** حدّث DTO/Mapper فقط إن لم توجد قاعدة جديدة.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 3: Feature تحتاج current user

- **التشخيص:** اعتمد على CurrentUserProvider.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 4: اختبار يحتاج sleep

- **التشخيص:** احقن Clock أوScheduler.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 5: UseCase تعيد HTTP status

- **التشخيص:** أعد Output/Failure.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 6: Widget/Route تستورد HTTP client

- **التشخيص:** انقل الاتصال إلى Data Source.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 7: Repository تعيد Map

- **التشخيص:** حوّل إلى Entity أوRead Model.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 8: أخطاء implementations مختلفة

- **التشخيص:** ترجمها إلى Failure موحدة.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 9: إضافة notification channel

- **التشخيص:** Extension خلف Contract.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 10: واجهة 20 method

- **التشخيص:** قسّم capabilities.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 11: Fake لا يشبه الإنتاج

- **التشخيص:** Contract Test.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 12: Feature صعبة الحذف

- **التشخيص:** راجع Public API وimports.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 13: Core يتضخم

- **التشخيص:** أعد العناصر إلى Features.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 14: Mapper يحسب خصمًا

- **التشخيص:** انقل القاعدة إلى Domain.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 15: Controller يقرر authorization

- **التشخيص:** Policy في UseCase.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 16: UseCase تنشئ UUID

- **التشخيص:** IdGenerator contract.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 17: Business rule تستخدم now مباشرة

- **التشخيص:** Clock contract.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 18: Retry في ثلاث طبقات

- **التشخيص:** Policy واحدة عند Boundary.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 19: Cache miss يساوي not found

- **التشخيص:** ميّز المعنى أوأخفِه.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 20: Read model مختلف

- **التشخيص:** Query Service متخصص.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 21: تغيرت قاعدة البيانات

- **التشخيص:** يجب أن يتغير Adapter لا UseCase.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 22: API أضاف حقلًا

- **التشخيص:** حدّث DTO/Mapper فقط إن لم توجد قاعدة جديدة.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 23: Feature تحتاج current user

- **التشخيص:** اعتمد على CurrentUserProvider.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 24: اختبار يحتاج sleep

- **التشخيص:** احقن Clock أوScheduler.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 25: UseCase تعيد HTTP status

- **التشخيص:** أعد Output/Failure.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 26: Widget/Route تستورد HTTP client

- **التشخيص:** انقل الاتصال إلى Data Source.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 27: Repository تعيد Map

- **التشخيص:** حوّل إلى Entity أوRead Model.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 28: أخطاء implementations مختلفة

- **التشخيص:** ترجمها إلى Failure موحدة.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 29: إضافة notification channel

- **التشخيص:** Extension خلف Contract.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 30: واجهة 20 method

- **التشخيص:** قسّم capabilities.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 31: Fake لا يشبه الإنتاج

- **التشخيص:** Contract Test.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 32: Feature صعبة الحذف

- **التشخيص:** راجع Public API وimports.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 33: Core يتضخم

- **التشخيص:** أعد العناصر إلى Features.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 34: Mapper يحسب خصمًا

- **التشخيص:** انقل القاعدة إلى Domain.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 35: Controller يقرر authorization

- **التشخيص:** Policy في UseCase.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 36: UseCase تنشئ UUID

- **التشخيص:** IdGenerator contract.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 37: Business rule تستخدم now مباشرة

- **التشخيص:** Clock contract.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 38: Retry في ثلاث طبقات

- **التشخيص:** Policy واحدة عند Boundary.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 39: Cache miss يساوي not found

- **التشخيص:** ميّز المعنى أوأخفِه.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 40: Read model مختلف

- **التشخيص:** Query Service متخصص.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 41: تغيرت قاعدة البيانات

- **التشخيص:** يجب أن يتغير Adapter لا UseCase.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 42: API أضاف حقلًا

- **التشخيص:** حدّث DTO/Mapper فقط إن لم توجد قاعدة جديدة.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 43: Feature تحتاج current user

- **التشخيص:** اعتمد على CurrentUserProvider.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 44: اختبار يحتاج sleep

- **التشخيص:** احقن Clock أوScheduler.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 45: UseCase تعيد HTTP status

- **التشخيص:** أعد Output/Failure.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 46: Widget/Route تستورد HTTP client

- **التشخيص:** انقل الاتصال إلى Data Source.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 47: Repository تعيد Map

- **التشخيص:** حوّل إلى Entity أوRead Model.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 48: أخطاء implementations مختلفة

- **التشخيص:** ترجمها إلى Failure موحدة.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 49: إضافة notification channel

- **التشخيص:** Extension خلف Contract.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.

#### بطاقة 50: واجهة 20 method

- **التشخيص:** قسّم capabilities.
- **اتجاه الاعتماد:** Adapter إلى Contract داخلي.
- **اختبار:** بدّل التفصيل وتحقق من ثبات السياسة.
- **SOLID:** راجع SRP وOCP وDIP ثم LSP وISP.
