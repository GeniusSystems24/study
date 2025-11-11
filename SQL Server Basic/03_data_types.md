# 3. أنواع البيانات (Data Types)

## مقدمة

أنواع البيانات في SQL Server هي أساس بنية قاعدة البيانات، وتحدد:

- 🔹 **نوع القيم**: ما الذي يمكن تخزينه في العمود
- 🔹 **حجم التخزين**: المساحة المطلوبة على القرص وفي الذاكرة
- 🔹 **الأداء**: سرعة المعالجة والبحث والفرز
- 🔹 **سلامة البيانات**: القيود والتحقق من صحة البيانات
- 🔹 **العمليات المتاحة**: الدوال والمعاملات التي يمكن تطبيقها
- 🔹 **قابلية الفهرسة**: كيفية إنشاء واستخدام الفهارس

## أهمية اختيار النوع المناسب

```sql
-- ❌ مثال سيء: استخدام NVARCHAR(MAX) لرمز بريدي
CREATE TABLE BadExample (
    PostalCode NVARCHAR(MAX)  -- يستهلك ذاكرة ضخمة!
);

-- ✅ مثال جيد: استخدام النوع المناسب
CREATE TABLE GoodExample (
    PostalCode CHAR(5)        -- يستهلك 5 بايت فقط
);
```

## تصنيف أنواع البيانات في SQL Server

SQL Server يحتوي على أكثر من 30 نوع بيانات مدمج، مصنفة إلى:

1. **Exact Numerics** (الأرقام الدقيقة)
2. **Approximate Numerics** (الأرقام التقريبية)
3. **Date and Time** (التاريخ والوقت)
4. **Character Strings** (النصوص)
5. **Unicode Character Strings** (النصوص بـ Unicode)
6. **Binary Strings** (البيانات الثنائية)
7. **Other Data Types** (أنواع أخرى)

## 1. الأنواع الرقمية الدقيقة (Exact Numeric Types)

### الأعداد الصحيحة (Integer Types)

#### نظرة تفصيلية

| النوع | المدى (Signed) | المدى بالأرقام | حجم التخزين | Bits | الاستخدام الأمثل |
|------|---------------|----------------|-------------|------|------------------|
| **BIT** | 0, 1, NULL | - | 1 بايت لكل 8 أعمدة | 1 | القيم المنطقية (Boolean) |
| **TINYINT** | 0 إلى 255 | 2^8 | 1 بايت | 8 | الأعمار، النسب المئوية، الحالات |
| **SMALLINT** | -32,768 إلى 32,767 | 2^16 | 2 بايت | 16 | العدادات الصغيرة، السنوات |
| **INT** | -2,147,483,648 إلى 2,147,483,647 | 2^32 | 4 بايت | 32 | **المفاتيح الأساسية، العدادات** |
| **BIGINT** | -9,223,372,036,854,775,808 إلى... | 2^64 | 8 بايت | 64 | الأرقام الضخمة، Timestamps |

#### تفاصيل BIT

```sql
-- BIT: نوع خاص للقيم المنطقية
CREATE TABLE ProductFlags (
    ProductID INT PRIMARY KEY,
    IsActive BIT DEFAULT 1,           -- افتراضياً نشط
    IsFeatured BIT DEFAULT 0,
    IsOnSale BIT,
    IsDiscontinued BIT DEFAULT 0
);

-- ملاحظة مهمة: SQL Server يخزن حتى 8 أعمدة BIT في بايت واحد!
-- هذا يوفر المساحة بشكل كبير

-- القيم المقبولة: 0, 1, NULL
INSERT INTO ProductFlags VALUES (1, 1, 0, NULL, 0);  -- صحيح
-- INSERT INTO ProductFlags VALUES (2, 2, 0, 0, 0);  -- خطأ! فقط 0 أو 1

-- استعلام
SELECT * FROM ProductFlags 
WHERE IsActive = 1 AND IsOnSale = 1;
```

#### متى تستخدم كل نوع؟

```sql
-- TINYINT: الأعمار والنسب الصغيرة
CREATE TABLE Persons (
    PersonID INT PRIMARY KEY,
    Age TINYINT CHECK (Age BETWEEN 0 AND 120),
    PerformanceRating TINYINT CHECK (PerformanceRating BETWEEN 1 AND 5)
);

-- SMALLINT: السنوات والأشهر
CREATE TABLE DateParts (
    EventID INT PRIMARY KEY,
    Year SMALLINT,                    -- 1900-2100 كافي
    Month TINYINT CHECK (Month BETWEEN 1 AND 12),
    DayOfMonth TINYINT CHECK (DayOfMonth BETWEEN 1 AND 31)
);

-- INT: المفاتيح الأساسية والعدادات العامة
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    TotalItems INT DEFAULT 0
);

-- BIGINT: الأعداد الضخمة جداً
CREATE TABLE Analytics (
    EventID BIGINT PRIMARY KEY IDENTITY(1,1),
    UnixTimestamp BIGINT,             -- عدد المللي ثانية منذ 1970
    TotalPageViews BIGINT,
    GlobalTransactionID BIGINT
);
```

#### حساب المدى الأقصى

```sql
-- معرفة أقصى وأدنى قيمة لكل نوع
SELECT 
    'TINYINT' AS DataType,
    CAST(0 AS TINYINT) AS MinValue,
    CAST(255 AS TINYINT) AS MaxValue
UNION ALL
SELECT 'SMALLINT', -32768, 32767
UNION ALL
SELECT 'INT', -2147483648, 2147483647;

-- التحقق من overflow
DECLARE @MaxInt INT = 2147483647;
-- SELECT @MaxInt + 1;  -- خطأ Arithmetic overflow!
```

### الأعداد العشرية والمالية (Decimal & Money Types)

#### DECIMAL / NUMERIC (الأفضل للبيانات المالية)

```sql
-- البنية: DECIMAL(precision, scale)
-- precision: إجمالي عدد الأرقام (1-38)
-- scale: عدد الأرقام بعد الفاصلة العشرية (0-precision)

CREATE TABLE PrecisionExamples (
    -- أمثلة على الدقة المختلفة
    Price1 DECIMAL(10,2),        -- 99999999.99 (8 قبل، 2 بعد)
    Price2 DECIMAL(18,4),        -- 99999999999999.9999
    TaxRate DECIMAL(5,4),        -- 9.9999 (نسبة ضريبة)
    ScientificValue DECIMAL(38,10),  -- أقصى دقة
    
    -- NUMERIC مطابق تماماً لـ DECIMAL
    Amount NUMERIC(12,2)
);

-- حساب حجم التخزين
-- Precision 1-9   = 5 bytes
-- Precision 10-19 = 9 bytes
-- Precision 20-28 = 13 bytes
-- Precision 29-38 = 17 bytes

-- أمثلة عملية
INSERT INTO PrecisionExamples (Price1, TaxRate) 
VALUES (12345.67, 0.1425);  -- صحيح

-- INSERT INTO PrecisionExamples (Price1) 
-- VALUES (123456789.99);  -- خطأ! تجاوز الدقة

-- العمليات الحسابية تحافظ على الدقة
SELECT 
    Price1,
    Price1 * 1.15 AS WithTax,
    CAST(Price1 * 1.15 AS DECIMAL(10,2)) AS Rounded
FROM PrecisionExamples;
```

#### MONEY و SMALLMONEY

```sql
-- MONEY: نوع خاص مُحسّن للعملات
CREATE TABLE MoneyExamples (
    -- MONEY
    Salary MONEY,                    -- ±922,337,203,685,477.5808
    Bonus MONEY,
    
    -- SMALLMONEY
    DailyAllowance SMALLMONEY        -- ±214,748.3647
);

-- خصائص MONEY
-- ✅ أسرع من DECIMAL في العمليات الحسابية
-- ✅ يحتوي على 4 أرقام عشرية دائماً
-- ✅ حجم ثابت: 8 بايت (MONEY) أو 4 بايت (SMALLMONEY)
-- ❌ دقة ثابتة قد لا تناسب جميع الحالات

INSERT INTO MoneyExamples VALUES (5500.50, 1000.25, 150.75);

-- مقارنة DECIMAL vs MONEY
DECLARE @DecimalVal DECIMAL(19,4) = 100.12345;
DECLARE @MoneyVal MONEY = 100.12345;

SELECT 
    @DecimalVal AS DecimalValue,     -- 100.1235 (تقريب)
    @MoneyVal AS MoneyValue;         -- 100.1235 (يحفظ 4 فقط)

-- الفرق في الأداء
-- MONEY: أسرع بنسبة 10-15% في العمليات الحسابية
-- DECIMAL: أكثر مرونة في الدقة
```

