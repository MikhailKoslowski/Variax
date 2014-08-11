-----------------------------------------------------------
-- Default Libs
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-- My libs
-- USE work.my_functions.all
-----------------------------------------------------------
ENTITY FlashReader IS
	PORT (
			KEY : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			LEDG : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			CLOCK_50 : IN STD_LOGIC;
			UART_TXD : OUT STD_LOGIC
		 );
END FlashReader;
--------------------------------------------------------
ARCHITECTURE structure OF FlashReader IS

COMPONENT FlashController
	PORT (
			clk : IN STD_LOGIC;
			addr : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
			data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			rdy : OUT STD_LOGIC 
		  );
END COMPONENT;

COMPONENT BaudGenerator IS	
	PORT (	clk : IN STD_LOGIC;
			clk_out : OUT STD_LOGIC
		  );
END COMPONENT;

COMPONENT UartTransmitter IS
	PORT (
		  clk : IN STD_LOGIC;
		  data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  send : IN STD_LOGIC;
		  rdy : OUT STD_LOGIC;
		  TXD : OUT STD_LOGIC
		 );
END COMPONENT;

COMPONENT DataGenerator IS
	PORT (
		  clk : IN STD_LOGIC;
		  nxt : IN STD_LOGIC;
		  data : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		  rdy : OUT STD_LOGIC
		 );
END COMPONENT;

SIGNAL uart_send : STD_LOGIC;
SIGNAL uart_clk : STD_LOGIC;
SIGNAL uart_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL uart_rdy : STD_LOGIC := '1';
SIGNAL s_addr : STD_LOGIC_VECTOR(18 DOWNTO 0);

BEGIN
	
controller : FlashController PORT MAP ( clk => CLOCK_50, addr=>s_addr, data=>LEDG(7 DOWNTO 0), rdy=>LEDG(9));
baudgen : BaudGenerator PORT MAP ( clk => CLOCK_50, clk_out => uart_clk);
transmitter : UartTransmitter PORT MAP (clk => uart_clk, data => uart_data, send => uart_send, rdy=>uart_rdy, TXD => UART_TXD);
datagen : DataGenerator PORT MAP ( clk=> CLOCK_50, nxt => uart_rdy, data => uart_data, rdy => uart_send);

s_addr(9 DOWNTO 0) <= SW;
s_addr(18 DOWNTO 10) <= "000000000";

END structure;
--------------------------------------------------------