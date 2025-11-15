DEVICE = up5k
PACKAGE = sg48
TOP = leds

SOURCES = src/leds.v
PCF = constraints/icesugar.pcf

BUILD_DIR = build

$(shell mkdir -p $(BUILD_DIR))

build: $(BUILD_DIR)/$(TOP).bin

$(BUILD_DIR)/$(TOP).json: $(SOURCES)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(SOURCES)

$(BUILD_DIR)/$(TOP).asc: $(BUILD_DIR)/$(TOP).json $(PCF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $< --pcf $(PCF) --asc $@

$(BUILD_DIR)/$(TOP).bin: $(BUILD_DIR)/$(TOP).asc
	icepack $< $@

time: $(BUILD_DIR)/$(TOP).asc
	icetime -tmd $(DEVICE) $<

clean:
	rm -rf $(BUILD_DIR)

.PHONY: build time clean