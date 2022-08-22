CREATE TABLE [dbo].[Pharmacy]
(
[PharmacyUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__Pharmacy__Pharma__267ABA7A] DEFAULT (newid()),
[Name] [varchar] (150) COLLATE Cyrillic_General_CI_AS NOT NULL,
[Address] [varchar] (250) COLLATE Cyrillic_General_CI_AS NOT NULL,
[AddresUID] [uniqueidentifier] NULL,
[PhoneNumber] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[Pharmacy] ADD CONSTRAINT [PK_Pharmacy_PharmacyUID] PRIMARY KEY CLUSTERED ([PharmacyUID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Pharmacy] ON [dbo].[Pharmacy] ([Name], [Address])
GO
