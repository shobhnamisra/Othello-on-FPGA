library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vgacontrol is
     Port ( clk : in STD_LOGIC;
                rgb : out STD_LOGIC_VECTOR (2 downto 0);
                hsn : out STD_LOGIC;
                vsn : out STD_LOGIC;
					 row : in STD_LOGIC_VECTOR(3 downto 0);
					 col : out STD_LOGIC_VECTOR(3 downto 0);
					 lederror : out STD_LOGIC;
					 data_out_valid:out std_logic;
					 datatest: out std_logic_vector(1 downto 0);
					 reset :in std_logic;
					 btntest : out std_logic;
					 
					 DRAM_ADDR   : OUT   STD_LOGIC_VECTOR (12 downto 0);
   DRAM_BA      : OUT   STD_LOGIC_VECTOR (1 downto 0);
   DRAM_CAS_N   : OUT   STD_LOGIC;
   DRAM_CKE      : OUT   STD_LOGIC;
   DRAM_CLK      : OUT   STD_LOGIC;
   DRAM_CS_N   : OUT   STD_LOGIC;
   DRAM_DQ      : INOUT STD_LOGIC_VECTOR(15 downto 0);
   DRAM_DQM      : OUT   STD_LOGIC_VECTOR(1 downto 0);
   DRAM_RAS_N   : OUT   STD_LOGIC;
   DRAM_WE_N    : OUT   STD_LOGIC); 
					
end vgacontrol;

architecture Behavioral of vgacontrol is

     COMPONENT sync_mod
            PORT( clk : IN std_logic;
                          reset : IN std_logic;
                          start : IN std_logic; 
                          y_control : OUT std_logic_vector(9 downto 0);
                          x_control : OUT std_logic_vector(9 downto 0);
                          h_s : OUT std_logic;
                          v_s : OUT std_logic;
                          video_on : OUT std_logic );
      END COMPONENT;
		
		COMPONENT Keypad_Input
            PORT( sys_clk : in  std_logic;                      -- Clock source and
                  resetn  : in  std_logic;                      -- Reset on global inputs
                  btn : out std_logic;
	               baddr : out std_logic_vector(3 downto 0);
	               row     : in  std_logic_vector (3 downto 0);  -- Sense keypad rows
                  col     : out std_logic_vector (3 downto 0);  -- Drive columns
                  shift   : out std_logic_vector (31 downto 0));
       END COMPONENT;
		 
		 COMPONENT main
		      PORT(	
				      clk 			: IN STD_LOGIC; --Input clock
				button		: IN STD_LOGIC; --HIGH when any button is pushed on board
				reset			: IN STD_LOGIC; --LOW when reset button is pushed
				error			: OUT STD_LOGIC; --Will light up LED to indicate a bad move was tried
				pass			: IN STD_LOGIC; --Will be HIGH when the player requests a pass
				baddr			: IN STD_LOGIC_VECTOR(3 DOWNTO 0); --The address pins from the board
				user			: BUFFER STD_LOGIC_VECTOR(1 DOWNTO 0); --The user display

				oe				: OUT STD_LOGIC := '1'; --Output enable for sram
				we				: OUT STD_LOGIC := '1'; --Write enable for sram and latches
				raddr			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- Address pins to latch decoders and sram
				--data 			: INOUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => 'Z') --This is the bidirectional data bus to/from SRAM
				datai : out std_logic_vector(1 downto 0);
				datao : in std_logic_vector(1 downto 0)
				);
		END COMPONENT;
		
	
	COMPONENT sdram_clk_gen
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
	END COMPONENT;
	
	COMPONENT sdram_controller
	port(
      -- Host side
      clk_100m0_i    : in std_logic;            -- Master clock
      reset_i        : in std_logic := '0';     -- Reset, active high
      refresh_i      : in std_logic := '0';     -- Initiate a refresh cycle, active high
      rw_i           : in std_logic := '0';     -- Initiate a read or write operation, active high
      we_i           : in std_logic := '0';     -- Write enable, active low
      addr_i         : in std_logic_vector(23 downto 0) := (others => '0');   -- Address from host to SDRAM
      data_i         : in std_logic_vector(15 downto 0) := (others => '0');   -- Data from host to SDRAM
      ub_i           : in std_logic;            -- Data upper byte enable, active low
      lb_i           : in std_logic;            -- Data lower byte enable, active low
      ready_o        : out std_logic := '0';    -- Set to '1' when the memory is ready
      done_o         : out std_logic := '0';    -- Read, write, or refresh, operation is done
      data_o         : out std_logic_vector(15 downto 0);   -- Data from SDRAM to host
 
      -- SDRAM side
      sdCke_o        : out std_logic;           -- Clock-enable to SDRAM
      sdCe_bo        : out std_logic;           -- Chip-select to SDRAM
      sdRas_bo       : out std_logic;           -- SDRAM row address strobe
      sdCas_bo       : out std_logic;           -- SDRAM column address strobe
      sdWe_bo        : out std_logic;           -- SDRAM write enable
      sdBs_o         : out std_logic_vector(1 downto 0);    -- SDRAM bank address
      sdAddr_o       : out std_logic_vector(12 downto 0);   -- SDRAM row/column address
      sdData_io      : inout std_logic_vector(15 downto 0); -- Data to/from SDRAM
      sdDqmh_o       : out std_logic;           -- Enable upper-byte of SDRAM databus if true
      sdDqml_o       : out std_logic            -- Enable lower-byte of SDRAM databus if true
   );
