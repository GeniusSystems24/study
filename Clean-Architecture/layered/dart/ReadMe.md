---
title: "The Comprehensive Practical Guide to Clean Architecture, Layer-Based Pattern, and SOLID in Dart and Flutter"
author: "Eng. Anwar Al-Sayari"
---

# The Complete Guide to Clean Architecture with a Layered-Based Pattern and SOLID

[اللغة العربية](Readme_ar.md)

[For JavaScript developers](../Javascript/Readme.md)

> A practical English reference that combines architecture theory, dependency diagrams, design rules, code examples, tests, refactoring guidance, and a complete runnable project.

## Guide profile

- Architectural style: `Clean Architecture – Layered-Based Pattern`.
- Part One: layers, boundaries, contracts, dependency direction, and runtime flow.
- Part Two: applying `SOLID` principles across the layers.
- Reference scenarios: login, order creation, and order retrieval.
- Intended level: intermediate to advanced.
- Primary goal: move from cosmetic folder organization to an architecture that is testable, replaceable, and explicit about business rules.

## How to use this guide

Do not treat architecture as a folder template that must be copied unchanged. Start with responsibilities and use cases, then design contracts, and only then select implementation details. The included project is a reference implementation, not a universal prescription.

Recommended study sequence:

1. Read the layer responsibilities.
2. Study the compile-time dependency diagrams.
3. Compare dependency flow with runtime interaction.
4. Apply one SOLID principle to a small example.
5. Run the reference project and its tests.
6. Replace one infrastructure implementation without changing Domain or Application code.
7. Add a new external provider behind an existing abstraction.
8. Run architecture-boundary checks.
9. Review the code with the checklists at the end of this guide.

---

# Part One — Clean Architecture with a Layered-Based Pattern

## 1. The problem this architecture addresses

Small systems often begin with a direct path from a route or screen to a database client. That is fast initially, but the design tends to accumulate structural problems:

- UI code knows database details.
- Business rules become coupled to a framework.
- Tests require network, file-system, or database access.
- Replacing storage affects many unrelated files.
- Error handling is duplicated across controllers and services.
- Validation rules are scattered and inconsistent.
- Circular dependencies appear between modules.
- It becomes difficult to locate the canonical implementation of a business rule.
- Infrastructure models leak into domain code.
- Changes become risky because responsibility boundaries are unclear.

Clean Architecture does not remove the essential complexity of the business. It prevents technical complexity from spreading through the entire codebase.

## 2. The central idea

The application is divided into layers with explicit responsibilities. Compile-time dependencies are controlled so stable business policy does not depend on volatile implementation details.

The layers used in this guide are:

1. `Presentation`
2. `Application`
3. `Domain`
4. `Infrastructure / Data`
5. `Composition Root` as the assembly point, not as a business layer

```mermaid
flowchart TB
    P[Presentation]
    A[Application]
    D[Domain]
    I[Infrastructure / Data]
    C[Composition Root]

    P --> A
    A --> D
    I --> D
    I --> A
    C --> P
    C --> A
    C --> D
    C --> I
```

The diagram describes source-code dependency and import direction. It does not describe the full runtime path of a request.

## 3. Dependency flow versus runtime flow

At runtime, a request may start at the user, travel down to an external data source, and return upward. Compile-time dependencies should still respect the architectural boundaries.

```mermaid
sequenceDiagram
    actor User
    participant UI as Presentation
    participant UC as Application Use Case
    participant Entity as Domain
    participant Port as Repository Abstraction
    participant Impl as Infrastructure Implementation

    User->>UI: Request
    UI->>UC: Input DTO
    UC->>Entity: Create or invoke domain behavior
    UC->>Port: Call abstraction
    Impl-->>Port: Concrete runtime implementation
    Port-->>UC: Domain result
    UC-->>UI: Output DTO
    UI-->>User: Response
```

A common misunderstanding is to conclude that because Infrastructure executes at the bottom of the runtime call chain, Domain must import Infrastructure. The opposite is preferred: Infrastructure implements abstractions owned by the inner policy layers.

## 4. The limited-knowledge rule

Each layer should know as little as possible about the others:

- `Presentation` knows use cases and presentation-oriented contracts.
- `Application` knows domain rules and the abstractions needed to fulfill use cases.
- `Domain` knows neither UI nor database nor framework.
- `Infrastructure` knows the contracts it implements and the technology it integrates.
- `Composition Root` knows all concrete classes because it creates and wires them.

This rule does not ban all imports. It bans imports that reverse the desired dependency direction or expose unnecessary details.

## 5. Architectural boundaries as policy boundaries

A boundary is useful only when it protects a policy difference. Typical policy categories are:

- Interaction policy: how a user or external caller communicates with the system.
- Application policy: how a use case is orchestrated.
- Domain policy: rules that must always remain true.
- Infrastructure policy: how data is stored, transmitted, hashed, logged, or observed.

If two modules change for unrelated reasons, they likely belong on different sides of a boundary.

## 6. Presentation layer

### 6.1 Responsibilities

Presentation is the system boundary facing users or external clients. It commonly contains:

- HTTP controllers and routes.
- CLI commands.
- UI screens and widgets.
- State management.
- Parsing raw transport input.
- Transport-level validation.
- Mapping application output to HTTP responses or view states.
- Selecting a status code or presentation error message.
- Authentication token extraction from the transport.

### 6.2 What should not live here

- Pricing rules.
- SQL or database transactions.
- Complex entity construction.
- Storage-provider selection.
- Domain calculations.
- Cryptographic implementation details.
- Business authorization rules that must be consistent across transports.

### 6.3 Presentation flow

```mermaid
flowchart LR
    U[User or Client] --> R[Route]
    R --> C[Controller]
    C --> TV[Transport Validation]
    TV --> DTO[Input DTO]
    DTO --> UC[Use Case]
    UC --> OUT[Output DTO]
    OUT --> RESP[HTTP, CLI, or UI Response]
```

### 6.4 Transport validation

Presentation validation focuses on the shape of the request:

- Is the field present?
- Is the JSON valid?
- Is the expected type a string, number, or list?
- Is the request within size limits?
- Is the `Content-Type` supported?
- Can the route parameter be parsed?

A rule such as “a cancelled order cannot be confirmed” is a domain rule, not transport validation.

## 7. Application layer

### 7.1 Role

The Application layer implements use cases and coordinates operations. It is not the canonical home of core business invariants, but it knows the sequence of steps required to fulfill a user goal.

Typical use cases include:

- `LoginUseCase`
- `CreateOrderUseCase`
- `GetOrderUseCase`
- `CancelSubscriptionUseCase`
- `GenerateInvoiceUseCase`

### 7.2 Contents

- Use cases.
- Commands and queries.
- Input DTOs.
- Output DTOs.
- Input and output ports.
- Application-specific errors.
- Transaction orchestration.
- Use-case authorization checks.
- Coordination across repositories or services.

### 7.3 What should not live here

- HTTP status codes.
- Widgets or screens.
- SQL or vendor SDK calls.
- Framework-specific decorators as core policy.
- Domain invariants that must be protected by the entity itself.

### 7.4 Use-case lifecycle

```mermaid
flowchart TB
    Input[Input DTO] --> Validate[Application Validation]
    Validate --> Load[Load Domain Objects]
    Load --> Rule[Invoke Domain Behavior]
    Rule --> Persist[Persist Through Abstraction]
    Persist --> Output[Output DTO]
```

### 7.5 Rules that belong in Application

A rule belongs here when it coordinates a specific workflow, for example:

- The caller must be authenticated before invoking the use case.
- Two repositories must be called in a defined sequence.
- A transaction must begin and end around several operations.
- A policy is selected based on an application permission.
- An event is published after successful completion.

A rule that must always be true for an entity should remain in Domain.

## 8. Domain layer

### 8.1 The heart of the system

Domain models the business language and protects business invariants. It should remain useful even if the UI, database, framework, or transport is replaced.

Common elements:

- Entities.
- Value Objects.
- Aggregates.
- Domain Services.
- Domain Events.
- Business rules and policies.
- Repository abstractions when they are needed by domain-facing use cases.
- Domain-specific exceptions or result types.

### 8.2 Entities

An entity has identity and a lifecycle. It should protect its own invariants instead of allowing arbitrary external mutation.

Good entity design favors behavior-oriented methods:

- `order.addItem(...)`
- `order.cancel(...)`
- `user.changePassword(...)`
- `subscription.renew(...)`

Avoid exposing mutable fields that permit invalid states.

### 8.3 Value Objects

A Value Object has no persistent identity. Equality is based on value. Typical examples:

- `Email`
- `Money`
- `Address`
- `DateRange`
- `Percentage`

A Value Object should validate itself at construction and remain immutable.

### 8.4 Domain Services

Use a Domain Service when an important domain operation does not naturally belong to one entity or Value Object. It should still express domain policy and remain infrastructure-independent.

### 8.5 Repository abstractions

A repository contract describes the collection-like operations required by the application. It should not expose database-specific query objects, ORM entities, or transport models.

