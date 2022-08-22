using System;
using System.Windows.Forms;

namespace SpargoTest
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            Console.WriteLine("Hello! This app for farmacy");
            ShowMainManu();

            Console.Read();
        }

        private static void ShowMainManu()
        {
            Console.WriteLine("1. Список товарных наименований");
            Console.WriteLine("2. Список аптек");
            Console.WriteLine("3. Список складов");
            Console.WriteLine("4. Список партий");
            Console.WriteLine("5. Cписок товаров");
            Console.ForegroundColor = ConsoleColor.Green;
            Console.Write("Выберите пункт меню: ");

            var choosedItemStr = Selector(Console.ReadLine(), "Выберите пункт меню: ");
            Console.ForegroundColor = ConsoleColor.White;

            switch (choosedItemStr)
            {
                case 1:

                    break;
                case 2:

                    break;
                case 3:

                    break;
                case 4:

                    break;
                case 5:

                    break;
                default:
                    MessageBox.Show($"Неизвестная команда '{choosedItemStr}'! Повторите попытку.");
                    break;
            }
        }

        private static int Selector(string choosedItemStr, string ifError)
        {
            while (true)
            {
                if (int.TryParse(choosedItemStr, out var choosedItemNum))
                {
                    return choosedItemNum;
                }

                MessageBox.Show($"Команда '{choosedItemStr}' не расспознана! Повторите попытку.");
                Console.Write(ifError);
                choosedItemStr = Console.ReadLine();
            }
        }
    }
}