#### متى تستخدم أي نوع؟

```sql
-- ✅ استخدم DECIMAL عندما:
-- - تحتاج لدقة محددة (مثل 6 أرقام عشرية)
-- - تتعامل مع عملات رقمية أو أسعار صرف دقيقة
-- - تحتاج لحسابات علمية دقيقة

-- ✅ استخدم MONEY عندما:
-- - تتعامل مع عملات تقليدية
-- - 4 أرقام عشرية كافية
-- - تحتاج لأداء أفضل قليلاً
-- - توفير المساحة مهم

CREATE TABLE BestPractices (
    -- للرواتب والأسعار العامة
    Salary MONEY,
    ProductPrice MONEY,
    
    -- لأسعار الصرف والنسب الدقيقة
    ExchangeRate DECIMAL(18,6),
    InterestRate DECIMAL(8,6),
    
    -- للكميات والأوزان
    Quantity DECIMAL(10,3),
    Weight DECIMAL(12,4)
);
```

### الأعداد التقريبية (Approximate Numeric Types)

#### FLOAT و REAL

```sql
-- FLOAT(n): عدد عائم بدقة متغيرة
-- n = عدد البتات للدقة (1-53)
-- n=1-24  → REAL (4 بايت، دقة 7 أرقام)
-- n=25-53 → FLOAT (8 بايت، دقة 15 رقم)

CREATE TABLE ApproximateNumbers (
    -- REAL: دقة منخفضة، مساحة أقل
    Temperature REAL,                -- -3.40E+38 to 3.40E+38
    Humidity REAL,
    
    -- FLOAT: دقة عالية
    Latitude FLOAT(53),              -- -1.79E+308 to 1.79E+308
    Longitude FLOAT(53),
    ScientificValue FLOAT(53),
    
    -- FLOAT بدون تحديد = FLOAT(53)
    Measurement FLOAT
);

-- ⚠️ تحذير مهم: الأرقام التقريبية ليست دقيقة تماماً!
DECLARE @Float1 FLOAT = 0.1;
DECLARE @Float2 FLOAT = 0.2;
DECLARE @Sum FLOAT = @Float1 + @Float2;

SELECT @Sum;  -- قد تكون النتيجة 0.30000000000000004 بدلاً من 0.3!

-- ❌ لا تستخدم FLOAT للمقارنات الدقيقة
SELECT CASE 
    WHEN 0.1 + 0.2 = 0.3 THEN 'Equal'
    ELSE 'Not Equal'  -- ستكون النتيجة!
END;

-- ✅ استخدم DECIMAL للدقة
DECLARE @Dec1 DECIMAL(10,2) = 0.1;
DECLARE @Dec2 DECIMAL(10,2) = 0.2;
SELECT @Dec1 + @Dec2;  -- بالضبط 0.30
```

#### متى تستخدم FLOAT/REAL؟

```sql
-- ✅ استخدم FLOAT عندما:
CREATE TABLE SuitableForFloat (
    -- البيانات العلمية
    PlanckConstant FLOAT,            -- 6.62607015 × 10^-34
    AvogadroNumber FLOAT,            -- 6.022 × 10^23
    
    -- الإحداثيات الجغرافية
    GPS_Latitude FLOAT,
    GPS_Longitude FLOAT,
    
    -- القياسات التقريبية
    SensorReading FLOAT,
    TemperatureKelvin FLOAT
);

-- ❌ لا تستخدم FLOAT لـ:
-- - المبالغ المالية (استخدم DECIMAL/MONEY)
-- - العدادات (استخدم INT)
-- - المفاتيح الأساسية
-- - أي شيء يحتاج مقارنة دقيقة
```

## 2. أنواع التاريخ والوقت (Date and Time Types)

### جدول المقارنة الشامل

| النوع | النطاق | الدقة | حجم التخزين | يدعم Timezone | الاستخدام |
|------|--------|-------|-------------|--------------|-----------|
| **DATE** | 0001-01-01 : 9999-12-31 | يوم | 3 بايت | ❌ | التواريخ فقط |
| **TIME** | 00:00:00 : 23:59:59.9999999 | 100 نانو ثانية | 3-5 بايت | ❌ | الأوقات فقط |
| **DATETIME** | 1753-01-01 : 9999-12-31 | 3.33 مللي ثانية | 8 بايت | ❌ | قديم، شائع |
| **DATETIME2** | 0001-01-01 : 9999-12-31 | 100 نانو ثانية | 6-8 بايت | ❌ | **الأفضل حديثاً** |
| **SMALLDATETIME** | 1900-01-01 : 2079-06-06 | دقيقة | 4 بايت | ❌ | توفير مساحة |
| **DATETIMEOFFSET** | 0001-01-01 : 9999-12-31 | 100 نانو ثانية | 10 بايت | ✅ | تطبيقات عالمية |

### DATE - التاريخ فقط

```sql
-- DATE: يخزن التاريخ فقط بدون وقت
CREATE TABLE EventDates (
    EventID INT PRIMARY KEY,
    EventDate DATE,                  -- فقط السنة-الشهر-اليوم
    BirthDate DATE,
    ExpiryDate DATE
);

-- أمثلة
INSERT INTO EventDates VALUES 
    (1, '2025-11-11', '1990-05-15', '2026-12-31'),
    (2, CAST(GETDATE() AS DATE), '1985-03-20', '2025-06-30');

-- الفوائد
-- ✅ يوفر المساحة (3 بايت فقط)
-- ✅ استعلامات أسرع عند عدم الحاجة للوقت
-- ✅ لا توجد مشاكل في المقارنة (لا يوجد جزء وقت)

SELECT * FROM EventDates 
WHERE EventDate = '2025-11-11';  -- دقيق تماماً
```

### TIME - الوقت فقط

```sql
-- TIME(n): يخزن الوقت فقط
-- n = عدد الأرقام للكسور الثانوية (0-7)

CREATE TABLE WorkShifts (
    ShiftID INT PRIMARY KEY,
    ShiftName NVARCHAR(50),
    StartTime TIME(0),               -- دقة بالثانية
    EndTime TIME(0),
    BreakTime TIME(2)                -- دقة بـ 0.01 ثانية
);

INSERT INTO WorkShifts VALUES 
    (1, N'الصباحية', '08:00:00', '16:00:00', '12:30:00'),
    (2, N'المسائية', '16:00:00', '00:00:00', '20:00:00');

-- حساب الفرق
SELECT 
    ShiftName,
    DATEDIFF(HOUR, StartTime, EndTime) AS ShiftHours,
    DATEADD(HOUR, 1, StartTime) AS AfterOneHour
FROM WorkShifts;
```

### DATETIME vs DATETIME2

```sql
-- DATETIME: النوع القديم (موجود منذ SQL Server 2000)
CREATE TABLE OldDates (
    LegacyDate DATETIME              -- 1753-01-01 to 9999-12-31
);

-- مشاكل DATETIME:
-- ❌ لا يدعم التواريخ قبل 1753
-- ❌ دقة منخفضة (3.33 مللي ثانية)
-- ❌ حجم ثابت (8 بايت)
-- ❌ تقريب غير متوقع

-- مثال على مشكلة التقريب
DECLARE @dt DATETIME = '2025-11-11 12:30:45.123';
SELECT @dt;  -- النتيجة: 2025-11-11 12:30:45.123
-- قد يتم تقريب .123 إلى .120 أو .127!

-- DATETIME2: النوع الحديث (SQL Server 2008+)
CREATE TABLE ModernDates (
    ModernDate DATETIME2(7)          -- دقة قصوى
);

-- مزايا DATETIME2:
-- ✅ نطاق أوسع (من سنة 1 إلى 9999)
-- ✅ دقة أعلى (100 نانو ثانية)
-- ✅ حجم متغير حسب الدقة
-- ✅ توافق مع .NET DateTime

-- مقارنة الدقة
DECLARE @dt2 DATETIME2(7) = '2025-11-11 12:30:45.1234567';
SELECT @dt2;  -- بالضبط: 2025-11-11 12:30:45.1234567

-- اختيار الدقة المناسبة
DATETIME2(0)  -- دقة بالثانية      → 6 بايت
DATETIME2(1)  -- دقة 0.1 ثانية     → 6 بايت
DATETIME2(2)  -- دقة 0.01 ثانية    → 6 بايت
DATETIME2(3)  -- دقة بالمللي ثانية → 7 بايت
DATETIME2(7)  -- دقة قصوى          → 8 بايت (الافتراضي)
```

