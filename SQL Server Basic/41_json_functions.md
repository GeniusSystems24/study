# دوال التعامل مع بيانات JSON في SQL Server

## 📋 نبذة

JSON (JavaScript Object Notation) هو تنسيق شائع لتبادل البيانات. يوفر SQL Server (من الإصدار 2016 فصاعداً) مجموعة قوية من الدوال للتعامل مع بيانات JSON، بما في ذلك القراءة، الكتابة، التحليل، والتعديل.

---

## 🎯 الأهداف التعليمية

بنهاية هذا الموضوع، ستكون قادراً على:

- فهم بنية JSON وكيفية تخزينها في SQL Server
- استخدام دوال JSON لاستخراج البيانات
- تحويل نتائج الاستعلامات إلى JSON
- تحليل وتعديل بيانات JSON
- بناء تطبيقات تتكامل مع APIs باستخدام JSON

---

## 📊 دوال JSON الأساسية

### 1. ISJSON - التحقق من صحة JSON

```sql
-- التحقق من صحة نص JSON
SELECT ISJSON('{"name":"أحمد","age":30}') AS IsValid;  -- النتيجة: 1 (صحيح)
SELECT ISJSON('{"name":"أحمد",}') AS IsValid;  -- النتيجة: 0 (غير صحيح)

-- التحقق من البيانات في جدول
CREATE TABLE JsonData (
    ID INT PRIMARY KEY,
    JsonContent NVARCHAR(MAX)
);

INSERT INTO JsonData VALUES 
(1, '{"name":"محمد","email":"mohamed@email.com"}'),
(2, 'invalid json'),
(3, '{"products":[{"id":1,"name":"لابتوب"}]}');

-- عرض الصفوف ذات JSON صحيح فقط
SELECT ID, JsonContent
FROM JsonData
WHERE ISJSON(JsonContent) = 1;
```

### 2. JSON_VALUE - استخراج قيمة واحدة

```sql
DECLARE @json NVARCHAR(MAX) = N'{
    "customer": {
        "name": "عبدالله السعيد",
        "email": "abdullah@email.com",
        "age": 35,
        "city": "الرياض"
    }
}';

-- استخراج قيم محددة
SELECT 
    JSON_VALUE(@json, '$.customer.name') AS CustomerName,
    JSON_VALUE(@json, '$.customer.email') AS Email,
    JSON_VALUE(@json, '$.customer.age') AS Age,
    JSON_VALUE(@json, '$.customer.city') AS City;

-- مع بيانات معقدة
DECLARE @order NVARCHAR(MAX) = N'{
    "orderId": 12345,
    "orderDate": "2024-01-15",
    "customer": {
        "id": 101,
        "name": "نورة الأحمد"
    },
    "total": 3500.50
}';

SELECT 
    JSON_VALUE(@order, '$.orderId') AS OrderID,
    JSON_VALUE(@order, '$.orderDate') AS OrderDate,
    JSON_VALUE(@order, '$.customer.name') AS CustomerName,
    JSON_VALUE(@order, '$.total') AS Total;
```

### 3. JSON_QUERY - استخراج كائن أو مصفوفة

```sql
DECLARE @json NVARCHAR(MAX) = N'{
    "customer": {
        "name": "أحمد",
        "addresses": [
            {"type": "home", "city": "الرياض"},
            {"type": "work", "city": "جدة"}
        ]
    },
    "orderDate": "2024-01-15"
}';

-- استخراج كائن كامل
SELECT JSON_QUERY(@json, '$.customer') AS CustomerObject;

-- استخراج مصفوفة
SELECT JSON_QUERY(@json, '$.customer.addresses') AS Addresses;

-- استخراج عنصر من مصفوفة
SELECT JSON_QUERY(@json, '$.customer.addresses[0]') AS FirstAddress;
SELECT JSON_QUERY(@json, '$.customer.addresses[1]') AS SecondAddress;
```

### 4. OPENJSON - تحويل JSON إلى صفوف

