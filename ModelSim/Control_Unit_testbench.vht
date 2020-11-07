library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Control_Unit_testbench is
end entity Control_Unit_testbench;

architecture Behavioral of Control_Unit_testbench is

    component SimpleProcessor_ControlUnit is
        port(
            Clk, Reset, Run : in std_logic;
            IR_word : in std_logic_vector(8 downto 0);
            Control_word : out std_logic_vector(9 downto 0)
        );
    end component;

    signal CLOCK_50 : std_logic;
    signal RESET, RUN : std_logic;
    signal INSTR : std_logic_vector(8 downto 0);
    signal CW : std_logic_vector(9 downto 0);

begin
    
    uut: SimpleProcessor_ControlUnit port map(
        CLOCK_50, RESET, RUN, INSTR, CW
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
        INSTR <= (others => '0');
        RUN <= '0';
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';
        INSTR <= "001000000";
        RUN <= '1';
        wait for 20 ns;
        RUN <= '0';
        wait for 20 ns;
        RUN <= '1';
        INSTR <= "000111001";
        wait for 20 ns;
        RUN <= '0';
        wait for 20 ns;
        RUN <= '1';
        INSTR <= "010001000";
        wait for 20 ns;
        RUN <= '0';
        wait for 60 ns;
        RUN <= '1';
        INSTR <= "011001100";
        wait for 20 ns;
        RUN <= '0';
        wait for 80 ns;
        wait;
    end process;
    
end architecture Behavioral;