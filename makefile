DEVICE = up5k
PACKAGE = sg48
TOP = leds

SOURCES = src/leds.v
PCF = constraints/icesugar.pcf

build: $(TOP).bin

$(TOP).json: $(SOURCES)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(SOURCES)

$(TOP).asc: $(TOP).json $(PCF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $(TOP).json --pcf $(PCF) --asc $@

$(TOP).bin: $(TOP).asc
	icepack $< $@

upload: $(TOP).bin
	iceprog $<

clean:
	rm -f *.json *.asc *.bin

.PHONY: build upload clean