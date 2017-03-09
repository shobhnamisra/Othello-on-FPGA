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
		data_in1: in std_logic;
		data_in2: in std_logic;
		data_in3: in std_logic;
		data_in4: in std_logic;
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
	data_transfer : process (enable)
	begin
		if (enable = '1') then 
			LED1 <= data_in1;
		else 
			LED1 <= '0' ;
		end if ;
		if (enable = '1') then 
			LED2 <= data_in2;
		else 
			LED2 <= '0' ;
		end if ;
		if (enable = '1') then 
			LED3 <= data_in3;
		else 
			LED3 <= '0' ;
		end if ;
		if (enable = '1') then 
			LED4 <= data_in4;
		else 
			LED4 <= '0' ;
		end if ;
		if (enable = '1') then 
			LED5 <= data_in5;
		else 
			LED5 <= '0' ;
		end if ;
		if (enable = '1') then 
			LED6 <= data_in6;
		else 
			LED6 <= '0' ;
		end if ;
		if (enable = '1') then 
			LED7 <= data_in7;
		else 
			LED7 <= '0' ;
		end if ;
		if (enable = '1') then 
			LED8 <= data_in8;
		else 
			LED8 <= '0' ;
		end if ;
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
