SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PharmacyCrud]
    @EntityId INT = NULL,
    @Name VARCHAR(300) = NULL,
    @Address VARCHAR(500) = NULL,
    @PhoneNumber VARCHAR(100) = NULL,
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            p.PharmacyId, 
            p.Name, 
            p.Address, 
            p.PhoneNumber
        FROM dbo.Pharmacy AS p
        WHERE @EntityId IS NULL 
            OR p.PharmacyId = @EntityId       
        ORDER BY p.PharmacyId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.Pharmacy (Name, Address, PhoneNumber)
        VALUES (@Name, @Address, @PhoneNumber);
    END

    IF @Function = 2
    BEGIN
    	BEGIN TRANSACTION
        	DELETE FROM dbo.PharmacyDepot WHERE PharmacyId = @EntityId
            DELETE FROM dbo.Pharmacy WHERE PharmacyId = @EntityId

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
