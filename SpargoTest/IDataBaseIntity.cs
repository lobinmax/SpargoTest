using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Windows.Forms;

namespace SpargoTest
{
    public interface IDataBaseIntity
    {
        string ProcedureName { get; set; }
        int Id { get; set; }
        bool NotEmpty { get; set; }
        void FillObjFromDr(DataRow row);
    }

    public abstract class DataBaseIntity<T> where T: IDataBaseIntity
    {
        public virtual void Create(object[] @params)
        {
            SqlHelper.GetConnect().ExecuteSpDt(
                procedureName: ((IDataBaseIntity)this).ProcedureName, parameters: @params);
        }

        public virtual List<T> Read()
        {
            var dt = SqlHelper.GetConnect().ExecuteSpDt(procedureName: ((IDataBaseIntity)this).ProcedureName);

            var entityList = new List<T>();
            foreach (var dataRow in dt.RowsEnumerable())
            {
                var entityInstance = (T) Activator.CreateInstance(typeof(T));
                entityInstance?.FillObjFromDr(dataRow);
                entityList.Add(entityInstance);
            }

            return entityList;
        }

        public virtual void Read(int id)
        {
            var dt = SqlHelper.GetConnect().ExecuteSpDt(
                procedureName: ((IDataBaseIntity)this).ProcedureName, "@EntityId", id);

            if (!dt.RowsEnumerable().Any()) { return; }

            ((IDataBaseIntity) this).FillObjFromDr(dt.RowsEnumerable().Single());
            ((IDataBaseIntity) this).NotEmpty = true;
        }

        public virtual void Delete()
        {
            if (MessageBox.Show($"Запись будет удалена! Вы согласны?", "", MessageBoxButtons.YesNo) != DialogResult.Yes)
            {
                return;
            }

            SqlHelper.GetConnect().ExecuteSpDt(
                procedureName: ((IDataBaseIntity)this).ProcedureName, 
                "@EntityId", ((IDataBaseIntity)this).Id, 
                "@Function", 2);
        } 
    }
}
