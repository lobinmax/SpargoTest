SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PackageProductCrud]
    @EntityId INT = NULL,
    @PharmProductId INT = NULL,
    @PharmacyDepotId INT = NULL,
    @Count INT = NULL, 
    @Function TINYINT = 0
AS 
BEGIN    
    IF @Function = 0
    BEGIN
    	SELECT 
            pp.PackageProductId, 
            pp.PharmProductId, 
            pp.PharmacyDepotId, 
            pp.Count 
        FROM dbo.PackageProduct AS pp
        WHERE @EntityId IS NULL 
            OR pp.PackageProductId = @EntityId       
        ORDER BY pp.PackageProductId
    END	

    IF @Function = 1
    BEGIN    	
        INSERT INTO dbo.PackageProduct (PharmProductId, PharmacyDepotId, Count)
        VALUES (@PharmProductId, @PharmacyDepotId, @Count);
    END

    IF @Function = 2
    BEGIN
        DELETE FROM dbo.PackageProduct WHERE PackageProductId = @EntityId
    END
END
GO
