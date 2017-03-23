library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vgacontrol is
     Port ( clk : in STD_LOGIC;
                --sw : in STD_LOGIC_VECTOR (2 downto 0);
                rgb : out STD_LOGIC_VECTOR (2 downto 0);
                hsn : out STD_LOGIC;
                vsn : out STD_LOGIC;
					 button : in STD_LOGIC;
					 row : in STD_LOGIC_VECTOR(3 downto 0);
					 col : out STD_LOGIC_VECTOR(3 downto 0));
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
                  button : out std_logic;
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

     --buffer
     --signal sw_next:STD_LOGIC_VECTOR (2 downto 0);
     signal video:std_logic;
	  signal baddress:std_logic_vector(3 downto 0);
	  signal x,y:std_logic_vector(9 downto 0);
	  signal keypress:std_logic;
	  signal user: std_logic_vector(1 downto 0);
begin
     keypress<=button;
	  
     Inst_Keypad_Input: Keypad_Input PORT MAP(sys_clk => clk, resetn => '0', button => keypress, baddr => baddress, row=>row, col=>col );     

     Inst_sync_mod: sync_mod PORT MAP( clk => clk, reset => '0', start => '1', y_control => y, x_control => x,
                                                                         h_s => hsn, v_s => vsn, video_on => video );

	 Inst_main: main PORT MAP(clk=>clk, , reset=>'1',pass=>'1',baddr=>baddress, user=>user );																							 
		
     rgb<= "100" when video = '0' else
                  "010" ;

end Behavioral;