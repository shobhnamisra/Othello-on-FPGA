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
				video_on : in std_logic);
	end img_gen;

architecture behavioral of img_gen is
   
-- grid
constant grid_t:integer range 0 to 650:=10; --grid line thickness
constant grid_b:integer range 0 to 650:=10; --grid begins from
constant grid_e:integer range 0 to 650:=460; --end of grid
signal grid_on:std_logic;
signal rgb_grid:std_logic_vector(2 downto 0);


--box
constant size:integer range 0 to 200:=100;--size of box
signal box_on:std_logic;
signal rgb_box:std_logic_vector(2 downto 0);



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
process(grid_on,x,y,rgb_grid)

begin 

   if( (x>grid_b and x<grid_e and ((y>1 and y<(1+grid_t)) or (y>120 and y<(120+grid_t)) or (y>230 and y<(230+grid_t))
	    or (y>340 and y<(340+grid_t)) or (y>450 and y<(450+grid_t)))) or
	    (y>grid_b and y<grid_e and ((x>1 and x<(1+grid_t)) or (x>120 and x<(120+grid_t)) or (x>230 and x<(230+grid_t))
	    or (x>340 and x<(340+grid_t)) or (x>450 and x<(450+grid_t)))) 
	     ) then
	grid_on<='1';
	else grid_on<='0';
	end if;


rgb_grid<="000";--black
end process;

--user display
process(addr, user, clk)
variable box_x,box_y:integer range 0 to 650:=1;
variable f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16 :integer range 0 to 2:=0;
  begin
  
    if clk'event and clk='1' then
	   if( addr="0001" and (user ="01" or user="10")) then --box_x:=20; box_y:=20; 
		f1:=1;
		end if;
		if( addr="0010" and (user ="01" or user="10")) then --box_x:=130; box_y:=20; 
		f2:=1;
		end if;
		if( addr="0011" and (user ="01" or user="10")) then-- box_x:=240; box_y:=20;
		f3:=1;
		end if;
		if( addr="0100" and (user ="01" or user="10")) then-- box_x:=350; box_y:=20;
		f4:=1;
		end if;
		if( addr="0101" and (user ="01" or user="10")) then-- box_x:=20; box_y:=130;
		f5:=1;
		end if;
		if( addr="0110" and (user ="01" or user="10")) then-- box_x:=130; box_y:=130; 
		f6:=1;
		end if;
		if( addr="0111" and (user ="01" or user="10")) then-- box_x:=240; box_y:=130; 
		f7:=1;
		end if;
		if( addr="1000" and (user ="01" or user="10")) then-- box_x:=350; box_y:=130; 
		f8:=1;
		end if;
		if( addr="1001" and (user ="01" or user="10")) then-- box_x:=20; box_y:=240; 
		f9:=1;
		end if;
      if( addr="1010" and (user ="01" or user="10")) then-- box_x:=130; box_y:=240; 
		f10:=1;
		end if;
		if( addr="1011" and (user ="01" or user="10")) then-- box_x:=240; box_y:=240;
		f11:=1;
		end if;
		if( addr="1100" and (user ="01" or user="10")) then-- box_x:=350; box_y:=240; 
		f12:=1;
		end if;
		if( addr="1101" and (user ="01" or user="10")) then-- box_x:=20; box_y:=350; 
		f13:=1;
		end if;
		if( addr="1110" and (user ="01" or user="10")) then-- box_x:=130; box_y:=350; 
		f14:=1;
		end if;
		if( addr="1111" and (user ="01" or user="10")) then-- box_x:=240; box_y:=350;
		f15:=1;
		end if;
		if( addr="0000" and (user ="01" or user="10")) then-- box_x:=350; box_y:=350;
		f16:=1;
		end if;
		
		if(((x>20 and x<(20+size)and f1=1) or (x>130 and x<(130+size)and f2=1) or (x>240 and x<(240+size)and f3=1) or (x>350 and x<(350+size)and f4=1)
	       or (x>20 and x<(20+size)and f5=1) or (x>130 and x<(130+size)and f6=1) or (x>240 and x<(240+size)and f7=1) or (x>350 and x<(350+size)and f8=1)
			 or (x>20 and x<(20+size)and f9=1) or (x>130 and x<(130+size)and f10=1) or (x>240 and x<(240+size)and f11=1) or (x>350 and x<(350+size)and f12=1)
			 or (x>20 and x<(20+size)and f13=1) or (x>130 and x<(130+size)and f14=1) or (x>240 and x<(240+size)and f15=1) or (x>350 and x<(350+size)and f16=1))and 
			 ((y>20 and y<(20+size)and f1=1) or (y>130 and y<(130+size)and f2=1) or (y>240 and y<(240+size)and f3=1) or (y>350 and y<(350+size)and f4=1)
	       or (y>20 and y<(20+size)and f5=1) or (y>130 and y<(130+size)and f6=1) or (y>240 and y<(240+size)and f7=1) or (y>350 and y<(350+size)and f8=1)
			 or (y>20 and y<(20+size)and f9=1) or (y>130 and y<(130+size)and f10=1) or (y>240 and y<(240+size)and f11=1) or (y>350 and y<(350+size)and f12=1)
			 or (y>20 and y<(20+size)and f13=1) or (y>130 and y<(130+size)and f14=1) or (y>240 and y<(240+size)and f15=1) or (y>350 and y<(350+size)and f16=1))) then
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
  rgb_next <= "010" when vdbt="100" else --Background of the screen is green 
              rgb_grid when (video_on='1' and grid_on='1') else
              rgb_grid when vdbt="111" else
	           rgb_box when vdbt="101" else 
				  "000";
--output
rgb<=rgb_reg;

end behavioral;
	