### DATETIMEOFFSET - مع المنطقة الزمنية

```sql
-- DATETIMEOFFSET: يتضمن معلومات المنطقة الزمنية
CREATE TABLE GlobalEvents (
    EventID INT PRIMARY KEY,
    EventName NVARCHAR(100),
    EventTime DATETIMEOFFSET(7),
    ServerTime DATETIME2(7)
);

-- إدراج بيانات مع timezone
INSERT INTO GlobalEvents VALUES 
    (1, 'New York Meeting', '2025-11-11 10:00:00 -05:00', SYSDATETIME()),
    (2, 'Tokyo Conference', '2025-11-11 23:00:00 +09:00', SYSDATETIME()),
    (3, 'Riyadh Event', '2025-11-11 15:00:00 +03:00', SYSDATETIME());

-- تحويل بين المناطق الزمنية
SELECT 
    EventName,
    EventTime AS OriginalTime,
    SWITCHOFFSET(EventTime, '+00:00') AS UTC_Time,
    SWITCHOFFSET(EventTime, '+03:00') AS RiyadhTime,
    TODATETIMEOFFSET(ServerTime, '+03:00') AS ServerInRiyadh
FROM GlobalEvents;

-- الحصول على timezone الحالي
SELECT SYSDATETIMEOFFSET();  -- مع timezone
SELECT SYSUTCDATETIME();     -- UTC فقط
```

### الدوال الأساسية للتاريخ

```sql
-- الحصول على التاريخ/الوقت الحالي
SELECT 
    GETDATE() AS DATETIME_Now,           -- DATETIME
    SYSDATETIME() AS DATETIME2_Now,      -- DATETIME2(7)
    SYSUTCDATETIME() AS UTC_Now,         -- UTC DATETIME2
    SYSDATETIMEOFFSET() AS WithOffset,   -- مع timezone
    CURRENT_TIMESTAMP AS Standard;       -- مثل GETDATE()

-- استخراج أجزاء التاريخ
SELECT 
    YEAR(GETDATE()) AS CurrentYear,
    MONTH(GETDATE()) AS CurrentMonth,
    DAY(GETDATE()) AS CurrentDay,
    DATEPART(HOUR, GETDATE()) AS CurrentHour,
    DATEPART(MINUTE, GETDATE()) AS CurrentMinute,
    DATEPART(WEEKDAY, GETDATE()) AS DayOfWeek,      -- 1=Sunday
    DATEPART(QUARTER, GETDATE()) AS Quarter;

-- بناء تاريخ من أجزاء
SELECT 
    DATEFROMPARTS(2025, 11, 11) AS NewDate,
    TIMEFROMPARTS(14, 30, 0, 0, 0) AS NewTime,
    DATETIMEFROMPARTS(2025, 11, 11, 14, 30, 0, 0) AS NewDateTime,
    DATETIME2FROMPARTS(2025, 11, 11, 14, 30, 0, 0, 7) AS NewDateTime2;

-- العمليات الحسابية
SELECT 
    DATEADD(DAY, 7, GETDATE()) AS NextWeek,
    DATEADD(MONTH, -3, GETDATE()) AS ThreeMonthsAgo,
    DATEADD(YEAR, 1, GETDATE()) AS NextYear,
    DATEADD(HOUR, 5, GETDATE()) AS In5Hours,
    
    DATEDIFF(DAY, '2020-01-01', GETDATE()) AS DaysSince2020,
    DATEDIFF(MONTH, '2020-01-01', GETDATE()) AS MonthsSince2020,
    DATEDIFF(YEAR, '1990-05-15', GETDATE()) AS Age;

-- DATEDIFF_BIG: للفروقات الكبيرة جداً (يرجع BIGINT)
SELECT DATEDIFF_BIG(SECOND, '1900-01-01', GETDATE()) AS SecondsSince1900;

-- EOMONTH: آخر يوم في الشهر
SELECT 
    EOMONTH(GETDATE()) AS EndOfCurrentMonth,
    EOMONTH(GETDATE(), 1) AS EndOfNextMonth,
    EOMONTH(GETDATE(), -1) AS EndOfLastMonth;
```

### أفضل الممارسات للتواريخ

```sql
-- ✅ استخدام ISO 8601 Format
-- التنسيق: YYYY-MM-DD أو YYYY-MM-DD HH:MM:SS
INSERT INTO Events VALUES ('2025-11-11');        -- ✅ آمن
-- INSERT INTO Events VALUES ('11/11/2025');     -- ❌ قد يُفسر خطأ حسب اللغة

-- ✅ استخدم النوع المناسب
CREATE TABLE BestPracticesDates (
    -- تاريخ ميلاد → DATE كافي
    BirthDate DATE,
    
    -- تاريخ ووقت إنشاء → DATETIME2
    CreatedAt DATETIME2(2) DEFAULT SYSDATETIME(),
    
    -- لتطبيق عالمي → DATETIMEOFFSET
    LastLoginUTC DATETIMEOFFSET(2),
    
    -- وقت محدد → TIME
    DailyReportTime TIME(0)
);

-- ✅ تجنب استخدام DATETIME في التطبيقات الجديدة
-- استخدم DATETIME2 بدلاً منه

-- ✅ احذر من مشاكل Timezone
-- دائماً احفظ في UTC ثم حوّل للعرض
```

## 3. الأنواع النصية (Character String Types)

### الفرق الجوهري: ASCII vs Unicode

```sql
-- ASCII (1 بايت لكل حرف)
-- - يدعم فقط 256 حرف
-- - لا يدعم العربية والصينية واليابانية وغيرها
-- - أصغر في الحجم

-- Unicode (2 بايت لكل حرف)
-- - يدعم أكثر من 65,000 حرف
-- - يدعم جميع لغات العالم
-- - النوع الموصى به للتطبيقات متعددة اللغات
```

### جدول المقارنة الشامل

| النوع | حجم أقصى | ترميز | بايت/حرف | التخزين | Unicode | الاستخدام |
|------|----------|-------|----------|---------|---------|-----------|
| **CHAR(n)** | 8,000 حرف | ASCII | 1 | ثابت | ❌ | رموز ثابتة |
| **VARCHAR(n)** | 8,000 حرف | ASCII | 1 | متغير | ❌ | نصوص إنجليزية |
| **VARCHAR(MAX)** | 2 GB | ASCII | 1 | متغير | ❌ | نصوص ضخمة |
| **NCHAR(n)** | 4,000 حرف | Unicode | 2 | ثابت | ✅ | رموز عالمية |
| **NVARCHAR(n)** | 4,000 حرف | Unicode | 2 | متغير | ✅ | **نصوص عربية** |
| **NVARCHAR(MAX)** | 1 GB | Unicode | 2 | متغير | ✅ | نصوص عربية ضخمة |
| **TEXT** | 2 GB | ASCII | 1 | LOB | ❌ | ⚠️ قديم، استخدم VARCHAR(MAX) |
| **NTEXT** | 1 GB | Unicode | 2 | LOB | ✅ | ⚠️ قديم، استخدم NVARCHAR(MAX) |

### CHAR - النص الثابت

```sql
-- CHAR(n): يخزن بالضبط n بايت، يملأ بمسافات
CREATE TABLE FixedLengthExamples (
    CountryCode CHAR(2),             -- دائماً 2 حرف: SA, US, GB
    PostalCode CHAR(5),              -- دائماً 5 أرقام: 12345
    ProductCode CHAR(10),            -- دائماً 10 أحرف
    Gender CHAR(1),                  -- M أو F
    YesNo CHAR(1)                    -- Y أو N
);

-- أمثلة
INSERT INTO FixedLengthExamples VALUES ('SA', '12345', 'PROD000001', 'M', 'Y');

-- ⚠️ تحذير: CHAR يملأ بمسافات!
DECLARE @Code CHAR(10) = 'ABC';
SELECT 
    LEN(@Code) AS ActualLength,      -- النتيجة: 3
    DATALENGTH(@Code) AS StorageSize; -- النتيجة: 10 (مع مسافات!)

-- المسافات تُزال تلقائياً في المقارنات
SELECT CASE 
    WHEN 'ABC' = CAST('ABC' AS CHAR(10)) THEN 'Equal'  -- ستكون Equal
END;

-- متى تستخدم CHAR؟
-- ✅ الرموز والأكواد ذات الطول الثابت دائماً
-- ✅ الأداء أفضل قليلاً عند البحث والفهرسة
-- ❌ لا تستخدمه للنصوص المتغيرة (مضيعة للمساحة)
```

