# 33. البحث النصي الكامل (Full-Text Search)

## إنشاء Full-Text Index

```sql
-- 1. إنشاء Full-Text Catalog
CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;

-- 2. إنشاء Full-Text Index
CREATE FULLTEXT INDEX ON Products(ProductName, Description)
KEY INDEX PK_Products
WITH STOPLIST = SYSTEM;
```

## البحث

### CONTAINS - بحث دقيق

```sql
-- بحث عن كلمة
SELECT * 
FROM Products
WHERE CONTAINS(ProductName, 'لابتوب');

-- بحث عن عدة كلمات
SELECT * 
FROM Products
WHERE CONTAINS(ProductName, '"لابتوب" OR "كمبيوتر"');

-- بحث عن عبارة
SELECT * 
FROM Products
WHERE CONTAINS(Description, '"لابتوب عالي الأداء"');

-- بحث بالبادئة
SELECT * 
FROM Products
WHERE CONTAINS(ProductName, '"كمب*"');  -- كمبيوتر، كمبيوترات
```

### FREETEXT - بحث ذكي

```sql
-- بحث ذكي (يفهم المرادفات والتصريفات)
SELECT * 
FROM Products
WHERE FREETEXT(Description, N'أجهزة حاسوب محمولة');
```

### CONTAINSTABLE - مع الترتيب

```sql
-- يُرجع النتائج مع درجة التطابق
SELECT 
    p.ProductName,
    ft.RANK
FROM Products p
INNER JOIN CONTAINSTABLE(Products, ProductName, 'لابتوب') AS ft
    ON p.ProductID = ft.[KEY]
ORDER BY ft.RANK DESC;
```

## الخلاصة

- للبحث السريع في النصوص الكبيرة
- يدعم البحث الذكي والمرادفات
- أسرع من LIKE بكثير للنصوص الطويلة

---

[⬅️ السابق: Partitioning](32_partitioning.md)
 [التالي: Change Data Capture ⬅️](34_cdc.md)
 [🏠 العودة للفهرس](README.md)