```mermaid
classDiagram
    class OrderRepository {
      <<interface>>
      +save(order)
      +getById(id)
    }
    class InMemoryOrderRepository
    class SqlOrderRepository
    class MongoOrderRepository
    OrderRepository <|.. InMemoryOrderRepository
    OrderRepository <|.. SqlOrderRepository
    OrderRepository <|.. MongoOrderRepository
```

## 9. Infrastructure / Data layer

### 9.1 Responsibilities

Infrastructure handles concrete technical details:

- Repository implementations.
- Database access.
- API clients.
- Local storage.
- File access.
- Message brokers.
- Email, payments, and notification providers.
- Cryptographic services.
- Logging adapters.
- Cache implementations.
- Mappers between external models and domain objects.

### 9.2 The leakage rule

Infrastructure-specific objects should not escape into the inner layers. Avoid returning:

- ORM entities.
- Raw JSON objects.
- Vendor SDK responses.
- Database cursors.
- Framework request or response objects.

Map them to domain entities, Value Objects, or explicit DTOs.

### 9.3 Mapper responsibilities

A mapper translates between representations. It should not silently invent business decisions. Mapping and validation are separate concerns:

- Mapping changes shape.
- Validation determines whether input is acceptable.
- Domain construction protects invariants.

```mermaid
flowchart LR
    RAW[Raw API or DB Model] --> MAP[Mapper]
    MAP --> DOMAIN[Domain Entity]
    DOMAIN --> MAP2[Mapper]
    MAP2 --> DTO[Persistence or Transport Model]
```

## 10. Composition Root

The Composition Root is the only place that should freely know concrete implementations. It creates the object graph, selects adapters, and injects dependencies.

```mermaid
flowchart LR
    C[Composition Root] --> Controller
    C --> LoginUseCase
    C --> UserRepositoryImpl
    C --> PasswordHasherImpl
    C --> TokenServiceImpl
    Controller --> LoginUseCase
    LoginUseCase --> UserRepositoryContract
    LoginUseCase --> PasswordHasherContract
    LoginUseCase --> TokenServiceContract
```

Do not spread object construction throughout use cases. Hidden construction creates hidden coupling and makes replacement difficult.

## 11. Layered pattern versus feature-based organization

These are different dimensions:

- Layered architecture describes responsibility and dependency boundaries.
- Feature-based organization describes how files are grouped for navigation and ownership.

They can be combined. A large system may use feature folders, with each feature containing `presentation`, `application`, `domain`, and `infrastructure` subfolders.

```mermaid
flowchart TB
    Root[src]
    Root --> Auth[auth feature]
    Root --> Orders[orders feature]
    Auth --> AP[presentation]
    Auth --> AA[application]
    Auth --> AD[domain]
    Auth --> AI[infrastructure]
    Orders --> OP[presentation]
    Orders --> OA[application]
    Orders --> OD[domain]
    Orders --> OI[infrastructure]
```

Choose the file organization that best supports ownership and discovery, while keeping dependency boundaries explicit.

## 12. Boundary rules

A practical rule set:

1. Domain imports no framework or infrastructure package.
2. Application imports Domain and contract modules, not concrete adapters.
3. Presentation imports Application-facing APIs, not persistence clients.
4. Infrastructure may import Domain and Application contracts to implement them.
5. Composition Root may import all layers.
6. Shared utilities must not become a hidden dependency dumping ground.
7. Cross-layer models must be explicit and intentional.
8. Tests may cross boundaries only when the test type requires it.

```mermaid
flowchart LR
    P[Presentation] --> A[Application]
    A --> D[Domain]
    I[Infrastructure] --> A
    I --> D
    C[Composition Root] --> P
    C --> A
    C --> D
    C --> I
```

## 13. Contracts between layers

### 13.1 Repository contract

Represents data access required by a use case or domain policy.

### 13.2 Service port

Represents a technical capability required by Application, such as hashing, token generation, clock access, or email delivery.

### 13.3 Input port

Represents how a caller invokes a use case. In many languages, the use-case class itself is the input port.

### 13.4 Output port

Represents how a use case reports results to a specific boundary. It is optional; explicit return values are often simpler.

### 13.5 Contract quality checklist

A good contract should be:

- Small.
- Named in business language.
- Free from vendor-specific types.
- Stable relative to its implementations.
- Easy to fake in tests.
- Explicit about errors and nullability.
- Focused on caller needs.

## 14. DTOs

DTOs carry data across boundaries. They are not automatically domain models.

Use DTOs when:

- The transport shape differs from the domain model.
- You want to hide internal state.
- A use case returns a purpose-built response.
- Versioning is required.
- Serialization concerns must remain outside Domain.

Avoid creating DTOs mechanically for every method when no boundary or representation difference exists.

## 15. Mapping

Mapping should occur at the boundary where representations differ.

Typical mapping points:

- HTTP request to input DTO.
- Persistence row to domain entity.
- Domain entity to output DTO.
- External provider response to internal result.

```mermaid
flowchart LR
    HTTP[HTTP JSON] --> INPUT[Input DTO]
    INPUT --> UC[Use Case]
    UC --> DOMAIN[Domain Entity]
    DOMAIN --> OUTPUT[Output DTO]
    OUTPUT --> JSON[HTTP JSON]
```

## 16. Error handling

Errors should retain meaning as they move outward.

A useful classification:

- `DomainError`: invariant or business-rule violation.
- `ApplicationError`: use-case failure, missing resource, or policy rejection.
- `InfrastructureError`: provider, database, network, or serialization failure.
- `PresentationError`: malformed request or unsupported transport behavior.

Presentation maps internal errors to an external representation. Domain should not know HTTP status codes.

```mermaid
flowchart BT
    DBE[Database Error] --> IE[Infrastructure Error]
    IE --> AE[Application Error or Result]
    DE[Domain Error] --> AE
    AE --> PM[Presentation Mapping]
    PM --> HTTP[HTTP Status and Body]
```

## 17. Validation strategy

Validation exists at multiple levels:

| Level | Concern | Example |
| --- | --- | --- |
| Presentation | Transport shape | Required JSON field |
| Application | Use-case precondition | Caller has permission |
| Domain | Invariant | Quantity must be positive |
| Infrastructure | Provider constraint | Column length or API format |

Do not duplicate the same rule without a reason. Some defensive repetition is acceptable at trust boundaries, but the canonical rule should have one owner.

## 18. Transactions

Transaction boundaries usually belong to Application because a use case knows which operations must succeed atomically. The technical transaction mechanism is supplied by Infrastructure.

```mermaid
sequenceDiagram
    participant UC as Use Case
    participant TX as Transaction Port
    participant R1 as Repository A
    participant R2 as Repository B

    UC->>TX: begin
    UC->>R1: save aggregate
    UC->>R2: save audit record
    alt success
        UC->>TX: commit
    else failure
        UC->>TX: rollback
    end
```

Avoid making entities aware of database transactions.

## 19. Caching

Caching is normally an infrastructure concern, but cache policy may be application-specific.

Common patterns:

- Cache-aside.
- Read-through repository decorator.
- Write-through.
- Time-based invalidation.
- Event-based invalidation.

```mermaid
flowchart LR
    UC[Use Case] --> R[Repository Contract]
    R --> CR[Cached Repository Decorator]
    CR --> C[Cache]
    CR --> DB[Primary Repository]
```

A decorator allows caching to be added without changing the use case, demonstrating OCP and DIP.

## 20. Authentication and authorization

Separate these concerns:

- Authentication establishes identity.
- Authorization determines whether an identity may perform an action.
- Credential parsing belongs to Presentation.
- Token verification is a technical service behind a port.
- Business permission rules may belong to Application or Domain depending on scope.

Do not spread role strings and permission checks across controllers.

## 21. Logging and monitoring

Logging is a cross-cutting technical concern. Prefer structured logging through an abstraction or middleware. Domain entities should not emit framework logs directly.

Useful observability fields:

- Correlation ID.
- Use-case name.
- Duration.
- Result category.
- External provider name.
- Retry count.
- Error code.

Never log secrets, plaintext passwords, full tokens, or sensitive personal data.

## 22. Testing pyramid

```mermaid
flowchart TB
    E2E[E2E Tests — Few]
    INT[Integration Tests — Some]
    APP[Application Tests — Many]
    DOM[Domain Unit Tests — Many]
    E2E --> INT --> APP --> DOM
```

### 22.1 Domain tests

- Fast.
- No framework.
- No database.
- Cover invariants and value semantics.

### 22.2 Application tests

- Use fakes or mocks for ports.
- Verify orchestration and result mapping.
- Avoid testing framework internals.

### 22.3 Infrastructure tests

- Verify concrete adapters against real or disposable dependencies.
- Use contract tests so multiple implementations behave consistently.

### 22.4 Presentation tests

- Verify routing, parsing, status mapping, and response shape.
- Keep business assertions in lower-level tests.

## 23. Architecture tests

Architecture tests enforce import rules automatically.

Typical checks:

- Domain does not import Infrastructure.
- Application does not import Presentation.
- Presentation does not import database packages.
- Concrete repository classes are used only in Composition Root and tests.
- Cycles are rejected.

A lightweight script can scan import statements, while larger systems may use dependency-graph tools.

---

# Part Two — Applying SOLID Inside the Layered Architecture

