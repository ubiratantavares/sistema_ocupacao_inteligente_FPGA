all: build/out.bit

build/out.bit: build/out.config
	ecppack --compress --input build/out.config --bit build/out.bit

build/out.config: build/out.json hdl/top.lpf
	nextpnr-ecp5 --json build/out.json --lpf hdl/top.lpf --textcfg build/out.config --package CABGA381 --45k --speed 6

build/out.json: hdl/top.v hdl/pir.v hdl/led_rgb.v
	yosys -p "read_verilog hdl/top.v hdl/pir.v hdl/led_rgb.v; synth_ecp5 -json build/out.json -abc9"

load: 
	openFPGALoader -b colorlight-i9 build/out.bit
	
