onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label RESET /Control_Unit_testbench/RESET
add wave -noupdate -label CLOCK_50 /Control_Unit_testbench/CLOCK_50
add wave -noupdate -label RUN /Control_Unit_testbench/RUN
add wave -noupdate -label INSTR -radix binary /Control_Unit_testbench/INSTR
add wave -noupdate -label CW -radix binary /Control_Unit_testbench/CW
add wave -noupdate -divider ControlUnit
add wave -noupdate -label Clock /Control_Unit_testbench/uut/clk
add wave -noupdate -label Reset /Control_Unit_testbench/uut/Reset
add wave -noupdate -label next_state -radix symbolic /Control_Unit_testbench/uut/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 80
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 20
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {260 ns}
