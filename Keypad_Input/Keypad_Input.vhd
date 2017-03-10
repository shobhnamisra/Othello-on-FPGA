----------------------------------
--		Library Declaration 	--
----------------------------------
-- Like any other programming language, we should declare libraries

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------
--		Entity Declaration 		--
----------------------------------
-- Here we specify all input/output ports

entity Keypad_Input is
	Port(
		data_in1: out std_logic;
		data_in2: out std_logic;
		data_in3: out std_logic;
		data_in4: out std_logic;
		data_in5: in std_logic;
		data_in6: in std_logic;
		data_in7: in std_logic;
		data_in8: in std_logic;
		enable: in std_logic;
		green_led1 : out std_logic;
		green_led2 : out std_logic;
		green_led3 : out std_logic;
		green_led4 : out std_logic;
		green_led5 : out std_logic;
		green_led6 : out std_logic;
		green_led7 : out std_logic;
		green_led8 : out std_logic
	);
end entity;

----------------------------------
--	Architecture Declaration 	--
----------------------------------
--	here we put the description code of the designarchitecture Behavioral of input is


architecture behave of Keypad_Input is

-- signal declaration
signal LED1  : std_logic ;
signal LED2  : std_logic ;
signal LED3  : std_logic ;
signal LED4  : std_logic ;
signal LED5  : std_logic ;
signal LED6  : std_logic ;
signal LED7  : std_logic ;
signal LED8  : std_logic ;

begin

 
-- data transfer process : data is written 
	data_transfer : process 
	begin
	
		--if (enable = '1') then 
			data_in1 <= '1';		-- put first input pin to 1 and check for the 5,6,7 and 8 pins
			LED1 <= '1';
			--wait for 100000000 ns;
			LED5 <= data_in5;
			--wait for 100000000 ns;
			LED6 <= data_in6;
			--wait for 100000000 ns;
			LED7 <= data_in7;
			--wait for 100000000 ns;
			LED8 <= data_in8;
			--wait for 100000000 ns;
			
			data_in2 <= '1';		-- -- put second input pin to 1 and check for the 5,6,7 and 8 pins
			LED2 <= '1';
			--wait for 100000000 ns;
			LED5 <= data_in5;
			--wait for 100000000 ns;
			LED6 <= data_in6;
			--wait for 100000000 ns;
			LED7 <= data_in7;
			--wait for 100000000 ns;
			LED8 <= data_in8;
			--wait for 100000000 ns;
			
			data_in3 <= '1';		-- put third pin to 1 and check for the 5,6,7 and 8 pins
			LED3 <= '1';
			--wait for 100000000 ns;
			LED5 <= data_in5;
			--wait for 100000000 ns;
			LED6 <= data_in6;
			--wait for 100000000 ns;
			LED7 <= data_in7;
			--wait for 100000000 ns;
			LED8 <= data_in8;
			--wait for 100000000 ns;
			
			data_in4 <= '1';		-- put fourth input pin to 1 and check for the 5,6,7 and 8 pins
			LED4 <= '1';
			--wait for 100000000 ns;
			LED5 <= data_in5;
			--wait for 100000000 ns;
			LED6 <= data_in6;
			--wait for 100000000 ns;
			LED7 <= data_in7;
			--wait for 100000000 ns;
			LED8 <= data_in8;
			--wait for 100000000 ns;
			
		   --wait;
	end process data_transfer;

	green_led1 <= LED1;
	green_led2 <= LED2;
	green_led3 <= LED3;
	green_led4 <= LED4;
	green_led5 <= LED5;
	green_led6 <= LED6;
	green_led7 <= LED7;
	green_led8 <= LED8;
	
	end behave;
