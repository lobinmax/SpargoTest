CREATE TABLE [dbo].[Pharmacy]
(
[PharmacyId] [int] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (150) COLLATE Cyrillic_General_CI_AS NOT NULL,
[Address] [varchar] (250) COLLATE Cyrillic_General_CI_AS NOT NULL,
[PhoneNumber] [varchar] (50) COLLATE Cyrillic_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[Pharmacy] ADD CONSTRAINT [PK_Pharmacy] PRIMARY KEY CLUSTERED ([PharmacyId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_Pharmacy] ON [dbo].[Pharmacy] ([Name], [Address])
GO
