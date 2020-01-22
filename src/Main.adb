
with Ada.Text_IO, Ada.Integer_Text_IO, Ada.IO_Exceptions, CarTask, CarWashTasks;
use Ada.Text_IO, CarTask, CarWashTasks;

procedure Main is

   Zn: Character := ' ';

   StandsNumber: Integer; --liczba stanowisk
   CarsNumber :  Integer; --liczba aut

   type Cars is array(Integer range <>) of Car;
   type Data is array(1..2) of Integer;
   UserData : Data;

   -- Wyswietlenie menu
   procedure Menu is
   begin
      New_Line;
      Put_Line("Menu:");
      Put_Line(" 1 - Symulacja z domyslnymi parametrami");
      Put_Line(" 2 - Ustawienie parametrow i symulacja");
      Put_Line(" 3 - Wyjscie");
      New_Line;
   end Menu;

   -- Pobieranie danych od uzytkownika
   function GetDataFromUser return Data is
      Numbers : Data := (others => 0);
      Valid : Boolean := False;
   begin
      while Valid = False loop
         begin
            Put_Line("");
            Put_Line("Podaj liczbe stanowisk(1-10):");
            Ada.Integer_Text_IO.Get(Numbers(1));
            if Numbers(1) < 1 or Numbers(1) > 10 then
               Put_Line("Liczba nie miesci sie w zakresie!");
            else
               Valid := True;
            end if;
         exception
            when Data_Error => Put_Line("Bledna wartosc!");
               Valid := False;
         end;
      end loop;

      loop
         begin
            Put_Line("");
            Put_Line("Podaj liczbe samochodow(1-100):");
            Ada.Integer_Text_IO.Get(Numbers(2));
            if Numbers(2) < 1 or Numbers(2) > 100 then
               Put_Line("Liczba nie miesci sie w zakresie!");
            else
               return Numbers;
            end if;
         exception
            when Data_Error => Put_Line("Bledna wartosc!");
         end;
      end loop;
   end GetDataFromUser;


   procedure Simulation is
      CarWash : aliased CarWashTask(StandsNumber);
      Cars : array (1..CarsNumber) of Car;
   begin
      Put_Line("");
      Put_Line("Symulacja rozpoczeta");

      --rozpoczecie zadan
      for i in Integer range 1..carsNumber loop
         Cars(i).start(CarWash);
      end loop;

      -- czas symulacji
      for i in Integer range 1..60 loop
         delay(1.0);
      end loop;

      --zatrzymanie zadan
      for i in Integer range 1..carsNumber loop
         Cars(i).stop;
      end loop;

      CarWash.stop;

   end Simulation;

begin

   loop
      Menu;
      Zn := ' ';
      Get(Zn);
      exit when Zn = '3';

      case Zn is
         when '1' =>
            StandsNumber := 2;
            CarsNumber := 20;
            Simulation;
         when '2' =>
            UserData := GetDataFromUser;
            StandsNumber := UserData(1);
            CarsNumber := UserData(2);
            Simulation;
         when others => Put_Line("Blad!!");
      end case;
   end loop;

end Main;