## 24. SRP — Single Responsibility Principle

### 24.1 Meaning

A module should have one reason to change. “One responsibility” does not mean one method; it means one coherent axis of change.

### 24.2 Across the layers

- Presentation changes because interaction or transport changes.
- Application changes because a workflow changes.
- Domain changes because business policy changes.
- Infrastructure changes because technology or providers change.

### 24.3 Violation indicators

- A controller validates business rules, runs SQL, and formats email.
- A repository calculates discounts.
- A use case parses HTTP headers.
- An entity sends network requests.
- A service has dozens of unrelated dependencies.

### 24.4 Refactoring path

1. Identify independent reasons to change.
2. Name each responsibility in business or technical language.
3. Move each responsibility behind a focused interface or class.
4. Keep orchestration in Application.
5. Add tests before and after the move.

## 25. OCP — Open/Closed Principle

### 25.1 Meaning

Software elements should be open for extension and closed for modification. New behavior should often be introduced by adding a new implementation, decorator, strategy, or policy rather than rewriting stable code.

### 25.2 Examples

- Add `PostgresOrderRepository` without changing `CreateOrderUseCase`.
- Add `CachedOrderRepository` as a decorator.
- Add a new `TokenService` implementation.
- Add a new pricing strategy behind a policy contract.

### 25.3 Avoid giant conditionals

A large `if/else` or `switch` based on provider type often signals a missing abstraction. Do not remove every conditional; remove conditionals that select volatile implementation behavior throughout stable policy code.

```mermaid
classDiagram
    class NotificationSender {
      <<interface>>
      +send(message)
    }
    class EmailSender
    class SmsSender
    class PushSender
    NotificationSender <|.. EmailSender
    NotificationSender <|.. SmsSender
    NotificationSender <|.. PushSender
```

## 26. LSP — Liskov Substitution Principle

### 26.1 Meaning

Any implementation of a contract must be usable wherever the contract is expected without breaking the caller's valid assumptions.

An implementation violates LSP when it:

- Throws unsupported-operation errors for required operations.
- Returns a different semantic meaning.
- Strengthens preconditions unexpectedly.
- Weakens postconditions.
- Changes error categories incompatibly.
- Mutates state that the contract promises not to mutate.

### 26.2 Repository example

If `OrderRepository.getById(id)` promises either an `Order` or a not-found result, every implementation must preserve that behavior. A cache implementation cannot silently return stale data beyond the documented policy, and a mock should not bypass important contract rules.

### 26.3 Contract tests

Run the same test suite against every implementation to verify substitutability.

```mermaid
flowchart TB
    CT[Repository Contract Test Suite]
    CT --> MEM[InMemory Repository]
    CT --> SQL[SQL Repository]
    CT --> CACHE[Cached Repository]
```

## 27. ISP — Interface Segregation Principle

### 27.1 Meaning

Clients should not depend on methods they do not use. Prefer focused interfaces shaped around use-case needs.

A broad interface such as `GenericRepository<T>` can force unrelated capabilities onto all models. Instead, use focused contracts:

- `OrderReader`
- `OrderWriter`
- `UserByEmailFinder`
- `TokenIssuer`

### 27.2 Benefits

- Smaller mocks and fakes.
- Fewer accidental dependencies.
- Clearer ownership.
- Easier implementation by external adapters.
- Less pressure to return generic, weakly typed results.

## 28. DIP — Dependency Inversion Principle

### 28.1 Meaning

High-level policy should not depend on low-level details. Both depend on abstractions. Details implement abstractions owned near the policy that needs them.

```mermaid
flowchart LR
    UC[Login Use Case] --> UR[User Repository Contract]
    UC --> PH[Password Hasher Contract]
    UC --> TS[Token Service Contract]
    IUR[In-Memory User Repository] --> UR
    SH[SHA Hasher] --> PH
    HT[HMAC Token Service] --> TS
```

### 28.2 Who owns the abstraction?

The abstraction should be owned by the layer whose policy it serves. If Application needs to load a user, the contract should be defined in or near Application/Domain, not buried in the database adapter package.

### 28.3 DIP is not only dependency injection

Dependency injection is a wiring technique. DIP is the design rule that stable policy depends on abstractions. A container can inject concrete classes while still violating DIP if the use case imports those concrete types.

## 29. SOLID mapping by layer

| Principle | Presentation | Application | Domain | Infrastructure |
| --- | --- | --- | --- | --- |
| SRP | Separate parsing, controller, and response mapping | One use case per workflow | Focused entities and services | Separate clients, mappers, repositories |
| OCP | Add presenters or transports | Add use cases or policies | Add strategies and domain policies | Add adapters and decorators |
| LSP | Replace presenters consistently | Replace ports/fakes | Preserve domain contracts | Implement contracts faithfully |
| ISP | Small view contracts | Focused input/output ports | Focused repository contracts | Focused provider adapters |
| DIP | Depend on use-case APIs | Depend on ports and Domain | Depend on pure abstractions | Implement inner abstractions |

## 30. How the principles reinforce one another

- SRP exposes natural boundaries.
- ISP keeps contracts aligned with those boundaries.
- DIP turns contracts into stable dependency points.
- OCP allows new implementations to be added behind the contracts.
- LSP ensures those implementations are genuinely interchangeable.

```mermaid
flowchart LR
    SRP --> ISP
    ISP --> DIP
    DIP --> OCP
    OCP --> LSP
    LSP --> Maintainability
```

## 31. Common anti-patterns

### 31.1 Fat Controller

A controller parses input, enforces business policy, executes SQL, and formats output. Split transport concerns from use-case orchestration and domain logic.

### 31.2 Anemic Domain with scattered rules

Entities are passive data bags while rules live in random services. Move invariant-protecting behavior into entities and Value Objects.

### 31.3 Over-generalized Generic Repository

A generic CRUD abstraction exposes operations that are not meaningful for every aggregate. Prefer use-case-oriented contracts.

### 31.4 Hidden Service Locator

A global registry hides dependencies and makes tests order-dependent. Use explicit constructor injection from Composition Root.

### 31.5 Framework Leakage

Domain or Application imports framework request objects, decorators, ORM entities, or SDK exceptions. Map at the boundary.

### 31.6 DTO Leakage

One data structure is reused across HTTP, Application, Domain, and persistence. Each boundary loses independence.

### 31.7 Circular Dependencies

Two modules import each other because responsibilities are entangled. Extract a stable abstraction or move the shared policy to the correct owner.

### 31.8 God Service

A service contains dozens of unrelated methods and dependencies. Split by cohesive use case or domain capability.

## 32. Refactoring strategy

A safe migration path from a tangled system:

1. Add characterization tests around current behavior.
2. Identify one high-value use case.
3. Extract a use-case class from the controller.
4. Move business invariants into entities or Value Objects.
5. Introduce repository/service abstractions at the policy boundary.
6. Move concrete data access behind adapters.
7. Create a Composition Root.
8. Add import-boundary checks.
9. Repeat feature by feature.
10. Remove obsolete paths only after tests prove equivalence.

Avoid a full rewrite when incremental extraction is possible.

## 33. Choosing the right complexity level

Not every project needs four physical packages, dozens of interfaces, and a container. Use architectural elements where they protect real change boundaries.

Questions to ask:

- Is the business logic non-trivial?
- Are there multiple transports?
- Are external providers likely to change?
- Is test isolation valuable?
- Will several developers work in parallel?
- Does the system have long expected lifetime?
- Is regulatory traceability required?

For a tiny script, a few functions may be enough. For a long-lived product, explicit boundaries usually repay the initial cost.

## 34. Design checklist

### Domain

- Business invariants are protected inside Domain.
- Domain has no framework imports.
- Value Objects validate their own state.
- Entities expose behavior, not arbitrary mutation.
- Repository contracts use domain language.
- Domain errors are meaningful and transport-independent.

### Application

- Each use case has one clear goal.
- Dependencies are explicit in the constructor.
- Input and output models are intentional.
- Transactions are orchestrated here when needed.
- No SQL or HTTP details are present.
- Authorization policy is placed deliberately.

### Infrastructure

- Adapters implement contracts faithfully.
- Raw provider models do not leak inward.
- Mapping is explicit.
- Retry, timeout, and observability policies are visible.
- Secrets are injected, not hard-coded.
- Contract tests cover substitutability.

### Presentation

- Controllers are thin.
- Transport validation is separated from business validation.
- Error mapping is centralized.
- HTTP status codes remain here.
- Presentation imports no persistence package.
- Response shapes are stable and versionable.

## 35. Code-review questions

1. What is the single responsibility of this module?
2. What business rule does this code protect?
3. Which layer owns the abstraction?
4. Can the dependency be replaced in a unit test?
5. Does this change introduce a framework type into Domain?
6. Is a DTO being reused across unrelated boundaries?
7. Does this implementation honor the full contract?
8. Could a decorator or strategy add this behavior without modifying stable code?
9. Is the transaction boundary explicit?
10. Are logs free from sensitive information?
11. Does the error retain business meaning?
12. Is there an import cycle?
13. Can a new provider be added without changing the use case?
14. Are we solving a real problem or adding ceremonial abstraction?
15. Does the test assert behavior rather than implementation detail?

