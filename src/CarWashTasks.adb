with Ada.Text_IO, CarTask, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, CarTask;

package body CarWashTasks is


   task body CarWashTask  is

      Stands: array (1..StandsNumber) of aliased Stand;

      MaxQueue : Integer := 3; -- maksymalna dopuszczalna kolejka
      LowestQueue : Integer:= MaxQueue+1; -- najlepsza kolejka(najkrotsza)

      Index : Integer:=0;
      NotWashedCars : Integer:=0;

   begin

      loop

         select

            accept ChooseStand (Decision : in out Boolean; ChoosenStand : out StandPtr; StandId : in out Integer) do

               for i in Integer range 1..StandsNumber loop

                  if(Stands(i).Queue < LowestQueue) then
                     LowestQueue := Stands(i).Queue;
                     Index := i;
                  end if;

               end loop;

               if(LowestQueue >= MaxQueue) then
                  NotWashedCars := NotWashedCars+1;
                  Decision := False;
               else
                  Decision := True;
                  StandId := Index;
                  Stands(Index).Queue := Stands(Index).Queue + 1;
                  Put_Line("");
                  Put_Line("Stanowisko" & Index'Img & ": nowe auto - miejsce w kolejce:" & Stands(Index).Queue'Img);
                  ChoosenStand := Stands(Index)'Unrestricted_Access;
               end if;

               LowestQueue := 10;

            end ChooseStand;

         or
            accept stop;
            Put_Line("");
            Put_Line("Podsumowanie:");
            Put_Line("Nieumyte auta z powodu zbyt duzej kolejki: " & NotWashedCars'Img );

            for i in Integer range 1..StandsNumber loop
                Put_Line("Stanowisko: " & i'Img & " - liczba umytych samochodow:" & Stands(i).WashedCars'Img);
               Stands(i).Wash.Stop;
            end loop;

            Put_Line("");
            exit;

         end select;
      end loop;

   end CarWashTask;


   task body Washing is

      Id : Integer := 1;
      WashedCars : Integer := 0;

      -- losowy tryb mycia - 3/4/5 s
      type ModeRange is range 3..5;
      package RandomMode is new Ada.Numerics.Discrete_Random(Result_Subtype =>ModeRange);
      use RandomMode;
      ModeGenerator : Generator;
      WashMode : ModeRange;

   begin

      loop
         select

            accept Wash(StandId: Integer; Queue : in out Integer; Washed : in out Integer) do
               Reset(ModeGenerator);
               WashMode := Random(ModeGenerator);

               Put_Line("");
               Put_Line("Stanowisko"& StandId'Img & " - myty samochod nr:" & Id'Img & " - tryb:" & WashMode'Img);
               delay Duration(WashMode);
               Queue := Queue - 1;
               WashedCars := WashedCars + 1;
               Id := Id + 1;
               Put_Line("");
               Put_Line("Stanowisko"& StandId'Img & " - liczba umytych samochodow:" & WashedCars'Img);
               Washed := WashedCars;
            end Wash;
         or

            accept Stop;
            exit;

         end select;
      end loop;

   end Washing;

end CarWashTasks;
