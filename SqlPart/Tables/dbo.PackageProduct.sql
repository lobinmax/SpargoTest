CREATE TABLE [dbo].[PackageProduct]
(
[PackageProductId] [int] NOT NULL IDENTITY(0, 1),
[PharmProductId] [int] NOT NULL,
[PharmacyDepotId] [int] NOT NULL,
[Count] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[PackageProduct] ADD CONSTRAINT [PK_PackageProduct] PRIMARY KEY CLUSTERED ([PackageProductId])
GO
ALTER TABLE [dbo].[PackageProduct] ADD CONSTRAINT [FK_PackageProduct_PharmacyDepot_PharmacyDepotId] FOREIGN KEY ([PharmacyDepotId]) REFERENCES [dbo].[PharmacyDepot] ([PharmacyDepotId])
GO
ALTER TABLE [dbo].[PackageProduct] ADD CONSTRAINT [FK_PackageProduct_PharmProduct_PharmProductId] FOREIGN KEY ([PharmProductId]) REFERENCES [dbo].[PharmProduct] ([PharmProductId])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Количество', 'SCHEMA', N'dbo', 'TABLE', N'PackageProduct', 'COLUMN', N'Count'
GO
