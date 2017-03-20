library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;               -- changed from unsigned.
-- use work.COUNTDOWN_PACKAGE.all;
-- library altera;
-- use altera.maxplus2.all;

-- Title "Keypad encoder circuit"
-- Prepared by: D.N. Warren-Smith
-- Updated: 14 February 2001
-- Modified by N. J. Gunton
-- Date 6th February 2008 & March 2011
-- the original can be found at
-- http://users.senet.com.au/~dwsmith/vhdl.htm#top

-- connect strobe to drive the interrupt line?

entity Keypad_Input is
  port (
    sys_clk : in  std_logic;                      -- Clock source and
    resetn  : in  std_logic;                      -- Reset on global inputs
--    strobe : out    std_logic;                  -- key pressed
    led1 : out std_logic;
	 led2 : out std_logic;
	 led3 : out std_logic;
	 led4 : out std_logic;
	 row     : in  std_logic_vector (3 downto 0);  -- Sense keypad rows
    col     : out std_logic_vector (3 downto 0);  -- Drive columns
    shift   : out std_logic_vector (31 downto 0));
end Keypad_Input;

architecture keys of Keypad_Input is
  signal key_pressed : std_logic;       -- High when a key pressed
  signal NKP         : std_logic;
  signal mat         : std_logic_vector (3 downto 0);  -- key conversion matrix
  signal d           : unsigned(3 downto 0);  -- Control counter
  signal cnt         : unsigned (1 downto 0);  -- used in key debounce
  signal divider     : unsigned(15 downto 0);
                                        -- used for keypad scan clock generation
  signal clk         : std_logic;       -- internal clk
  signal pulse       : std_logic;
  signal inp0        : std_logic_vector(3 downto 0);

begin

  -- Scan the keyboard until a key is pressed
  process (clk, key_pressed, resetn)
  begin
    if (clk'event and clk = '1') then
      if (resetn = '0') then
        d <= "0000";  -- synchronous reset
      else
        if (key_pressed = '0') then
          d <= d + 1;
        end if;
      end if;  -- Counter stops counting when a key is pressed
    end if;
  end process;

  -- Column drivers, active low

  col(0) <= '0' when d(3 downto 2) = "00" else '1';
  col(1) <= '0' when d(3 downto 2) = "01" else '1';
  col(2) <= '0' when d(3 downto 2) = "10" else '1';
  col(3) <= '0' when d(3 downto 2) = "11" else '1';

  -- Sense keyboard rows with a multiplexer
  -- double inversion ughh
  -- keypad gives 0 when key pressed

with d select
  mat <=
  "0001" 	  when "1100",
  "0010" 	  when "1000",
  "0011" 	  when "0100",
  "0100" 	  when "0000",
  "0101" 	  when "1101",
  "0110" 	  when "1001",
  "0111" 	  when "0101",
  "1000" 	  when "0001",
  "1001" 	  when "1110",
  "1010" 	  when "1010",
  "1011" 	  when "0110",
  "1100" 	  when "0010",
  "1101" 	  when "1111",
  "1110" 	  when "1011",
  "1111" 	  when "0111",
  
  "0000"      when others;
  
  with d(1 downto 0) select
    key_pressed <= not row(3) when "11",
                   not row(2) when "10",
                   not row(1) when "01",
                   not row(0) when others;

  NKP           <= not key_pressed;

  -- Generate strobe when key press has settled
  -- st : debounce port map(clk, NKP, strobe);
  -- below is hacked process from debounce module

  process (Clk, nkp)
  begin
    if NKP = '1' then
      cnt      <= to_unsigned(0, 2);
    else
      if (clk'event and Clk = '1') then
        if (cnt /= to_unsigned(3, 2)) then
          cnt    <= cnt + to_unsigned(1, 2);
        end if;
      end if;
      if (cnt = to_unsigned(2, 2)) and (NKP = '0') then
        pulse    <= '1';
      else pulse <= '0';
      end if;
    end if;
  end process;


-- latch key value (from matrix) when we get a pulse
  process (clk,resetn,pulse,mat)
  begin
    if resetn = '0' then                -- asynchronous clear
      inp0   <= "0000";
    else
      if (clk'event and clk = '1') then
        if pulse = '1' then               -- left shift mat into shift register
          inp0 <= mat;
        end if;
      end if;
    end if;
  end process;

  process (inp0)
  begin
		led1 <= inp0(3);
		led2 <= inp0(2);
		led3 <= inp0(1);
		led4 <= inp0(0);
	end process;
  
  -- shift is padded to 32 bits to keep sopc_builder happy ;-) NJG
  shift <= "0000000000000000000000000000"&inp0;

--end;


-- purpose: takes the system clock and drops it to 2mS clock
-- type : sequential
-- inputs : sys_clk, resetn
-- outputs: clk
clock_div : process (sys_clk, resetn)
begin  -- process clock_div
  if resetn = '0' then                  -- asynchronous reset (active low)
    divider   <= to_unsigned(0, 16);
    clk       <= '0';
  elsif sys_clk'event and sys_clk = '1' then  -- rising clock edge
    if divider = X"8235" then
      clk     <= not clk;
      divider <= to_unsigned(0, 16);
    else
      divider <= divider + to_unsigned(1, 16);
    end if;

  end if;
end process clock_div;

end;