### VARCHAR - النص المتغير

```sql
-- VARCHAR(n): يخزن فقط الطول الفعلي + 2 بايت overhead
CREATE TABLE VariableLengthExamples (
    Username VARCHAR(50),            -- حتى 50 حرف
    Email VARCHAR(255),              -- حتى 255 حرف
    Description VARCHAR(1000),
    WebsiteURL VARCHAR(500)
);

-- مقارنة التخزين
DECLARE @Char CHAR(100) = 'Hello';
DECLARE @Varchar VARCHAR(100) = 'Hello';

SELECT 
    DATALENGTH(@Char) AS CharStorage,     -- 100 بايت دائماً
    DATALENGTH(@Varchar) AS VarcharStorage; -- 5 بايت فقط!

-- VARCHAR(MAX): للنصوص الضخمة
CREATE TABLE LargeTexts (
    ArticleID INT PRIMARY KEY,
    Content VARCHAR(MAX)             -- حتى 2 GB
);

-- ⚠️ تحذير: MAX له تكلفة أداء
-- لا تستخدم MAX إلا إذا كنت متأكداً أنك تحتاج لأكثر من 8000 حرف
```

### NCHAR و NVARCHAR - دعم Unicode

```sql
-- NVARCHAR: الخيار الأمثل للنصوص العربية
CREATE TABLE ArabicContent (
    -- ❌ خطأ: سيحفظ علامات استفهام ???
    NameASCII VARCHAR(100),
    
    -- ✅ صحيح: يحفظ العربية بشكل صحيح
    NameUnicode NVARCHAR(100),
    
    -- أمثلة متنوعة
    ArabicName NVARCHAR(100),
    ChineseName NVARCHAR(100),
    RussianName NVARCHAR(100),
    MixedContent NVARCHAR(500)
);

-- ⚠️ مهم جداً: استخدم N قبل النص العربي!
INSERT INTO ArabicContent VALUES 
    ('Ahmed',                        -- ASCII - سيعمل للإنجليزية
     N'أحمد محمد',                  -- N قبل النص العربي!
     N'أحمد محمد علي',
     N'王伟',                         -- صيني
     N'Иван Петров',                -- روسي
     N'Hello مرحبا 你好 Привет');   -- مختلط

-- بدون N ستحصل على ??? بدلاً من العربية!
-- INSERT INTO ArabicContent (NameUnicode) VALUES ('أحمد'); -- ❌ خطأ!

-- حساب الحجم
DECLARE @Arabic NVARCHAR(100) = N'أحمد';
SELECT 
    LEN(@Arabic) AS Characters,           -- 4 أحرف
    DATALENGTH(@Arabic) AS Bytes;         -- 8 بايت (4 × 2)

-- NVARCHAR(MAX) للنصوص العربية الضخمة
CREATE TABLE ArabicArticles (
    ArticleID INT PRIMARY KEY,
    Title NVARCHAR(200),
    Content NVARCHAR(MAX),               -- حتى 1 GB
    Summary NVARCHAR(500)
);
```

### الحد الأقصى للأحرف

```sql
-- لماذا الحد 8000 و 4000؟
-- في SQL Server، حجم الصف الواحد محدود بـ 8060 بايت!

-- CHAR/VARCHAR: حد 8000 حرف
-- 8000 بايت × 1 بايت/حرف = 8000 حرف

-- NCHAR/NVARCHAR: حد 4000 حرف
-- 8000 بايت × 0.5 = 4000 حرف (لأن كل حرف = 2 بايت)

-- محاولة تجاوز الحد ستفشل
-- CREATE TABLE TooBig (
--     Data VARCHAR(9000)  -- ❌ خطأ!
-- );

-- الحل: استخدم MAX
CREATE TABLE BigData (
    Data VARCHAR(MAX),   -- ✅ حتى 2 GB
    DataUnicode NVARCHAR(MAX)  -- ✅ حتى 1 GB
);

-- ملاحظة: MAX يُخزن خارج الصف (LOB) إذا تجاوز 8000 بايت
```

### أفضل الممارسات للنصوص

```sql
CREATE TABLE TextBestPractices (
    -- ✅ استخدم NVARCHAR للعربية والنصوص متعددة اللغات
    ArabicName NVARCHAR(100),
    ArabicAddress NVARCHAR(300),
    
    -- ✅ استخدم VARCHAR للإنجليزية فقط (توفير مساحة 50%)
    Email VARCHAR(255),              -- بريد إلكتروني دائماً إنجليزي
    Username VARCHAR(50),
    
    -- ✅ استخدم CHAR للأطوال الثابتة
    CountryCode CHAR(2),
    CurrencyCode CHAR(3),
    PhoneCode CHAR(4),
    
    -- ✅ حدد الطول المناسب (لا تبالغ)
    ShortDescription NVARCHAR(200),  -- ✅
    -- LongDescription NVARCHAR(8000), -- ❌ إذا لم تكن متأكداً
    
    -- ✅ استخدم MAX فقط للحاجة الفعلية
    BlogPost NVARCHAR(MAX),          -- محتوى طويل فعلاً
    
    -- ❌ تجنب TEXT و NTEXT (قديمة)
    -- OldContent TEXT                -- قديم! استخدم VARCHAR(MAX)
);

-- حساب المساحة المستهلكة
SELECT 
    'CHAR(100)' AS Type,
    DATALENGTH(CAST('Hello' AS CHAR(100))) AS Bytes
UNION ALL
SELECT 'VARCHAR(100)', DATALENGTH(CAST('Hello' AS VARCHAR(100)))
UNION ALL
SELECT 'NCHAR(100)', DATALENGTH(CAST(N'Hello' AS NCHAR(100)))
UNION ALL
SELECT 'NVARCHAR(100)', DATALENGTH(CAST(N'Hello' AS NVARCHAR(100)))
UNION ALL
SELECT 'NVARCHAR(مرحبا)', DATALENGTH(CAST(N'مرحبا' AS NVARCHAR(100)));
```

### Collation (الترتيب والمقارنة)

```sql
-- Collation يحدد:
-- 1. كيفية ترتيب النصوص
-- 2. كيفية المقارنة (حساس لحالة الأحرف أم لا)
-- 3. حساسية الحروف المشابهة

-- عرض collation الحالي
SELECT SERVERPROPERTY('Collation') AS ServerCollation;
SELECT DATABASEPROPERTYEX('master', 'Collation') AS DatabaseCollation;

-- أمثلة شائعة
-- SQL_Latin1_General_CP1_CI_AS
--   └─ CI = Case Insensitive (غير حساس لحالة الأحرف)
--   └─ AS = Accent Sensitive (حساس للتشكيل)

-- Arabic_CI_AS: للعربية
-- Latin1_General_CI_AS: للإنجليزية

-- تحديد collation لعمود معين
CREATE TABLE CollationExample (
    EnglishText VARCHAR(100) COLLATE Latin1_General_CI_AS,
    ArabicText NVARCHAR(100) COLLATE Arabic_CI_AS,
    CaseSensitive VARCHAR(100) COLLATE Latin1_General_CS_AS  -- CS = Case Sensitive
);

-- المقارنة
DECLARE @Text1 VARCHAR(50) = 'Hello';
DECLARE @Text2 VARCHAR(50) = 'hello';

-- Case Insensitive (الافتراضي)
SELECT CASE 
    WHEN @Text1 = @Text2 THEN 'Equal'  -- ستكون Equal
    ELSE 'Not Equal'
END;

-- Case Sensitive
SELECT CASE 
    WHEN @Text1 COLLATE Latin1_General_CS_AS = @Text2 COLLATE Latin1_General_CS_AS 
    THEN 'Equal'
    ELSE 'Not Equal'  -- ستكون Not Equal
END;
```

