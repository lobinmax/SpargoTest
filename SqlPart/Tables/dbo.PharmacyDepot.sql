CREATE TABLE [dbo].[PharmacyDepot]
(
[PharmacyDepotUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__PharmacyD__Pharm__21B6055D] DEFAULT (newid()),
[PharmacyUID] [uniqueidentifier] NOT NULL,
[Name] [varchar] (50) COLLATE Cyrillic_General_CI_AS NOT NULL,
[Address] [varchar] (250) COLLATE Cyrillic_General_CI_AS NOT NULL,
[AddressUID] [uniqueidentifier] NULL
)
GO
ALTER TABLE [dbo].[PharmacyDepot] ADD CONSTRAINT [PK_PharmacyDepot_PharmacyDepotUID] PRIMARY KEY CLUSTERED ([PharmacyDepotUID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_PharmacyDepot] ON [dbo].[PharmacyDepot] ([PharmacyUID], [Name])
GO
ALTER TABLE [dbo].[PharmacyDepot] ADD CONSTRAINT [FK_PharmacyDepot_Pharmacy_PharmacyUID] FOREIGN KEY ([PharmacyUID]) REFERENCES [dbo].[Pharmacy] ([PharmacyUID])
GO
