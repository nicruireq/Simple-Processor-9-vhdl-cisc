----------------------------------------------------------------------------------
--	@brief	SimpleProcessor
--
--	@author Nicolas Ruiz Requejo
--
--	
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simpleProcessor is
	port(
		DIN : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		Resetn, Clock, Run : IN STD_LOGIC;
		Done : OUT STD_LOGIC;
		BusWires : BUFFER STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
end simpleProcessor;

architecture behavioral of simpleProcessor is
	
	COMPONENT RegN
	GENERIC ( n : INTEGER := 1 );
	PORT
	(
		CLK		:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		enable		:	 IN STD_LOGIC;
		D		:	 IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Q		:	 OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT SimpleProcessor_ControlUnit
	PORT
	(
		Clk		:	 IN STD_LOGIC;
		Reset		:	 IN STD_LOGIC;
		Run		:	 IN STD_LOGIC;
		IR_word		:	 IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		Control_word		:	 OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
	END COMPONENT;
	
	-- register file mem and control signals
	type REGISTER_FILE_TYPE is array(7 downto 0) of std_logic_vector(8 downto 0);
	signal register_file : REGISTER_FILE_TYPE;
	signal RF_dir_in, RF_dir_out : std_logic_vector(2 downto 0);
	signal RF_databus_out : std_logic_vector(8 downto 0);
	signal RF_write_en : std_logic;
	-- Accumlator and ALU output G and instruction registers enables
	signal A_in, G_in, IR_in : std_logic;
	-- To select data bus source to read
	signal sel_databus_source : std_logic_vector(1 downto 0);
	-- ALU and other internal buses plus control signals
	signal A_to_ALU, ALU_to_G, G_to_Bus, IR_bus : std_logic_vector(8 downto 0);
	signal control_bus : std_logic_vector(9 downto 0);
	signal Sel_RF_dir_Read, Sel_RF_dir_Write, AddSub : std_logic;
	
	attribute keep: boolean;
	attribute keep of A_to_ALU: signal is true;
	attribute keep of ALU_to_G: signal is true;
	attribute keep of G_to_Bus: signal is true;
	attribute keep of RF_databus_out: signal is true;
	attribute keep of IR_bus: signal is true;
	
	attribute keep of Sel_RF_dir_Write: signal is true;
	attribute keep of Sel_RF_dir_Read: signal is true;
	attribute keep of RF_write_en: signal is true;
	attribute keep of sel_databus_source: signal is true;
	attribute keep of A_in: signal is true;
	attribute keep of G_in: signal is true;
	attribute keep of AddSub: signal is true;
	attribute keep of IR_in: signal is true;
	
	attribute keep of RF_dir_out: signal is true;
	attribute keep of register_file: signal is true;

begin

	register_file_process: process(Clock)
	begin	
		if rising_edge(Clock) then
			if RF_write_en = '1' then
				register_file(to_integer(unsigned(RF_dir_in))) <= BusWires;
			end if;
		end if;
	end process;
	-- asynchronous read for output register
	RF_databus_out <= register_file(to_integer(unsigned(RF_dir_out)));
	
	Reg_A: RegN generic map(n => 9) port map(Clock, Resetn, A_in, BusWires, A_to_ALU);
	Reg_G: RegN generic map(n => 9) port map(Clock, Resetn, G_in, ALU_to_G, G_to_Bus);
	Reg_IR: RegN generic map(n => 9) port map(Clock, Resetn, IR_in, DIN, IR_bus);
	
	-- mux to select the source address to read or write in register file
	RF_dir_in <= IR_bus(5 downto 3) when Sel_RF_dir_Write = '0' else
						IR_bus(2 downto 0) when Sel_RF_dir_Write = '1' else
						(others => '0');
	RF_dir_out <= IR_bus(5 downto 3) when Sel_RF_dir_Read = '0' else
						IR_bus(2 downto 0) when Sel_RF_dir_Read = '1' else
						(others => '0');
	
	-- selecting data bus source between register file, G ALU output register
	--	or DIN input
	BusWires <= RF_databus_out when sel_databus_source = "00" else
				   G_to_Bus when sel_databus_source = "01" else
					DIN when sel_databus_source = "10" else
					(others => '0');
	
	-- ALU_to_G is needed in order to write synchronously G register
	ALU: process(A_to_ALU, BusWires, AddSub)
	begin
		if AddSub = '1' then
			ALU_to_G <= std_logic_vector(unsigned(A_to_ALU) - unsigned(BusWires));
		else
			ALU_to_G <= std_logic_vector(unsigned(A_to_ALU) + unsigned(BusWires));
		end if;
	end process;
	
	-- control unit instantiation and breakdown of control bus signals
	Control_Unit: SimpleProcessor_ControlUnit port map(Clock, Resetn, Run, IR_bus, control_bus);
	Sel_RF_dir_Read <= control_bus(9);
	Sel_RF_dir_Write <= control_bus(8);
	RF_write_en <= control_bus(7);
	sel_databus_source <= control_bus(6 downto 5);
	A_in <= control_bus(4);
	G_in <= control_bus(3);
	IR_in <= control_bus(2);
	AddSub <= control_bus(1);
	Done <= control_bus(0);

end behavioral;