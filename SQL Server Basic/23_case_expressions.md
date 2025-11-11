# 23. تعبيرات CASE

## مقدمة

**CASE** هو تعبير شرطي يشبه IF-ELSE في لغات البرمجة الأخرى.

## البنية الأساسية (Simple CASE)

```sql
-- CASE البسيط
SELECT 
    FirstName,
    DepartmentID,
    CASE DepartmentID
        WHEN 1 THEN N'المبيعات'
        WHEN 2 THEN N'التسويق'
        WHEN 3 THEN N'تكنولوجيا المعلومات'
        WHEN 4 THEN N'الموارد البشرية'
        ELSE N'غير محدد'
    END AS DepartmentName
FROM Employees;
```

## CASE المتقدم (Searched CASE)

```sql
-- CASE مع شروط معقدة
SELECT 
    FirstName,
    Salary,
    CASE 
        WHEN Salary < 5000 THEN N'منخفض'
        WHEN Salary BETWEEN 5000 AND 10000 THEN N'متوسط'
        WHEN Salary BETWEEN 10001 AND 15000 THEN N'جيد'
        WHEN Salary > 15000 THEN N'ممتاز'
        ELSE N'غير محدد'
    END AS SalaryLevel
FROM Employees;
```

## CASE في SELECT

```sql
-- تصنيف الموظفين حسب مدة الخدمة
SELECT 
    FirstName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN N'جديد'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 3 THEN N'مبتدئ'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 5 THEN N'متوسط'
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 10 THEN N'خبير'
        ELSE N'محترف'
    END AS ExperienceLevel,
    CASE 
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 THEN Salary * 1.1
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 3 THEN Salary * 1.05
        ELSE Salary
    END AS AdjustedSalary
FROM Employees;
```

## CASE في WHERE

```sql
-- استعلام مشروط بناءً على متغير
DECLARE @SearchType VARCHAR(20) = 'HighSalary';

SELECT FirstName, Salary
FROM Employees
WHERE 
    CASE @SearchType
        WHEN 'HighSalary' THEN 
            CASE WHEN Salary > 10000 THEN 1 ELSE 0 END
        WHEN 'LowSalary' THEN 
            CASE WHEN Salary < 5000 THEN 1 ELSE 0 END
        WHEN 'MediumSalary' THEN 
            CASE WHEN Salary BETWEEN 5000 AND 10000 THEN 1 ELSE 0 END
        ELSE 1
    END = 1;
```

## CASE في ORDER BY

```sql
-- ترتيب ديناميكي
DECLARE @SortColumn VARCHAR(20) = 'Salary';
DECLARE @SortDirection VARCHAR(4) = 'DESC';

SELECT FirstName, Salary, DepartmentID
FROM Employees
ORDER BY 
    CASE 
        WHEN @SortColumn = 'FirstName' AND @SortDirection = 'ASC' THEN FirstName
    END ASC,
    CASE 
        WHEN @SortColumn = 'FirstName' AND @SortDirection = 'DESC' THEN FirstName
    END DESC,
    CASE 
        WHEN @SortColumn = 'Salary' AND @SortDirection = 'ASC' THEN Salary
    END ASC,
    CASE 
        WHEN @SortColumn = 'Salary' AND @SortDirection = 'DESC' THEN Salary
    END DESC;
```

## CASE في UPDATE

```sql
-- تحديث مشروط
UPDATE Employees
SET Salary = 
    CASE 
        WHEN DepartmentID = 1 THEN Salary * 1.10  -- زيادة 10% للمبيعات
        WHEN DepartmentID = 2 THEN Salary * 1.08  -- زيادة 8% للتسويق
        WHEN DepartmentID = 3 THEN Salary * 1.12  -- زيادة 12% لـ IT
        ELSE Salary * 1.05  -- زيادة 5% للباقي
    END
WHERE IsActive = 1;

-- تحديث حالات متعددة
UPDATE Products
SET 
    StockStatus = CASE 
        WHEN StockQuantity = 0 THEN N'نفذ'
        WHEN StockQuantity <= ReorderLevel THEN N'منخفض'
        WHEN StockQuantity > ReorderLevel * 2 THEN N'جيد'
        ELSE N'متوسط'
    END,
    NeedsReorder = CASE 
        WHEN StockQuantity <= ReorderLevel THEN 1
        ELSE 0
    END;
```

## CASE متداخل (Nested CASE)

