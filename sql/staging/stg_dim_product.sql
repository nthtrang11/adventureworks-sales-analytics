-- cleaned DimProduct table
SELECT p.[ProductKey]
      ,p.[ProductAlternateKey] as ProductItemCode
      --,[ProductSubcategoryKey]
      --,[WeightUnitMeasureCode]
      --,[SizeUnitMeasureCode]
      ,p.[EnglishProductName] as ProductName
	  ,ps.EnglishProductSubcategoryName as SubCategory
	  ,pc.EnglishProductCategoryName as ProductCategory

      --,[SpanishProductName]
      --,[FrenchProductName]
      --,[StandardCost]
      --,[FinishedGoodsFlag]
      ,p.[Color] as ProductColor
      --,[SafetyStockLevel]
      --,[ReorderPoint]
      --,[ListPrice]
      ,p.[Size] as ProductSize
      --,[SizeRange]
      --,[Weight]
      --,[DaysToManufacture]
      ,p.[ProductLine] as ProductLine
      --,[DealerPrice]
      --,[Class]
      --,[Style]
      ,p.[ModelName] as ProductModelName
      --,[LargePhoto]
      ,p.[EnglishDescription] as ProductDescription
      --,[FrenchDescription]
      --,[ChineseDescription]
      --,[ArabicDescription]
      --,[HebrewDescription]
      --,[ThaiDescription]
      --,[GermanDescription]
      --,[JapaneseDescription]
      --,[TurkishDescription]
      --,[StartDate]
      --,[EndDate]
      ,ISNULL(p.[Status], 'Outdated') as ProductStatus
  FROM [AdventureWorksDW2022].[dbo].[DimProduct] as p
  LEFT JOIN [dbo].[DimProductSubcategory] as ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
  LEFT JOIN [dbo].[DimProductCategory] as pc ON pc.ProductCategoryKey = ps.ProductCategoryKey
  ORDER BY p.ProductKey ASC
