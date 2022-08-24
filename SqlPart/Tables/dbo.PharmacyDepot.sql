CREATE TABLE [dbo].[PharmacyDepot]
(
[PharmacyDepotId] [int] NOT NULL IDENTITY(0, 1),
[PharmacyId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE Cyrillic_General_CI_AS NOT NULL,
[Address] [varchar] (250) COLLATE Cyrillic_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[PharmacyDepot] ADD CONSTRAINT [PK_PharmacyDepot_PharmacyDepotId] PRIMARY KEY CLUSTERED ([PharmacyDepotId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_PharmacyDepot] ON [dbo].[PharmacyDepot] ([PharmacyId], [Name])
GO
ALTER TABLE [dbo].[PharmacyDepot] ADD CONSTRAINT [FK_PharmacyDepot_Pharmacy_PharmacyId] FOREIGN KEY ([PharmacyId]) REFERENCES [dbo].[Pharmacy] ([PharmacyId])
GO