## 3. أنواع التاريخ والوقت (Date/Time Types)

| النوع | النطاق | الدقة | حجم التخزين |
|------|--------|-------|-------------|
| **DATE** | 0001-01-01 إلى 9999-12-31 | يوم | 3 بايت |
| **TIME** | 00:00:00 إلى 23:59:59 | 100 نانو ثانية | 5 بايت |
| **DATETIME** | 1753-01-01 إلى 9999-12-31 | 3.33 ميلي ثانية | 8 بايت |
| **DATETIME2** | 0001-01-01 إلى 9999-12-31 | 100 نانو ثانية | 6-8 بايت |
| **SMALLDATETIME** | 1900-01-01 إلى 2079-06-06 | دقيقة | 4 بايت |
| **DATETIMEOFFSET** | مثل DATETIME2 + timezone | 100 نانو ثانية | 10 بايت |

```sql
CREATE TABLE Events (
    EventID INT PRIMARY KEY,
    EventDate DATE,                      -- فقط التاريخ
    EventTime TIME,                      -- فقط الوقت
    CreatedAt DATETIME,                  -- قديم لكن شائع
    ModifiedAt DATETIME2,                -- الأفضل حديثاً
    QuickNote SMALLDATETIME,             -- لتوفير المساحة
    GlobalTime DATETIMEOFFSET            -- مع المنطقة الزمنية
);

-- أمثلة إدراج
INSERT INTO Events VALUES (
    1,
    '2025-11-11',                        -- DATE
    '14:30:00',                          -- TIME
    GETDATE(),                           -- DATETIME
    SYSDATETIME(),                       -- DATETIME2
    GETDATE(),                           -- SMALLDATETIME
    SYSDATETIMEOFFSET()                  -- DATETIMEOFFSET
);

-- عرض البيانات
SELECT * FROM Events;
```

### الدوال المفيدة

```sql
-- التاريخ والوقت الحالي
SELECT GETDATE();                    -- DATETIME
SELECT SYSDATETIME();                -- DATETIME2
SELECT CURRENT_TIMESTAMP;            -- DATETIME

-- استخراج أجزاء التاريخ
SELECT 
    YEAR(GETDATE()) AS CurrentYear,
    MONTH(GETDATE()) AS CurrentMonth,
    DAY(GETDATE()) AS CurrentDay;

-- إضافة/طرح من التاريخ
SELECT DATEADD(DAY, 7, GETDATE());      -- إضافة 7 أيام
SELECT DATEADD(MONTH, -3, GETDATE());   -- طرح 3 أشهر
SELECT DATEADD(YEAR, 1, GETDATE());     -- إضافة سنة

-- الفرق بين تاريخين
SELECT DATEDIFF(DAY, '2025-01-01', GETDATE()) AS DaysPassed;
SELECT DATEDIFF(YEAR, '2000-05-15', GETDATE()) AS YearsOld;
```

## 4. الأنواع المنطقية (Boolean)

```sql
-- BIT: يخزن 0 أو 1 (أو NULL)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    IsActive BIT DEFAULT 1,          -- 1 = نشط, 0 = غير نشط
    IsFeatured BIT DEFAULT 0,
    IsOnSale BIT
);

-- الإدراج
INSERT INTO Products VALUES (1, N'لابتوب', 1, 0, 1);
INSERT INTO Products VALUES (2, N'هاتف', 1, 1, 0);

-- الاستعلام
SELECT * FROM Products WHERE IsActive = 1;
SELECT * FROM Products WHERE IsFeatured = 1 AND IsOnSale = 1;
```

## 4. الأنواع الثنائية (Binary Data Types)

### جدول المقارنة

| النوع | الحجم الأقصى | التخزين | الاستخدام |
|------|-------------|---------|-----------|
| **BINARY(n)** | 8,000 بايت | ثابت | بيانات ثنائية ثابتة (Hashes, Keys) |
| **VARBINARY(n)** | 8,000 بايت | متغير | بيانات ثنائية متغيرة |
| **VARBINARY(MAX)** | 2 GB | متغير | ملفات، صور، مستندات |
| **IMAGE** | 2 GB | LOB | ⚠️ قديم، استخدم VARBINARY(MAX) |

### BINARY و VARBINARY

```sql
-- BINARY: طول ثابت، يملأ بأصفار
CREATE TABLE BinaryExamples (
    -- BINARY: للبيانات الثابتة
    PasswordHash BINARY(32),         -- SHA-256 hash (دائماً 32 بايت)
    EncryptionKey BINARY(16),        -- AES-128 key (دائماً 16 بايت)
    MD5Hash BINARY(16),              -- MD5 hash (دائماً 16 بايت)
    
    -- VARBINARY: للبيانات المتغيرة
    Signature VARBINARY(256),
    Token VARBINARY(500),
    SmallImage VARBINARY(8000)       -- صورة صغيرة
);

-- تخزين hash
DECLARE @Password NVARCHAR(100) = N'MySecurePassword123';
DECLARE @Hash VARBINARY(32) = HASHBYTES('SHA2_256', @Password);

INSERT INTO BinaryExamples (PasswordHash) VALUES (@Hash);

-- عرض البيانات الثنائية (Hex format)
SELECT 
    PasswordHash,
    CONVERT(VARCHAR(MAX), PasswordHash, 1) AS HexValue,  -- 0x...
    CONVERT(VARCHAR(MAX), PasswordHash, 2) AS HexWithoutPrefix
FROM BinaryExamples;
```

### VARBINARY(MAX) - تخزين الملفات

```sql
-- تخزين الملفات في قاعدة البيانات
CREATE TABLE FileStorage (
    FileID INT PRIMARY KEY IDENTITY(1,1),
    FileName NVARCHAR(255) NOT NULL,
    FileExtension VARCHAR(10),
    FileSize BIGINT,                 -- بالبايت
    ContentType VARCHAR(100),        -- MIME type
    FileContent VARBINARY(MAX),      -- الملف نفسه
    FileHash BINARY(32),             -- SHA-256 للتحقق
    UploadedBy INT,
    UploadDate DATETIME2 DEFAULT SYSDATETIME(),
    LastAccessed DATETIME2
);

-- إدراج ملف (في تطبيق حقيقي يأتي من المستخدم)
INSERT INTO FileStorage (FileName, FileExtension, ContentType, FileContent, FileHash)
VALUES (
    'document.pdf',
    '.pdf',
    'application/pdf',
    0x255044462D,  -- بيانات الملف (مبسط للمثال)
    HASHBYTES('SHA2_256', 0x255044462D)
);

-- استرجاع معلومات الملف
SELECT 
    FileID,
    FileName,
    FileExtension,
    DATALENGTH(FileContent) AS FileSizeBytes,
    DATALENGTH(FileContent) / 1024.0 AS FileSizeKB,
    DATALENGTH(FileContent) / 1048576.0 AS FileSizeMB,
    ContentType,
    UploadDate
FROM FileStorage;

-- ⚠️ ملاحظات مهمة عن تخزين الملفات في قاعدة البيانات:
-- ✅ مزايا:
--    - النسخ الاحتياطي الموحد
--    - ACID Transactions
--    - أمان موحد
-- ❌ عيوب:
--    - حجم قاعدة البيانات يزداد بشكل كبير
--    - بطء في الأداء مع الملفات الكبيرة
--    - نسخ احتياطية أكبر وأبطأ
-- 
-- البديل الأفضل غالباً: تخزين الملفات على نظام الملفات
-- وحفظ المسار فقط في قاعدة البيانات
```

### FILESTREAM - البديل الأفضل للملفات الكبيرة

```sql
-- FILESTREAM: يخزن البيانات في نظام الملفات
-- لكن يديرها SQL Server

-- تفعيل FILESTREAM (يحتاج صلاحيات admin)
-- EXEC sp_configure 'filestream access level', 2;
-- RECONFIGURE;

-- CREATE DATABASE MyDB
-- WITH FILESTREAM (NON_TRANSACTED_ACCESS = FULL);

-- CREATE TABLE DocumentsFileStream (
--     DocumentID UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
--     DocumentName NVARCHAR(255),
--     Document VARBINARY(MAX) FILESTREAM
-- );

-- مزايا FILESTREAM:
-- ✅ أداء أفضل للملفات > 1 MB
-- ✅ يُخزن خارج قاعدة البيانات (توفير مساحة)
-- ✅ يمكن الوصول للملفات مباشرة من Windows
```

