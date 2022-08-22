CREATE TABLE [dbo].[PackageProduct]
(
[PackageProductUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__PackagePr__Packa__24927208] DEFAULT (newid()),
[FarmProductUID] [uniqueidentifier] NOT NULL,
[PharmacyDepotUID] [uniqueidentifier] NOT NULL,
[Count] [int] NOT NULL,
[Balance] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[PackageProduct] ADD CONSTRAINT [PK_PackageProduct_PackageProductUID] PRIMARY KEY CLUSTERED ([PackageProductUID])
GO
ALTER TABLE [dbo].[PackageProduct] ADD CONSTRAINT [FK_PackageProduct_PharmacyDepot_PharmacyDepotUID] FOREIGN KEY ([PharmacyDepotUID]) REFERENCES [dbo].[PharmacyDepot] ([PharmacyDepotUID])
GO
ALTER TABLE [dbo].[PackageProduct] ADD CONSTRAINT [FK_PackageProduct_PharmProduct_FarmProductUID] FOREIGN KEY ([FarmProductUID]) REFERENCES [dbo].[PharmProduct] ([FarmProductUID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Остаток в партии', 'SCHEMA', N'dbo', 'TABLE', N'PackageProduct', 'COLUMN', N'Balance'
GO
EXEC sp_addextendedproperty N'MS_Description', 'Количество', 'SCHEMA', N'dbo', 'TABLE', N'PackageProduct', 'COLUMN', N'Count'
GO
