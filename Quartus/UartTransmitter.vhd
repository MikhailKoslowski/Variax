-----------------------------------------------------------
-- Default Libs
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- My libs
-- USE work.my_functions.all
-----------------------------------------------------------
ENTITY UartTransmitter IS
	PORT (
		  clk : IN STD_LOGIC;
		  data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  send : IN STD_LOGIC;
		  rdy : OUT STD_LOGIC := '1';
		  TXD : OUT STD_LOGIC := '1'
		 );
END ENTITY;
-----------------------------------------------------------
ARCHITECTURE structure OF UartTransmitter IS
	SIGNAL running : STD_LOGIC := '0';
	SIGNAL s_data : STD_LOGIC_VECTOR (0 TO 9);
BEGIN
	PROCESS (clk)
		VARIABLE outBit : INTEGER RANGE -1 to 9 := -1;
	BEGIN
		IF clk'EVENT AND clk='1' THEN
			IF send = '1' AND running = '0' THEN
				s_data(1 TO 8) <= data;
				s_data(9) <= '0'; -- Start bit
				s_data(0) <= '1'; -- Stop bit
				outBit := 9;
				rdy <= '0';
				running <= '1';
			ELSIF running = '1' AND outBit >= 0 THEN
				TXD <= s_data(outBit);
				outBit := outBit-1;
			ELSE
				running <= '0';
				rdy <= '1';
			END IF;
		END IF;
	END PROCESS;
	
END ARCHITECTURE structure;