## 5. أنواع البيانات الفريدة والمتخصصة

### UNIQUEIDENTIFIER (GUID)

```sql
-- UNIQUEIDENTIFIER: معرّف فريد عالمياً (128-bit)
-- Format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX

CREATE TABLE Sessions (
    SessionID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserID INT NOT NULL,
    SessionToken UNIQUEIDENTIFIER DEFAULT NEWID(),
    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),
    ExpiresAt DATETIME2,
    IsActive BIT DEFAULT 1
);

-- إدراج مع GUID تلقائي
INSERT INTO Sessions (UserID, ExpiresAt)
VALUES (1, DATEADD(HOUR, 24, SYSDATETIME()));

-- إنشاء GUID يدوياً
DECLARE @NewGUID UNIQUEIDENTIFIER = NEWID();
SELECT @NewGUID;  -- مثال: A1B2C3D4-E5F6-7890-ABCD-EF1234567890

-- NEWSEQUENTIALID(): GUIDs متسلسلة (أفضل للفهرسة)
CREATE TABLE OrdersWithGUID (
    OrderID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
    OrderDate DATETIME2 DEFAULT SYSDATETIME()
);

-- مزايا GUID:
-- ✅ فريد عالمياً (يمكن إنشاؤه في أي مكان)
-- ✅ مناسب للأنظمة الموزعة
-- ✅ لا حاجة لـ IDENTITY

-- عيوب GUID:
-- ❌ حجم كبير (16 بايت vs 4 بايت لـ INT)
-- ❌ صعب القراءة والتذكر
-- ❌ أداء الفهرسة أقل (إلا مع NEWSEQUENTIALID)
-- ❌ يزيد حجم الفهارس والجداول

-- مقارنة الأحجام
SELECT 
    DATALENGTH(CAST(1 AS INT)) AS IntSize,           -- 4 بايت
    DATALENGTH(CAST(NEWID() AS UNIQUEIDENTIFIER)) AS GUIDSize;  -- 16 بايت
```

### HIERARCHYID - للبيانات الهرمية

```sql
-- HIERARCHYID: لتمثيل الهياكل الشجرية
CREATE TABLE OrganizationChart (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    Position HIERARCHYID,
    PositionLevel AS Position.GetLevel(),  -- مستوى الموظف
    ManagerPosition HIERARCHYID
);

-- إدراج الرئيس التنفيذي (الجذر)
INSERT INTO OrganizationChart (EmployeeID, EmployeeName, Position)
VALUES (1, N'الرئيس التنفيذي', HIERARCHYID::GetRoot());

-- إدراج المديرين
DECLARE @ManagerPos HIERARCHYID = HIERARCHYID::GetRoot();
INSERT INTO OrganizationChart VALUES 
    (2, N'مدير المبيعات', @ManagerPos.GetDescendant(NULL, NULL), @ManagerPos),
    (3, N'مدير تقنية المعلومات', @ManagerPos.GetDescendant(NULL, NULL), @ManagerPos);

-- الاستعلام الهرمي
SELECT 
    EmployeeID,
    EmployeeName,
    Position.ToString() AS PositionPath,
    PositionLevel
FROM OrganizationChart
ORDER BY Position;

-- مزايا HIERARCHYID:
-- ✅ مُحسّن للهياكل الشجرية
-- ✅ دوال مدمجة للتنقل (GetAncestor, GetDescendant)
-- ✅ أداء أفضل من الاستعلامات العودية
```

### XML - البيانات المنظمة

```sql
-- XML: لتخزين بيانات XML منظمة
CREATE TABLE XmlData (
    DataID INT PRIMARY KEY IDENTITY(1,1),
    XmlContent XML,
    XmlSchema XML SCHEMA COLLECTION MySchemaCollection  -- مع schema
);

-- إدراج XML
INSERT INTO XmlData (XmlContent) VALUES (
    '<person>
        <name>Ahmed Mohamed</name>
        <age>30</age>
        <email>ahmed@example.com</email>
        <phones>
            <phone type="mobile">0501234567</phone>
            <phone type="home">0112345678</phone>
        </phones>
    </person>'
);

-- استعلام XML باستخدام XQuery
SELECT 
    XmlContent.value('(/person/name)[1]', 'NVARCHAR(100)') AS Name,
    XmlContent.value('(/person/age)[1]', 'INT') AS Age,
    XmlContent.value('(/person/email)[1]', 'VARCHAR(100)') AS Email
FROM XmlData;

-- استخراج قائمة
SELECT 
    Phone.value('(@type)[1]', 'VARCHAR(20)') AS PhoneType,
    Phone.value('(.)[1]', 'VARCHAR(20)') AS PhoneNumber
FROM XmlData
CROSS APPLY XmlContent.nodes('/person/phones/phone') AS Phones(Phone);

-- التحقق من وجود عنصر
SELECT * FROM XmlData
WHERE XmlContent.exist('/person/email') = 1;

-- تعديل XML
UPDATE XmlData
SET XmlContent.modify('
    replace value of (/person/age/text())[1]
    with "31"
');
```

### JSON - البيانات شبه المنظمة (SQL Server 2016+)

```sql
-- JSON يُخزن كـ NVARCHAR
CREATE TABLE JsonData (
    DataID INT PRIMARY KEY IDENTITY(1,1),
    JsonContent NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT SYSDATETIME()
);

-- إدراج JSON
INSERT INTO JsonData (JsonContent) VALUES (N'{
    "name": "Ahmed Mohamed",
    "age": 30,
    "email": "ahmed@example.com",
    "phones": [
        {"type": "mobile", "number": "0501234567"},
        {"type": "home", "number": "0112345678"}
    ],
    "address": {
        "city": "Riyadh",
        "country": "Saudi Arabia"
    },
    "skills": ["SQL", "C#", "JavaScript"]
}');

-- قراءة قيم JSON
SELECT 
    JSON_VALUE(JsonContent, '$.name') AS Name,
    JSON_VALUE(JsonContent, '$.age') AS Age,
    JSON_VALUE(JsonContent, '$.email') AS Email,
    JSON_VALUE(JsonContent, '$.address.city') AS City,
    JSON_VALUE(JsonContent, '$.phones[0].number') AS MobilePhone
FROM JsonData;

-- استخراج كائن JSON
SELECT 
    DataID,
    JSON_QUERY(JsonContent, '$.address') AS AddressObject,
    JSON_QUERY(JsonContent, '$.phones') AS PhonesArray,
    JSON_QUERY(JsonContent, '$.skills') AS SkillsArray
FROM JsonData;

-- تحويل JSON إلى جدول
SELECT *
FROM JsonData
CROSS APPLY OPENJSON(JsonContent, '$.phones')
WITH (
    PhoneType VARCHAR(20) '$.type',
    PhoneNumber VARCHAR(20) '$.number'
);

-- تحويل نتيجة استعلام إلى JSON
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE DepartmentID = 1
FOR JSON PATH, ROOT('employees');

-- التحقق من صحة JSON
SELECT ISJSON(N'{"name":"Ahmed"}');  -- 1 = صحيح
SELECT ISJSON(N'{invalid json}');     -- 0 = خطأ

-- تعديل JSON
UPDATE JsonData
SET JsonContent = JSON_MODIFY(
    JsonContent,
    '$.age',
    31
);

-- إضافة عنصر جديد
UPDATE JsonData
SET JsonContent = JSON_MODIFY(
    JsonContent,
    '$.lastModified',
    CONVERT(VARCHAR(30), SYSDATETIME(), 127)
);
```

### SPATIAL DATA - البيانات الجغرافية

