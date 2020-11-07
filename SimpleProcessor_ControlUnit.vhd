----------------------------------------------------------------------------------
--
--	@brief	SimpleProcessor control unit
--
--	@author Nicolas Ruiz Requejo
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleProcessor_ControlUnit is
	port(
		Clk, Reset, Run : in std_logic;
		IR_word : in std_logic_vector(8 downto 0);
		Control_word : out std_logic_vector(9 downto 0)
	);
end SimpleProcessor_ControlUnit;

architecture behavioral of SimpleProcessor_ControlUnit is

	type STATE_TYPE is (FETCH, DECODE, ALU_1, ALU_2);
	signal next_state : STATE_TYPE;
	
	constant cw_null : std_logic_vector(9 downto 0) := "0000000000";
	constant cw_fetch : std_logic_vector(9 downto 0) := "0000000100";
	constant cw_mv : std_logic_vector(9 downto 0) := 	 "1010000001";
	constant cw_mvi : std_logic_vector(9 downto 0) := 	 "0011000001";
	constant cw_alu0 : std_logic_vector(9 downto 0) :=  "0000010000";
	constant cw_add : std_logic_vector(9 downto 0) :=   "1000001000";
	constant cw_sub : std_logic_vector(9 downto 0) :=   "1000001010";
	constant cw_wb : std_logic_vector(9 downto 0) :=    "0010100001";
	
	attribute keep: boolean;
	attribute keep of next_state: signal is true;
	
begin

	fsm_logic: process(Clk, Reset)
	begin
		if Reset = '1' then
			next_state <= FETCH;
			--Control_word <= cw_null;
		elsif rising_edge(Clk) then
			case next_state is
				when FETCH =>
					if Run = '1' then
						next_state <= DECODE;
						--Control_word <= cw_fetch;
					else
						next_state <= FETCH;
						-- datapath inhbition
						--Control_word <= cw_null;
					end if;
				when DECODE =>
					case IR_word(8 downto 6) is
						when "000" =>
							next_state <= FETCH;
							--Control_word <= cw_mv;
						when "001" =>
							next_state <= FETCH;
							--Control_word <= cw_mvi;
						when "010" | "011" =>
							next_state <= ALU_1;
							--Control_word <= cw_alu0;
						when others => 
							next_state <= FETCH;
							--Control_word <= cw_null;
					end case;
				when ALU_1 =>
					next_state <= ALU_2;
					--if IR_word(8 downto 6) = "010" then
						--Control_word <= cw_add;
					--elsif IR_word(8 downto 6) = "011" then
						--Control_word <= cw_sub;
					--else
						--Control_word <= cw_null;
					--end if;
				when ALU_2 =>
					next_state <= FETCH;
					--Control_word <= cw_wb;
			end case;
		end if;
	end process;
	
	mealy_combinational_logic: process(next_state, IR_word, Run)
	begin
		case next_state is
			when FETCH =>
				if Run = '1' then
						Control_word <= cw_fetch;
					else
						-- datapath inhbition
						Control_word <= cw_null;
					end if;
			when DECODE =>
				case IR_word(8 downto 6) is
					when "000" =>
						Control_word <= cw_mv;
					when "001" =>
						Control_word <= cw_mvi;
					when "010" | "011" =>
						Control_word <= cw_alu0;
					when others => 
						Control_word <= cw_null;
				end case; 
			when ALU_1 =>
				if IR_word(8 downto 6) = "010" then
					Control_word <= cw_add;
				elsif IR_word(8 downto 6) = "011" then
					Control_word <= cw_sub;
				else
					Control_word <= cw_null;
				end if;
			when ALU_2 =>
				Control_word <= cw_wb;
		end case;
	end process;

end behavioral;