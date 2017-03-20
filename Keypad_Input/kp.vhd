library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity kp is
  Port(
    clk : in std_logic;
    c1 : inout std_logic;
	 c2 : inout std_logic;
	 c3 : inout std_logic;
	 c4 : inout std_logic;
	 r1 : inout std_logic;
	 r2 : inout std_logic;
	 r3 : inout std_logic;
	 r4 : inout std_logic;
	 led1 : out std_logic;
	 led2 : out std_logic;
	 led3 : out std_logic;
	 led4 : out std_logic;
	 led5 : out std_logic;
	 led6 : out std_logic;
	 led7 : out std_logic;
	 led8 : out std_logic);
	
end kp;

architecture behavioral of kp is
 

begin

 process
  begin
  --if clk'event and clk='1' then
    r1<='0'; r2<='0'; r3<='0'; r4<='0'; --pull all rows to 0
	 c1<='1'; c2<='1'; c3<='1'; c4<='1'; --pull all columns to 1
	 wait until c1='0' or c2='0' or c3= '0' or c4='0';
	 if(c1='0') then led1<='1';
	 else led1<='0';
	 end if;
	 if(c2='0') then led2<='1';
	 else led2<='0';
	 end if;
	 if(c3='0') then led3<='1';
	 else led3<='0';
	 end if;
	 if(c4='0') then led4<='1';
	 else led4<='0';
	 end if;
	 
	  r1<='1';                      --sequentially pull each row high and check columns
	 if(c1='1' and c2='1' and c3='1' and c4='1') then led5<='1';
	 else led5<='0';
	 end if;
	 r2<='1';  
	 if(c1='1' and c2='1' and c3='1' and c4='1') then led6<='1';
	 else led6<='0';
	 end if;
	 r3<='1';  
	 if(c1='1' and c2='1' and c3='1' and c4='1') then led7<='1';
	 else led7<='0';
	 end if;
	 r4<='1';  
	 if(c1='1' and c2='1' and c3='1' and c4='1') then led8<='1';
	 else led8<='0';
	 end if;
	end process; 
end behavioral;	 