```sql
-- CASE داخل CASE
SELECT 
    FirstName,
    Salary,
    DepartmentID,
    CASE DepartmentID
        WHEN 1 THEN 
            CASE 
                WHEN Salary > 10000 THEN N'مدير مبيعات'
                ELSE N'موظف مبيعات'
            END
        WHEN 2 THEN 
            CASE 
                WHEN Salary > 12000 THEN N'مدير تسويق'
                ELSE N'موظف تسويق'
            END
        WHEN 3 THEN 
            CASE 
                WHEN Salary > 15000 THEN N'مهندس رئيسي'
                WHEN Salary > 10000 THEN N'مهندس أول'
                ELSE N'مطور'
            END
        ELSE N'موظف عام'
    END AS JobTitle
FROM Employees;
```

## CASE مع الدوال التجميعية

```sql
-- عد شرطي
SELECT 
    DepartmentID,
    COUNT(*) AS TotalEmployees,
    COUNT(CASE WHEN Salary > 10000 THEN 1 END) AS HighSalary,
    COUNT(CASE WHEN Salary BETWEEN 5000 AND 10000 THEN 1 END) AS MediumSalary,
    COUNT(CASE WHEN Salary < 5000 THEN 1 END) AS LowSalary,
    SUM(CASE WHEN Gender = 'M' THEN 1 ELSE 0 END) AS Males,
    SUM(CASE WHEN Gender = 'F' THEN 1 ELSE 0 END) AS Females
FROM Employees
GROUP BY DepartmentID;

-- متوسطات مشروطة
SELECT 
    DepartmentID,
    AVG(Salary) AS OverallAverage,
    AVG(CASE WHEN Gender = 'M' THEN Salary END) AS MaleAverage,
    AVG(CASE WHEN Gender = 'F' THEN Salary END) AS FemaleAverage,
    AVG(CASE WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 5 THEN Salary END) AS NewEmployeesAvg
FROM Employees
GROUP BY DepartmentID;
```

## أمثلة عملية

### مثال 1: تقرير شامل للموظفين

```sql
SELECT 
    EmployeeID,
    FirstName + ' ' + LastName AS FullName,
    Salary,
    
    -- تصنيف الراتب
    CASE 
        WHEN Salary >= (SELECT AVG(Salary) * 1.5 FROM Employees) THEN N'⭐⭐⭐ ممتاز'
        WHEN Salary >= (SELECT AVG(Salary) FROM Employees) THEN N'⭐⭐ جيد'
        ELSE N'⭐ مقبول'
    END AS SalaryRating,
    
    -- حالة الأداء
    CASE 
        WHEN Salary > 15000 AND DATEDIFF(YEAR, HireDate, GETDATE()) < 2 THEN N'نجم صاعد'
        WHEN Salary > 15000 AND DATEDIFF(YEAR, HireDate, GETDATE()) >= 10 THEN N'خبير متميز'
        WHEN Salary < 5000 AND DATEDIFF(YEAR, HireDate, GETDATE()) > 5 THEN N'يحتاج مراجعة'
        ELSE N'عادي'
    END AS PerformanceStatus,
    
    -- الزيادة المقترحة
    CASE 
        WHEN Salary < (SELECT AVG(Salary) FROM Employees e WHERE e.DepartmentID = Employees.DepartmentID) 
            THEN Salary * 0.15
        WHEN DATEDIFF(YEAR, HireDate, GETDATE()) >= 5 
            THEN Salary * 0.10
        ELSE Salary * 0.05
    END AS SuggestedRaise
FROM Employees
WHERE IsActive = 1;
```

### مثال 2: تحليل الطلبات

```sql
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    
    -- حالة الطلب
    CASE OrderStatus
        WHEN 1 THEN N'🆕 جديد'
        WHEN 2 THEN N'⏳ قيد المعالجة'
        WHEN 3 THEN N'📦 تم الشحن'
        WHEN 4 THEN N'✅ تم التسليم'
        WHEN 5 THEN N'❌ ملغي'
        ELSE N'❓ غير معروف'
    END AS StatusText,
    
    -- فئة الطلب
    CASE 
        WHEN TotalAmount >= 10000 THEN N'VIP'
        WHEN TotalAmount >= 5000 THEN N'ذهبي'
        WHEN TotalAmount >= 1000 THEN N'فضي'
        ELSE N'برونزي'
    END AS OrderCategory,
    
    -- الأولوية
    CASE 
        WHEN TotalAmount > 10000 AND OrderStatus = 1 THEN N'عاجل جداً'
        WHEN TotalAmount > 5000 OR DATEDIFF(DAY, OrderDate, GETDATE()) > 7 THEN N'عاجل'
        WHEN OrderStatus = 5 THEN N'منخفض'
        ELSE N'عادي'
    END AS Priority,
    
    -- وقت التسليم المتوقع
    CASE 
        WHEN TotalAmount > 10000 THEN DATEADD(DAY, 1, OrderDate)
        WHEN TotalAmount > 5000 THEN DATEADD(DAY, 3, OrderDate)
        ELSE DATEADD(DAY, 7, OrderDate)
    END AS EstimatedDelivery
FROM Orders;
```

