#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <alchemy/task.h>

RT_TASK hello_task;

// function to be executed by task
void helloWorld(void *arg)
{
  	
  RTIME period  = 1000000000;
  rt_task_set_periodic(NULL,TM_NOW,period);
  while(1){
	RTIME now = rt_timer_read();
	printf("Hello World che bella giornata!\n");
	printf("%lld\n-----------------\n",now);
	rt_task_wait_period(NULL);
  }
  return;
}

int main(int argc, char* argv[])
{
  char  str[10] ;
  printf("start task\n");
  sprintf(str,"hello");
  
  /* Create task
   * Arguments: &task,
   *            name,
   *            stack size (0=default),
   *            priority,
   *            mode (FPU, start suspended, ...)
   */  
  rt_task_create(&hello_task, str, 0, 50, 0);

  /*  Start task
   * Arguments: &task,
   *            task function,
   *            function argument
   */
  rt_task_start(&hello_task, &helloWorld, 0);
  pause();
}
