using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Windows.Forms;

namespace SpargoTest
{
    public static class SqlHelper
    {
        private const string ConnectionString =
            "Data Source = 192.168.0.101; Database = SpargoTest; Encrypt = False; Integrated Security = False; User ID = sa; Password = **********";

        public static SqlConnection GetConnect()
        { 
            var connection = new SqlConnection(ConnectionString);
            try
            {
                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }
                return connection;
            }
            catch (SqlException ex)
            {
                MessageBox.Show($"Ошибка при подключении к БД.{Environment.NewLine}{ex.Message}");
                throw;
            }
        }
    }

    public static class Extentions
    {
        public static DataTable ExecuteSpDt(this SqlConnection sqlConn, string procedureName, params object[] parameters)
        {
            var dt = new DataTable("Table0");
            try
            {
                var command = new SqlCommand()
                {
                    Connection = sqlConn,
                    CommandText = procedureName,
                    CommandType = CommandType.StoredProcedure
                };
                command.AddParametersInSqlCommand(parameters);

                var sqlDataAdapter = new SqlDataAdapter(command);
                sqlDataAdapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                throw ex;
            }
            return dt;
        }

        private static void AddParametersInSqlCommand(this SqlCommand sqlCommand, params object[] parameters)
        {
            if (parameters.Length == 0) return;
            if ((parameters.Length % 2) != 0)
            {
                throw new Exception($"Ошибка программиста. Нечетное количество параметров в хранимой процедуре.{Environment.NewLine}{sqlCommand.CommandText}");
            }

            for (var i = 0; i < parameters.Length; i += 2)
            {
                sqlCommand.Parameters.AddWithValue((string)parameters[i], parameters[i + 1]);
            }
        }

        public static IEnumerable<DataRow> RowsEnumerable(this DataTable dataTable)
        {
            return dataTable.Rows.Cast<DataRow>();
        }

        public static T? CustomValue<T>(this object editValue) where T : struct
        {
            if (editValue == null || editValue == DBNull.Value || editValue.ToString().IsNullOrEmptyOrWhiteSpace())
            {
                return null;
            }

            if (typeof(T) == typeof(int))
            {
                var vInt = int.Parse(editValue.ToString() ?? string.Empty);
                return vInt as T?;
            }

            return (T?) editValue;
        }

        public static T CustomValueNn<T>(this object editValue) where T : struct
        {
            return editValue?.CustomValue<T>() ?? throw new ArgumentNullException("");
        }

        public static string CustomValue(this object editValue)
        {
            if (editValue == null || editValue.ToString().IsNullOrEmptyOrWhiteSpace())
            {
                return null;
            }
            return editValue.ToString();
        }

        public static bool IsNullOrEmptyOrWhiteSpace(this string str) => string.IsNullOrEmpty(str.StrTrim());

        public static string StrTrim(this string str)
        {
            if (str == null || string.IsNullOrEmpty(str.Trim()) || string.IsNullOrWhiteSpace(str.Trim()))
            {
                return null;
            }
            return str.Trim();
        }
    }
}
