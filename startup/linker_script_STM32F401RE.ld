ENTRY(Reset_handler)

_estack = ORIGIN(SRAM) + LENGTH(SRAM);

MEMORY
{
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
}

SECTIONS
{
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    }> FLASH

    .text :
    {

        . = ALIGN(4);
        *(.text)
        *(.text.*)
        *(.eh_frame)
        *(.eh_frame*)
        *(.init)
        *(.fini)
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
    }> FLASH

    /*
    .ARM :
    {
        . = ALIGN(4);
        *(.ARM*)
        . = ALIGN(4);
    }> FLASH

    .debug :
    {
        . = ALIGN(4);
        *(.debug*)
        . = ALIGN(4);
    }> FLASH
    */

    . = ALIGN(4);
    _sidata = LOADADDR(.data);

    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data.*)
        *(.init_array)
        *(.fini_array)
        . = ALIGN(4);
        _edata = .;
    }> SRAM AT> FLASH

    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        /** Used for NewLib Syscalls.c **/
        __bss_start__ = _sbss;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
        /** Used for NewLib Syscalls.c **/
        __bss_end__ = _ebss;
        . = ALIGN(4);
        /** Used for NewLib Syscalls.c: brk() heap allocation **/
        __end__ = .;
        end = __end__;
    }> SRAM
}
