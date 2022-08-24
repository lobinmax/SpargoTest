using System;
using System.Linq;
using System.Windows.Forms;

namespace SpargoTest
{
    internal class Program
    {
        private static void Main()
        {
            Console.WriteLine("Hello! This app for pharmacy \n");

            ShowMainManu();

            Console.Read();
        }

        private static void ShowMainManu()
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Выберите пункт меню: ");
            Console.ForegroundColor = ConsoleColor.White;

            Console.WriteLine("1. Список товарных наименований");
            Console.WriteLine("2. Список аптек");
            Console.WriteLine("3. Список складов");
            Console.WriteLine("4. Список партий");
            Console.WriteLine("5. Cписок товаров в аптеке");

            Console.Write("Ваша коменда: ");
            var choosedItemStr = Selector(Console.ReadLine(), "Выберите пункт меню: ", new []{ "1", "2", "3", "4", "5"});

            switch (choosedItemStr)
            {
                case "1":
                    ShowAllPharmProducts(ShowMainManu);
                    break;
                case "2":
                    ShowAllPharmacy(ShowMainManu);
                    break;
                case "3":
                    ShowAllPharmacyDepot(ShowMainManu);
                    break;
                case "4":
                    ShowAllPackageProduct(ShowMainManu);
                    break;
                case "5":
                    PharmProductsInPharmacy(ShowMainManu);
                    break;
                default:
                    ConsoleShowError($"Неизвестная команда '{choosedItemStr}'! Повторите попытку.");
                    break;
            }
        }

        private static string Selector(string choosedItemStr, string ifError, string[] allowCommand)
        {
            while (true)
            {
                if (allowCommand.Contains(choosedItemStr))
                {
                    Console.WriteLine("");
                    return choosedItemStr;
                }

                ConsoleShowError($"Команда '{choosedItemStr}' не расспознана как допустимая! Повторите попытку.");
                Console.Write(ifError);
                choosedItemStr = Console.ReadLine();
            }
        }

