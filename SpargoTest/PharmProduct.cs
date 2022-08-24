using System.Data;

namespace SpargoTest
{
    public class PharmProduct: DataBaseIntity<PharmProduct>, IDataBaseIntity
    {
        public string ProcedureName { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public bool NotEmpty { get; set; }

        public PharmProduct()
        {
            this.ProcedureName = "PharmProductCrud";
        }
        public PharmProduct(int id)
        {
            this.ProcedureName = "PharmProductCrud";
            base.Read(id);
        }

        public void FillObjFromDr(DataRow row)
        {
            this.NotEmpty = true;
            this.Id = row["PharmProductId"].CustomValueNn<int>(); 
            this.Name = row["Name"].CustomValue();
        }
    }
}