## 36. Practical exercises

### Exercise 1 — Cancel order

Add `CancelOrderUseCase`. The Domain entity must reject cancellation after shipment. Keep the controller transport-focused.

### Exercise 2 — Cached repository

Create a repository decorator that caches reads. The use case must remain unchanged.

### Exercise 3 — Alternative token provider

Add a second token implementation and select it only in Composition Root.

### Exercise 4 — Database adapter

Replace the in-memory repository with a SQL or document-store adapter without modifying Domain.

### Exercise 5 — Domain event

Publish `OrderCreated` after successful creation. Decide whether event publication belongs in the use case or a transaction/outbox abstraction.

### Exercise 6 — Authorization policy

Introduce a focused `OrderAuthorizationPolicy` and test it independently.

### Exercise 7 — Pagination

Add order listing with an explicit page request and page result. Do not leak database cursor objects.

### Exercise 8 — Structured logging

Add correlation IDs and use-case duration without logging secrets.

### Exercise 9 — Retry policy

Wrap an external adapter with a retry decorator. Do not retry domain validation failures.

### Exercise 10 — Contract tests

Write one reusable suite and run it against all repository implementations.

## 37. Reference project architecture

```mermaid
flowchart TB
    Router --> AuthController
    Router --> OrderController
    AuthController --> LoginUseCase
    OrderController --> CreateOrderUseCase
    OrderController --> GetOrderUseCase
    LoginUseCase --> UserRepository
    LoginUseCase --> PasswordHasher
    LoginUseCase --> TokenService
    CreateOrderUseCase --> OrderRepository
    GetOrderUseCase --> OrderRepository
    UserRepository <|.. InMemoryUserRepository
    OrderRepository <|.. InMemoryOrderRepository
```

## 38. Login scenario

```mermaid
sequenceDiagram
    actor Client
    participant Controller as AuthController
    participant UseCase as LoginUseCase
    participant Users as UserRepository
    participant Hasher as PasswordHasher
    participant Tokens as TokenService

    Client->>Controller: POST /api/auth/login
    Controller->>UseCase: LoginRequest
    UseCase->>Users: findByEmail
    Users-->>UseCase: User
    UseCase->>Hasher: verify
    Hasher-->>UseCase: true
    UseCase->>Tokens: issue
    Tokens-->>UseCase: token
    UseCase-->>Controller: LoginResponse
    Controller-->>Client: 200 JSON
```

## 39. Create-order scenario

```mermaid
sequenceDiagram
    actor Client
    participant Controller as OrderController
    participant UseCase as CreateOrderUseCase
    participant Order as Domain Order
    participant Repo as OrderRepository

    Client->>Controller: POST /api/orders
    Controller->>UseCase: CreateOrderRequest
    UseCase->>Order: construct and validate items
    UseCase->>Repo: save(order)
    Repo-->>UseCase: persisted order
    UseCase-->>Controller: output DTO
    Controller-->>Client: 201 JSON
```

## 40. Acceptance criteria for the reference project

- Login succeeds with the demo credentials.
- Invalid credentials produce a stable application error.
- An order rejects empty items or non-positive quantities.
- Money rejects negative amounts and currency mismatch.
- Use cases are testable with in-memory implementations.
- Presentation does not import repository implementations.
- Domain imports no framework package.
- Concrete implementations are selected in Composition Root.
- Boundary checks fail when an illegal import is introduced.
- All example tests pass in the documented runtime.

## 41. Production hardening checklist

- Replace demo token logic with a reviewed implementation.
- Store password hashes using a password-specific KDF.
- Use secure secret management.
- Add request size limits.
- Add timeouts to external calls.
- Use idempotency where required.
- Add transactional persistence.
- Add an outbox for reliable events.
- Add rate limiting and abuse controls.
- Add structured logs, metrics, and traces.
- Redact sensitive values.
- Add health and readiness checks.
- Add database migrations.
- Add dependency vulnerability scanning.
- Add contract and integration tests in CI.

## 42. Advanced questions and answers

### Does every project need four layers?

No. Use the minimum structure that preserves important boundaries. A small tool may combine Presentation and Application, while a complex product benefits from explicit separation.

### Must repository interfaces always live in Domain?

No universal rule applies. Put the contract near the policy that owns the required operation. Domain ownership is common when the contract is expressed in domain language; Application ownership is reasonable when it is purely use-case-specific.

### Is a DTO required for every function?

No. DTOs are boundary tools, not ceremony. Use them when representation, versioning, or coupling concerns justify them.

### May Infrastructure depend on Domain?

Yes. Infrastructure often imports domain entities and contracts in order to implement persistence or external-service adapters.

### May Presentation depend on Domain?

Prefer Presentation to depend on Application outputs. Direct Domain use can be acceptable for simple read-only display values, but it increases coupling and should be deliberate.

### Where should authorization live?

Transport-level identity extraction belongs to Presentation. Use-case authorization usually belongs to Application. Invariants that depend on business ownership may belong to Domain.

### Where do events live?

Domain events belong to Domain; publication infrastructure belongs to Infrastructure; orchestration and transaction coordination usually belong to Application.

### What about CQRS?

CQRS can be introduced when read and write models have meaningfully different needs. Do not add it only to imitate a pattern.

### What about microservices?

Clean internal boundaries are valuable inside a modular monolith and inside each service. Microservices do not replace architecture; they add distributed-system complexity.

### How do I know the architecture is over-engineered?

Symptoms include interfaces with only one trivial implementation and no testing benefit, DTOs that duplicate fields without boundary value, use cases that only forward calls, and excessive navigation for simple behavior.

## 43. Glossary

| Term | Meaning |
| --- | --- |
| Entity | Domain object with identity and lifecycle |
| Value Object | Immutable value-defined domain concept |
| Aggregate | Consistency boundary around related domain objects |
| Use Case | Application workflow that fulfills a user goal |
| Port | Abstraction required by a policy layer |
| Adapter | Concrete implementation connecting a port to technology |
| Repository | Collection-like abstraction for aggregate persistence |
| DTO | Data Transfer Object used across a boundary |
| Mapper | Translator between representations |
| Composition Root | Central object-graph assembly point |
| Dependency Rule | Stable policy does not depend on volatile details |
| Contract Test | Reusable test suite applied to multiple implementations |
| Decorator | Wrapper adding behavior while preserving a contract |
| Strategy | Interchangeable policy implementation |
| Domain Event | Record that a domain-relevant fact occurred |
| Outbox | Reliable event-publication pattern coupled with persistence |
| Idempotency | Repeating an operation has no unintended additional effect |

## 44. Pre-release architecture checklist

- [ ] Domain has no framework imports.
- [ ] Application has no database client imports.
- [ ] Presentation has no concrete repository imports.
- [ ] Infrastructure models are mapped before crossing inward.
- [ ] Every use case has focused tests.
- [ ] Important invariants have Domain tests.
- [ ] Errors are mapped in one place.
- [ ] Secrets are not committed or logged.
- [ ] Timeouts and retries are bounded.
- [ ] Transactions are explicit.
- [ ] Architecture checks run in CI.
- [ ] Dependency cycles are rejected.
- [ ] Public DTOs are versioned deliberately.
- [ ] Observability fields are structured.
- [ ] Contract tests cover replaceable adapters.

---
# Dart-Specific Implementation Guide

## 45. Why Dart is well suited to explicit layered boundaries

Dart provides static types, interfaces through abstract classes, immutable data patterns, sound null safety, and strong analyzer support. These features make architectural contracts visible and enforceable.

Important practices:

- Use `abstract interface class` or `abstract class` for ports.
- Prefer immutable entities and DTOs.
- Use constructor injection.
- Use sealed results or typed exceptions deliberately.
- Keep framework imports out of Domain.
- Configure analyzer rules.
- Use package-level boundaries when the codebase grows.
- Add tests for every use case and Value Object.

## 46. Dart SRP example

### Poor design

```dart
class OrderController {
  Future<void> create(HttpRequest request) async {
    // Parses transport, validates business rules,
    // calculates totals, persists, and writes HTTP output.
  }
}
```

### Improved design

```dart
class OrderController {
  OrderController(this._createOrderUseCase);

  final CreateOrderUseCase _createOrderUseCase;

  Future<Map<String, Object?>> create(
    CreateOrderRequest request,
  ) async {
    return _createOrderUseCase.execute(request);
  }
}
```

## 47. Dart DIP example

```dart
abstract interface class UserRepository {
  Future<User?> findByEmail(Email email);
}

class LoginUseCase {
  LoginUseCase({
    required UserRepository userRepository,
    required PasswordHasher passwordHasher,
    required TokenService tokenService,
  })  : _userRepository = userRepository,
        _passwordHasher = passwordHasher,
        _tokenService = tokenService;

  final UserRepository _userRepository;
  final PasswordHasher _passwordHasher;
  final TokenService _tokenService;
}
```

The Composition Root supplies concrete implementations:

```dart
final userRepository = InMemoryUserRepository(seedUsers);
final passwordHasher = SimplePasswordHasher();
final tokenService = SimpleTokenService(secret: secret);
final loginUseCase = LoginUseCase(
  userRepository: userRepository,
  passwordHasher: passwordHasher,
  tokenService: tokenService,
);
```

