# 28. التعامل مع JSON و XML

## JSON في SQL Server (2016+)

### قراءة JSON - JSON_VALUE

```sql
DECLARE @json NVARCHAR(MAX) = N'{
    "name": "أحمد محمد",
    "age": 30,
    "email": "ahmed@email.com",
    "skills": ["SQL", "C#", "JavaScript"]
}';

SELECT 
    JSON_VALUE(@json, '$.name') AS Name,
    JSON_VALUE(@json, '$.age') AS Age,
    JSON_VALUE(@json, '$.email') AS Email,
    JSON_VALUE(@json, '$.skills[0]') AS FirstSkill;
```

### JSON_QUERY - استخراج كائنات/مصفوفات

```sql
DECLARE @json NVARCHAR(MAX) = N'{
    "employee": {
        "name": "أحمد",
        "department": "IT"
    },
    "projects": ["Project1", "Project2"]
}';

SELECT 
    JSON_QUERY(@json, '$.employee') AS EmployeeObject,
    JSON_QUERY(@json, '$.projects') AS ProjectsArray;
```

### OPENJSON - تحويل JSON إلى جدول

```sql
DECLARE @json NVARCHAR(MAX) = N'[
    {"id": 1, "name": "أحمد", "salary": 10000},
    {"id": 2, "name": "فاطمة", "salary": 12000},
    {"id": 3, "name": "محمد", "salary": 9000}
]';

SELECT *
FROM OPENJSON(@json)
WITH (
    id INT '$.id',
    name NVARCHAR(50) '$.name',
    salary DECIMAL(10,2) '$.salary'
);
```

### FOR JSON - تحويل جدول إلى JSON

```sql
-- FOR JSON PATH
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
FOR JSON PATH;

-- مع تسمية مخصصة
SELECT 
    EmployeeID AS 'employee.id',
    FirstName AS 'employee.firstName',
    LastName AS 'employee.lastName',
    Salary AS 'employee.salary'
FROM Employees
FOR JSON PATH;

-- FOR JSON AUTO (تلقائي حسب الـ JOINs)
SELECT 
    d.DepartmentName,
    e.FirstName,
    e.Salary
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
FOR JSON AUTO;
```

### JSON_MODIFY - تعديل JSON

```sql
DECLARE @json NVARCHAR(MAX) = N'{
    "name": "أحمد",
    "salary": 10000,
    "department": "IT"
}';

-- تحديث قيمة
SET @json = JSON_MODIFY(@json, '$.salary', 12000);

-- إضافة قيمة جديدة
SET @json = JSON_MODIFY(@json, '$.email', 'ahmed@email.com');

-- حذف قيمة
SET @json = JSON_MODIFY(@json, '$.department', NULL);

SELECT @json;
```

### ISJSON - التحقق من صحة JSON

```sql
DECLARE @json NVARCHAR(MAX) = N'{"name": "أحمد"}';
DECLARE @invalid NVARCHAR(MAX) = N'{name: أحمد}';  -- خطأ

SELECT 
    ISJSON(@json) AS IsValid,        -- 1
    ISJSON(@invalid) AS IsInvalid;   -- 0

-- استخدام في WHERE
SELECT *
FROM Products
WHERE ISJSON(Metadata) = 1;
```

### مثال عملي JSON - تخزين البيانات الديناميكية

```sql
-- إنشاء جدول مع JSON
CREATE TABLE Products_JSON (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Specifications NVARCHAR(MAX)  -- JSON
);

-- إدراج بيانات
INSERT INTO Products_JSON VALUES 
(1, N'لابتوب', N'{
    "brand": "Dell",
    "cpu": "Intel i7",
    "ram": "16GB",
    "storage": "512GB SSD"
}'),
(2, N'هاتف', N'{
    "brand": "Samsung",
    "screen": "6.5 inch",
    "camera": "48MP",
    "battery": "4500mAh"
}');

-- الاستعلام
SELECT 
    ProductName,
    JSON_VALUE(Specifications, '$.brand') AS Brand,
    JSON_VALUE(Specifications, '$.cpu') AS CPU,
    JSON_VALUE(Specifications, '$.ram') AS RAM
FROM Products_JSON;

-- البحث
SELECT *
FROM Products_JSON
WHERE JSON_VALUE(Specifications, '$.brand') = 'Dell';
```

## XML في SQL Server

### إنشاء XML

```sql
-- FOR XML RAW
SELECT 
    EmployeeID,
    FirstName,
    LastName
FROM Employees
FOR XML RAW;

-- FOR XML PATH
SELECT 
    EmployeeID AS '@id',
    FirstName AS 'Name/First',
    LastName AS 'Name/Last',
    Salary
FROM Employees
FOR XML PATH('Employee'), ROOT('Employees');
```

### قراءة XML - value()