end component;
     --buffer signals
     signal video:std_logic;
	  signal baddress:std_logic_vector(3 downto 0);
	  signal raddress:std_logic_vector(23 downto 0);
	  signal xp,yp:std_logic_vector(9 downto 0);
	  signal keypress:std_logic;
	  signal userdata: std_logic_vector(1 downto 0);
	  signal oe : std_logic;
	  signal we : std_logic;
	  signal data : std_logic_vector(15 downto 0);
	  signal data_output : std_logic_vector(15 downto 0);
	  signal clk100 : std_logic;
	  signal req : std_logic;
	  signal req_write : std_logic;
	  
	  
	  -- grid
constant grid_t:integer range 0 to 650:=10; --grid line thickness
constant grid_b:integer range 0 to 650:=20; --grid begins from
constant grid_e:integer range 0 to 650:=460; --end of grid
signal grid_on:std_logic;
signal rgb_grid:std_logic_vector(2 downto 0);

--x,y pixel cursor
signal x,y:integer range 0 to 650;

--mux
signal vdbt:std_logic_vector(17 downto 0);

--buffer
signal rgb_reg,rgb_next:std_logic_vector(2 downto 0);

--box
constant size:integer range 0 to 200:=100;--size of box
signal f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16 :std_logic;
signal rgb_box,rgb_box1,rgb_box2,rgb_box3,rgb_box4,rgb_box5,rgb_box6,rgb_box7,rgb_box8,rgb_box9,rgb_box10,rgb_box11,rgb_box12,rgb_box13,rgb_box14,rgb_box15,rgb_box16:std_logic_vector(2 downto 0);	  
	  
	  
begin

     
	  Inst_Keypad_Input: Keypad_Input PORT MAP(sys_clk=>clk, resetn => '1', btn=>keypress, baddr => baddress, row=>row, col=>col );     

	 
     Inst_sync_mod: sync_mod PORT MAP( clk => clk, reset => '0', start => '1', y_control => yp, x_control => xp,
                                                                         h_s => hsn, v_s => vsn, video_on => video );

	 Inst_main: main PORT MAP(clk=>clk, button=>keypress , reset=>reset,error=>lederror,pass=>'1',baddr=>baddress,user=>userdata, oe=>oe,we=>we,raddr=>raddress(3 downto 0),datai=>data(1 downto 0), datao=> data_output(1 downto 0) );																							 
		
	
	 Inst_sdram_clk_gen : sdram_clk_gen PORT MAP(inclk0=>clk, c0=>clk100);
	 
	 Inst_sdram_controller : sdram_controller PORT MAP ( 
	 clk_100m0_i=>clk100,
	sdaddr_o=>DRAM_ADDR,
	sdBs_o=>DRAM_BA,
	sdCas_bo=>DRAM_CAS_N,
	sdCke_o=>DRAM_CKE,
	sdCe_bo=>DRAM_CS_N,
	sdData_io=>DRAM_DQ,
	sdDqmh_o=>DRAM_DQM(1),
	sdDqml_o=>DRAM_DQM(0),
	sdRas_bo=>DRAM_RAS_N,
	sdWe_bo=>DRAM_WE_N,
	addr_i=>raddress,
   data_i=>data,
	done_o => data_out_valid,
	data_o=>data_output,
	rw_i=>req,
	we_i=>req_write,
	ub_i=>'1',
	lb_i=>'0'
	);
	
    raddress(23 downto 4)<=x"00000";
	 data(15 downto 2)<="00000000000000";
	 data_output(15 downto 2)<="00000000000000";
	 DRAM_CLK<=clk100;
	 
