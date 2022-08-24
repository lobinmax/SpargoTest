using System.Data;

namespace SpargoTest
{
    public class PackageProduct: DataBaseIntity<PackageProduct>, IDataBaseIntity
    {
        public string ProcedureName { get; set; }
        public int Id { get; set; }
        public PharmProduct PharmProduct { get; set; }
        public int PharmProductId { get; set; }
        public PharmacyDepot PharmacyDepot { get; set; }
        public int PharmacyDepotId { get; set; }
        public int Count { get; set; }
        public bool NotEmpty { get; set; }

        public PackageProduct()
        {
            this.ProcedureName = "PackageProductCrud";
        }
        public PackageProduct(int id)
        {
            this.ProcedureName = "PackageProductCrud";
            base.Read(id);
        }

        public void FillObjFromDr(DataRow row)
        {
            this.NotEmpty = true;
            this.Id = row["PharmacyDepotId"].CustomValueNn<int>();
            this.PharmProduct = new PharmProduct(row["PharmProductId"].CustomValueNn<int>());
            this.PharmProductId = row["PharmProductId"].CustomValueNn<int>();
            this.PharmacyDepot = new PharmacyDepot(row["PharmacyDepotId"].CustomValueNn<int>());
            this.PharmacyDepotId = row["PharmacyDepotId"].CustomValueNn<int>();
            this.Count = row["Count"].CustomValueNn<int>(); 
        }
    }
}