```sql
DECLARE @xml XML = N'
<Employees>
    <Employee id="1">
        <Name>أحمد محمد</Name>
        <Salary>10000</Salary>
    </Employee>
    <Employee id="2">
        <Name>فاطمة علي</Name>
        <Salary>12000</Salary>
    </Employee>
</Employees>';

-- استخراج قيمة واحدة
SELECT @xml.value('(/Employees/Employee/@id)[1]', 'INT') AS FirstEmployeeID;

-- استخراج نص
SELECT @xml.value('(/Employees/Employee/Name)[1]', 'NVARCHAR(100)') AS FirstName;
```

### query() - استخراج جزء XML

```sql
SELECT @xml.query('/Employees/Employee[@id=1]') AS FirstEmployee;
```

### exist() - التحقق من وجود عنصر

```sql
SELECT 
    CASE 
        WHEN @xml.exist('/Employees/Employee[@id=1]') = 1 
        THEN N'موجود'
        ELSE N'غير موجود'
    END AS CheckResult;
```

### modify() - تعديل XML

```sql
-- إضافة عنصر
SET @xml.modify('
    insert <Employee id="3">
        <Name>محمود حسن</Name>
        <Salary>9000</Salary>
    </Employee>
    as last into (/Employees)[1]
');

-- تحديث قيمة
SET @xml.modify('
    replace value of (/Employees/Employee[@id=1]/Salary/text())[1]
    with "11000"
');

-- حذف عنصر
SET @xml.modify('delete /Employees/Employee[@id=2]');

SELECT @xml;
```

### nodes() - تحويل XML إلى جدول

```sql
DECLARE @xml XML = N'
<Products>
    <Product id="1" name="لابتوب" price="25000"/>
    <Product id="2" name="هاتف" price="15000"/>
    <Product id="3" name="تابلت" price="20000"/>
</Products>';

SELECT 
    Product.value('@id', 'INT') AS ProductID,
    Product.value('@name', 'NVARCHAR(100)') AS ProductName,
    Product.value('@price', 'DECIMAL(10,2)') AS Price
FROM @xml.nodes('/Products/Product') AS T(Product);
```

### مثال عملي XML

```sql
-- جدول مع XML
CREATE TABLE Orders_XML (
    OrderID INT PRIMARY KEY,
    OrderData XML
);

-- إدراج
INSERT INTO Orders_XML VALUES 
(1, N'
<Order>
    <Customer>أحمد محمد</Customer>
    <Items>
        <Item>
            <ProductName>لابتوب</ProductName>
            <Quantity>2</Quantity>
            <Price>25000</Price>
        </Item>
        <Item>
            <ProductName>ماوس</ProductName>
            <Quantity>3</Quantity>
            <Price>150</Price>
        </Item>
    </Items>
</Order>
');

-- الاستعلام
SELECT 
    OrderID,
    OrderData.value('(/Order/Customer)[1]', 'NVARCHAR(100)') AS Customer,
    Item.value('(ProductName)[1]', 'NVARCHAR(100)') AS Product,
    Item.value('(Quantity)[1]', 'INT') AS Quantity,
    Item.value('(Price)[1]', 'DECIMAL(10,2)') AS Price
FROM Orders_XML
CROSS APPLY OrderData.nodes('/Order/Items/Item') AS T(Item);
```

## JSON vs XML

```sql
-- مقارنة الأداء والاستخدام

-- ✅ JSON
-- - أخف وأسرع
-- - أسهل في القراءة
-- - مثالي لـ Web APIs
-- - دعم أفضل في JavaScript

-- ✅ XML
-- - أكثر قوة (Schema validation)
-- - دعم أفضل في .NET
-- - Namespaces
-- - XPath و XQuery
```

## نصائح وأفضل الممارسات

```sql
-- ✅ استخدم JSON للبيانات البسيطة والديناميكية
-- ✅ استخدم XML للبيانات المعقدة التي تحتاج Validation
-- ✅ أضف فهارس على JSON/XML للأداء

-- فهرس على JSON
ALTER TABLE Products_JSON
ADD Brand AS JSON_VALUE(Specifications, '$.brand') PERSISTED;

CREATE INDEX IX_Brand ON Products_JSON(Brand);

-- فهرس XML
CREATE PRIMARY XML INDEX IX_XML_Primary ON Orders_XML(OrderData);
CREATE XML INDEX IX_XML_Value ON Orders_XML(OrderData)
    USING XML INDEX IX_XML_Primary FOR VALUE;
```

## الخلاصة

| الميزة | JSON | XML |
|--------|------|-----|
| **البساطة** | ✅ سهل | ⚠️ معقد |
| **الأداء** | ✅ أسرع | ⚠️ أبطأ |
| **الحجم** | ✅ أصغر | ⚠️ أكبر |
| **Validation** | ❌ محدود | ✅ قوي |
| **Web APIs** | ✅ مثالي | ⚠️ أقل |

---

[⬅️ السابق: String Operations](27_string_operations.md)
 [التالي: Cursors ⬅️](29_cursors.md)
 [🏠 العودة للفهرس](README.md)
