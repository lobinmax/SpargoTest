CREATE TABLE [dbo].[PharmProduct]
(
[PharmProductId] [int] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (150) COLLATE Cyrillic_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[PharmProduct] ADD CONSTRAINT [PK_PharmProduct] PRIMARY KEY CLUSTERED ([PharmProductId])
GO
