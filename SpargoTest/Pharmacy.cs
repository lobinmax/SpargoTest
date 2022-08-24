using System.Data;

namespace SpargoTest
{
    public class Pharmacy: DataBaseIntity<Pharmacy>, IDataBaseIntity
    {
        public string ProcedureName { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public bool NotEmpty { get; set; }
        public Pharmacy()
        {
            this.ProcedureName = "PharmacyCrud";
        }
        public Pharmacy(int id)
        {
            this.ProcedureName = "PharmacyCrud";
            base.Read(id);
        }

        public void FillObjFromDr(DataRow row)
        {
            this.NotEmpty = true;
            this.Id = row["PharmacyId"].CustomValueNn<int>();
            this.Name = row["Name"].CustomValue();
            this.Address = row["Address"].CustomValue();
            this.PhoneNumber = row["PhoneNumber"].CustomValue();
        }
    }
}