## 48. Testing a Dart use case

```dart
import 'package:test/test.dart';

class FakeUserRepository implements UserRepository {
  @override
  Future<User?> findByEmail(Email email) async {
    if (email.value == 'user@example.com') {
      return User(
        id: 'u-1',
        email: email,
        passwordHash: 'hash',
      );
    }
    return null;
  }
}

void main() {
  test('login returns a token for valid credentials', () async {
    final useCase = LoginUseCase(
      userRepository: FakeUserRepository(),
      passwordHasher: FakePasswordHasher(valid: true),
      tokenService: FakeTokenService('token'),
    );

    final result = await useCase.execute(
      const LoginRequest(
        email: 'user@example.com',
        password: 'secret',
      ),
    );

    expect(result.token, 'token');
  });
}
```

## 49. Dart import-boundary rules

| From | May import |
| --- | --- |
| `domain` | `domain`, language-level utilities |
| `application` | `application`, `domain` |
| `presentation` | `presentation`, `application` |
| `infrastructure` | `infrastructure`, `application`, `domain` |
| `composition` | all layers |

For larger systems, split layers or bounded contexts into separate packages and use the analyzer to enforce public APIs.

## 50. Running the Dart project

```bash
dart pub get
dart test
dart analyze
dart run bin/server.dart
```

The API listens on `http://localhost:8080`.

Example login request:

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H 'content-type: application/json' \
  -d '{"email":"anwar@example.com","password":"secret123"}'
```

## 51. Dart production notes

- Replace demo cryptography with reviewed packages.
- Use immutable data classes or records carefully at boundaries.
- Prefer typed failures for expected business outcomes.
- Avoid broad `catch (e)` without preserving stack traces.
- Add request cancellation and timeouts where supported.
- Validate environment configuration before starting the server.
- Use `dart analyze` in CI.
- Add integration tests for concrete adapters.
- Keep Flutter-specific or server-framework types outside Domain.
- Add package boundaries as the codebase grows.

---
# Project Extension Labs

## Lab 1 — Add `CancelOrderUseCase`

Goal: add cancellation without changing existing use cases.

Acceptance criteria:

- A pending order can be cancelled.
- A shipped order cannot be cancelled.
- The invariant lives in Domain.
- The controller maps the domain/application error.
- Unit tests cover both outcomes.

## Lab 2 — Add `CachedOrderRepository`

Goal: demonstrate OCP and decorator composition.

Steps:

1. Implement the same repository contract.
2. Read from cache first.
3. Fall back to the wrapped repository.
4. Cache successful reads.
5. Invalidate on writes.
6. Wire the decorator in Composition Root.
7. Keep use cases unchanged.

## Lab 3 — Add an alternative token provider

- Define behavior through the existing port.
- Implement a new provider.
- Run the same contract tests.
- Select it through configuration in Composition Root.
- Do not add provider checks to `LoginUseCase`.

## Lab 4 — Add a database adapter

- Choose SQL or a document database.
- Create persistence models outside Domain.
- Map rows/documents to domain entities.
- Preserve not-found and save semantics.
- Add integration tests.
- Run repository contract tests.

## Lab 5 — Add a domain event

Introduce `OrderCreated` with:

- Order ID.
- User ID.
- Total amount.
- Timestamp from an injected clock.

Decide whether publication is immediate, transactional, or outbox-based. Document the decision.

## Lab 6 — Add authorization

Create a policy that answers whether an actor may read or cancel an order. Keep token parsing out of the policy.

## Lab 7 — Add pagination

Use explicit models such as:

- `PageRequest`
- `PageResult<T>`
- `OrderSort`

Do not expose database cursors unless the public contract intentionally uses cursor pagination.

## Lab 8 — Add structured logging

Record:

- Correlation ID.
- Use-case name.
- Duration.
- Result category.
- Error code.

Do not record secrets or raw passwords.

## Lab 9 — Add retry and timeout policies

Apply them only to retryable infrastructure failures. Use bounded attempts and backoff. Do not retry validation or invariant failures.

## Lab 10 — Add contract tests

Build a reusable repository test suite and run it against:

- In-memory implementation.
- Database implementation.
- Cached decorator.

## Lab 11 — Add idempotent order creation

- Accept an idempotency key.
- Store the result by key.
- Return the previous result for duplicate requests.
- Keep transport parsing separate from application policy.

## Lab 12 — Add an outbox

- Persist the aggregate and outbox record atomically.
- Publish asynchronously.
- Mark successful publication.
- Retry safely.
- Monitor backlog size.

## Lab 13 — Add a second transport

Expose the same use cases through CLI, HTTP, or a message consumer. Do not duplicate business rules.

## Lab 14 — Add a second currency policy

Introduce a pricing or exchange policy behind a focused abstraction. Keep `Money` invariant-safe.

## Lab 15 — Add architecture fitness functions

Fail CI when:

- Domain imports framework code.
- Application imports concrete adapters.
- Presentation imports persistence.
- Dependency cycles appear.
- A forbidden package is introduced.

---

# Architecture Decision Record Template

```markdown
# ADR-001: Adopt Clean Layered Architecture

## Status
Accepted

## Context
Describe the business complexity, expected lifetime, team size, testing requirements, and external integrations.

## Decision
Use Presentation, Application, Domain, Infrastructure/Data, and a Composition Root with explicit dependency rules.

## Alternatives
- Transaction-script architecture
- Framework-centric MVC
- Feature-only folder organization
- Full hexagonal architecture
- Modular monolith with package boundaries

## Consequences
Positive:
- Testable policy layers
- Replaceable infrastructure
- Explicit responsibilities
- Better long-term maintainability

Negative:
- More files and contracts
- Higher initial learning cost
- Risk of ceremonial abstractions
- Need for automated boundary checks
```

# Interview and Review Questions

1. Explain the difference between runtime call direction and compile-time dependency direction.
2. Why should Domain avoid framework imports?
3. When should a rule live in Application instead of Domain?
4. Who should own a repository abstraction?
5. How does DIP differ from dependency injection?
6. Give an example of an LSP violation in a repository.
7. When is a DTO valuable, and when is it ceremony?
8. How would you add caching without changing a use case?
9. Where should a transaction boundary live?
10. How do contract tests support LSP?
11. Why can a generic repository violate ISP?
12. What belongs in Composition Root?
13. How do you prevent infrastructure model leakage?
14. How would you migrate a legacy controller incrementally?
15. Which architecture rules should be enforced automatically?
16. How do Domain Events relate to Application orchestration?
17. When is CQRS justified?
18. Why does a modular monolith still need internal boundaries?
19. How do you test a use case without a database?
20. What evidence would tell you the architecture is over-engineered?

# Executive Summary

Clean layered architecture is not a folder convention. It is a policy for assigning responsibility and controlling dependency direction. Presentation handles interaction. Application orchestrates use cases. Domain protects business meaning and invariants. Infrastructure implements replaceable technical details. Composition Root assembles the object graph.

SOLID strengthens these boundaries: SRP clarifies why modules change, ISP keeps contracts focused, DIP points dependencies toward abstractions, OCP enables extension behind those abstractions, and LSP guarantees that replacements preserve behavior.

The architecture is successful when business rules are easy to locate, tests are fast and isolated, infrastructure can be replaced without rewriting use cases, and new developers can explain why each dependency exists.

---
# Complete Reference Project Appendix

The following appendix contains the full source tree and every project file so the guide remains self-contained.

## Project tree

```text
.gitignore
README.md
analysis_options.yaml
bin/server.dart
lib/src/application/dto/create_order_request.dart
lib/src/application/dto/login_request.dart
lib/src/application/dto/login_response.dart
lib/src/application/errors/application_exception.dart
lib/src/application/ports/password_hasher.dart
lib/src/application/ports/token_service.dart
lib/src/application/usecases/create_order_use_case.dart
lib/src/application/usecases/get_order_use_case.dart
lib/src/application/usecases/login_use_case.dart
lib/src/composition/app_container.dart
lib/src/composition/create_http_handler.dart
lib/src/domain/entities/order.dart
lib/src/domain/entities/user.dart
lib/src/domain/errors/domain_exception.dart
lib/src/domain/repositories/order_repository.dart
lib/src/domain/repositories/user_repository.dart
lib/src/domain/value_objects/email.dart
lib/src/domain/value_objects/money.dart
lib/src/infrastructure/repositories/in_memory_order_repository.dart
lib/src/infrastructure/repositories/in_memory_user_repository.dart
lib/src/infrastructure/security/simple_password_hasher.dart
lib/src/infrastructure/security/simple_token_service.dart
lib/src/presentation/controllers/auth_controller.dart
lib/src/presentation/controllers/order_controller.dart
lib/src/presentation/http/json_io.dart
lib/src/presentation/http/router.dart
lib/src/presentation/middleware/error_handler.dart
lib/src/shared/result.dart
pubspec.yaml
test/application/create_order_use_case_test.dart
test/application/login_use_case_test.dart
test/domain/money_test.dart
```

## Source files

### `.gitignore`

```gitignore
.dart_tool/
build/
coverage/
```
### `README.md`

```markdown
# Dart Layered Clean Architecture Example

