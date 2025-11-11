# 32. تقسيم الجداول (Table Partitioning)

## ما هو Partitioning؟

تقسيم جدول كبير إلى أجزاء أصغر بناءً على عمود معين (مثل التاريخ).

## المزايا

- ✅ استعلامات أسرع على البيانات القديمة
- ✅ صيانة أسهل (Backup/Restore لكل partition)
- ✅ أرشفة البيانات القديمة بسهولة

## خطوات الإنشاء

### 1. إنشاء Partition Function

```sql
-- تقسيم حسب السنة
CREATE PARTITION FUNCTION PF_OrderDate_Year(DATE)
AS RANGE RIGHT FOR VALUES 
('2023-01-01', '2024-01-01', '2025-01-01');

-- سينشئ 4 partitions:
-- 1: قبل 2023
-- 2: 2023
-- 3: 2024  
-- 4: 2025 وما بعد
```

### 2. إنشاء Partition Scheme

```sql
CREATE PARTITION SCHEME PS_OrderDate_Year
AS PARTITION PF_OrderDate_Year
ALL TO ([PRIMARY]);
-- أو توزيع على Filegroups مختلفة
```

### 3. إنشاء الجدول

```sql
CREATE TABLE Orders_Partitioned (
    OrderID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
) ON PS_OrderDate_Year(OrderDate);
```

## الاستعلام

```sql
-- الاستعلام العادي (SQL Server يختار Partition تلقائياً)
SELECT * 
FROM Orders_Partitioned
WHERE OrderDate BETWEEN '2024-01-01' AND '2024-12-31';

-- عرض Partition لكل صف
SELECT 
    OrderID,
    OrderDate,
    $PARTITION.PF_OrderDate_Year(OrderDate) AS PartitionNumber
FROM Orders_Partitioned;
```

## الخلاصة

- يحسن الأداء للجداول الضخمة (ملايين الصفوف)
- مفيد للبيانات ذات النمط الزمني
- يسهل الأرشفة والصيانة

---

[⬅️ السابق: APPLY Operators](31_apply_operators.md)
 [التالي: Full-Text Search ⬅️](33_fulltext_search.md)
 [🏠 العودة للفهرس](README.md)
