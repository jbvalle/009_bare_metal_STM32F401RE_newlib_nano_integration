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
CFLAGS = -g3 -Wall -mfloat-abi=soft -mcpu=$(MARCH) -mthumb -O0 -I./$(INC_DIR) 
LFLAGS = --specs=rdimon.specs -T $(LD) -Wl,-Map=$(DEB_DIR)/main.map

TARGET = $(DEB_DIR)/main.elf

all: $(OBJ) $(TARGET)

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c | mkobj
	$(CC) $(CFLAGS) -c -o $@ $^

$(SRC_DIR)/$(OBJ_DIR)/%.o : $(SUP_DIR)/%.c | mkobj
	$(CC) $(CFLAGS) -c -o $@ $^

$(TARGET) : $(OBJ) | mkdeb
	$(CC) $(CFLAGS) $(LFLAGS) -o $@ $^

mkobj:
	mkdir -p $(SRC_DIR)/$(OBJ_DIR)

mkdeb:
	mkdir -p $(DEB_DIR)

flash: FORCE
	openocd -f  $(DEB_INTERFACE) -f $(DEB_TARGET) &
	gdb-multiarch $(TARGET) -x $(SUP_DIR)/flash.gdb
	pkill openocd

debug: FORCE
	openocd -f  $(DEB_INTERFACE) -f $(DEB_TARGET) &
	gdb-multiarch $(TARGET) -x $(SUP_DIR)/debug.gdb

semi_host: FORCE
	openocd -f  $(DEB_INTERFACE) -f $(DEB_TARGET) 

semi_client: FORCE
	gdb-multiarch $(TARGET) -x $(SUP_DIR)/semi.gdb

clean: FORCE
	rm -rf $(SRC_DIR)/$(OBJ_DIR) $(DEB_DIR)

edit: FORCE
	vim -S Session.vim


FORCE: 

.PHONY = FORCE clean mkobj mkdeb flash

