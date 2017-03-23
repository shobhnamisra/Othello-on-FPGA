library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity img_gen is
     Port ( clk:in std_logic;
	         x_control : in std_logic_vector(9 downto 0);
				y_control : in std_logic_vector(9 downto 0);
				rgb : out std_logic_vector(2 downto 0);
				addr : in std_logic_vector(3 downto 0);
				user : in std_logic_vector(1 downto 0);
				video_on : in std_logic;
				we : in std_logic;
				oe : in std_logic);
	end img_gen;

architecture behavioral of img_gen is
   
-- grid
constant grid_t:integer:=1; --grid line thickness
constant grid_b:integer:=1; --grid begins from
constant grid_e:integer:=46; --end of grid
signal grid_on:std_logic;
signal rgb_grid:std_logic_vector(2 downto 0);


--box
constant size:integer:=10;--size of box
signal box_on:std_logic;
signal rgb_box:std_logic_vector(2 downto 0);
variable box_x,box_y:integer:=1;


--x,y pixel cursor
signal x,y:integer range 0 to 650;

--mux
signal vdbt:std_logic_vector(2 downto 0);

--buffer
signal rgb_reg,rgb_next:std_logic_vector(2 downto 0);

begin

--x,y pixel cursor
x <=conv_integer(x_control);
y <=conv_integer(y_control);

--grid object
process(grid_on)
variable grid_d:integer:=1;
begin 
while (grid_d<=46) loop
   if( x>grid_b and x<grid_e and y>grid_d and y<(grid_d+grid_t) and y>grid_b and y<grid_e and x>grid_d and x<(grid_d+grid_t)) then
	grid_on<='1';
	else grid_on<='0';
	end if;
	grid_d:=grid_d+11;
end loop;
rgb_grid<="000";--black
end process;

--user display
process(addr, user, clk)
  begin
  if(we='0' and oe='1') then
    if clk'event and clk='1' then
	   if(NOT addr="0000") then box_x:=2; box_y:=2;
		end if;
		if(NOT addr="0001") then box_x:=13; box_y:=2;
		end if;
		if(NOT addr="0010") then box_x:=24; box_y:=2;
		end if;
		if(NOT addr="0011") then box_x:=35; box_y:=2;
		end if;
		if(NOT addr="0100") then box_x:=2; box_y:=13;
		end if;
		if(NOT addr="0101") then box_x:=13; box_y:=13;
		end if;
		if(NOT addr="0110") then box_x:=24; box_y:=13;
		end if;
		if(NOT addr="0111") then box_x:=35; box_y:=13;
		end if;
		if(NOT addr="1000") then box_x:=2; box_y:=24;
		end if;
      if(NOT addr="1001") then box_x:=13; box_y:=24;
		end if;
		if(NOT addr="1010") then box_x:=24; box_y:=24;
		end if;
		if(NOT addr="1011") then box_x:=35; box_y:=24;
		end if;
		if(NOT addr="1100") then box_x:=2; box_y:=35;
		end if;
		if(NOT addr="1101") then box_x:=13; box_y:=35;
		end if;
		if(NOT addr="1110") then box_x:=24; box_y:=35;
		end if;
		if(NOT addr="1111") then box_x:=35; box_y:=35;
		end if;
		
		if(x>box_x and x<(box_x+size) and y>box_y and y<(box_y+size)) then
		box_on<='1';
		else box_on<='0';
		end if;
		
		if(user="00") then
		rgb_box<="010";
		elsif(user="01") then
		rgb_box<="001";
		elsif(user="10") then
		rgb_box<="100";
		else rgb_box<="010";
		end if;
	 end if;
  end if;
end process;

--buffer
process(clk)
begin
     if clk'event and clk='1' then
         rgb_reg<=rgb_next;
     end if;
end process;

--mux
vdbt<=video_on & grid_on & box_on; 
  rgb_next <= "010" when vdbt="100" else --Background of the screen is red 
              rgb_grid when vdbt="110" else
              rgb_grid when vdbt="111" else
	           rgb_box when vdbt="101" else 
				  "000";
--output
rgb<=rgb_reg;

end behavioral;
	