```sql
-- مثال بسيط: مصفوفة من القيم
DECLARE @jsonArray NVARCHAR(MAX) = N'["أحمد", "محمد", "فاطمة", "نورة"]';

SELECT *
FROM OPENJSON(@jsonArray);

-- النتيجة:
-- key | value   | type
-- 0   | أحمد    | 1
-- 1   | محمد    | 1
-- 2   | فاطمة   | 1
-- 3   | نورة    | 1

-- مصفوفة من الكائنات
DECLARE @products NVARCHAR(MAX) = N'[
    {"id": 1, "name": "لابتوب HP", "price": 3500, "inStock": true},
    {"id": 2, "name": "هاتف Samsung", "price": 2800, "inStock": false},
    {"id": 3, "name": "سماعات Sony", "price": 1200, "inStock": true}
]';

-- تحويل إلى جدول مع تحديد الأعمدة
SELECT *
FROM OPENJSON(@products)
WITH (
    ProductID INT '$.id',
    ProductName NVARCHAR(100) '$.name',
    Price DECIMAL(10,2) '$.price',
    InStock BIT '$.inStock'
);

-- مثال متقدم: JSON معقد
DECLARE @orderData NVARCHAR(MAX) = N'{
    "orderId": 1001,
    "customer": {
        "id": 501,
        "name": "عبدالله",
        "email": "abdullah@email.com"
    },
    "items": [
        {"productId": 1, "quantity": 2, "price": 3500},
        {"productId": 2, "quantity": 1, "price": 2800}
    ]
}';

-- استخراج معلومات العميل
SELECT *
FROM OPENJSON(@orderData, '$.customer')
WITH (
    CustomerID INT '$.id',
    CustomerName NVARCHAR(100) '$.name',
    Email NVARCHAR(100) '$.email'
);

-- استخراج العناصر
SELECT *
FROM OPENJSON(@orderData, '$.items')
WITH (
    ProductID INT '$.productId',
    Quantity INT '$.quantity',
    Price DECIMAL(10,2) '$.price'
);
```

---

## 🔄 تحويل البيانات إلى JSON

### 1. FOR JSON PATH - تحويل نتائج الاستعلام

```sql
-- إنشاء جداول تجريبية
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    City NVARCHAR(50)
);

INSERT INTO Customers VALUES
(1, N'أحمد محمد', 'ahmed@email.com', N'الرياض'),
(2, N'فاطمة علي', 'fatima@email.com', N'جدة'),
(3, N'خالد حسن', 'khaled@email.com', N'الدمام');

-- تحويل إلى JSON
SELECT CustomerID, Name, Email, City
FROM Customers
FOR JSON PATH;

-- النتيجة:
-- [
--   {"CustomerID":1,"Name":"أحمد محمد","Email":"ahmed@email.com","City":"الرياض"},
--   {"CustomerID":2,"Name":"فاطمة علي","Email":"fatima@email.com","City":"جدة"},
--   {"CustomerID":3,"Name":"خالد حسن","Email":"khaled@email.com","City":"الدمام"}
-- ]

-- تخصيص أسماء الخصائص
SELECT 
    CustomerID AS 'customer.id',
    Name AS 'customer.name',
    Email AS 'customer.email',
    City AS 'customer.address.city'
FROM Customers
FOR JSON PATH;

-- إضافة عنصر جذر
SELECT CustomerID, Name, Email
FROM Customers
FOR JSON PATH, ROOT('customers');

-- النتيجة:
-- {
--   "customers": [
--     {"CustomerID":1,"Name":"أحمد محمد","Email":"ahmed@email.com"},
--     ...
--   ]
-- }
```

### 2. FOR JSON AUTO - تحويل تلقائي

```sql
-- إنشاء جدول الطلبات
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    Total DECIMAL(10,2)
);

INSERT INTO Orders VALUES
(101, 1, '2024-01-15', 5500.00),
(102, 2, '2024-01-16', 2800.00),
(103, 1, '2024-01-17', 1200.00);

-- تحويل مع JOIN
SELECT 
    c.CustomerID,
    c.Name,
    o.OrderID,
    o.OrderDate,
    o.Total
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
FOR JSON AUTO;

-- النتيجة تكون متداخلة تلقائياً:
-- [
--   {
--     "CustomerID": 1,
--     "Name": "أحمد محمد",
--     "o": [
--       {"OrderID": 101, "OrderDate": "2024-01-15", "Total": 5500.00},
--       {"OrderID": 103, "OrderDate": "2024-01-17", "Total": 1200.00}
--     ]
--   },
--   ...
-- ]
```

