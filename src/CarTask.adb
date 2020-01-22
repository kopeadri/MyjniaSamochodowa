with Ada.Text_IO, Ada.Numerics.Discrete_Random, CarWashTasks, Ada.Real_Time;
use Ada.Text_IO, CarWashTasks, Ada.Real_Time;

package body CarTask is

   task body Car is

      -- losowy czas przybycia na myjnie
      type ArrivalTimeRange is range 0..50;
      package RandomTime is new Ada.Numerics.Discrete_Random(ArrivalTimeRange);
      use RandomTime;
      TimeGenerator: Generator;
      ArrivalTime : ArrivalTimeRange;

      type CarWashPtr is access all CarWashTask;
      CWPtr : CarWashPtr;

      -- wybor stanowiska
      Decision : Boolean := True; -- decyzja czy auto bedzie myte
      ChoosenStand : StandPtr;
      StandId : Integer := 0;

   begin

      accept Start(CW: aliased  in out CarWashTask) do
         CWPtr :=  CW'Access;
      end Start;

      Reset(TimeGenerator);
      ArrivalTime := Random(TimeGenerator);

      delay Duration(ArrivalTime);

      CWPtr.ChooseStand(Decision,ChoosenStand,StandId);

      if Decision then
         ChoosenStand.Wash.Wash(StandId,ChoosenStand.Queue, ChoosenStand.WashedCars);
      else
         Put_Line("");
         Put_Line("!!! Kolejka zbyt dluga, samochod odjechal !!!");
      end if;

      loop
         select

            accept stop;
            exit;

         end select;
      end loop;

   end Car;

end CarTask;
