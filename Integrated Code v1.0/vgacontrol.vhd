library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vgacontrol is
     Port ( clk : in STD_LOGIC;
                rgb : out STD_LOGIC_VECTOR (2 downto 0);
                hsn : out STD_LOGIC;
                vsn : out STD_LOGIC;
					 row : in STD_LOGIC_VECTOR(3 downto 0);
					 col : out STD_LOGIC_VECTOR(3 downto 0);
					 lederror : out STD_LOGIC;
					 data_out_valid:out std_logic;
					 
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
				data 			: INOUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => 'Z') --This is the bidirectional data bus to/from SRAM
				);
		END COMPONENT;
		
		COMPONENT img_gen
		     Port ( clk:in std_logic;
	         x_control : in std_logic_vector(9 downto 0);
				y_control : in std_logic_vector(9 downto 0);
				rgb : out std_logic_vector(2 downto 0);
				addr : in std_logic_vector(3 downto 0);
				user : in std_logic_vector(1 downto 0);
				video_on : in std_logic);
	   END COMPONENT;
		
		COMPONENT sdram_test
		     port(
    CLOCK_50      : IN STD_LOGIC;
	 
	 --from main
	 raddr : in std_logic_vector(3 downto 0);
	 data : inout std_logic_vector(1 downto 0);
	 we : in std_logic;
	 oe : in std_logic;
   
   -- Signals to/from the SDRAM chip
   DRAM_ADDR   : OUT   STD_LOGIC_VECTOR (12 downto 0);
   DRAM_BA      : OUT   STD_LOGIC_VECTOR (1 downto 0);
   DRAM_CAS_N   : OUT   STD_LOGIC;
   DRAM_CKE      : OUT   STD_LOGIC;
   DRAM_CLK      : OUT   STD_LOGIC;
   DRAM_CS_N   : OUT   STD_LOGIC;
   DRAM_DQ      : INOUT STD_LOGIC_VECTOR(15 downto 0);
   DRAM_DQM      : OUT   STD_LOGIC_VECTOR(1 downto 0);
   DRAM_RAS_N   : OUT   STD_LOGIC;
   DRAM_WE_N    : OUT   STD_LOGIC;
   
   --- Inputs from rest of the system
   data_out : out std_logic_vector(15 downto 0);
   data_out_valid : OUT     STD_LOGIC
  
	);
	END COMPONENT;

     --buffer
     --signal sw_next:STD_LOGIC_VECTOR (2 downto 0);
     signal video:std_logic;
	  signal baddress:std_logic_vector(3 downto 0);
	  signal raddress:std_logic_vector(3 downto 0);
	  signal x,y:std_logic_vector(9 downto 0);
	  signal keypress:std_logic;
	  signal userdata: std_logic_vector(1 downto 0);
	  signal oe : std_logic;
	  signal we : std_logic;
	  signal data : std_logic_vector(1 downto 0);
begin
     
	  Inst_Keypad_Input: Keypad_Input PORT MAP(sys_clk=>clk, resetn => '1', btn=>keypress, baddr => baddress, row=>row, col=>col );     

	 
     Inst_sync_mod: sync_mod PORT MAP( clk => clk, reset => '0', start => '1', y_control => y, x_control => x,
                                                                         h_s => hsn, v_s => vsn, video_on => video );

	 Inst_main: main PORT MAP(clk=>clk, button=>keypress , reset=>'0',error=>lederror,pass=>'1',baddr=>baddress,user=>userdata, oe=>oe,we=>we,raddr=>raddress,data=>data );																							 
		
	
	 Inst_img_gen: img_gen PORT MAP( clk => clk, x_control => x, y_control => y, rgb=>rgb, addr=>raddress, user=>data, video_on => video );
     

	 Inst_sdram_test : sdram_test PORT MAP(CLOCK_50=>clk,
	                                       raddr=>raddress, data=>data, oe=>oe,we=>we,data_out_valid=>data_out_valid, data_out(1 downto 0)=>data,
														DRAM_ADDR=>DRAM_ADDR,DRAM_BA=>DRAM_BA,DRAM_CAS_N =>DRAM_CAS_N,  
                                          DRAM_CKE=>DRAM_CKE,DRAM_CLK=>DRAM_CLK,DRAM_CS_N=>DRAM_CS_N,DRAM_DQ=>DRAM_DQ,
								                  DRAM_DQM=>DRAM_DQM,DRAM_RAS_N=>DRAM_RAS_N,DRAM_WE_N=>DRAM_WE_N);    
														
	

end Behavioral;