        #region Препараты
        private static void ShowAllPharmProducts(Action backAction)
        {
            var productsList = new PharmProduct().Read();

            if (productsList.Any())
            {
                productsList.ForEach(x => Console.WriteLine($"{x.Id.CustomValue()?.PadRight(2)}|{x.Name?.PadRight(50)}"));
            }
            else
            {
                Console.WriteLine("Список препаратов пуст");
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Для добавления нового препарата введите '+'");
            Console.WriteLine("Для удаления препарата введите '-'");
            Console.WriteLine("Для возврата в предыдущий уровень меню введите '-1'");
            Console.ForegroundColor = ConsoleColor.White;
            Console.Write("Ваша коменда: ");

            var command = Selector(Console.ReadLine(), "Повторите вашу команду: ", new []{ "+", "-", "-1" });

            switch (command)
            {
                case "+": 
                    AddNewPharmProduct(() => { ShowAllPharmProducts(ShowMainManu); });
                    break;
                case "-":
                    DeletePharmProduct(() => { ShowAllPharmProducts(ShowMainManu); });
                    break;
                case "-1":
                    backAction.Invoke();
                    break;
                default:
                    ConsoleShowError($"Неизвестная команда '{command}'! Повторите попытку.");
                    break;
            }
        }
        private static void AddNewPharmProduct(Action backAction)
        {
            var newPharmProduct = new PharmProduct();
            Console.Write("Введите наименование препарата: ");
            newPharmProduct.Name = Console.ReadLine();

            newPharmProduct.Create(
                new object []
                { 
                    "@Name", newPharmProduct.Name,
                    "@Function", 1
                });

            if (MessageBox.Show($"Хотите добавить следующий пропарат?", "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                Console.WriteLine();
                AddNewPharmProduct(backAction);
            }
            backAction.Invoke();
        }
        private static void DeletePharmProduct(Action backAction)
        {
            Console.Write("Введите идентификатор препарата: ");
            var pharmProductDel = Console.ReadLine().CustomValue<int>();
            if (!pharmProductDel.HasValue)
            {
                ConsoleShowError($"Идентификатор не распознан");
                backAction.Invoke();
            }
            var pharmProduct =  new PharmProduct(pharmProductDel.Value); 
            if (!pharmProduct.NotEmpty)
            {
                ConsoleShowError($"Препарат с идентификатором '{pharmProductDel}' не найден");
                backAction.Invoke();
            }

            pharmProduct.Delete();
            backAction.Invoke();
        }
        #endregion

        #region Аптеки
        private static void ShowAllPharmacy(Action backAction)
        {
            var pharmacyList = new Pharmacy().Read();

            if (pharmacyList.Any())
            {
                pharmacyList.ForEach(x => Console.WriteLine(
                    $"{x.Id.CustomValue()?.PadRight(2)}|{x.Name?.PadRight(30)}|{x.Address?.PadRight(60)}|{x.PhoneNumber?.PadRight(20)}"));
            }
            else
            {
                Console.WriteLine("Список аптек пуст");
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Для добавления новой аптеки введите '+'");
            Console.WriteLine("Для удаления аптеки введите '-'");
            Console.WriteLine("Для возврата в предыдущий уровень меню введите '-1'");
            Console.ForegroundColor = ConsoleColor.White;
            Console.Write("Ваша коменда: ");

            var command = Selector(Console.ReadLine(), "Повторите вашу команду: ", new[] { "+", "-", "-1" });

            switch (command)
            {
                case "+":  
                    AddNewPharmacy(() => { ShowAllPharmacy(ShowMainManu); });
                    break;
                case "-":
                    DeletePharmacy(() => { ShowAllPharmacy(ShowMainManu); });
                    break;
                case "-1":
                    backAction.Invoke();
                    break;
                default:
                    ConsoleShowError($"Неизвестная команда '{command}'! Повторите попытку.");
                    break;
            }
        }
        private static void AddNewPharmacy(Action backAction)
        {
            var newPharmacy = new Pharmacy();
            Console.Write("Введите наименование аптеки: ");
            newPharmacy.Name = Console.ReadLine();
            Console.Write("Введите адрес аптеки: ");
            newPharmacy.Address = Console.ReadLine();
            Console.Write("Введите телефон аптеки: ");
            newPharmacy.PhoneNumber = Console.ReadLine();

            newPharmacy.Create(
                new object[]
                {
                    "@Name", newPharmacy.Name,
                    "@Address", newPharmacy.Address,
                    "@PhoneNumber", newPharmacy.PhoneNumber,
                    "@Function", 1
                });

            if (MessageBox.Show($"Хотите добавить следующую аптеку?", "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                Console.WriteLine();
                AddNewPharmacy(backAction);
            }
            backAction.Invoke();
        }
        private static void DeletePharmacy(Action backAction)
        {
            Console.Write("Введите идентификатор аптеки: ");
            var pharmacyDel = Console.ReadLine().CustomValue<int>();
            if (!pharmacyDel.HasValue)
            {
                ConsoleShowError($"Идентификатор не распознан");
                backAction.Invoke();
            }
            var pharmacy = new Pharmacy(pharmacyDel.Value);
            if (!pharmacy.NotEmpty)
            {
                ConsoleShowError($"Аптека с идентификатором '{pharmacy}' не найдена");
                backAction.Invoke();
            }

            pharmacy.Delete();
            backAction.Invoke();
        }
        #endregion

        #region Склады
        private static void ShowAllPharmacyDepot(Action backAction)
        {
            var pharmacyDepotList = new PharmacyDepot().Read();

            if (pharmacyDepotList.Any())
            {
                pharmacyDepotList.ForEach(x => Console.WriteLine(
                    $"{x.Id.CustomValue()?.PadRight(2)}|{x.Name?.PadRight(30)}|Ап.{x.Pharmacy.Name?.PadRight(30)}|{x.Address?.PadRight(50)}"));
            }
            else
            {
                Console.WriteLine("Список складов пуст");
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Для добавления нового склада введите '+'");
            Console.WriteLine("Для удаления склада введите '-'");
            Console.WriteLine("Для возврата в предыдущий уровень меню введите '-1'");
            Console.ForegroundColor = ConsoleColor.White;
            Console.Write("Ваша коменда: ");

            var command = Selector(Console.ReadLine(), "Повторите вашу команду: ", new[] { "+", "-", "-1" });

            switch (command)
            {
                case "+": 
                    AddNewPharmacyDepot(() => { ShowAllPharmacyDepot(ShowMainManu); });
                    break;
                case "-":
                    DeletePharmacyDepot(() => { ShowAllPharmacyDepot(ShowMainManu); });
                    break;
                case "-1":
                    backAction.Invoke();
                    break;
                default:
                    ConsoleShowError($"Неизвестная команда '{command}'! Повторите попытку.");
                    break;
            }
        }
        private static void AddNewPharmacyDepot(Action backAction)
        {
            var newPharmacyDepot = new PharmacyDepot();
            Console.Write("Введите наименование склада: ");
            newPharmacyDepot.Name = Console.ReadLine();
            Console.Write("Введите идентификатор аптеки: ");
            newPharmacyDepot.PharmacyId = Console.ReadLine().CustomValueNn<int>();
            Console.Write("Введите адрес склада: ");
            newPharmacyDepot.Address = Console.ReadLine();

            newPharmacyDepot.Create(
                new object[]
                {
                    "@Name", newPharmacyDepot.Name,
                    "@PharmacyId", newPharmacyDepot.PharmacyId,
                    "@Address", newPharmacyDepot.Address,
                    "@Function", 1
                });

            if (MessageBox.Show($"Хотите добавить следующий склад?", "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                Console.WriteLine();
                AddNewPharmacyDepot(backAction);
            }
            backAction.Invoke();
        }
        private static void DeletePharmacyDepot(Action backAction)
        {
            Console.Write("Введите идентификатор склада: ");
            var pharmacyDepotDel = Console.ReadLine().CustomValue<int>();
            if (!pharmacyDepotDel.HasValue)
            {
                ConsoleShowError($"Идентификатор не распознан");
                backAction.Invoke();
            }
            var pharmacyDepot = new PharmacyDepot(pharmacyDepotDel.Value);
            if (!pharmacyDepot.NotEmpty)
            {
                ConsoleShowError($"Склад с идентификатором '{pharmacyDepot}' не найден");
                backAction.Invoke();
            }

            pharmacyDepot.Delete();
            backAction.Invoke();
        }
        #endregion

        #region Партии
        private static void ShowAllPackageProduct(Action backAction)
        {
            var packageProductList = new PackageProduct().Read();

            if (packageProductList.Any())
            {
                packageProductList.ForEach(x => Console.WriteLine(
                    $"{x.Id.CustomValue()?.PadRight(2)}|Скл.{x.PharmacyDepot?.Name?.PadRight(30)}|прп.{x.PharmProduct?.Name?.PadRight(30)}|{x.Count.CustomValue()?.PadRight(50)}"));
            }
            else
            {
                Console.WriteLine("Список партий пуст");
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("Для добавления новой партии введите '+'");
            Console.WriteLine("Для удаления партии введите '-'");
            Console.WriteLine("Для возврата в предыдущий уровень меню введите '-1'");
            Console.ForegroundColor = ConsoleColor.White;
            Console.Write("Ваша коменда: ");

            var command = Selector(Console.ReadLine(), "Повторите вашу команду: ", new[] { "+", "-", "-1" });

            switch (command)
            {
                case "+":
                    AddNewPackageProduct(() => { ShowAllPackageProduct(ShowMainManu); });
                    break;
                case "-":
                    DeletePackageProduct(() => { ShowAllPackageProduct(ShowMainManu); });
                    break;
                case "-1":
                    backAction.Invoke();
                    break;
                default:
                    ConsoleShowError($"Неизвестная команда '{command}'! Повторите попытку.");
                    break;
            }
        }
        private static void AddNewPackageProduct(Action backAction)
        {
            var newPackageProduct = new PackageProduct();
            Console.Write("Введите идентификатор препарата: ");
            newPackageProduct.PharmProductId = Console.ReadLine().CustomValueNn<int>();
            Console.Write("Введите идентификатор склада: ");
            newPackageProduct.PharmacyDepotId = Console.ReadLine().CustomValueNn<int>();
            Console.Write("Введите адрес склада: ");
            newPackageProduct.Count = Console.ReadLine().CustomValueNn<int>();
            Console.Write("Введите количество в партии: ");

            newPackageProduct.Create(
                new object[]
                {
                    "@PharmProductId", newPackageProduct.PharmProductId,
                    "@PharmacyDepotId", newPackageProduct.PharmacyDepotId,
                    "@Count", newPackageProduct.Count,
                    "@Function", 1
                });

            if (MessageBox.Show($"Хотите добавить следующую партию?", "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                Console.WriteLine();
                AddNewPackageProduct(backAction);
            }
            backAction.Invoke();
        }
        private static void DeletePackageProduct(Action backAction)
        {
            Console.Write("Введите идентификатор партии: ");
            var pharmacyDepotDel = Console.ReadLine().CustomValue<int>();
            if (!pharmacyDepotDel.HasValue)
            {
                ConsoleShowError($"Идентификатор не распознан");
                backAction.Invoke();
            }
            var pharmacyDepot = new PharmacyDepot(pharmacyDepotDel.Value);
            if (!pharmacyDepot.NotEmpty)
            {
                ConsoleShowError($"Партия с идентификатором '{pharmacyDepot}' не найден");
                backAction.Invoke();
            }

            pharmacyDepot.Delete();
            backAction.Invoke();
        }
        #endregion

        private static void PharmProductsInPharmacy(Action backAction)
        {
            Console.Write("Для вывода товаров введите идентификатор аптеки: ");
            var pharmacyId = Console.ReadLine().CustomValue<int>();
            if (!pharmacyId.HasValue)
            {
                ConsoleShowError("Идентификатор не распознан. Повторите ввод");
                PharmProductsInPharmacy(backAction);
                return;
            }

            var pharmacy = new Pharmacy(pharmacyId.Value);
            if (!pharmacy.NotEmpty)
            {
                ConsoleShowError($"Аптека с идентификатором '{pharmacy}' не найдена");
                PharmProductsInPharmacy(backAction);
                return;
            }

            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.WriteLine($"Список препаратов в аптеке '{pharmacy.Name}'");
            Console.ForegroundColor = ConsoleColor.White;

            var dt = SqlHelper.GetConnect().ExecuteSpDt(
                procedureName: "dbo.PharmProductsInPharmacy",
                new object[] {"@PharmacyId", pharmacy.Id});
            if (!dt.RowsEnumerable().Any())
            {
                Console.WriteLine("Список пуст");
                backAction.Invoke();
            }

            foreach (var row in dt.RowsEnumerable())
            {
                Console.WriteLine($"{row["PharmacyName"].CustomValue().PadRight(30)}|{row["Count"].CustomValue()}"); 
            }

            Console.WriteLine();
            Console.Write("Для продолжения нажмите <Enter> ... ");
            while (Console.ReadKey().Key != ConsoleKey.Enter) { }

            backAction.Invoke();
        }

        private static void ConsoleShowError(string textError, bool isWriteLine = true)
        {
            Console.ForegroundColor = ConsoleColor.DarkRed;
            if (isWriteLine)
            {
                Console.WriteLine(textError);
            }
            else
            {
                Console.Write(textError);
            }
            Console.ForegroundColor = ConsoleColor.White;
        }
    }
}
