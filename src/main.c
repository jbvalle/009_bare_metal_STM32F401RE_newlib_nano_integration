#include <stdint.h>
#include "peripherals.h"

RCC_t * const RCC = (RCC_t *)0x40023800;
GPIOx_t * const GPIOA = (GPIOx_t *)0x40020000;
TIMx_t * const TIM2 = (TIMx_t *)0x40000000;
EXTI_t * const EXTI = (EXTI_t *)0x40013C00;
NVIC_t * const NVIC = (NVIC_t *)0xE000E100;

int main(void){


    for(;;);
}

