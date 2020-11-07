# stop any simulation that is currently running
quit -sim

# create the default "work" library
vlib work;

# compile the VHDL source code in the parent folder
vcom ../*.vhd
# compile the VHDL code of the testbench
vcom *.vhd
# start the Simulator, including some libraries that may be needed
vsim work.Processor_testbench -Lf 220model -Lf altera_mf
# show waveforms specified in wave.do
do wave_processor.do
# advance the simulation the desired amount of time
run 500 ns
