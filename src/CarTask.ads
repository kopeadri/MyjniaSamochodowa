with CarWashTasks;
use CarWashTasks;

package CarTask is

  task type Car is
    entry Start(CW : aliased in out CarWashTask);
    entry Stop;
  end;

end CarTask;
