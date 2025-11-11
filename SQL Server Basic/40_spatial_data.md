# 40. البيانات المكانية (Spatial Data)

## أنواع البيانات المكانية

SQL Server يدعم نوعين:

- **GEOGRAPHY**: للإحداثيات على الكرة الأرضية (GPS)
- **GEOMETRY**: للإحداثيات المستوية (الخرائط)

## GEOGRAPHY - للمواقع الجغرافية

```sql
-- إنشاء جدول بموقع
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    StoreName NVARCHAR(100),
    Location GEOGRAPHY
);

-- إدراج نقاط (Latitude, Longitude)
INSERT INTO Stores VALUES 
(1, N'فرع القاهرة', geography::Point(30.0444, 31.2357, 4326)),
(2, N'فرع الإسكندرية', geography::Point(31.2001, 29.9187, 4326)),
(3, N'فرع الجيزة', geography::Point(30.0131, 31.2089, 4326));

-- 4326 = SRID (Spatial Reference ID) للـ GPS
```

## حساب المسافة

```sql
-- المسافة بين نقطتين (بالمتر)
DECLARE @Cairo GEOGRAPHY = geography::Point(30.0444, 31.2357, 4326);
DECLARE @Alex GEOGRAPHY = geography::Point(31.2001, 29.9187, 4326);

SELECT @Cairo.STDistance(@Alex) AS DistanceInMeters;  -- ~179,000 متر

-- البحث عن أقرب متجر
DECLARE @MyLocation GEOGRAPHY = geography::Point(30.0500, 31.2500, 4326);

SELECT TOP 1
    StoreName,
    Location.STDistance(@MyLocation) / 1000 AS DistanceKM
FROM Stores
ORDER BY Location.STDistance(@MyLocation);
```

## البحث ضمن نطاق (Radius Search)

```sql
-- جميع المتاجر ضمن 10 كم
DECLARE @MyLocation GEOGRAPHY = geography::Point(30.0444, 31.2357, 4326);
DECLARE @RadiusMeters FLOAT = 10000;  -- 10 كم

SELECT 
    StoreName,
    Location.STDistance(@MyLocation) / 1000 AS DistanceKM
FROM Stores
WHERE Location.STDistance(@MyLocation) <= @RadiusMeters
ORDER BY Location.STDistance(@MyLocation);
```

## المناطق (Polygons)

```sql
-- تعريف منطقة (مثلث مثلاً)
DECLARE @DeliveryZone GEOGRAPHY = geography::STGeomFromText(
    'POLYGON((30.0 31.0, 30.1 31.0, 30.05 31.1, 30.0 31.0))', 
    4326
);

-- هل الموقع داخل منطقة التوصيل؟
DECLARE @CustomerLocation GEOGRAPHY = geography::Point(30.05, 31.05, 4326);

SELECT 
    CASE 
        WHEN @DeliveryZone.STContains(@CustomerLocation) = 1 
        THEN N'نعم - داخل منطقة التوصيل'
        ELSE N'لا - خارج منطقة التوصيل'
    END AS IsInZone;
```

## الخطوط (LineString)

```sql
-- تعريف طريق
DECLARE @Route GEOGRAPHY = geography::STGeomFromText(
    'LINESTRING(30.0444 31.2357, 30.0500 31.2400, 30.0600 31.2500)',
    4326
);

-- طول الطريق (بالمتر)
SELECT @Route.STLength() AS RouteLengthMeters;
```

## GEOMETRY - للخرائط المستوية

```sql
-- مثال: مخطط مبنى
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY,
    RoomName NVARCHAR(50),
    Area GEOMETRY
);

-- غرفة مربعة
INSERT INTO Rooms VALUES 
(1, N'الصالة', geometry::STGeomFromText('POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))', 0));

-- حساب المساحة
SELECT 
    RoomName,
    Area.STArea() AS SquareMeters
FROM Rooms;
```

## الدوال المفيدة

