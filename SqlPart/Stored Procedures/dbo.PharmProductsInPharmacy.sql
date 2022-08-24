SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PharmProductsInPharmacy]
    @PharmacyId INT
AS BEGIN

    SELECT 
        pp1.Name AS PharmacyName, 
        CAST(SUM(pp.Count) AS VARCHAR(10)) + ' шт.' AS Count
    FROM dbo.Pharmacy AS p
    INNER JOIN dbo.PharmacyDepot AS pd ON p.PharmacyId = pd.PharmacyId
    INNER JOIN dbo.PackageProduct AS pp ON pd.PharmacyDepotId = pp.PharmacyDepotId
    INNER JOIN dbo.PharmProduct AS pp1 ON pp.PharmProductId = pp1.PharmProductId
    WHERE p.PharmacyId = @PharmacyId
    GROUP BY pp1.Name
       	
END
GO
