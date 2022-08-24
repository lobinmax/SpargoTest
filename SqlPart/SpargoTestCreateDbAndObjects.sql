--
-- Скрипт сгенерирован Devart dbForge Studio 2019 for SQL Server, Версия 5.8.107.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/sql/studio
-- Дата скрипта: 25.08.2022 3:17:30
-- Версия сервера: 11.00.6020
--


SET DATEFORMAT ymd
SET ARITHABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS, XACT_ABORT OFF
GO
USE master
GO

IF DB_NAME() <> N'master' SET NOEXEC ON

--
-- Создать базу данных [SpargoTest]
--
PRINT (N'Создать базу данных [SpargoTest]')
GO
IF DB_ID('SpargoTest') IS NULL
CREATE DATABASE SpargoTest
ON PRIMARY(
    NAME = N'SpargoTest',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SpargoTest.mdf',
    SIZE = 10240KB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1024KB
)
LOG ON(
    NAME = N'SpargoTest_log',
    FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\SpargoTest_log.ldf',
    SIZE = 5120KB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
GO

--
-- Изменить базу данных
--
PRINT (N'Изменить базу данных')
GO
ALTER DATABASE SpargoTest
  SET
    ANSI_NULL_DEFAULT OFF,
    ANSI_NULLS OFF,
    ANSI_PADDING OFF,
    ANSI_WARNINGS OFF,
    ARITHABORT OFF,
    AUTO_CLOSE OFF,
    AUTO_CREATE_STATISTICS ON,
    AUTO_SHRINK OFF,
    AUTO_UPDATE_STATISTICS ON,
    AUTO_UPDATE_STATISTICS_ASYNC OFF,
    COMPATIBILITY_LEVEL = 110,
    CONCAT_NULL_YIELDS_NULL OFF,
    CURSOR_CLOSE_ON_COMMIT OFF,
    CURSOR_DEFAULT GLOBAL,
    DATE_CORRELATION_OPTIMIZATION OFF,
    DB_CHAINING OFF,
    HONOR_BROKER_PRIORITY OFF,
    MULTI_USER,
    NESTED_TRIGGERS = ON,
    NUMERIC_ROUNDABORT OFF,
    PAGE_VERIFY CHECKSUM,
    PARAMETERIZATION SIMPLE,
    QUOTED_IDENTIFIER OFF,
    READ_COMMITTED_SNAPSHOT OFF,
    RECOVERY FULL,
    RECURSIVE_TRIGGERS OFF,
    TRANSFORM_NOISE_WORDS = OFF,
    TRUSTWORTHY OFF
    WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE SpargoTest
  SET DISABLE_BROKER
GO

ALTER DATABASE SpargoTest
  SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE SpargoTest
  SET FILESTREAM (NON_TRANSACTED_ACCESS = OFF)
GO

USE SpargoTest
GO

IF DB_NAME() <> N'SpargoTest' SET NOEXEC ON
GO

--
-- Создать таблицу [dbo].[PharmProduct]
--
PRINT (N'Создать таблицу [dbo].[PharmProduct]')
GO
IF OBJECT_ID(N'dbo.PharmProduct', 'U') IS NULL
CREATE TABLE dbo.PharmProduct (
  PharmProductId int IDENTITY (0, 1),
  Name varchar(150) NOT NULL,
  CONSTRAINT PK_PharmProduct PRIMARY KEY CLUSTERED (PharmProductId)
)
ON [PRIMARY]
GO

--
-- Создать таблицу [dbo].[PharmacyDepot]
--
PRINT (N'Создать таблицу [dbo].[PharmacyDepot]')
GO
IF OBJECT_ID(N'dbo.PharmacyDepot', 'U') IS NULL
CREATE TABLE dbo.PharmacyDepot (
  PharmacyDepotId int IDENTITY (0, 1),
  PharmacyId int NOT NULL,
  Name varchar(50) NOT NULL,
  Address varchar(250) NOT NULL,
  CONSTRAINT PK_PharmacyDepot_PharmacyDepotId PRIMARY KEY CLUSTERED (PharmacyDepotId)
)
ON [PRIMARY]
GO

--
-- Создать индекс [UK_PharmacyDepot] для объекта типа таблица [dbo].[PharmacyDepot]
--
PRINT (N'Создать индекс [UK_PharmacyDepot] для объекта типа таблица [dbo].[PharmacyDepot]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'UK_PharmacyDepot' AND object_id = OBJECT_ID(N'dbo.PharmacyDepot'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'PharmacyId' AND object_id = OBJECT_ID(N'dbo.PharmacyDepot'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Name' AND object_id = OBJECT_ID(N'dbo.PharmacyDepot'))
CREATE UNIQUE INDEX UK_PharmacyDepot
  ON dbo.PharmacyDepot (PharmacyId, Name)
  ON [PRIMARY]
GO

--
-- Создать таблицу [dbo].[Pharmacy]
--
PRINT (N'Создать таблицу [dbo].[Pharmacy]')
GO
IF OBJECT_ID(N'dbo.Pharmacy', 'U') IS NULL
CREATE TABLE dbo.Pharmacy (
  PharmacyId int IDENTITY (0, 1),
  Name varchar(150) NOT NULL,
  Address varchar(250) NOT NULL,
  PhoneNumber varchar(50) NULL,
  CONSTRAINT PK_Pharmacy PRIMARY KEY CLUSTERED (PharmacyId)
)
ON [PRIMARY]
GO

--
-- Создать индекс [IDX_Pharmacy] для объекта типа таблица [dbo].[Pharmacy]
--
PRINT (N'Создать индекс [IDX_Pharmacy] для объекта типа таблица [dbo].[Pharmacy]')
GO
IF NOT EXISTS (
  SELECT 1 FROM sys.indexes
  WHERE name = N'IDX_Pharmacy' AND object_id = OBJECT_ID(N'dbo.Pharmacy'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Name' AND object_id = OBJECT_ID(N'dbo.Pharmacy'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'Address' AND object_id = OBJECT_ID(N'dbo.Pharmacy'))
CREATE UNIQUE INDEX IDX_Pharmacy
  ON dbo.Pharmacy (Name, Address)
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--
-- Создать процедуру [dbo].[PharmacyCrud]
--
GO
PRINT (N'Создать процедуру [dbo].[PharmacyCrud]')
GO
IF OBJECT_ID(N'dbo.PharmacyCrud', 'P') IS NULL
EXEC sp_executesql N'CREATE PROCEDURE dbo.PharmacyCrud
    @EntityId INT = NULL,
    @Name VARCHAR(300) = NULL,
    @Address VARCHAR(500) = NULL,
    @PhoneNumber VARCHAR(100) = NULL,
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            p.PharmacyId, 
            p.Name, 
            p.Address, 
            p.PhoneNumber
        FROM dbo.Pharmacy AS p
        WHERE @EntityId IS NULL 
            OR p.PharmacyId = @EntityId       
        ORDER BY p.PharmacyId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.Pharmacy (Name, Address, PhoneNumber)
        VALUES (@Name, @Address, @PhoneNumber);
    END

    IF @Function = 2
    BEGIN
    	BEGIN TRANSACTION
        	DELETE FROM dbo.PharmacyDepot WHERE PharmacyId = @EntityId
            DELETE FROM dbo.Pharmacy WHERE PharmacyId = @EntityId

        IF @@error = 0
        BEGIN
        	COMMIT TRANSACTION
        END
        ELSE BEGIN
            ROLLBACK TRANSACTION
        END
    END
END
'
GO

--
-- Создать таблицу [dbo].[PackageProduct]
--
PRINT (N'Создать таблицу [dbo].[PackageProduct]')
GO
IF OBJECT_ID(N'dbo.PackageProduct', 'U') IS NULL
CREATE TABLE dbo.PackageProduct (
  PackageProductId int IDENTITY (0, 1),
  PharmProductId int NOT NULL,
  PharmacyDepotId int NOT NULL,
  Count int NOT NULL,
  CONSTRAINT PK_PackageProduct PRIMARY KEY CLUSTERED (PackageProductId)
)
ON [PRIMARY]
GO

--
-- Добавить расширенное свойство [MS_Description] для [dbo].[PackageProduct].[Count] (столбец)
--
PRINT (N'Добавить расширенное свойство [MS_Description] для [dbo].[PackageProduct].[Count] (столбец)')
GO
IF NOT EXISTS (SELECT 1 FROM sys.fn_listextendedproperty(N'MS_Description', 'SCHEMA', N'dbo', 'TABLE', N'PackageProduct', 'COLUMN', N'Count'))
EXEC sys.sp_addextendedproperty N'MS_Description', 'Количество', 'SCHEMA', N'dbo', 'TABLE', N'PackageProduct', 'COLUMN', N'Count'
GO

--
-- Создать процедуру [dbo].[PharmProductsInPharmacy]
--
GO
PRINT (N'Создать процедуру [dbo].[PharmProductsInPharmacy]')
GO
IF OBJECT_ID(N'dbo.PharmProductsInPharmacy', 'P') IS NULL
EXEC sp_executesql N'CREATE PROCEDURE dbo.PharmProductsInPharmacy
    @PharmacyId INT
AS BEGIN

    SELECT 
        pp1.Name AS PharmacyName, 
        CAST(SUM(pp.Count) AS VARCHAR(10)) + '' шт.'' AS Count
    FROM dbo.Pharmacy AS p
    INNER JOIN dbo.PharmacyDepot AS pd ON p.PharmacyId = pd.PharmacyId
    INNER JOIN dbo.PackageProduct AS pp ON pd.PharmacyDepotId = pp.PharmacyDepotId
    INNER JOIN dbo.PharmProduct AS pp1 ON pp.PharmProductId = pp1.PharmProductId
    WHERE p.PharmacyId = @PharmacyId
    GROUP BY pp1.Name
       	
END
'
GO

--
-- Создать процедуру [dbo].[PharmProductCrud]
--
GO
PRINT (N'Создать процедуру [dbo].[PharmProductCrud]')
GO
IF OBJECT_ID(N'dbo.PharmProductCrud', 'P') IS NULL
EXEC sp_executesql N'CREATE PROCEDURE dbo.PharmProductCrud
    @EntityId INT = NULL,
    @Name VARCHAR(300) = NULL,
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            pp.PharmProductId,  
            pp.Name AS [Name]
        FROM dbo.PharmProduct AS pp
        WHERE @EntityId IS NULL 
            OR pp.PharmProductId = @EntityId        
        ORDER BY pp.PharmProductId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.PharmProduct (Name)
        VALUES (@Name);
    END

    IF @Function = 2
    BEGIN
    	BEGIN TRANSACTION
        	DELETE FROM dbo.PackageProduct WHERE PharmProductId = @EntityId
            DELETE FROM dbo.PharmProduct WHERE PharmProductId = @EntityId

        IF @@error = 0
        BEGIN
        	COMMIT TRANSACTION
        END
        ELSE BEGIN
            ROLLBACK TRANSACTION
        END
    END
END
'
GO

--
-- Создать процедуру [dbo].[PharmacyDepotCrud]
--
GO
PRINT (N'Создать процедуру [dbo].[PharmacyDepotCrud]')
GO
IF OBJECT_ID(N'dbo.PharmacyDepotCrud', 'P') IS NULL
EXEC sp_executesql N'CREATE PROCEDURE dbo.PharmacyDepotCrud
    @EntityId INT = NULL,
    @PharmacyId INT = NULL,
    @Name VARCHAR(300) = NULL,
    @Address VARCHAR(500) = NULL, 
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            pd.PharmacyDepotId, 
            pd.PharmacyId, 
            pd.Name, 
            pd.Address
        FROM dbo.PharmacyDepot AS pd
        WHERE @EntityId IS NULL 
            OR pd.PharmacyDepotId = @EntityId       
        ORDER BY pd.PharmacyDepotId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.PharmacyDepot (PharmacyId, Name, Address)
        VALUES (@PharmacyId, @Name, @Address);
    END

    IF @Function = 2
    BEGIN
    	BEGIN TRANSACTION
        	DELETE FROM dbo.PackageProduct WHERE PharmacyDepotId = @EntityId
            DELETE FROM dbo.PharmacyDepot WHERE PharmacyDepotId = @EntityId

        IF @@error = 0
        BEGIN
        	COMMIT TRANSACTION
        END
        ELSE BEGIN
            ROLLBACK TRANSACTION
        END
    END
END
'
GO

--
-- Создать процедуру [dbo].[PackageProductCrud]
--
GO
PRINT (N'Создать процедуру [dbo].[PackageProductCrud]')
GO
IF OBJECT_ID(N'dbo.PackageProductCrud', 'P') IS NULL
EXEC sp_executesql N'CREATE PROCEDURE dbo.PackageProductCrud
    @EntityId INT = NULL,
    @PharmProductId INT = NULL,
    @PharmacyDepotId INT = NULL,
    @Count INT = NULL, 
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            pp.PackageProductId, 
            pp.PharmProductId, 
            pp.PharmacyDepotId, 
            pp.Count 
        FROM dbo.PackageProduct AS pp
        WHERE @EntityId IS NULL 
            OR pp.PackageProductId = @EntityId       
        ORDER BY pp.PackageProductId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.PackageProduct (PharmProductId, PharmacyDepotId, Count)
        VALUES (@PharmProductId, @PharmacyDepotId, @Count);
    END

    IF @Function = 2
    BEGIN
        DELETE FROM dbo.PackageProduct WHERE PackageProductId = @EntityId
    END
END
'
GO
-- 
-- Вывод данных для таблицы PackageProduct
--
PRINT (N'Вывод данных для таблицы PackageProduct')
SET IDENTITY_INSERT dbo.PackageProduct ON
GO
INSERT dbo.PackageProduct(PackageProductId, PharmProductId, PharmacyDepotId, Count) VALUES (0, 1, 2, 253)
INSERT dbo.PackageProduct(PackageProductId, PharmProductId, PharmacyDepotId, Count) VALUES (1, 5, 3, 40)
INSERT dbo.PackageProduct(PackageProductId, PharmProductId, PharmacyDepotId, Count) VALUES (3, 5, 4, 60)
INSERT dbo.PackageProduct(PackageProductId, PharmProductId, PharmacyDepotId, Count) VALUES (4, 7, 2, 648)
INSERT dbo.PackageProduct(PackageProductId, PharmProductId, PharmacyDepotId, Count) VALUES (5, 6, 4, 47)
INSERT dbo.PackageProduct(PackageProductId, PharmProductId, PharmacyDepotId, Count) VALUES (6, 6, 7, 150)
GO
SET IDENTITY_INSERT dbo.PackageProduct OFF
GO
-- 
-- Вывод данных для таблицы Pharmacy
--
PRINT (N'Вывод данных для таблицы Pharmacy')
SET IDENTITY_INSERT dbo.Pharmacy ON
GO
INSERT dbo.Pharmacy(PharmacyId, Name, Address, PhoneNumber) VALUES (1, 'Аптечный пункт', 'Россия, Красноярский край, п.Степной, ул.Школьная, 9А', '8-800-775-64-03')
INSERT dbo.Pharmacy(PharmacyId, Name, Address, PhoneNumber) VALUES (2, 'Аптека 100', 'Россия, Красноярский край, Зеленогорск, Набережная улица, 38', '8-800-775-64-03')
INSERT dbo.Pharmacy(PharmacyId, Name, Address, PhoneNumber) VALUES (3, 'Аптека 104', 'Россия, Красноярский край, Бородино, улица Горького, 2', '8-800-775-64-03')
GO
SET IDENTITY_INSERT dbo.Pharmacy OFF
GO
-- 
-- Вывод данных для таблицы PharmacyDepot
--
PRINT (N'Вывод данных для таблицы PharmacyDepot')
SET IDENTITY_INSERT dbo.PharmacyDepot ON
GO
INSERT dbo.PharmacyDepot(PharmacyDepotId, PharmacyId, Name, Address) VALUES (2, 1, 'Склад №59', 'Россия, Красноярский край, п.Степной, ул.Школьная, 10')
INSERT dbo.PharmacyDepot(PharmacyDepotId, PharmacyId, Name, Address) VALUES (3, 1, 'Склад №2', 'Россия, Красноярский край, п.Степной, ул.Школьная, 29')
INSERT dbo.PharmacyDepot(PharmacyDepotId, PharmacyId, Name, Address) VALUES (4, 2, 'Склад №36', 'Россия, Красноярский край, Канск, Краснопартизанская улица, 71, стр.5')
INSERT dbo.PharmacyDepot(PharmacyDepotId, PharmacyId, Name, Address) VALUES (7, 2, 'Склад №85', 'Россия, Красноярск, улица Мичурина, 39/3')
GO
SET IDENTITY_INSERT dbo.PharmacyDepot OFF
GO
-- 
-- Вывод данных для таблицы PharmProduct
--
PRINT (N'Вывод данных для таблицы PharmProduct')
SET IDENTITY_INSERT dbo.PharmProduct ON
GO
INSERT dbo.PharmProduct(PharmProductId, Name) VALUES (1, 'Когоцел')
INSERT dbo.PharmProduct(PharmProductId, Name) VALUES (5, 'Парацетамол')
INSERT dbo.PharmProduct(PharmProductId, Name) VALUES (6, 'Аспирин')
INSERT dbo.PharmProduct(PharmProductId, Name) VALUES (7, 'Терафлю')
GO
SET IDENTITY_INSERT dbo.PharmProduct OFF
GO

USE SpargoTest
GO

IF DB_NAME() <> N'SpargoTest' SET NOEXEC ON
GO

--
-- Создать внешний ключ [FK_PharmacyDepot_Pharmacy_PharmacyId] для объекта типа таблица [dbo].[PharmacyDepot]
--
PRINT (N'Создать внешний ключ [FK_PharmacyDepot_Pharmacy_PharmacyId] для объекта типа таблица [dbo].[PharmacyDepot]')
GO
IF OBJECT_ID('dbo.FK_PharmacyDepot_Pharmacy_PharmacyId', 'F') IS NULL
  AND OBJECT_ID('dbo.PharmacyDepot', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.Pharmacy', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'PharmacyId' AND object_id = OBJECT_ID(N'dbo.PharmacyDepot'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'PharmacyId' AND object_id = OBJECT_ID(N'dbo.Pharmacy'))
ALTER TABLE dbo.PharmacyDepot
  ADD CONSTRAINT FK_PharmacyDepot_Pharmacy_PharmacyId FOREIGN KEY (PharmacyId) REFERENCES dbo.Pharmacy (PharmacyId)
GO

--
-- Создать внешний ключ [FK_PackageProduct_PharmacyDepot_PharmacyDepotId] для объекта типа таблица [dbo].[PackageProduct]
--
PRINT (N'Создать внешний ключ [FK_PackageProduct_PharmacyDepot_PharmacyDepotId] для объекта типа таблица [dbo].[PackageProduct]')
GO
IF OBJECT_ID('dbo.FK_PackageProduct_PharmacyDepot_PharmacyDepotId', 'F') IS NULL
  AND OBJECT_ID('dbo.PackageProduct', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PharmacyDepot', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'PharmacyDepotId' AND object_id = OBJECT_ID(N'dbo.PackageProduct'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'PharmacyDepotId' AND object_id = OBJECT_ID(N'dbo.PharmacyDepot'))
ALTER TABLE dbo.PackageProduct
  ADD CONSTRAINT FK_PackageProduct_PharmacyDepot_PharmacyDepotId FOREIGN KEY (PharmacyDepotId) REFERENCES dbo.PharmacyDepot (PharmacyDepotId)
GO

--
-- Создать внешний ключ [FK_PackageProduct_PharmProduct_PharmProductId] для объекта типа таблица [dbo].[PackageProduct]
--
PRINT (N'Создать внешний ключ [FK_PackageProduct_PharmProduct_PharmProductId] для объекта типа таблица [dbo].[PackageProduct]')
GO
IF OBJECT_ID('dbo.FK_PackageProduct_PharmProduct_PharmProductId', 'F') IS NULL
  AND OBJECT_ID('dbo.PackageProduct', 'U') IS NOT NULL
  AND OBJECT_ID('dbo.PharmProduct', 'U') IS NOT NULL
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'PharmProductId' AND object_id = OBJECT_ID(N'dbo.PackageProduct'))
  AND EXISTS (
  SELECT 1 FROM sys.columns
  WHERE name = N'PharmProductId' AND object_id = OBJECT_ID(N'dbo.PharmProduct'))
ALTER TABLE dbo.PackageProduct
  ADD CONSTRAINT FK_PackageProduct_PharmProduct_PharmProductId FOREIGN KEY (PharmProductId) REFERENCES dbo.PharmProduct (PharmProductId)
GO
SET NOEXEC OFF
GO