```sql
-- GEOMETRY: للبيانات الهندسية (إحداثيات مسطحة)
-- GEOGRAPHY: للبيانات الجغرافية (كرة أرضية)

CREATE TABLE Locations (
    LocationID INT PRIMARY KEY,
    LocationName NVARCHAR(100),
    
    -- GEOMETRY: لخرائط المدن والمباني
    BuildingShape GEOMETRY,
    
    -- GEOGRAPHY: لإحداثيات GPS العالمية
    GPS_Point GEOGRAPHY
);

-- إدراج نقطة جغرافية (Riyadh)
INSERT INTO Locations (LocationID, LocationName, GPS_Point)
VALUES (
    1,
    N'الرياض',
    GEOGRAPHY::Point(24.7136, 46.6753, 4326)  -- Latitude, Longitude, SRID
);

-- إدراج نقطة أخرى (Jeddah)
INSERT INTO Locations VALUES (
    2,
    N'جدة',
    NULL,
    GEOGRAPHY::Point(21.4858, 39.1925, 4326)
);

-- حساب المسافة بين نقطتين (بالمتر)
DECLARE @Riyadh GEOGRAPHY = GEOGRAPHY::Point(24.7136, 46.6753, 4326);
DECLARE @Jeddah GEOGRAPHY = GEOGRAPHY::Point(21.4858, 39.1925, 4326);

SELECT 
    @Riyadh.STDistance(@Jeddah) AS DistanceMeters,
    @Riyadh.STDistance(@Jeddah) / 1000 AS DistanceKM;  -- حوالي 849 كم

-- إنشاء مضلع (منطقة)
DECLARE @RiyadhArea GEOGRAPHY = GEOGRAPHY::STGeomFromText(
    'POLYGON((
        46.5 24.5,
        47.0 24.5,
        47.0 25.0,
        46.5 25.0,
        46.5 24.5
    ))',
    4326
);

-- التحقق إذا كانت نقطة داخل منطقة
SELECT 
    CASE 
        WHEN @RiyadhArea.STContains(@Riyadh) = 1 
        THEN N'داخل المنطقة'
        ELSE N'خارج المنطقة'
    END AS LocationStatus;
```

### SQL_VARIANT - نوع متعدد

```sql
-- SQL_VARIANT: يمكنه تخزين أي نوع بيانات (ماعدا TEXT, NTEXT, IMAGE, TIMESTAMP)
CREATE TABLE DynamicData (
    DataID INT PRIMARY KEY,
    DataKey NVARCHAR(50),
    DataValue SQL_VARIANT  -- يمكن أن يكون أي شيء!
);

-- تخزين أنواع مختلفة
INSERT INTO DynamicData VALUES 
    (1, 'Age', 30),                           -- INT
    (2, 'Name', N'أحمد'),                     -- NVARCHAR
    (3, 'Salary', 5500.50),                   -- DECIMAL
    (4, 'IsActive', CAST(1 AS BIT)),         -- BIT
    (5, 'BirthDate', '1990-05-15');          -- DATE

-- استرجاع مع معرفة النوع
SELECT 
    DataKey,
    DataValue,
    SQL_VARIANT_PROPERTY(DataValue, 'BaseType') AS DataType,
    SQL_VARIANT_PROPERTY(DataValue, 'MaxLength') AS MaxLength
FROM DynamicData;

-- تحويل للنوع المناسب
SELECT 
    DataKey,
    CAST(DataValue AS INT) AS IntValue
FROM DynamicData
WHERE SQL_VARIANT_PROPERTY(DataValue, 'BaseType') = 'int';

-- ⚠️ استخدم SQL_VARIANT بحذر:
-- ❌ أداء أقل
-- ❌ لا يمكن فهرسته بشكل فعّال
-- ❌ يزيد تعقيد الكود
-- ✅ مفيد فقط للبيانات الديناميكية جداً
```

## نصائح اختيار النوع المناسب

### للأرقام

```sql
✅ استخدم INT للمعرّفات (IDs)
✅ استخدم DECIMAL(p,s) للمبالغ المالية
✅ استخدم TINYINT للأعمار والنسب الصغيرة
✅ استخدم BIGINT فقط عند الحاجة (يستهلك ذاكرة أكبر)
```

### للنصوص

```sql
✅ استخدم NVARCHAR للنصوص العربية دائماً
✅ استخدم VARCHAR للنصوص الإنجليزية فقط
✅ حدد الطول المناسب (لا تستخدم MAX إلا للحاجة)
✅ استخدم CHAR فقط للأطوال الثابتة (رموز، أكواد)
```

### للتواريخ

```sql
✅ استخدم DATE للتواريخ فقط (بدون وقت)
✅ استخدم TIME للوقت فقط
✅ استخدم DATETIME2 للتاريخ والوقت (الأفضل حديثاً)
✅ استخدم DATETIMEOFFSET للتطبيقات العالمية
```

## أمثلة عملية شاملة

```sql
-- جدول موظفين كامل
CREATE TABLE Employees (
    -- المعرّفات
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeGUID UNIQUEIDENTIFIER DEFAULT NEWID(),
    
    -- البيانات الشخصية
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    FullNameArabic NVARCHAR(100),
    DateOfBirth DATE,
    Age AS (DATEDIFF(YEAR, DateOfBirth, GETDATE())),  -- عمود محسوب
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    
    -- معلومات الاتصال
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    Address NVARCHAR(200),
    
    -- معلومات الوظيفة
    HireDate DATE DEFAULT GETDATE(),
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Bonus MONEY DEFAULT 0,
    DepartmentID SMALLINT,
    
    -- حالة الموظف
    IsActive BIT DEFAULT 1,
    IsManager BIT DEFAULT 0,
    
    -- البيانات التقنية
    CreatedAt DATETIME2 DEFAULT SYSDATETIME(),
    ModifiedAt DATETIME2,
    ProfilePicture VARBINARY(MAX),
    
    -- بيانات إضافية
    Notes NVARCHAR(MAX),
    Metadata NVARCHAR(MAX)  -- يمكن تخزين JSON هنا
);
```

## 6. جدول مقارنة شامل لجميع أنواع البيانات

### حسب الفئة والاستخدام

| الفئة | النوع | الحجم | المدى/الدقة | Unicode | الاستخدام الأمثل |
|------|------|-------|-------------|---------|------------------|
| **أعداد صحيحة** | BIT | 1 بت | 0, 1, NULL | - | القيم المنطقية |
| | TINYINT | 1 بايت | 0-255 | - | الأعمار، النسب |
| | SMALLINT | 2 بايت | ±32K | - | السنوات، العدادات الصغيرة |
| | INT | 4 بايت | ±2B | - | **المفاتيح الأساسية** |
| | BIGINT | 8 بايت | ±9Q | - | الأرقام الضخمة |
| **أعداد عشرية** | DECIMAL(p,s) | 5-17 بايت | دقيق | - | **المبالغ المالية** |
| | NUMERIC(p,s) | 5-17 بايت | دقيق | - | مثل DECIMAL |
| | MONEY | 8 بايت | ±922T | - | العملات (4 أرقام) |
| | SMALLMONEY | 4 بايت | ±214K | - | عملات صغيرة |
| **أعداد تقريبية** | REAL | 4 بايت | 7 أرقام | - | قياسات تقريبية |
| | FLOAT(53) | 8 بايت | 15 رقم | - | علمية، GPS |
| **نصوص** | CHAR(n) | n بايت | 8000 | ❌ | رموز ثابتة |
| | VARCHAR(n) | متغير | 8000 | ❌ | نصوص إنجليزية |
| | VARCHAR(MAX) | متغير | 2GB | ❌ | نصوص ضخمة |
| | NCHAR(n) | n×2 بايت | 4000 | ✅ | رموز عالمية |
| | NVARCHAR(n) | متغير | 4000 | ✅ | **نصوص عربية** |
| | NVARCHAR(MAX) | متغير | 1GB | ✅ | نصوص عربية ضخمة |
| **تاريخ** | DATE | 3 بايت | 0001-9999 | - | تواريخ فقط |
| | TIME | 3-5 بايت | 100ns | - | أوقات فقط |
| | DATETIME | 8 بايت | 1753-9999 | - | قديم |
| | DATETIME2 | 6-8 بايت | 0001-9999 | - | **الأفضل حديثاً** |
| | DATETIMEOFFSET | 10 بايت | + timezone | - | تطبيقات عالمية |
| **ثنائي** | BINARY(n) | n بايت | 8000 | - | Hashes, Keys |
| | VARBINARY(n) | متغير | 8000 | - | توقيعات، tokens |
| | VARBINARY(MAX) | متغير | 2GB | - | ملفات، صور |
| **خاص** | UNIQUEIDENTIFIER | 16 بايت | GUID | - | معرفات فريدة |
| | XML | متغير | 2GB | ✅ | بيانات XML |
| | JSON | متغير | 2GB | ✅ | بيانات JSON |
| | GEOGRAPHY | متغير | - | - | GPS، خرائط |
| | HIERARCHYID | متغير | - | - | بيانات هرمية |

