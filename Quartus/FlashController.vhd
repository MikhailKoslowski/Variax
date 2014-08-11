-----------------------------------------------------------
-- Default Libs
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- My libs
-- USE work.my_functions.all
-----------------------------------------------------------
ENTITY FlashController IS
	GENERIC( freq : NATURAL := 50_000_000 );
	PORT (	clk : IN STD_LOGIC;
			addr : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
			data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			rdy : OUT STD_LOGIC
		  );
END FlashController;
--------------------------------------------------------
ARCHITECTURE structure OF FlashController IS
	SIGNAL s_addr : STD_LOGIC_VECTOR(18 DOWNTO 0);
	SIGNAL s_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	PROCESS(clk)
		VARIABLE count: NATURAL RANGE 0 TO freq := 0;
	BEGIN
		-- clk rising edge.
		IF clk'EVENT AND clk='1' THEN
				IF count = 0 THEN
					s_addr <= addr;
				ELSIF count = freq THEN
					data <= s_data;
					rdy <= '1';
				ELSE
					s_data <= s_addr(7 DOWNTO 0);
					rdy <= '0';
				END IF;
				
				count := count + 1;
		END IF;
	END PROCESS;
END structure;
--------------------------------------------------------