#include <stdint.h>
#include "peripherals.h"

#define TIM2_IRQn 28
#define NVIC_ISER_WIDTH 32


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

void TIM2_handler(void){
    // Reset Status Register
    TIM2->TIMx_SR = 0;
    // some action
    GPIOA->GPIOx_ODR ^= (1 << 5);
}

void global_enable_IRQ_NVIC(void){
    uint32_t priMASK = 0;
    __asm volatile("MSR primask, %0":: "r"(priMASK):"memory");
}

void global_disable_IRQ_NVIC(void){

    uint32_t priMASK = 1;
    __asm volatile("MSR primask, %0":: "r"(priMASK):"memory");
}

void _TIM2_IRQ_init(uint32_t period_ms){

    // Enable TIM2
    RCC->RCC_APB1ENR |= 1;
    global_disable_IRQ_NVIC();
    // Config Prescaler
    TIM2->TIMx_PSC = 16000 - 1;
    // Config Reload Value
    TIM2->TIMx_ARR = period_ms - 1;
    // Reset Current Val Register
    TIM2->TIMx_CNT = 0;
    // Fill Compare Value Register
    TIM2->TIMx_CCR1 = 0;
    // Configure CapComp Controller to throw an Interrupt 
    TIM2->TIMx_DIER |= (1 << 1);
    // Enable NVIC IRQ28
    NVIC->ISER[TIM2_IRQn / NVIC_ISER_WIDTH] |= (1 << (28 % NVIC_ISER_WIDTH));
    // Enable Global unmasking
    global_enable_IRQ_NVIC();
    // Start Counter
    TIM2->TIMx_CR1 |= 1;
}

int main(void){

    RCC->RCC_AHB1ENR |= 1;
    GPIOA->GPIOx_MODER &= ~(3 << (5 * 2));
    GPIOA->GPIOx_MODER |=  (1 << (5 * 2));

    _TIM2_IRQ_init(100);

    ////printf("Hello There\n");
    for(;;);
}