### 3. INCLUDE_NULL_VALUES و WITHOUT_ARRAY_WRAPPER

```sql
-- تضمين القيم NULL
SELECT CustomerID, Name, Email, NULL AS Phone
FROM Customers
WHERE CustomerID = 1
FOR JSON PATH, INCLUDE_NULL_VALUES;

-- بدون مصفوفة (لصف واحد)
SELECT CustomerID, Name, Email
FROM Customers
WHERE CustomerID = 1
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;

-- النتيجة: كائن واحد بدلاً من مصفوفة
-- {"CustomerID":1,"Name":"أحمد محمد","Email":"ahmed@email.com"}
```

---

## ✏️ تعديل بيانات JSON

### JSON_MODIFY - تعديل قيمة في JSON

```sql
DECLARE @json NVARCHAR(MAX) = N'{
    "customer": {
        "name": "أحمد",
        "email": "ahmed@email.com",
        "age": 30
    }
}';

-- تحديث قيمة موجودة
SET @json = JSON_MODIFY(@json, '$.customer.age', 31);
SELECT @json AS UpdatedAge;

-- إضافة خاصية جديدة
SET @json = JSON_MODIFY(@json, '$.customer.phone', '0501234567');
SELECT @json AS AddedPhone;

-- حذف خاصية
SET @json = JSON_MODIFY(@json, '$.customer.age', NULL);
SELECT @json AS RemovedAge;

-- تحديث متعدد
DECLARE @data NVARCHAR(MAX) = N'{
    "product": {
        "name": "لابتوب",
        "price": 3500,
        "stock": 10
    }
}';

SET @data = JSON_MODIFY(@data, '$.product.price', 3200);
SET @data = JSON_MODIFY(@data, '$.product.stock', 8);
SET @data = JSON_MODIFY(@data, '$.product.discount', 0.15);

SELECT @data AS UpdatedProduct;
```

### تعديل المصفوفات

```sql
DECLARE @json NVARCHAR(MAX) = N'{
    "products": [
        {"id": 1, "name": "لابتوب"},
        {"id": 2, "name": "هاتف"}
    ]
}';

-- تحديث عنصر في المصفوفة
SET @json = JSON_MODIFY(@json, '$.products[0].name', N'لابتوب HP');
SELECT @json AS UpdatedArray;

-- إضافة عنصر جديد للمصفوفة
SET @json = JSON_MODIFY(@json, 'append $.products', 
    JSON_QUERY('{"id": 3, "name": "سماعات"}'));
SELECT @json AS AddedToArray;
```

---

## 🔍 أمثلة عملية متقدمة

### 1. تخزين واستعلام بيانات JSON في جدول

```sql
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName NVARCHAR(100),
    Specifications NVARCHAR(MAX) -- سنخزن JSON هنا
);

-- إدراج منتجات مع JSON
INSERT INTO Products (ProductName, Specifications) VALUES
(N'لابتوب HP ProBook', N'{
    "brand": "HP",
    "processor": "Intel i7",
    "ram": "16GB",
    "storage": "512GB SSD",
    "screen": "15.6 inch",
    "price": 3500
}'),
(N'هاتف Samsung Galaxy', N'{
    "brand": "Samsung",
    "processor": "Snapdragon 888",
    "ram": "8GB",
    "storage": "128GB",
    "camera": "64MP",
    "price": 2800
}'),
(N'سماعات Sony WH-1000XM4', N'{
    "brand": "Sony",
    "type": "Wireless",
    "noiseCancellation": true,
    "batteryLife": "30 hours",
    "price": 1200
}');

-- استعلام البيانات من JSON
SELECT 
    ProductID,
    ProductName,
    JSON_VALUE(Specifications, '$.brand') AS Brand,
    JSON_VALUE(Specifications, '$.price') AS Price,
    JSON_VALUE(Specifications, '$.ram') AS RAM
FROM Products;

-- البحث في JSON
SELECT ProductName, Specifications
FROM Products
WHERE JSON_VALUE(Specifications, '$.brand') = 'HP';

-- البحث حسب السعر
SELECT 
    ProductName,
    JSON_VALUE(Specifications, '$.price') AS Price
FROM Products
WHERE CAST(JSON_VALUE(Specifications, '$.price') AS DECIMAL) > 2000
ORDER BY CAST(JSON_VALUE(Specifications, '$.price') AS DECIMAL) DESC;
```

