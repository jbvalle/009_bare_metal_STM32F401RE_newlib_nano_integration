target extended-remote localhost:3333
monitor reset init
monitor flash write_image erase debug/main.elf
monitor arm semihosting enable
monitor reset
