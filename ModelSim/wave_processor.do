onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label DIN /Processor_testbench/DIN
add wave -noupdate -label RESET /Processor_testbench/Resetn
add wave -noupdate -label CLOCK_50 /Processor_testbench/CLOCK_50
add wave -noupdate -label RUN /Processor_testbench/Run
add wave -noupdate -label DONE /Processor_testbench/Done
add wave -noupdate -label DataBus -radix binary /Processor_testbench/BusWires
add wave -noupdate -divider SimpleProcessor
add wave -noupdate -label Clock /Processor_testbench/uut/Clock
add wave -noupdate -label Reset /Processor_testbench/uut/Resetn
add wave -noupdate -divider Registers
add wave -noupdate -label IR -radix binary /Processor_testbench/uut/Reg_IR/Q
add wave -noupdate -label A -radix binary /Processor_testbench/uut/Reg_A/Q
add wave -noupdate -label G -radix binary /Processor_testbench/uut/Reg_G/Q
add wave -noupdate -label register_file_out -radix binary /Processor_testbench/uut/RF_databus_out
add wave -noupdate -divider control_Word_from_processor
add wave -noupdate -label control_bus -radix binary /Processor_testbench/uut/control_bus
add wave -noupdate -divider Control_Signals
add wave -noupdate -label Sel_RF_dir_Read -radix binary /Processor_testbench/uut/Sel_RF_dir_Read
add wave -noupdate -label Sel_RF_dir_Write -radix binary /Processor_testbench/uut/Sel_RF_dir_Write
add wave -noupdate -label RF_write_en -radix binary /Processor_testbench/uut/RF_write_en
add wave -noupdate -label sel_databus_source -radix binary /Processor_testbench/uut/sel_databus_source
add wave -noupdate -label A_in -radix binary /Processor_testbench/uut/A_in
add wave -noupdate -label G_in -radix binary /Processor_testbench/uut/G_in
add wave -noupdate -label IR_in -radix binary /Processor_testbench/uut/IR_in
add wave -noupdate -label AddSub -radix binary /Processor_testbench/uut/AddSub
add wave -noupdate -label Done -radix binary /Processor_testbench/uut/Done

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 80
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 10
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {260 ns}