## 7. استراتيجيات اختيار النوع المناسب

### قاعدة الاختيار السريع

```sql
-- 1️⃣ للأرقام الصحيحة
IF عدد_صغير_جداً (0-255)
    → TINYINT
ELSE IF مفتاح_أساسي OR عداد_عام
    → INT
ELSE IF أرقام_ضخمة (فوق 2 مليار)
    → BIGINT

-- 2️⃣ للأرقام العشرية
IF مبالغ_مالية
    → DECIMAL(p,s) أو MONEY
ELSE IF حسابات_علمية
    → FLOAT

-- 3️⃣ للنصوص
IF يحتوي_على_عربي OR متعدد_اللغات
    → NVARCHAR(n)
ELSE IF إنجليزي_فقط
    → VARCHAR(n)

IF طول_ثابت (مثل رموز)
    → CHAR أو NCHAR
ELSE
    → VARCHAR أو NVARCHAR

-- 4️⃣ للتواريخ
IF تاريخ_فقط
    → DATE
ELSE IF وقت_فقط
    → TIME
ELSE IF يحتاج_timezone
    → DATETIMEOFFSET
ELSE
    → DATETIME2
```

### أمثلة واقعية متقدمة

```sql
CREATE TABLE RealWorldAdvanced (
    -- المعرفات
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserGUID UNIQUEIDENTIFIER DEFAULT NEWID(),
    
    -- البيانات الشخصية
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PhoneCountryCode CHAR(4),
    PhoneNumber VARCHAR(20),
    
    -- التاريخ والعمر
    BirthDate DATE,
    Age AS (DATEDIFF(YEAR, BirthDate, GETDATE())) PERSISTED,
    
    -- البيانات المالية
    AccountBalance DECIMAL(18,2),
    CreditLimit MONEY,
    DailySpendingLimit SMALLMONEY,
    
    -- الحالات والخيارات
    IsActive BIT DEFAULT 1,
    IsVerified BIT DEFAULT 0,
    AccountType TINYINT,
    UserLevel TINYINT CHECK (UserLevel BETWEEN 1 AND 100),
    
    -- الإحصائيات
    LoginCount INT DEFAULT 0,
    TotalPurchases BIGINT DEFAULT 0,
    AverageRating DECIMAL(3,2),
    
    -- التواريخ والأوقات
    CreatedAt DATETIME2(2) DEFAULT SYSDATETIME(),
    LastLoginAt DATETIMEOFFSET(2),
    UpdatedAt DATETIME2(2),
    PreferredWorkTime TIME(0),
    
    -- البيانات النصية
    Bio NVARCHAR(1000),
    Notes NVARCHAR(MAX),
    Preferences NVARCHAR(MAX),
    
    -- البيانات الثنائية
    ProfilePicture VARBINARY(MAX),
    PasswordHash BINARY(32),
    
    -- البيانات الجغرافية
    LastKnownLocation GEOGRAPHY
);
```

## 8. الأخطاء الشائعة وكيفية تجنبها

### ❌ الخطأ 1: استخدام NVARCHAR لكل شيء

```sql
-- ❌ سيء: مضيعة للمساحة
CREATE TABLE BadExample (
    Email NVARCHAR(500),
    CountryCode NVARCHAR(100),
    Age NVARCHAR(10)
);

-- ✅ جيد
CREATE TABLE GoodExample (
    Email VARCHAR(255),
    CountryCode CHAR(2),
    Age TINYINT
);
```

### ❌ الخطأ 2: استخدام VARCHAR(MAX) بدون حاجة

```sql
-- ❌ سيء
CREATE TABLE BadNames (
    FirstName VARCHAR(MAX),
    LastName VARCHAR(MAX)
);

-- ✅ جيد
CREATE TABLE GoodNames (
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);
```

### ❌ الخطأ 3: استخدام FLOAT للمبالغ المالية

```sql
-- ❌ خطير جداً!
CREATE TABLE BadFinances (
    AccountBalance FLOAT,
    TransactionAmount FLOAT
);

DECLARE @Amount FLOAT = 0.1 + 0.2;
SELECT @Amount;  -- 0.30000000000000004 ❌

-- ✅ الصحيح
CREATE TABLE GoodFinances (
    AccountBalance DECIMAL(18,2),
    TransactionAmount DECIMAL(18,2)
);

DECLARE @Correct DECIMAL(18,2) = 0.1 + 0.2;
SELECT @Correct;  -- 0.30 ✅
```

### ❌ الخطأ 4: نسيان N قبل النص العربي

```sql
-- ❌ سيحفظ ??? بدلاً من العربية
INSERT INTO Users (Name) VALUES ('أحمد محمد');

-- ✅ الصحيح
INSERT INTO Users (Name) VALUES (N'أحمد محمد');
```

## 9. نصائح التحسين والأداء

### تحسين المساحة

```sql
-- مثال: جدول بمليون صف

-- ❌ سيء (105 MB)
CREATE TABLE Inefficient (
    ID INT,
    Code NVARCHAR(MAX),
    Flag NVARCHAR(10),
    Status NVARCHAR(50)
);

-- ✅ محسّن (25 MB) - توفير 76%
CREATE TABLE Efficient (
    ID INT,
    Code CHAR(10),
    Flag BIT,
    Status TINYINT
);
```

### تحسين الأداء

```sql
-- استخدم الأنواع الأصغر الممكنة
-- INT أسرع في الفهرسة من BIGINT
-- TINYINT أسرع من INT للقيم الصغيرة

-- تجنب NULL عندما لا تحتاجه
CREATE TABLE OptimizedTable (
    ID INT NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- استخدم DATETIME2 بدقة مناسبة
-- DATETIME2(0)  -- ثانية (6 بايت)
-- DATETIME2(2)  -- 0.01 ثانية (6 بايت) - الأفضل
-- DATETIME2(7)  -- دقة قصوى (8 بايت) - عند الحاجة فقط
```

## 10. الخلاصة والتوصيات النهائية

### ✅ القواعد الذهبية

1. **للنصوص العربية**: استخدم `NVARCHAR` دائماً مع `N` قبل النص
2. **للمبالغ المالية**: استخدم `DECIMAL(p,s)` وليس `FLOAT`
3. **للمفاتيح الأساسية**: استخدم `INT IDENTITY` (أو `BIGINT` للجداول الضخمة)
4. **للتواريخ الحديثة**: استخدم `DATETIME2` وليس `DATETIME`
5. **للقيم المنطقية**: استخدم `BIT` وليس `TINYINT` أو `VARCHAR`
6. **حدد الحجم بدقة**: لا تستخدم `MAX` إلا للحاجة الفعلية
7. **وفّر المساحة**: استخدم `TINYINT` و `SMALLINT` عندما يكفي

### 📊 مرجع سريع حسب الحالة

| الحالة | النوع الموصى به | مثال |
|--------|------------------|-------|
| مفتاح أساسي | `INT IDENTITY` | `UserID INT PRIMARY KEY IDENTITY(1,1)` |
| اسم عربي | `NVARCHAR(100)` | `Name NVARCHAR(100)` |
| بريد إلكتروني | `VARCHAR(255)` | `Email VARCHAR(255)` |
| راتب | `DECIMAL(18,2)` | `Salary DECIMAL(18,2)` |
| عمر | `TINYINT` | `Age TINYINT CHECK(Age BETWEEN 0 AND 120)` |
| تاريخ ميلاد | `DATE` | `BirthDate DATE` |
| وقت إنشاء | `DATETIME2(2)` | `CreatedAt DATETIME2(2) DEFAULT SYSDATETIME()` |
| نشط/غير نشط | `BIT` | `IsActive BIT DEFAULT 1` |
| رمز بلد | `CHAR(2)` | `CountryCode CHAR(2)` |
| معرف فريد | `UNIQUEIDENTIFIER` | `SessionID UNIQUEIDENTIFIER DEFAULT NEWID()` |
| إحداثيات GPS | `GEOGRAPHY` | `Location GEOGRAPHY` |
| صورة ملف شخصي | `VARBINARY(MAX)` | `ProfilePic VARBINARY(MAX)` |

---

[⬅️ الموضوع السابق: التثبيت والإعداد](02_setup.md)
 [الموضوع التالي: إنشاء القواعد والجداول ⬅️](04_database_tables.md)
 [العودة للفهرس 🏠](README.md)
