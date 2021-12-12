# Target name
TARGET := blinky

# Microcontroller target. Replace with appropriate target name and clock speed
MCU := atmega328p
CLK := 16000000UL

# Define microcontroller, programmer, programmer port and baudrate for avrdude
PART := ATmega328p
PROGRAMMER := arduino
PORT := /dev/ttyACM0
BAUD := 115200

# Directories
SRC_DIR := src
INC_DIRS := $(shell find $(SRC_DIR) -type d)
BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj


# Compiler
CC := avr-gcc

# Include flags
IFLAGS := $(addprefix -I, $(INC_DIRS))

# Compiler flags
CFLAGS := $(IFLAGS) -mmcu=$(MCU) -DF_CPU=$(CLK) -Os -Wall

# Linker flags
LDFLAGS := -mmcu=$(MCU)

# Find all the C files to be compiled
SRC := $(shell find $(SRC_DIR) -name *.c)

# Define object targets
# String substitution for every C file
OBJ := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)


# Build hex file. Default rule
hex: $(BUILD_DIR)/$(TARGET).hex

# Convert binary into hexfile that can be flashed to the mcu
$(BUILD_DIR)/$(TARGET).hex: $(BUILD_DIR)/$(TARGET).elf
	@avr-objcopy -O ihex $< $@ -j .text -j .data
	@echo "\nBuild completed successfully!\n"
	@avr-size --format=avr --mcu=$(MCU) $(BUILD_DIR)/$(TARGET).elf

# Create binary file by linking object files
$(BUILD_DIR)/$(TARGET).elf: $(OBJ)
	@$(CC) $(LDFLAGS) $^ -o $@

# Compile source files. Create build directory if it does not exist
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo compiling $(notdir $<)
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c $< -o $@


# Flash the program to the microcontroller
.PHONY: flash
flash:
	@avrdude -p $(PART) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) \
	-U flash:w:$(BUILD_DIR)/$(TARGET).hex:i


# Remove build files
.PHONY: clean
clean:
	@rm -rf build
	@echo Build deleted