### 2. تحليل بيانات API Response

```sql
-- محاكاة استجابة API
DECLARE @apiResponse NVARCHAR(MAX) = N'{
    "status": "success",
    "data": {
        "users": [
            {
                "id": 1,
                "name": "أحمد محمد",
                "email": "ahmed@email.com",
                "orders": [
                    {"orderId": 101, "total": 500},
                    {"orderId": 102, "total": 750}
                ]
            },
            {
                "id": 2,
                "name": "فاطمة علي",
                "email": "fatima@email.com",
                "orders": [
                    {"orderId": 201, "total": 1200}
                ]
            }
        ]
    },
    "timestamp": "2024-01-15T10:30:00"
}';

-- استخراج المستخدمين
SELECT *
FROM OPENJSON(@apiResponse, '$.data.users')
WITH (
    UserID INT '$.id',
    UserName NVARCHAR(100) '$.name',
    Email NVARCHAR(100) '$.email',
    Orders NVARCHAR(MAX) '$.orders' AS JSON
);

-- استخراج المستخدمين والطلبات معاً
SELECT 
    u.UserID,
    u.UserName,
    o.OrderID,
    o.Total
FROM OPENJSON(@apiResponse, '$.data.users')
WITH (
    UserID INT '$.id',
    UserName NVARCHAR(100) '$.name',
    Orders NVARCHAR(MAX) '$.orders' AS JSON
) u
CROSS APPLY OPENJSON(u.Orders)
WITH (
    OrderID INT '$.orderId',
    Total DECIMAL(10,2) '$.total'
) o;
```

### 3. بناء JSON ديناميكي معقد

```sql
-- بناء JSON من عدة جداول
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    ProductName NVARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

INSERT INTO OrderDetails VALUES
(101, N'لابتوب HP', 1, 3500),
(101, N'سماعات Sony', 2, 1200),
(102, N'هاتف Samsung', 1, 2800);

-- إنشاء JSON متداخل
SELECT 
    o.OrderID,
    o.OrderDate,
    o.Total,
    (
        SELECT 
            od.ProductName AS 'product',
            od.Quantity AS 'quantity',
            od.UnitPrice AS 'price'
        FROM OrderDetails od
        WHERE od.OrderID = o.OrderID
        FOR JSON PATH
    ) AS items
FROM Orders o
WHERE o.CustomerID = 1
FOR JSON PATH;
```

### 4. معالجة JSON في Stored Procedure

