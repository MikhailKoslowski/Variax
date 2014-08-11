-----------------------------------------------------------
-- Default Libs
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- My libs
-- USE work.my_functions.all
-----------------------------------------------------------
ENTITY BaudGenerator IS
	GENERIC ( baud : INTEGER := 9_600;
			  freq : INTEGER := 50_000_000);
	PORT (clk: IN STD_LOGIC;
		  clk_out: OUT STD_LOGIC);
END ENTITY;
-----------------------------------------------------------
ARCHITECTURE structure OF BaudGenerator IS
	SIGNAL x: STD_LOGIC :='0';
	SIGNAL y: STD_LOGIC :='0';
	
	CONSTANT M : INTEGER := freq/baud;
	
BEGIN
	PROCESS (clk)
		VARIABLE count1: INTEGER RANGE 0 TO M-1 := 0;
	BEGIN
		IF clk'EVENT AND clk='1' THEN
			IF count1 < (M/2) THEN
				x <= '1';
			ELSE
				x <= '0';
			END IF;
			count1 := count1 + 1;
			IF count1 = M THEN
				count1 := 0;
				--x <= '1';
			END IF;
		END IF;
		
	END PROCESS;
	
	PROCESS (clk)
		VARIABLE count2: INTEGER RANGE 0 TO M-1 := 0;
	BEGIN
		IF clk'EVENT AND clk='0' AND M mod 2 = 1 THEN
			IF count2 < (M/2) THEN
				y <= '1';
			ELSE
				y <= '0';
			END IF;
			count2 := count2 + 1;
			IF count2 = M THEN
				count2 := 0;
				--y <= '1';
			END IF;
		END IF;
	END PROCESS;
	
	clk_out <= x OR y;
	
END ARCHITECTURE structure;