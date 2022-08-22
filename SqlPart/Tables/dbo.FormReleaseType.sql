CREATE TABLE [dbo].[FormReleaseType]
(
[FormReleaseId] [tinyint] NOT NULL IDENTITY(0, 1),
[Name] [varchar] (100) COLLATE Cyrillic_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[FormReleaseType] ADD CONSTRAINT [PK_FormReleaseType_FormReleaseTypeUID] PRIMARY KEY CLUSTERED ([FormReleaseId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_FormReleaseType_Name] ON [dbo].[FormReleaseType] ([Name])
GO