```sql
CREATE PROCEDURE sp_ProcessJsonOrder
    @jsonOrder NVARCHAR(MAX)
AS
BEGIN
    -- التحقق من صحة JSON
    IF ISJSON(@jsonOrder) = 0
    BEGIN
        RAISERROR(N'البيانات المدخلة ليست JSON صحيح', 16, 1);
        RETURN;
    END
    
    -- استخراج معلومات العميل
    DECLARE @customerID INT = JSON_VALUE(@jsonOrder, '$.customerId');
    DECLARE @orderDate DATE = JSON_VALUE(@jsonOrder, '$.orderDate');
    
    -- إنشاء الطلب
    DECLARE @newOrderID INT;
    INSERT INTO Orders (CustomerID, OrderDate, Total)
    VALUES (@customerID, @orderDate, 0);
    
    SET @newOrderID = SCOPE_IDENTITY();
    
    -- إدراج تفاصيل الطلب من JSON
    INSERT INTO OrderDetails (OrderID, ProductName, Quantity, UnitPrice)
    SELECT 
        @newOrderID,
        ProductName,
        Quantity,
        Price
    FROM OPENJSON(@jsonOrder, '$.items')
    WITH (
        ProductName NVARCHAR(100) '$.product',
        Quantity INT '$.quantity',
        Price DECIMAL(10,2) '$.price'
    );
    
    -- تحديث المجموع
    UPDATE Orders
    SET Total = (
        SELECT SUM(Quantity * UnitPrice)
        FROM OrderDetails
        WHERE OrderID = @newOrderID
    )
    WHERE OrderID = @newOrderID;
    
    -- إرجاع النتيجة كـ JSON
    SELECT 
        @newOrderID AS orderId,
        'success' AS status,
        'تم إنشاء الطلب بنجاح' AS message
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
END;
GO

-- استخدام الـ Procedure
DECLARE @order NVARCHAR(MAX) = N'{
    "customerId": 1,
    "orderDate": "2024-01-20",
    "items": [
        {"product": "لابتوب Dell", "quantity": 1, "price": 4000},
        {"product": "ماوس لاسلكي", "quantity": 2, "price": 80}
    ]
}';

EXEC sp_ProcessJsonOrder @order;
```

---

## 📊 مقارنة JSON مع XML

| الميزة | JSON | XML |
|--------|------|-----|
| **الحجم** | أصغر | أكبر |
| **القراءة** | أسهل للبشر | أكثر تعقيداً |
| **الأداء** | أسرع في التحليل | أبطأ |
| **الدعم في JavaScript** | أصلي | يحتاج تحليل |
| **المخططات (Schemas)** | JSON Schema | XSD قوي |
| **التعليقات** | غير مدعومة | مدعومة |
| **الاستخدام الشائع** | APIs, Web Apps | Enterprise, Legacy |

---

## ⚡ تحسين الأداء

### 1. إنشاء Computed Columns

```sql
-- إضافة أعمدة محسوبة لتحسين الأداء
ALTER TABLE Products
ADD Brand AS JSON_VALUE(Specifications, '$.brand') PERSISTED;

ALTER TABLE Products
ADD Price AS CAST(JSON_VALUE(Specifications, '$.price') AS DECIMAL(10,2)) PERSISTED;

-- الآن يمكن إنشاء فهرس
CREATE INDEX IX_Products_Brand ON Products(Brand);
CREATE INDEX IX_Products_Price ON Products(Price);

-- الاستعلام سيكون أسرع
SELECT ProductName, Brand, Price
FROM Products
WHERE Brand = 'HP' AND Price > 2000;
```

### 2. استخدام Full-Text Index مع JSON

```sql
-- إنشاء Full-Text Index على JSON
CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;

CREATE FULLTEXT INDEX ON Products(Specifications)
KEY INDEX PK_Products_ProductID;

-- البحث في JSON
SELECT ProductName, Specifications
FROM Products
WHERE CONTAINS(Specifications, 'Intel OR Snapdragon');
```

---

## 🎯 أفضل الممارسات

### ✅ افعل

1. **تحقق من صحة JSON** قبل الإدراج

    ```sql
    IF ISJSON(@jsonData) = 1
        INSERT INTO Table VALUES (@jsonData);
    ```

2. **استخدم Computed Columns** للحقول المستعلمة بكثرة

    ```sql
    ALTER TABLE T ADD Col AS JSON_VALUE(JsonCol, '$.path') PERSISTED;
    ```

3. **استخدم JSON للبيانات المرنة** (متغيرة البنية)

    ```sql
    -- مناسب للمواصفات المختلفة
    Specifications NVARCHAR(MAX) -- JSON
    ```

4. **اختر JSON_VALUE للقيم الفردية** و JSON_QUERY للكائنات

    ```sql
    JSON_VALUE(@json, '$.name')  -- قيمة واحدة
    JSON_QUERY(@json, '$.address')  -- كائن
    ```

### ❌ لا تفعل

