----------------------------------------------------------------------------------
-- @brief 		 RegN - Behavioral 
--					 Describes parallel input/output register of n bits.
--
-- @author 		 Nicolas Ruiz Requejo
--
--	Copyright (C) 2017-2018 Nicolas Ruiz Requejo
--
--  This file is part of Examen02Comp.
--
--  Examen02Comp is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  Examen02Comp is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with Examen02Comp.  If not, see <https://www.gnu.org/licenses/>.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegN is
	 generic(n : integer := 1);
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR (n-1 downto 0);
           Q : out  STD_LOGIC_VECTOR (n-1 downto 0));
end RegN;

architecture Behavioral of RegN is

	attribute keep: boolean;
	attribute keep of Q: signal is true;
begin

	registerN:
	process (CLK, RESET)
	begin
		-- asynchronous reset
		if RESET = '1' then
			Q <= (others => '0');
		elsif rising_edge(CLK) then
			-- synchronous enable
			if enable = '1' then
				-- load input data
				Q <= D;
			end if;
		end if;
	end process registerN;

end Behavioral;