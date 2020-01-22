package CarWashTasks is

   task type Washing is
    entry Wash(StandId: Integer; Queue : in out Integer; Washed : in out Integer); --proces mycia auta
    entry Stop;
   end;
   type WashPtr is access all Washing;

   type Stand is
      record
         Wash: aliased Washing; --proces mycia auta
         Queue : Integer := 0; --kolejka do stanowiska
         WashedCars : Integer := 0; --liczba umtytych aut
      end record;
   type StandPtr is access all Stand;

   task type CarWashTask(StandsNumber : Integer) is
      entry ChooseStand(Decision : in out Boolean; ChoosenStand : out StandPtr; StandId : in out Integer); --wybor stanowiska
      entry Stop;
   end CarWashTask;

end CarWashTasks;