1. **لا تستخدم JSON للبيانات المنظمة جداً**

    ```sql
    -- ❌ سيء
    CustomerData NVARCHAR(MAX) -- JSON لجميع بيانات العميل

    -- ✅ جيد
    CustomerID INT, Name NVARCHAR(100), Email NVARCHAR(100)
    ```

2. **لا تتجاهل الفهرسة**

    ```sql
    -- ❌ بطيء
    WHERE JSON_VALUE(Data, '$.id') = 123

    -- ✅ أسرع مع Computed Column
    WHERE ComputedID = 123
    ```

3. **لا تخزن JSON كـ VARCHAR**

    ```sql
    -- ❌ سيء
    JsonData VARCHAR(MAX)

    -- ✅ جيد
    JsonData NVARCHAR(MAX)  -- يدعم Unicode
    ```

---

## 🔐 الأمان

### 1. منع SQL Injection

```sql
-- ❌ غير آمن
DECLARE @sql NVARCHAR(MAX) = 
    'SELECT * FROM Products WHERE JSON_VALUE(Specs, ''$.brand'') = ''' + @userInput + '''';
EXEC(@sql);

-- ✅ آمن
SELECT * FROM Products
WHERE JSON_VALUE(Specifications, '$.brand') = @userInput;
```

### 2. التحقق من صحة البيانات

```sql
CREATE PROCEDURE sp_InsertProduct
    @productJson NVARCHAR(MAX)
AS
BEGIN
    -- التحقق من JSON
    IF ISJSON(@productJson) = 0
    BEGIN
        THROW 50001, N'JSON غير صحيح', 1;
    END
    
    -- التحقق من وجود الحقول المطلوبة
    IF JSON_VALUE(@productJson, '$.name') IS NULL
    BEGIN
        THROW 50002, N'اسم المنتج مطلوب', 1;
    END
    
    -- الإدراج
    INSERT INTO Products (ProductName, Specifications)
    VALUES (
        JSON_VALUE(@productJson, '$.name'),
        @productJson
    );
END;
```

---

## 📝 تمارين عملية

### تمرين 1: إنشاء نظام للتقييمات

```sql
-- أنشئ جدول للمنتجات مع تقييمات JSON
CREATE TABLE ProductReviews (
    ProductID INT,
    Reviews NVARCHAR(MAX) -- JSON
);

-- أدرج بيانات تجريبية
INSERT INTO ProductReviews VALUES
(1, N'[
    {"user": "أحمد", "rating": 5, "comment": "ممتاز"},
    {"user": "فاطمة", "rating": 4, "comment": "جيد جداً"}
]');

-- احسب متوسط التقييم
-- (جرب بنفسك!)
```

### تمرين 2: API Log System

```sql
-- أنشئ جدول لتسجيل طلبات API
CREATE TABLE ApiLogs (
    LogID INT IDENTITY PRIMARY KEY,
    Endpoint NVARCHAR(200),
    RequestData NVARCHAR(MAX), -- JSON
    ResponseData NVARCHAR(MAX), -- JSON
    LogDate DATETIME DEFAULT GETDATE()
);

-- أدرج سجل
-- استعلم البيانات
-- (جرب بنفسك!)
```

---

## 📚 موارد إضافية

- [JSON Data in SQL Server - Microsoft Docs](https://docs.microsoft.com/sql/relational-databases/json/json-data-sql-server)
- [JSON Functions Reference](https://docs.microsoft.com/sql/t-sql/functions/json-functions-transact-sql)
- [JSON Performance Tips](https://docs.microsoft.com/sql/relational-databases/json/optimize-json-processing-with-in-memory-oltp)

---

### الخطوة التالية

1. **طبق ما تعلمته** على مشاريع حقيقية
2. **راجع** المواضيع المعقدة
3. **تدرب** على كتابة Stored Procedures معقدة
4. **تعلم** تحسين الأداء المتقدم
5. **استكشف** ميزات SQL Server الجديدة

**حظاً موفقاً في مسيرتك مع SQL Server! 🚀**.

## 🔄 الملاحة

[⬅️ السابق: Spatial Data](40_spatial_data.md)
 [🏠 العودة للفهرس](README.md)
