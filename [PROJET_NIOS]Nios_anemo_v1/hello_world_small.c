#include "sys/alt_stdio.h"
#include "anemometre.h"
#include "stdio.h"
#include <unistd.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

int main()
{ 
  alt_putstr("Hello from Nios II!\n");

  /* Event loop never exits. */
  while (1){

	  get_anemo() ;
	  usleep(100) ;
  }

  return 0;
}
