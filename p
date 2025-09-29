#include "msp.h"
#include "stdbool.h"
#include "stdint.h"


#define RED        BIT0              // P1.0 (red LED)
#define BTN1       BIT1              // P1.1 (select LED)
#define BTN2       BIT4              // P1.4 (toggle selected LED)
#define RGB_MASK  (BIT0|BIT1|BIT2)   // P2.0..P2.2 (RGB channels)

#define DEBOUNCE_COUNT  30000      // coarse software delay

int main(void){
	
    // 1) Disable watchdog
    WDT_A->CTL = WDT_A_CTL_PW | WDT_A_CTL_HOLD;

    // 2) Buttons as inputs with pull-ups (active-low)
    P1->DIR &= ~(BTN1 | BTN2);
    P1->REN |=  (BTN1 | BTN2); 

    // 3) LEDs as outputs
    P1->DIR |= RED;
    P2->DIR |= RGB_MASK;

    // 4) All LEDs off
    P1->OUT &= ~RED;
   //P2->OUT &= ~RGB_MASK;
	  P2->OUT |= RGB_MASK;


    // selected LED index: 0=P1.0(red), 1=P2.0, 2=P2.1, 3=P2.2
    unsigned char selected = 0;
		
		bool b1_pressed = false;
		bool b2_pressed = false;
		
		bool red_sel = true;
		volatile unsigned int i;

    while(1){
			b1_pressed = false;
			b2_pressed = false;
				
			if ((P1->IN & BTN1) == 0){
				for (i = DEBOUNCE_COUNT; i > 0; i--){
				}
				if ((P1->IN & BTN1) == 0){
					b1_pressed = true;
				}
				
			if ((P1->IN & BTN2) == 0){
				for (i = DEBOUNCE_COUNT; i > 0; i--){
				}
				if ((P1->IN & BTN2) == 0){
					b2_pressed = true;
				}
				
				//change active output
			if (b1_pressed){
				red_sel = !(red_sel);
			}
			// toggle red
			else if (b2_pressed && red_sel){
				P1->OUT ^= RED;
			}
			//cycle rgb
			//if (b2_pressed && ! red_sel){
				//P1->OUT ^
			}
		}

	}
			
			
}
