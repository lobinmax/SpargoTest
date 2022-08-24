SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PharmProductCrud]
    @EntityId INT = NULL,
    @Name VARCHAR(300) = NULL,
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            pp.PharmProductId,  
            pp.Name AS [Name]
        FROM dbo.PharmProduct AS pp
        WHERE @EntityId IS NULL 
            OR pp.PharmProductId = @EntityId        
        ORDER BY pp.PharmProductId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.PharmProduct (Name)
        VALUES (@Name);
    END

    IF @Function = 2
    BEGIN
    	BEGIN TRANSACTION
        	DELETE FROM dbo.PackageProduct WHERE PharmProductId = @EntityId
            DELETE FROM dbo.PharmProduct WHERE PharmProductId = @EntityId

        IF @@error = 0
        BEGIN
        	COMMIT TRANSACTION
        END
        ELSE BEGIN
            ROLLBACK TRANSACTION
        END
    END
END
GO