A small Dart HTTP API demonstrating:

- Presentation, Application, Domain, and Infrastructure/Data layers.
- SOLID principles and dependency inversion.
- Login, order creation, and order retrieval use cases.
- Dependency injection through a composition root.
- Unit tests.

## Requirements

- Dart SDK 3.3 or newer.

## Run

```bash
dart pub get
dart test
dart analyze
dart run bin/server.dart
```

The API listens on `http://localhost:8080`.

## Demo credentials

- Email: `anwar@example.com`
- Password: `secret123`
```
### `analysis_options.yaml`

```yaml
include: package:lints/recommended.yaml
```
### `bin/server.dart`

```dart
import 'dart:io';

import 'package:dart_layered_clean_architecture_example/src/composition/app_container.dart';
import 'package:dart_layered_clean_architecture_example/src/composition/create_http_handler.dart';

Future<void> main() async {
  final container = await AppContainer.create();
  final handler = createHttpHandler(container);
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  stdout.writeln(
    'Dart Layered Clean Architecture example listening on '
    'http://${server.address.host}:${server.port}',
  );

  await for (final request in server) {
    await handler(request);
  }
}
```
### `lib/src/application/dto/create_order_request.dart`

```dart
import '../errors/application_exception.dart';

final class CreateOrderItemRequest {
  const CreateOrderItemRequest({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  factory CreateOrderItemRequest.fromJson(Map<String, Object?> json) {
    return CreateOrderItemRequest(
      productId: json['productId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      unitPrice: (json['unitPrice'] as num?) ?? -1,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  final String productId;
  final String name;
  final num unitPrice;
  final int quantity;
}

final class CreateOrderRequest {
  CreateOrderRequest({
    required this.userId,
    required this.currency,
    required List<CreateOrderItemRequest> items,
  }) : items = List.unmodifiable(items) {
    if (userId.trim().isEmpty || currency.trim().isEmpty || items.isEmpty) {
      throw const ApplicationException(
        'INVALID_ORDER_REQUEST',
        'userId, currency, and at least one item are required.',
        status: 422,
      );
    }
  }

  factory CreateOrderRequest.fromJson(Map<String, Object?> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => CreateOrderItemRequest.fromJson(
                  item.map((key, value) => MapEntry(key.toString(), value)),
                ))
            .toList()
        : <CreateOrderItemRequest>[];

    return CreateOrderRequest(
      userId: json['userId']?.toString() ?? '',
      currency: json['currency']?.toString().toUpperCase() ?? '',
      items: items,
    );
  }

  final String userId;
  final String currency;
  final List<CreateOrderItemRequest> items;
}
```
### `lib/src/application/dto/login_request.dart`

```dart
import '../errors/application_exception.dart';

final class LoginRequest {
  LoginRequest({required String email, required String password})
      : email = email.trim().toLowerCase(),
        password = password {
    if (this.email.isEmpty || this.password.isEmpty) {
      throw const ApplicationException(
        'INVALID_LOGIN_REQUEST',
        'Email and password are required.',
        status: 422,
      );
    }
  }

  factory LoginRequest.fromJson(Map<String, Object?> json) {
    return LoginRequest(
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  final String email;
  final String password;
}
```
### `lib/src/application/dto/login_response.dart`

```dart
final class LoginResponse {
  const LoginResponse({required this.token, required this.user});

  final String token;
  final Map<String, Object> user;

  Map<String, Object> toJson() => {
        'token': token,
        'user': user,
      };
}
```
### `lib/src/application/errors/application_exception.dart`

```dart
final class ApplicationException implements Exception {
  const ApplicationException(
    this.code,
    this.message, {
    this.status = 400,
    this.details,
  });

  final String code;
  final String message;
  final int status;
  final Object? details;

  @override
  String toString() => 'ApplicationException($code): $message';
}
```
### `lib/src/application/ports/password_hasher.dart`

```dart
abstract interface class PasswordHasher {
  Future<String> hash(String plainText);
  Future<bool> verify(String plainText, String hash);
}
```
### `lib/src/application/ports/token_service.dart`

```dart
abstract interface class TokenService {
  Future<String> issue(Map<String, Object> claims);
}
```
### `lib/src/application/usecases/create_order_use_case.dart`

```dart
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/value_objects/money.dart';
import '../dto/create_order_request.dart';
import '../errors/application_exception.dart';

typedef Clock = DateTime Function();

final class CreateOrderUseCase {
  CreateOrderUseCase({
    required this.userRepository,
    required this.orderRepository,
    Clock? clock,
  }) : clock = clock ?? (() => DateTime.now().toUtc());

  final UserRepository userRepository;
  final OrderRepository orderRepository;
  final Clock clock;

  Future<Map<String, Object>> execute(CreateOrderRequest request) async {
    final user = await userRepository.findById(request.userId);
    if (user == null) {
      throw const ApplicationException(
        'USER_NOT_FOUND',
        'User was not found.',
        status: 404,
      );
    }
    user.assertCanLogin();

    final items = request.items
        .map(
          (item) => OrderItem(
            productId: item.productId,
            name: item.name,
            unitPrice: Money(item.unitPrice, request.currency),
            quantity: item.quantity,
          ),
        )
        .toList();

    final order = Order(
      id: await orderRepository.nextIdentity(),
      userId: user.id,
      items: items,
      createdAt: clock(),
    );

    await orderRepository.save(order);
    return order.toJson();
  }
}
```
### `lib/src/application/usecases/get_order_use_case.dart`

```dart
import '../../domain/repositories/order_repository.dart';
import '../errors/application_exception.dart';

final class GetOrderUseCase {
  const GetOrderUseCase({required this.orderRepository});

  final OrderRepository orderRepository;

  Future<Map<String, Object>> execute(String id) async {
    final order = await orderRepository.findById(id);
    if (order == null) {
      throw const ApplicationException(
        'ORDER_NOT_FOUND',
        'Order was not found.',
        status: 404,
      );
    }
    return order.toJson();
  }
}
```
### `lib/src/application/usecases/login_use_case.dart`

```dart
import '../../domain/repositories/user_repository.dart';
import '../../domain/value_objects/email.dart';
import '../dto/login_request.dart';
import '../dto/login_response.dart';
import '../errors/application_exception.dart';
import '../ports/password_hasher.dart';
import '../ports/token_service.dart';

final class LoginUseCase {
  const LoginUseCase({
    required this.userRepository,
    required this.passwordHasher,
    required this.tokenService,
  });

  final UserRepository userRepository;
  final PasswordHasher passwordHasher;
  final TokenService tokenService;

  Future<LoginResponse> execute(LoginRequest request) async {
    final email = Email(request.email);
    final user = await userRepository.findByEmail(email);

    if (user == null) {
      throw const ApplicationException(
        'INVALID_CREDENTIALS',
        'Invalid credentials.',
        status: 401,
      );
    }

    user.assertCanLogin();
    final matches = await passwordHasher.verify(
      request.password,
      user.passwordHash,
    );

    if (!matches) {
      throw const ApplicationException(
        'INVALID_CREDENTIALS',
        'Invalid credentials.',
        status: 401,
      );
    }

    final token = await tokenService.issue({
      'sub': user.id,
      'email': user.email.value,
    });

    return LoginResponse(
      token: token,
      user: user.toPublicJson(),
    );
  }
}
```
### `lib/src/composition/app_container.dart`

```dart
import '../application/usecases/create_order_use_case.dart';
import '../application/usecases/get_order_use_case.dart';
import '../application/usecases/login_use_case.dart';
import '../domain/entities/user.dart';
import '../domain/value_objects/email.dart';
import '../infrastructure/repositories/in_memory_order_repository.dart';
import '../infrastructure/repositories/in_memory_user_repository.dart';
import '../infrastructure/security/simple_password_hasher.dart';
import '../infrastructure/security/simple_token_service.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/order_controller.dart';

final class AppContainer {
  AppContainer._({
    required this.authController,
    required this.orderController,
  });

  final AuthController authController;
  final OrderController orderController;

  static Future<AppContainer> create() async {
    const passwordHasher = SimplePasswordHasher();
    final userRepository = InMemoryUserRepository([
      User(
        id: 'u-1',
        email: Email('anwar@example.com'),
        name: 'Anwar',
        passwordHash: await passwordHasher.hash('secret123'),
      ),
    ]);
    final orderRepository = InMemoryOrderRepository();
    final tokenService = SimpleTokenService(secret: 'development-secret');

    final loginUseCase = LoginUseCase(
      userRepository: userRepository,
      passwordHasher: passwordHasher,
      tokenService: tokenService,
    );
    final createOrderUseCase = CreateOrderUseCase(
      userRepository: userRepository,
      orderRepository: orderRepository,
    );
    final getOrderUseCase = GetOrderUseCase(
      orderRepository: orderRepository,
    );

    return AppContainer._(
      authController: AuthController(loginUseCase: loginUseCase),
      orderController: OrderController(
        createOrderUseCase: createOrderUseCase,
        getOrderUseCase: getOrderUseCase,
      ),
    );
  }
}
```
### `lib/src/composition/create_http_handler.dart`

```dart
import 'dart:io';

import '../presentation/http/json_io.dart';
import '../presentation/http/router.dart';
import '../presentation/middleware/error_handler.dart';
import 'app_container.dart';

Future<void> Function(HttpRequest) createHttpHandler(AppContainer container) {
  final router = Router()
    ..register('POST', '/api/auth/login', container.authController.login)
    ..register('POST', '/api/orders', container.orderController.create)
    ..register('GET', '/api/orders/:id', container.orderController.getById);

  return (HttpRequest request) async {
    try {
      final match = router.match(request.method, request.uri.path);
      if (match == null) {
        await sendJson(request.response, HttpStatus.notFound, {
          'error': {
            'code': 'ROUTE_NOT_FOUND',
            'message': 'Route was not found.',
          },
        });
        return;
      }
      await match.handler(request, match.params);
    } catch (error, stackTrace) {
      stderr.writeln(stackTrace);
      await handleError(request.response, error);
    }
  };
}
```
### `lib/src/domain/entities/order.dart`

```dart
import '../errors/domain_exception.dart';
import '../value_objects/money.dart';

final class OrderItem {
  OrderItem({
    required this.productId,
    required this.name,
    required Money unitPrice,
    required this.quantity,
  }) : unitPrice = unitPrice {
    if (productId.trim().isEmpty || name.trim().isEmpty) {
      throw const DomainException(
        'INVALID_ORDER_ITEM',
        'Product id and name are required.',
      );
    }
    if (quantity <= 0) {
      throw const DomainException(
        'INVALID_QUANTITY',
        'Quantity must be a positive integer.',
      );
    }
  }

  final String productId;
  final String name;
  final Money unitPrice;
  final int quantity;

  Money subtotal() => unitPrice.multiply(quantity);

  Map<String, Object> toJson() => {
        'productId': productId,
        'name': name,
        'unitPrice': unitPrice.toJson(),
        'quantity': quantity,
        'subtotal': subtotal().toJson(),
      };
}

final class Order {
  Order({
    required this.id,
    required this.userId,
    required List<OrderItem> items,
    this.status = 'CREATED',
    DateTime? createdAt,
  })  : items = List.unmodifiable(items),
        createdAt = createdAt ?? DateTime.now().toUtc() {
    if (id.trim().isEmpty || userId.trim().isEmpty) {
      throw const DomainException(
        'INVALID_ORDER',
        'Order id and user id are required.',
      );
    }
    if (items.isEmpty) {
      throw const DomainException(
        'EMPTY_ORDER',
        'An order must contain at least one item.',
      );
    }
  }

  final String id;
  final String userId;
  final List<OrderItem> items;
  String status;
  final DateTime createdAt;

  Money total() {
    final first = items.first.subtotal();
    return items.skip(1).fold(first, (sum, item) => sum.add(item.subtotal()));
  }

  void confirm() {
    if (status != 'CREATED') {
      throw const DomainException(
        'INVALID_ORDER_STATE',
        'Only created orders can be confirmed.',
      );
    }
    status = 'CONFIRMED';
  }

  Map<String, Object> toJson() => {
        'id': id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'total': total().toJson(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };
}
```
### `lib/src/domain/entities/user.dart`

```dart
import '../errors/domain_exception.dart';
import '../value_objects/email.dart';

final class User {
  User({
    required this.id,
    required Email email,
    required this.name,
    required this.passwordHash,
    this.active = true,
  }) : email = email {
    if (id.trim().isEmpty || name.trim().isEmpty || passwordHash.isEmpty) {
      throw const DomainException(
        'INVALID_USER',
        'User id, name, and password hash are required.',
      );
    }
  }

  final String id;
  final Email email;
  final String name;
  final String passwordHash;
  bool active;

  void deactivate() {
    active = false;
  }

  void assertCanLogin() {
    if (!active) {
      throw const DomainException(
        'USER_INACTIVE',
        'Inactive users cannot sign in.',
      );
    }
  }

  Map<String, Object> toPublicJson() => {
        'id': id,
        'email': email.value,
        'name': name,
        'active': active,
      };
}
```
### `lib/src/domain/errors/domain_exception.dart`

```dart
final class DomainException implements Exception {
  const DomainException(this.code, this.message, {this.details});

  final String code;
  final String message;
  final Object? details;

  @override
  String toString() => 'DomainException($code): $message';
}
```
### `lib/src/domain/repositories/order_repository.dart`

```dart
import '../entities/order.dart';

abstract interface class OrderRepository {
  Future<String> nextIdentity();
  Future<void> save(Order order);
  Future<Order?> findById(String id);
}
```
### `lib/src/domain/repositories/user_repository.dart`

```dart
import '../entities/user.dart';
import '../value_objects/email.dart';

abstract interface class UserRepository {
  Future<User?> findByEmail(Email email);
  Future<User?> findById(String id);
}
```
### `lib/src/domain/value_objects/email.dart`

```dart
import '../errors/domain_exception.dart';

final class Email {
  Email(String value) : value = _validate(value);

  final String value;

  static String _validate(String raw) {
    final normalized = raw.trim().toLowerCase();
    final pattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!pattern.hasMatch(normalized)) {
      throw const DomainException(
        'INVALID_EMAIL',
        'A valid email address is required.',
      );
    }
    return normalized;
  }

  @override
  bool operator ==(Object other) => other is Email && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
```
### `lib/src/domain/value_objects/money.dart`

```dart
import '../errors/domain_exception.dart';

final class Money {
  Money(num amount, String currency)
      : amount = _validateAmount(amount),
        currency = _validateCurrency(currency);

  final double amount;
  final String currency;

  static double _validateAmount(num amount) {
    if (amount.isNaN || amount.isInfinite || amount < 0) {
      throw const DomainException(
        'INVALID_MONEY',
        'Money amount must be a non-negative finite number.',
      );
    }
    return double.parse(amount.toStringAsFixed(2));
  }

  static String _validateCurrency(String value) {
    final normalized = value.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(normalized)) {
      throw const DomainException(
        'INVALID_CURRENCY',
        'Currency must be a three-letter code.',
      );
    }
    return normalized;
  }

  Money add(Money other) {
    _assertSameCurrency(other);
    return Money(amount + other.amount, currency);
  }

  Money multiply(int multiplier) {
    if (multiplier < 0) {
      throw const DomainException(
        'INVALID_MULTIPLIER',
        'Multiplier must be non-negative.',
      );
    }
    return Money(amount * multiplier, currency);
  }

  void _assertSameCurrency(Money other) {
    if (other.currency != currency) {
      throw const DomainException(
        'CURRENCY_MISMATCH',
        'Money values must use the same currency.',
      );
    }
  }

  Map<String, Object> toJson() => {
        'amount': amount,
        'currency': currency,
      };
}
```
### `lib/src/infrastructure/repositories/in_memory_order_repository.dart`

```dart
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

final class InMemoryOrderRepository implements OrderRepository {
  InMemoryOrderRepository([Iterable<Order> initialOrders = const []])
      : _orders = {for (final order in initialOrders) order.id: order},
        _sequence = initialOrders.length;

  final Map<String, Order> _orders;
  int _sequence;

  @override
  Future<String> nextIdentity() async {
    _sequence += 1;
    return 'o-$_sequence';
  }

  @override
  Future<void> save(Order order) async {
    _orders[order.id] = order;
  }

  @override
  Future<Order?> findById(String id) async => _orders[id];
}
```
### `lib/src/infrastructure/repositories/in_memory_user_repository.dart`

```dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/value_objects/email.dart';

final class InMemoryUserRepository implements UserRepository {
  InMemoryUserRepository([Iterable<User> initialUsers = const []])
      : _users = {for (final user in initialUsers) user.id: user};

  final Map<String, User> _users;

  @override
  Future<User?> findByEmail(Email email) async {
    for (final user in _users.values) {
      if (user.email == email) return user;
    }
    return null;
  }

  @override
  Future<User?> findById(String id) async => _users[id];
}
```
### `lib/src/infrastructure/security/simple_password_hasher.dart`

```dart
import 'dart:convert';

import '../../application/ports/password_hasher.dart';

final class SimplePasswordHasher implements PasswordHasher {
  const SimplePasswordHasher();

  @override
  Future<String> hash(String plainText) async {
    final bytes = utf8.encode(plainText);
    var value = 2166136261;
    for (final byte in bytes) {
      value ^= byte;
      value = (value * 16777619) & 0xffffffff;
    }
    return value.toRadixString(16).padLeft(8, '0');
  }

  @override
  Future<bool> verify(String plainText, String hash) async {
    return await this.hash(plainText) == hash;
  }
}
```
### `lib/src/infrastructure/security/simple_token_service.dart`

```dart
import 'dart:convert';

import '../../application/ports/token_service.dart';

final class SimpleTokenService implements TokenService {
  SimpleTokenService({required this.secret, DateTime Function()? clock})
      : clock = clock ?? (() => DateTime.now().toUtc());

  final String secret;
  final DateTime Function() clock;

  @override
  Future<String> issue(Map<String, Object> claims) async {
    final payload = {
      ...claims,
      'iat': clock().millisecondsSinceEpoch ~/ 1000,
      'secretHint': secret.length,
    };
    return base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '');
  }
}
```
### `lib/src/presentation/controllers/auth_controller.dart`

```dart
import 'dart:io';

import '../../application/dto/login_request.dart';
import '../../application/usecases/login_use_case.dart';
import '../http/json_io.dart';

final class AuthController {
  const AuthController({required this.loginUseCase});

  final LoginUseCase loginUseCase;

  Future<void> login(
    HttpRequest request,
    Map<String, String> _params,
  ) async {
    final body = await readJsonBody(request);
    final result = await loginUseCase.execute(LoginRequest.fromJson(body));
    await sendJson(request.response, HttpStatus.ok, result.toJson());
  }
}
```
### `lib/src/presentation/controllers/order_controller.dart`

```dart
import 'dart:io';

import '../../application/dto/create_order_request.dart';
import '../../application/usecases/create_order_use_case.dart';
import '../../application/usecases/get_order_use_case.dart';
import '../http/json_io.dart';

final class OrderController {
  const OrderController({
    required this.createOrderUseCase,
    required this.getOrderUseCase,
  });

  final CreateOrderUseCase createOrderUseCase;
  final GetOrderUseCase getOrderUseCase;

  Future<void> create(
    HttpRequest request,
    Map<String, String> _params,
  ) async {
    final body = await readJsonBody(request);
    final result = await createOrderUseCase.execute(
      CreateOrderRequest.fromJson(body),
    );
    await sendJson(request.response, HttpStatus.created, result);
  }

  Future<void> getById(
    HttpRequest request,
    Map<String, String> params,
  ) async {
    final result = await getOrderUseCase.execute(params['id'] ?? '');
    await sendJson(request.response, HttpStatus.ok, result);
  }
}
```
### `lib/src/presentation/http/json_io.dart`

```dart
import 'dart:convert';
import 'dart:io';

import '../../application/errors/application_exception.dart';

Future<Map<String, Object?>> readJsonBody(HttpRequest request) async {
  try {
    final content = await utf8.decoder.bind(request).join();
    if (content.trim().isEmpty) return <String, Object?>{};
    final decoded = jsonDecode(content);
    if (decoded is! Map) {
      throw const ApplicationException(
        'INVALID_JSON',
        'JSON body must be an object.',
        status: 400,
      );
    }
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  } on FormatException {
    throw const ApplicationException(
      'INVALID_JSON',
      'Request body must contain valid JSON.',
      status: 400,
    );
  }
}

Future<void> sendJson(
  HttpResponse response,
  int status,
  Object body,
) async {
  response.statusCode = status;
  response.headers.contentType = ContentType.json;
  response.write(jsonEncode(body));
  await response.close();
}
```
### `lib/src/presentation/http/router.dart`

```dart
import 'dart:io';

typedef RouteHandler = Future<void> Function(
  HttpRequest request,
  Map<String, String> params,
);

final class _Route {
  const _Route({
    required this.method,
    required this.pattern,
    required this.handler,
  });

  final String method;
  final String pattern;
  final RouteHandler handler;
}

final class Router {
  final List<_Route> _routes = [];

  void register(String method, String pattern, RouteHandler handler) {
    _routes.add(_Route(
      method: method.toUpperCase(),
      pattern: pattern,
      handler: handler,
    ));
  }

  ({RouteHandler handler, Map<String, String> params})? match(
    String method,
    String path,
  ) {
    final requestSegments = Uri(path: path).pathSegments;

    for (final route in _routes) {
      if (route.method != method.toUpperCase()) continue;
      final patternSegments = Uri(path: route.pattern).pathSegments;
      if (patternSegments.length != requestSegments.length) continue;

      final params = <String, String>{};
      var matches = true;
      for (var index = 0; index < patternSegments.length; index++) {
        final expected = patternSegments[index];
        final actual = requestSegments[index];
        if (expected.startsWith(':')) {
          params[expected.substring(1)] = actual;
        } else if (expected != actual) {
          matches = false;
          break;
        }
      }
      if (matches) return (handler: route.handler, params: params);
    }
    return null;
  }
}
```
### `lib/src/presentation/middleware/error_handler.dart`

```dart
import 'dart:io';

import '../../application/errors/application_exception.dart';
import '../../domain/errors/domain_exception.dart';
import '../http/json_io.dart';

Future<void> handleError(HttpResponse response, Object error) async {
  if (error is ApplicationException) {
    await sendJson(response, error.status, {
      'error': {
        'code': error.code,
        'message': error.message,
        'details': error.details,
      },
    });
    return;
  }

  if (error is DomainException) {
    await sendJson(response, HttpStatus.unprocessableEntity, {
      'error': {
        'code': error.code,
        'message': error.message,
        'details': error.details,
      },
    });
    return;
  }

  stderr.writeln(error);
  await sendJson(response, HttpStatus.internalServerError, {
    'error': {
      'code': 'INTERNAL_ERROR',
      'message': 'An unexpected error occurred.',
    },
  });
}
```
### `lib/src/shared/result.dart`

```dart
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Object error) onFailure,
  });
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;

  @override
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Object error) onFailure,
  }) {
    return onSuccess(value);
  }
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final Object error;

  @override
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Object error) onFailure,
  }) {
    return onFailure(error);
  }
}
```
### `pubspec.yaml`

```yaml
name: dart_layered_clean_architecture_example
description: Layered Clean Architecture and SOLID example using Dart.
version: 1.0.0
environment:
  sdk: ">=3.3.0 <4.0.0"

dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.0
```
### `test/application/create_order_use_case_test.dart`

```dart
import 'package:dart_layered_clean_architecture_example/src/application/dto/create_order_request.dart';
import 'package:dart_layered_clean_architecture_example/src/application/usecases/create_order_use_case.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/entities/user.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/value_objects/email.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/repositories/in_memory_order_repository.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/repositories/in_memory_user_repository.dart';
import 'package:test/test.dart';

void main() {
  test('CreateOrderUseCase creates and persists an order', () async {
    final userRepository = InMemoryUserRepository([
      User(
        id: 'u-1',
        email: Email('anwar@example.com'),
        name: 'Anwar',
        passwordHash: 'hash',
      ),
    ]);
    final orderRepository = InMemoryOrderRepository();
    final useCase = CreateOrderUseCase(
      userRepository: userRepository,
      orderRepository: orderRepository,
      clock: () => DateTime.utc(2026),
    );

    final result = await useCase.execute(
      CreateOrderRequest(
        userId: 'u-1',
        currency: 'USD',
        items: const [
          CreateOrderItemRequest(
            productId: 'p-1',
            name: 'Keyboard',
            unitPrice: 80,
            quantity: 2,
          ),
        ],
      ),
    );

    expect((result['total'] as Map)['amount'], 160);
    expect(result['status'], 'CREATED');
    expect(await orderRepository.findById(result['id'] as String), isNotNull);
  });
}
```
### `test/application/login_use_case_test.dart`

```dart
import 'package:dart_layered_clean_architecture_example/src/application/dto/login_request.dart';
import 'package:dart_layered_clean_architecture_example/src/application/ports/token_service.dart';
import 'package:dart_layered_clean_architecture_example/src/application/usecases/login_use_case.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/entities/user.dart';
import 'package:dart_layered_clean_architecture_example/src/domain/value_objects/email.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/repositories/in_memory_user_repository.dart';
import 'package:dart_layered_clean_architecture_example/src/infrastructure/security/simple_password_hasher.dart';
import 'package:test/test.dart';

