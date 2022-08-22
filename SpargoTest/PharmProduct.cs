using System;
using System.Collections.Generic;
using System.Text;

namespace SpargoTest
{
    public class PharmProduct
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string FormRelease { get; set; }
        public string Dosage { get; set; }
        public string DosageUnit { get; set; }
        public int Count { get; set; }

    }
}
