#include "stdio.h"
#include "system.h"
#include "unistd.h"
#define continu (volatile unsigned int*)AVALON_COMPOSANT_0_BASE
#define data (volatile unsigned int*)(AVALON_COMPOSANT_0_BASE + 4)

void get_anemo(){
		*continu = 0x3 ;
		int anemo_data = *data ;
		printf("%d \n", anemo_data & 0xFF) ;
		usleep(100000) ;
}