process(we,oe,req,req_write)
begin

--writing conditions
	 if(we='1' and oe='1') then 
      req<='0'; req_write<='0'; 
  elsif(we='0' and oe='1') then 
      req<='1'; req_write<='1'; 
  elsif(we='1' and oe='0') then  
      req<='1'; req_write<='0'; 
	end if;
end process;	 
	 --test pads
	 datatest<=data_output(1 downto 0);
	 btntest<=keypress;
	 
	 --Now starting the image gen part which has been a pain in my ass for a long time now. 
	 --I hope it works otherwise my cpi this sem is going to be very disappointing.
	 --I am just randomly writing comments so as to segregate this part of code from the rest.
	 --I am hungry.
	 --I think this much comments should be enough to make someone roll on the floor laughing their asses off(ROTFLMAO)
	 -- I'm a motherfucking starboy
	 
--x,y pixel cursor
x <=conv_integer(xp);
y <=conv_integer(yp);

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
	 
process(x,y, raddress,data,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f4,f15,f16,clk100)
begin
if(clk100'event and clk100='1') then
   if(x>20 and x<(20+size) and y>20 and y<(20+size)) then
		  f1<='1';
		  else f1<='0';
		  end if;
	if(x>130 and x<(130+size) and y>20 and y<(20+size)) then
		  f2<='1';
		  else f2<='0';
		  end if;
   if(x>240 and x<(240+size) and y>20 and y<(20+size)) then
		  f3<='1';
		  else f3<='0';
		  end if;
	if(x>350 and x<(350+size) and y>20 and y<(20+size)) then
		  f4<='1';
		  else f4<='0';
		  end if;
   if(x>20 and x<(20+size) and y>130 and y<(130+size)) then
		  f5<='1';
		  else f5<='0';
		  end if;
	if(x>130 and x<(130+size) and y>130 and y<(130+size)) then
		  f6<='1';
		  else f6<='0';
		  end if;
	if(x>240 and x<(240+size) and y>130 and y<(130+size)) then
		  f7<='1';
		  else f7<='0';
		  end if;
	if(x>350 and x<(350+size) and y>130 and y<(130+size)) then
		  f8<='1';
		  else f8<='0';
		  end if;
	if(x>20 and x<(20+size) and y>240 and y<(240+size)) then
		  f9<='1';
		  else f9<='0';
		  end if;
	if(x>130 and x<(130+size) and y>240 and y<(240+size)) then
		  f10<='1';
		  else f10<='0';
		  end if;
	if(x>240 and x<(240+size) and y>240 and y<(240+size)) then
		  f11<='1';
		  else f11<='0';
		  end if;
	if(x>350 and x<(350+size) and y>240 and y<(240+size)) then
		  f12<='1';
		  else f12<='0';
		  end if;
	if(x>20 and x<(20+size) and y>350 and y<(350+size)) then
		  f13<='1';
		  else f13<='0';
		  end if;
	if(x>130 and x<(130+size) and y>350 and y<(350+size)) then
		  f14<='1';
		  else f14<='0';
		  end if;
	if(x>240 and x<(240+size) and y>350 and y<(350+size)) then
		  f15<='1';
		  else f15<='0';
		  end if;
	if(x>350 and x<(350+size) and y>350 and y<(350+size)) then
		  f16<='1';
		  else f16<='0';
		  end if;
		  
if(data_output(1 downto 0)="00") then
  rgb_box<="010";
elsif(data_output(1 downto 0)="01") then
  rgb_box<="001";
elsif(data_output(1 downto 0)="10") then
  rgb_box<="100";
else rgb_box<="111";
end if;  

if(raddress(3 downto 0)="0001") then
  rgb_box1<=rgb_box;
elsif(raddress(3 downto 0)="0010") then
  rgb_box2<=rgb_box;
elsif(raddress(3 downto 0)="0011") then 
  rgb_box3<=rgb_box;
elsif(raddress(3 downto 0)="0100") then
  rgb_box4<=rgb_box;
elsif(raddress(3 downto 0)="0101") then
  rgb_box5<=rgb_box;
elsif(raddress(3 downto 0)="0110") then 
  rgb_box6<=rgb_box;
elsif(raddress(3 downto 0)="0111") then 
  rgb_box7<=rgb_box;
elsif(raddress(3 downto 0)="1000") then 
  rgb_box8<=rgb_box;
elsif(raddress(3 downto 0)="1001") then 
  rgb_box9<=rgb_box;
elsif(raddress(3 downto 0)="1010") then 
  rgb_box10<=rgb_box;
elsif(raddress(3 downto 0)="1011") then 
  rgb_box11<=rgb_box;  
elsif(raddress(3 downto 0)="1100") then 
  rgb_box12<=rgb_box;
elsif(raddress(3 downto 0)="1101") then 
  rgb_box13<=rgb_box;
elsif(raddress(3 downto 0)="1110") then 
  rgb_box14<=rgb_box;
elsif(raddress(3 downto 0)="1111") then 
  rgb_box15<=rgb_box;
elsif(raddress(3 downto 0)="0000") then 
  rgb_box16<=rgb_box; 
end if;
end if;
end process;
--buffer
process(clk100)
begin
     if clk100'event and clk100='1' then
         rgb_reg<=rgb_next;
     end if;
end process;

--mux
  vdbt<=video & grid_on & f1 & f2 & f3 & f4 & f5 & f6 & f7 & f8 & f9 & f10 & f11 & f12 & f13 & f14 & f15 & f16; 
  rgb_next <= "011" when vdbt="100000000000000000" else --Background of the screen is cyan 
              rgb_grid when (video='1' and grid_on='1') else
              --rgb_grid when vdbt="111" else
	           rgb_box1 when (video='1' and grid_on='0'and f1='1') else 
				  rgb_box2 when (video='1' and grid_on='0'and f2='1') else 
				  rgb_box3 when (video='1' and grid_on='0'and f3='1') else 
				  rgb_box4 when (video='1' and grid_on='0'and f4='1') else 
				  rgb_box5 when (video='1' and grid_on='0'and f5='1') else 
				  rgb_box6 when (video='1' and grid_on='0'and f6='1') else 
				  rgb_box7 when (video='1' and grid_on='0'and f7='1') else 
				  rgb_box8 when (video='1' and grid_on='0'and f8='1') else 
				  rgb_box9 when (video='1' and grid_on='0'and f9='1') else 
				  rgb_box10 when (video='1' and grid_on='0'and f10='1') else 
				  rgb_box11 when (video='1' and grid_on='0'and f11='1') else 
				  rgb_box12 when (video='1' and grid_on='0'and f12='1') else 
				  rgb_box13 when (video='1' and grid_on='0'and f13='1') else 
				  rgb_box14 when (video='1' and grid_on='0'and f14='1') else 
				  rgb_box15 when (video='1' and grid_on='0'and f15='1') else 
				  rgb_box16 when (video='1' and grid_on='0'and f16='1') else 
				  "000";
--output
rgb<=rgb_reg;  
 
  

end Behavioral;