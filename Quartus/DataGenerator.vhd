-----------------------------------------------------------
-- Default Libs
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- My libs
-- USE work.my_functions.all
-----------------------------------------------------------
ENTITY DataGenerator IS
	PORT (
		  clk : IN STD_LOGIC;
		  nxt : IN STD_LOGIC;
		  data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		  rdy : OUT STD_LOGIC
		 );
END ENTITY;
-----------------------------------------------------------
ARCHITECTURE structure OF DataGenerator IS
	SIGNAL running : STD_LOGIC := '0';
	SIGNAL s_data : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	SIGNAL rd1 : STD_LOGIC;
	SIGNAL rd2 : STD_LOGIC;
	
	SIGNAL lastNxt : STD_LOGIC := '0';
	
BEGIN
	PROCESS (clk)
		VARIABLE value : INTEGER RANGE 0 to 255 := 31;
	BEGIN
		IF clk'EVENT AND clk='1' THEN
			IF nxt='1' AND lastNxt='0' THEN
				-- Rising edge
				value := value + 1;
					IF value >= 127 THEN
						value := 32;
					END IF;
					s_data <= STD_LOGIC_VECTOR(TO_UNSIGNED(value, 8));
					rdy <= '1';
			ELSIF nxt='0' THEN
				-- Steady
				rdy <= '0';
			END IF;
			lastNxt <= nxt;
		END IF;
	END PROCESS;
	
	data <= s_data;
	
END ARCHITECTURE structure;