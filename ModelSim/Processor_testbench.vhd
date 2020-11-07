library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Processor_testbench is
end entity Processor_testbench;

architecture rtl of Processor_testbench is
    component simpleProcessor is
        port(
            DIN : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
            Resetn, Clock, Run : IN STD_LOGIC;
            Done : OUT STD_LOGIC;
            BusWires : BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0)
        );
    end component;

    signal DIN : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal Resetn, CLOCK_50, Run : STD_LOGIC;
    signal Done : STD_LOGIC;
    signal BusWires : STD_LOGIC_VECTOR(8 DOWNTO 0);

begin
    
    uut: simpleProcessor port map(
        DIN, Resetn, CLOCK_50, Run, Done, BusWires
    );

    clock_process: process
    begin
	   CLOCK_50 <= '0';
	   wait for 10 ns;
	   CLOCK_50 <= '1';
	   wait for 10 ns;
    end process;
    
    tests: process
    begin
        Resetn <= '1';
        DIN <= "000000000";
        Run <= '0';
        BusWires <= "000000000";
        wait for 20 ns;
        Resetn <= '0';
        DIN <= "001000000"; -- MVI R0,8
        Run <= '1';
        wait for 20 ns;
        Run <= '0';
        DIN <= "000001000"; -- 0x8
        wait for 20 ns;
        -- data should be in R0
        DIN <= "001001000"; -- MVI R1,4
        Run <= '1';
        wait for 20 ns;
        Run <= '0';
        DIN <= "000000100"; -- 0x4
        wait for 20 ns;
        -- data should be in R1
        DIN <= "010001000"; -- ADD R1,R0
        Run <= '1';
        wait for 20 ns;
        Run <= '0';
        wait for 60 ns;
        DIN <= "001100000"; -- MVI R4,10
        Run <= '1';
        wait for 20 ns;
        Run <= '0';
        DIN <= "000001010"; -- 0xA
        wait for 20 ns;
        DIN <= "011001100";  -- SUB R1,R4
        Run <= '1';
        wait for 20 ns;
        Run <= '0';
        wait for 60 ns;
        DIN <= "000111001";  -- MV R7,R1
        Run <= '1';
        wait for 20 ns;
        Run <= '0';

        wait;
    end process tests;
    
end architecture rtl;   