final class FakeTokenService implements TokenService {
  @override
  Future<String> issue(Map<String, Object> claims) async => 'token-1';
}

void main() {
  test('LoginUseCase returns a token and public user data', () async {
    const passwordHasher = SimplePasswordHasher();
    final user = User(
      id: 'u-1',
      email: Email('anwar@example.com'),
      name: 'Anwar',
      passwordHash: await passwordHasher.hash('secret123'),
    );
    final useCase = LoginUseCase(
      userRepository: InMemoryUserRepository([user]),
      passwordHasher: passwordHasher,
      tokenService: FakeTokenService(),
    );

    final result = await useCase.execute(
      LoginRequest(email: 'anwar@example.com', password: 'secret123'),
    );

    expect(result.token, 'token-1');
    expect(result.user['email'], 'anwar@example.com');
  });
}
```
### `test/domain/money_test.dart`

```dart
import 'package:dart_layered_clean_architecture_example/src/domain/value_objects/money.dart';
import 'package:test/test.dart';

void main() {
  test('Money adds values with the same currency', () {
    final total = Money(10, 'USD').add(Money(5.5, 'USD'));
    expect(total.toJson(), {'amount': 15.5, 'currency': 'USD'});
  });

  test('Money rejects mismatched currencies', () {
    expect(
      () => Money(10, 'USD').add(Money(10, 'EUR')),
      throwsA(isA<Exception>()),
    );
  });
}
```

# Final Notes for Dart

Use the project as a laboratory. Replace one detail at a time, run the tests, and verify that policy layers remain unchanged. The strongest evidence of a useful architecture is not the number of folders; it is the ability to change volatile details while preserving stable business behavior.

**Author credit:** Eng. Anwar Al-Sayari
