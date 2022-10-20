CC = arm-none-eabi-gcc

SRC_DIR = src
INC_DIR = inc
OBJ_DIR = obj
DEB_DIR = debug
SUP_DIR = startup

SRC := $(wildcard $(SRC_DIR)/*.c)
SRC += $(wildcard $(SUP_DIR)/*.c)
OBJ := $(patsubst $(SRC_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(SRC))
OBJ := $(patsubst $(SUP_DIR)/%.c, $(SRC_DIR)/$(OBJ_DIR)/%.o, $(OBJ))
LD := $(wildcard $(SUP_DIR)/*.ld)

DEB_INTERFACE = /usr/share/openocd/scripts/interface/stlink-v2.cfg
DEB_TARGET = /usr/share/openocd/scripts/target/stm32f4x.cfg

MARCH = cortex-m4
CFLAGS = -g -Wall -Wextra -mcpu=$(MARCH) -mthumb -O0 -I./$(INC_DIR)
LFLAGS = -nostdlib -T $(LD) -Wl,-Map=$(SUP_DIR)/main.map

TARGET = $(DEB_DIR)/main.elf

all:

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c | mkobj
	$(CC) $(CFLAGS) -c -o $@ $^

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SUP_DIR)/%.c | mkobj
	$(CC) $(CFLAGS) -c -o $@ $^

$(TARGET) : $(OBJ) | mkdir
	$(CC) $(LFLAGS) -o $@ $^

mkobj:
	mkdir -p $(SRC_DIR)/$(OBJ_DIR)

mkdeb:
	mkdir -p $(DEB_DIR)

flash: FORCE
	openocd -f  $(DEB_INTERFACE) -f $(DEB_TARGET) &
	gdb-multiarch $(TARGET) -x $(DEB_DIR)/flash.gdb
	pkill openocd

debug: FORCE
	openocd -f  $(DEB_INTERFACE) -f $(DEB_TARGET) &
	gdb-multiarch $(TARGET) -x $(DEB_DIR)/debug.gdb

clean: FORCE
	rm -rf $(SRC_DIR)/$(OBJ_DIR) $(DEB_DIR)

FORCE: 

.PHONY = FORCE clean mkobj mkdeb flash

