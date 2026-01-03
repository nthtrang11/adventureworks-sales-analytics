/*
====================================================
Update AdventureWorksDW Dates (FIXED VERSION)
Author  : David Alzamendi (Modified & Fixed)
Purpose : Update data years to recent years
====================================================
*/

SET NOCOUNT ON;
SET DATEFIRST 7; -- Monday

----------------------------------------------------
-- Declare variables
----------------------------------------------------
DECLARE @CurrentYear INT = YEAR(GETDATE());
DECLARE @LastDayCurrentYear DATE =
    DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 1, 0));

DECLARE @MaxDateInDW INT;
SELECT @MaxDateInDW = MAX(YEAR(OrderDate)) FROM dbo.FactInternetSales;

DECLARE @YearsToAdd INT = @CurrentYear - @MaxDateInDW;

IF (@YearsToAdd <= 0)
BEGIN
    PRINT 'No update required';
    RETURN;
END

----------------------------------------------------
-- Delete leap day rows to avoid FK issues
----------------------------------------------------
DELETE FROM FactCurrencyRate
WHERE MONTH([Date]) = 2 AND DAY([Date]) = 29;

DELETE FROM FactProductInventory
WHERE MONTH([MovementDate]) = 2 AND DAY([MovementDate]) = 29;

----------------------------------------------------
-- Drop Foreign Keys
----------------------------------------------------
ALTER TABLE FactCurrencyRate DROP CONSTRAINT FK_FactCurrencyRate_DimDate;
ALTER TABLE FactFinance DROP CONSTRAINT FK_FactFinance_DimDate;
ALTER TABLE FactInternetSales DROP CONSTRAINT FK_FactInternetSales_DimDate;
ALTER TABLE FactInternetSales DROP CONSTRAINT FK_FactInternetSales_DimDate1;
ALTER TABLE FactInternetSales DROP CONSTRAINT FK_FactInternetSales_DimDate2;
ALTER TABLE FactProductInventory DROP CONSTRAINT FK_FactProductInventory_DimDate;
ALTER TABLE FactResellerSales DROP CONSTRAINT FK_FactResellerSales_DimDate;
ALTER TABLE FactSurveyResponse DROP CONSTRAINT FK_FactSurveyResponse_DateKey;

----------------------------------------------------
-- Populate DimDate
----------------------------------------------------
DECLARE @StartDate DATE = '2015-01-01';
DECLARE @EndDate   DATE = @LastDayCurrentYear;

;WITH DateCTE AS (
    SELECT @StartDate AS FullDate
    UNION ALL
    SELECT DATEADD(DAY, 1, FullDate)
    FROM DateCTE
    WHERE FullDate < @EndDate
)
INSERT INTO dbo.DimDate (
    DateKey,
    FullDateAlternateKey,
    DayNumberOfWeek,
    EnglishDayNameOfWeek,
    SpanishDayNameOfWeek,
    FrenchDayNameOfWeek,
    DayNumberOfMonth,
    DayNumberOfYear,
    WeekNumberOfYear,
    EnglishMonthName,
    SpanishMonthName,
    FrenchMonthName,
    MonthNumberOfYear,
    CalendarQuarter,
    CalendarYear,
    CalendarSemester,
    FiscalQuarter,
    FiscalYear,
    FiscalSemester
)
SELECT
    CONVERT(INT, FORMAT(FullDate, 'yyyyMMdd')),
    FullDate,
    DATEPART(WEEKDAY, FullDate),
    DATENAME(WEEKDAY, FullDate),
    DATENAME(WEEKDAY, FullDate), -- Spanish (fallback)
    DATENAME(WEEKDAY, FullDate), -- French (fallback)
    DAY(FullDate),
    DATEPART(DAYOFYEAR, FullDate),
    DATEPART(WEEK, FullDate),
    DATENAME(MONTH, FullDate),
    DATENAME(MONTH, FullDate),   -- Spanish (fallback)
    DATENAME(MONTH, FullDate),   -- French (fallback)
    MONTH(FullDate),
    DATEPART(QUARTER, FullDate),
    YEAR(FullDate),
    CASE WHEN DATEPART(QUARTER, FullDate) <= 2 THEN 1 ELSE 2 END,
    DATEPART(QUARTER, FullDate),
    YEAR(FullDate),
    CASE WHEN DATEPART(QUARTER, FullDate) <= 2 THEN 1 ELSE 2 END
FROM DateCTE d
LEFT JOIN dbo.DimDate x
    ON x.FullDateAlternateKey = d.FullDate
WHERE x.DateKey IS NULL
OPTION (MAXRECURSION 0);

----------------------------------------------------
-- Update DATE columns
----------------------------------------------------
UPDATE DimCustomer       SET DateFirstPurchase = DATEADD(YEAR, @YearsToAdd, DateFirstPurchase) WHERE DateFirstPurchase IS NOT NULL;
UPDATE DimEmployee       SET StartDate = DATEADD(YEAR, @YearsToAdd, StartDate) WHERE StartDate IS NOT NULL;
UPDATE DimEmployee       SET EndDate   = DATEADD(YEAR, @YearsToAdd, EndDate)   WHERE EndDate IS NOT NULL;
UPDATE DimProduct        SET StartDate = DATEADD(YEAR, @YearsToAdd, StartDate) WHERE StartDate IS NOT NULL;
UPDATE DimProduct        SET EndDate   = DATEADD(YEAR, @YearsToAdd, EndDate)   WHERE EndDate IS NOT NULL;
UPDATE DimPromotion      SET StartDate = DATEADD(YEAR, @YearsToAdd, StartDate) WHERE StartDate IS NOT NULL;
UPDATE DimPromotion      SET EndDate   = DATEADD(YEAR, @YearsToAdd, EndDate)   WHERE EndDate IS NOT NULL;

