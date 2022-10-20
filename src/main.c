#include <stdint.h>
#include "peripherals.h"

RCC_t       * const RCC     = (RCC_t    *)0x40023800;
GPIOx_t     * const GPIOA   = (GPIOx_t  *)0x40020000;
TIMx_t      * const TIM2    = (TIMx_t   *)0x40000000;
EXTI_t      * const EXTI    = (EXTI_t   *)0x40013C00;
NVIC_t      * const NVIC    = (NVIC_t   *)0xE000E100;

void wait_ms(int time){
    for(int i = 0;i < time; i++){
        for(int j = 0; j < 1600; j++);
    }
}
int main(void){

    RCC->RCC_AHB1ENR |= 1;
    GPIOA->GPIOx_MODER &= ~(3 << (5 * 2));
    GPIOA->GPIOx_MODER |=  (1 << (5 * 2));


    for(;;);

}

