using System;
using System.Collections.Generic;
using System.Text;

namespace SpargoTest
{
    public interface IDataBaseIntit<T>
    {
        void Create(T newRecord);
        void Read();
        void Update();
        void Delete();
    }
}