UPDATE FactCallCenter        SET Date = DATEADD(YEAR, @YearsToAdd, Date) WHERE Date IS NOT NULL;
UPDATE FactCurrencyRate     SET Date = DATEADD(YEAR, @YearsToAdd, Date) WHERE Date IS NOT NULL;
UPDATE FactFinance          SET Date = DATEADD(YEAR, @YearsToAdd, Date) WHERE Date IS NOT NULL;
UPDATE FactInternetSales    SET OrderDate = DATEADD(YEAR, @YearsToAdd, OrderDate) WHERE OrderDate IS NOT NULL;
UPDATE FactInternetSales    SET DueDate   = DATEADD(YEAR, @YearsToAdd, DueDate)   WHERE DueDate IS NOT NULL;
UPDATE FactInternetSales    SET ShipDate  = DATEADD(YEAR, @YearsToAdd, ShipDate)  WHERE ShipDate IS NOT NULL;
UPDATE FactProductInventory SET MovementDate = DATEADD(YEAR, @YearsToAdd, MovementDate) WHERE MovementDate IS NOT NULL;
UPDATE FactResellerSales    SET OrderDate = DATEADD(YEAR, @YearsToAdd, OrderDate) WHERE OrderDate IS NOT NULL;
UPDATE FactResellerSales    SET DueDate   = DATEADD(YEAR, @YearsToAdd, DueDate)   WHERE DueDate IS NOT NULL;
UPDATE FactResellerSales    SET ShipDate  = DATEADD(YEAR, @YearsToAdd, ShipDate)  WHERE ShipDate IS NOT NULL;
UPDATE FactSalesQuota       SET Date = DATEADD(YEAR, @YearsToAdd, Date) WHERE Date IS NOT NULL;
UPDATE FactSurveyResponse   SET Date = DATEADD(YEAR, @YearsToAdd, Date) WHERE Date IS NOT NULL;

----------------------------------------------------
-- Update DateKey columns
----------------------------------------------------
UPDATE FactCallCenter        SET DateKey = CONVERT(INT, FORMAT([Date], 'yyyyMMdd'));
UPDATE FactCurrencyRate     SET DateKey = CONVERT(INT, FORMAT([Date], 'yyyyMMdd'));
UPDATE FactFinance          SET DateKey = CONVERT(INT, FORMAT([Date], 'yyyyMMdd'));
UPDATE FactInternetSales    SET OrderDateKey = CONVERT(INT, FORMAT(OrderDate, 'yyyyMMdd'));
UPDATE FactInternetSales    SET DueDateKey   = CONVERT(INT, FORMAT(DueDate, 'yyyyMMdd'));
UPDATE FactInternetSales    SET ShipDateKey  = CONVERT(INT, FORMAT(ShipDate, 'yyyyMMdd'));
UPDATE FactProductInventory SET DateKey = CONVERT(INT, FORMAT(MovementDate, 'yyyyMMdd'));
UPDATE FactResellerSales    SET OrderDateKey = CONVERT(INT, FORMAT(OrderDate, 'yyyyMMdd'));
UPDATE FactResellerSales    SET DueDateKey   = CONVERT(INT, FORMAT(DueDate, 'yyyyMMdd'));
UPDATE FactResellerSales    SET ShipDateKey  = CONVERT(INT, FORMAT(ShipDate, 'yyyyMMdd'));
UPDATE FactSalesQuota       SET DateKey = CONVERT(INT, FORMAT([Date], 'yyyyMMdd'));
UPDATE FactSurveyResponse   SET DateKey = CONVERT(INT, FORMAT([Date], 'yyyyMMdd'));

----------------------------------------------------
-- Update year-number columns
----------------------------------------------------
UPDATE FactSalesQuota SET CalendarYear = CalendarYear + @YearsToAdd;
UPDATE DimReseller SET FirstOrderYear = FirstOrderYear + @YearsToAdd WHERE FirstOrderYear IS NOT NULL;
UPDATE DimReseller SET LastOrderYear  = LastOrderYear  + @YearsToAdd WHERE LastOrderYear IS NOT NULL;
UPDATE DimReseller SET YearOpened     = YearOpened     + @YearsToAdd WHERE YearOpened IS NOT NULL;

----------------------------------------------------
-- Recreate Foreign Keys
----------------------------------------------------
ALTER TABLE FactCurrencyRate  WITH CHECK ADD CONSTRAINT FK_FactCurrencyRate_DimDate
FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactFinance WITH CHECK ADD CONSTRAINT FK_FactFinance_DimDate
FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactInternetSales WITH CHECK ADD CONSTRAINT FK_FactInternetSales_DimDate
FOREIGN KEY (OrderDateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactInternetSales WITH CHECK ADD CONSTRAINT FK_FactInternetSales_DimDate1
FOREIGN KEY (DueDateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactInternetSales WITH CHECK ADD CONSTRAINT FK_FactInternetSales_DimDate2
FOREIGN KEY (ShipDateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactProductInventory WITH CHECK ADD CONSTRAINT FK_FactProductInventory_DimDate
FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactResellerSales WITH CHECK ADD CONSTRAINT FK_FactResellerSales_DimDate
FOREIGN KEY (OrderDateKey) REFERENCES DimDate(DateKey);

ALTER TABLE FactSurveyResponse WITH CHECK ADD CONSTRAINT FK_FactSurveyResponse_DateKey
FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey);

PRINT 'Update completed successfully';
