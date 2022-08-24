SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PharmacyDepotCrud]
    @EntityId INT = NULL,
    @PharmacyId INT = NULL,
    @Name VARCHAR(300) = NULL,
    @Address VARCHAR(500) = NULL, 
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            pd.PharmacyDepotId, 
            pd.PharmacyId, 
            pd.Name, 
            pd.Address
        FROM dbo.PharmacyDepot AS pd
        WHERE @EntityId IS NULL 
            OR pd.PharmacyDepotId = @EntityId       
        ORDER BY pd.PharmacyDepotId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.PharmacyDepot (PharmacyId, Name, Address)
        VALUES (@PharmacyId, @Name, @Address);
    END

    IF @Function = 2
    BEGIN
    	BEGIN TRANSACTION
        	DELETE FROM dbo.PackageProduct WHERE PharmacyDepotId = @EntityId
            DELETE FROM dbo.PharmacyDepot WHERE PharmacyDepotId = @EntityId

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