```sql
-- نقطة
DECLARE @Point GEOGRAPHY = geography::Point(30.0, 31.0, 4326);

-- المسافة
SELECT @Point.STDistance(geography::Point(31.0, 32.0, 4326));

-- هل يحتوي؟
DECLARE @Polygon GEOGRAPHY = geography::STGeomFromText(
    'POLYGON((30 31, 31 31, 31 32, 30 32, 30 31))', 4326);
SELECT @Polygon.STContains(@Point);

-- التقاطع
SELECT @Polygon.STIntersects(@Point);

-- أقرب نقطة
DECLARE @Point1 GEOGRAPHY = geography::Point(30.0, 31.0, 4326);
DECLARE @Point2 GEOGRAPHY = geography::Point(31.0, 32.0, 4326);
SELECT @Point1.ShortestLineTo(@Point2);
```

## مثال عملي - تطبيق توصيل

```sql
CREATE TABLE DeliveryOrders (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    DeliveryAddress NVARCHAR(200),
    CustomerLocation GEOGRAPHY,
    DeliveryTime DATETIME2,
    Status VARCHAR(20)
);

-- إضافة طلب
INSERT INTO DeliveryOrders VALUES 
(1, N'أحمد محمد', N'شارع الهرم', 
    geography::Point(30.0131, 31.2089, 4326), 
    SYSDATETIME(), 'Pending');

-- إيجاد أقرب سائق متاح
DECLARE @DriverLocation GEOGRAPHY = geography::Point(30.0200, 31.2100, 4326);

SELECT TOP 1
    OrderID,
    CustomerName,
    CustomerLocation.STDistance(@DriverLocation) / 1000 AS DistanceKM
FROM DeliveryOrders
WHERE Status = 'Pending'
ORDER BY CustomerLocation.STDistance(@DriverLocation);
```

## الفهارس المكانية (Spatial Index)

```sql
-- إنشاء فهرس مكاني لتسريع الاستعلامات
CREATE SPATIAL INDEX SI_StoreLocation
ON Stores(Location)
WITH (
    BOUNDING_BOX = (
        xmin = 29.0, ymin = 30.0,  -- الحد الأدنى
        xmax = 32.0, ymax = 32.0   -- الحد الأقصى
    ),
    GRIDS = (
        LEVEL_1 = MEDIUM,
        LEVEL_2 = MEDIUM,
        LEVEL_3 = MEDIUM,
        LEVEL_4 = MEDIUM
    )
);
```

## الخلاصة

| النوع | الاستخدام |
|------|-----------|
| **GEOGRAPHY** | GPS، خرائط العالم، مسافات حقيقية |
| **GEOMETRY** | مخططات مباني، خرائط مستوية |

**الدوال المهمة:**

- `STDistance()` - المسافة
- `STContains()` - هل يحتوي؟
- `STIntersects()` - هل يتقاطع؟
- `STArea()` - المساحة
- `STLength()` - الطول

**الاستخدامات:**

- ✅ تطبيقات التوصيل
- ✅ البحث عن أقرب موقع
- ✅ تحديد مناطق الخدمة
- ✅ تحليل جغرافي

---

[⬅️ السابق: In-Memory OLTP](39_in_memory.md)
 [🏠 العودة للفهرس](README.md)

---

## 🎉 تهانينا

لقد أنهيت جميع مواضيع **خطة تعلم أساسيات SQL Server**!

### ما تعلمته

✅ **الأساسيات (1-10)**: المقدمة، التثبيت، أنواع البيانات، الجداول، DML، SELECT، الدوال، JOINs، GROUP BY، Subqueries

✅ **المتوسط (11-20)**: الفهارس، المفاتيح، Stored Procedures، Triggers، Transactions، Backup، الأمان، Views، CTEs، الأداء

✅ **المتقدم (21-30)**: Window Functions، PIVOT، CASE، MERGE، Temp Tables، Dynamic SQL، String Operations، JSON/XML، Cursors، Error Handling

✅ **الاحترافي (31-40)**: APPLY، Partitioning، Full-Text Search، CDC، Temporal Tables، Statistics، Locks، Snapshots، In-Memory OLTP، Spatial Data

[⬅️ السابق: In-Memory OLTP](39_in_memory.md)
[التالي: json Functions ⬅️](41_json_functions.md)
[🏠 العودة للفهرس](README.md)
