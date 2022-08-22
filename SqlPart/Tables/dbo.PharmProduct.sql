CREATE TABLE [dbo].[PharmProduct]
(
[FarmProductUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__FarmProdu__FarmP__108B795B] DEFAULT (newid()),
[Name] [varchar] (150) COLLATE Cyrillic_General_CI_AS NOT NULL,
[FormReleaseId] [tinyint] NOT NULL,
[Dosage] [decimal] (18, 0) NOT NULL,
[DosageUnitId] [tinyint] NOT NULL,
[Count] [int] NULL
)
GO
ALTER TABLE [dbo].[PharmProduct] ADD CONSTRAINT [PK_FarmProducts_FarmProductUID] PRIMARY KEY CLUSTERED ([FarmProductUID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_FarmProducts] ON [dbo].[PharmProduct] ([Name], [FormReleaseId], [Dosage], [Count])
GO
ALTER TABLE [dbo].[PharmProduct] ADD CONSTRAINT [FK_PharmProduct_DosageUnitType_DosageUnitId] FOREIGN KEY ([DosageUnitId]) REFERENCES [dbo].[DosageUnitType] ([DosageUnitId])
GO
ALTER TABLE [dbo].[PharmProduct] ADD CONSTRAINT [FK_PharmProduct_FormReleaseType_FormReleaseId] FOREIGN KEY ([FormReleaseId]) REFERENCES [dbo].[FormReleaseType] ([FormReleaseId])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Дозировка', 'SCHEMA', N'dbo', 'TABLE', N'PharmProduct', 'COLUMN', N'Dosage'
GO
EXEC sp_addextendedproperty N'MS_Description', 'Ед. изм. дозировки', 'SCHEMA', N'dbo', 'TABLE', N'PharmProduct', 'COLUMN', N'DosageUnitId'
GO
