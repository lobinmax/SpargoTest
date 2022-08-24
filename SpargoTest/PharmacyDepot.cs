using System.Data;

namespace SpargoTest
{
    public class PharmacyDepot: DataBaseIntity<PharmacyDepot>, IDataBaseIntity
    {
        public string ProcedureName { get; set; }
        public int Id { get; set; }
        public int PharmacyId { get; set; }
        public Pharmacy Pharmacy { get; set; }
        public string Name { get; set; }
        public string Address { get; set; } 
        public bool NotEmpty { get; set; }

        public PharmacyDepot()
        {
            this.ProcedureName = "PharmacyDepotCrud";
        }
        public PharmacyDepot(int id)
        {
            this.ProcedureName = "PharmacyDepotCrud";
            base.Read(id);
        }

        public void FillObjFromDr(DataRow row)
        {
            this.NotEmpty = true;
            this.Id = row["PharmacyDepotId"].CustomValueNn<int>();
            this.PharmacyId = row["PharmacyId"].CustomValueNn<int>();
            this.Pharmacy = new Pharmacy(row["PharmacyId"].CustomValueNn<int>());
            this.Name = row["Name"].CustomValue();
            this.Address = row["Address"].CustomValue(); 
        }
    }
}
