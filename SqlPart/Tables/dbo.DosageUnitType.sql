CREATE TABLE [dbo].[DosageUnitType]
(
[DosageUnitId] [tinyint] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (100) COLLATE Cyrillic_General_CI_AS NOT NULL,
[NameShort] [varchar] (20) COLLATE Cyrillic_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[DosageUnitType] ADD CONSTRAINT [PK_DosageUnitType_DosageUnitId] PRIMARY KEY CLUSTERED ([DosageUnitId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_DosageUnitType_Name] ON [dbo].[DosageUnitType] ([Name])
GO