### مثال 3: تصنيف العملاء

```sql
-- تصنيف العملاء بناءً على نشاطهم
WITH CustomerActivity AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.TotalAmount) AS TotalSpent,
        MAX(o.OrderDate) AS LastOrderDate
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT 
    CustomerName,
    TotalOrders,
    TotalSpent,
    
    -- تصنيف العميل
    CASE 
        WHEN TotalSpent > 100000 THEN N'💎 ماسي'
        WHEN TotalSpent > 50000 THEN N'🥇 ذهبي'
        WHEN TotalSpent > 20000 THEN N'🥈 فضي'
        WHEN TotalSpent > 5000 THEN N'🥉 برونزي'
        ELSE N'⚪ عادي'
    END AS CustomerTier,
    
    -- حالة النشاط
    CASE 
        WHEN DATEDIFF(DAY, LastOrderDate, GETDATE()) <= 30 THEN N'نشط'
        WHEN DATEDIFF(DAY, LastOrderDate, GETDATE()) <= 90 THEN N'متوسط النشاط'
        WHEN DATEDIFF(DAY, LastOrderDate, GETDATE()) <= 180 THEN N'خامل'
        WHEN LastOrderDate IS NULL THEN N'لم يشتري بعد'
        ELSE N'غير نشط'
    END AS ActivityStatus,
    
    -- التوصية
    CASE 
        WHEN DATEDIFF(DAY, LastOrderDate, GETDATE()) > 90 AND TotalSpent > 10000 
            THEN N'إرسال عرض خاص لاستعادته'
        WHEN TotalOrders = 1 
            THEN N'تشجيعه على الشراء مرة أخرى'
        WHEN TotalSpent > 50000 AND DATEDIFF(DAY, LastOrderDate, GETDATE()) <= 30 
            THEN N'تقديم خصم ولاء'
        ELSE N'متابعة عادية'
    END AS Recommendation
FROM CustomerActivity;
```

## CASE مع IIF (SQL Server 2012+)

```sql
-- IIF هو اختصار لـ CASE البسيط
SELECT 
    FirstName,
    Salary,
    IIF(Salary > 10000, N'مرتفع', N'منخفض') AS SalaryLevel,
    
    -- مكافئ لـ:
    CASE WHEN Salary > 10000 THEN N'مرتفع' ELSE N'منخفض' END AS SalaryLevel2;

-- IIF متداخل (غير مُنصح به)
SELECT 
    FirstName,
    Salary,
    IIF(Salary > 15000, N'ممتاز',
        IIF(Salary > 10000, N'جيد',
            IIF(Salary > 5000, N'متوسط', N'منخفض')
        )
    ) AS SalaryLevel;
```

## نصائح وأفضل الممارسات

```sql
-- ✅ استخدم CASE بدلاً من عدة IFs في التطبيق
-- ✅ حدد ELSE دائماً لتجنب NULL

SELECT 
    CASE DepartmentID
        WHEN 1 THEN N'المبيعات'
        WHEN 2 THEN N'التسويق'
        ELSE N'أخرى'  -- ✅ دائماً حدد ELSE
    END AS Department
FROM Employees;

-- ⚠️ احذر من أنواع البيانات المختلفة
SELECT 
    CASE 
        WHEN Salary > 10000 THEN N'مرتفع'
        WHEN Salary > 5000 THEN N'متوسط'
        ELSE N'منخفض'  -- يجب أن تكون جميع النتائج من نفس النوع
    END AS SalaryLevel
FROM Employees;

-- ✅ استخدم CASE في الفهارس المحسوبة
ALTER TABLE Employees
ADD SalaryCategory AS (
    CASE 
        WHEN Salary >= 15000 THEN 'High'
        WHEN Salary >= 10000 THEN 'Medium'
        ELSE 'Low'
    END
) PERSISTED;

CREATE INDEX IX_SalaryCategory ON Employees(SalaryCategory);
```

## الخلاصة

- **Simple CASE**: للمقارنة بقيمة واحدة
- **Searched CASE**: للشروط المعقدة
- **في SELECT**: لإنشاء أعمدة محسوبة
- **في WHERE**: للتصفية الشرطية
- **في UPDATE**: للتحديث المشروط
- **مع GROUP BY**: للتجميع الشرطي
- **IIF**: اختصار بسيط لحالات معينة

---

[⬅️ السابق: PIVOT & UNPIVOT](22_pivot_unpivot.md) 
 [التالي: MERGE Statement ⬅️](24_merge.md) 
 [🏠 العودة للفهرس](README.md)
