library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sdram_test is
  port(
    CLOCK_50      : IN STD_LOGIC;
   
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

   data_out      : OUT     STD_LOGIC_VECTOR (31 downto 0);
   data_out_valid : OUT     STD_LOGIC
  
	);

end entity;

architecture behavioral of sdram_test is

component sdram_controller 
  Port ( clk           : in  STD_LOGIC;
           reset         : in  STD_LOGIC;
           
           -- Interface to issue reads or write data
           cmd_ready         : out STD_LOGIC;                     -- '1' when a new command will be acted on
           cmd_enable        : in  STD_LOGIC;                     -- Set to '1' to issue new command (only acted on when cmd_read = '1')
           cmd_wr            : in  STD_LOGIC;                     -- Is this a write?
           cmd_address       : in  STD_LOGIC_VECTOR(22 downto 0); -- address to read/write
           cmd_byte_enable   : in  STD_LOGIC_VECTOR(3 downto 0);  -- byte masks for the write command
           cmd_data_in       : in  STD_LOGIC_VECTOR(31 downto 0); -- data for the write command
           
           data_out          : out STD_LOGIC_VECTOR(31 downto 0); -- word read from SDRAM
           data_out_ready    : out STD_LOGIC;                     -- is new data ready?
           
           -- SDRAM signals
           SDRAM_CLK     : out   STD_LOGIC;
           SDRAM_CKE     : out   STD_LOGIC;
           SDRAM_CS      : out   STD_LOGIC;
           SDRAM_RAS     : out   STD_LOGIC;
           SDRAM_CAS     : out   STD_LOGIC;
           SDRAM_WE      : out   STD_LOGIC;
           SDRAM_DQM     : out   STD_LOGIC_VECTOR( 1 downto 0);
           SDRAM_ADDR    : out   STD_LOGIC_VECTOR(12 downto 0);
           SDRAM_BA      : out   STD_LOGIC_VECTOR( 1 downto 0);
           SDRAM_DATA    : inout STD_LOGIC_VECTOR(15 downto 0));
end component;

component sdram_clk_gen
  PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
end component;
 signal  address:STD_LOGIC_VECTOR (23 downto 0);
 --signal  req_read:STD_LOGIC;
 signal  req_write:STD_LOGIC;
 signal  data_in:STD_LOGIC_VECTOR (31 downto 0);
 signal clk : std_logic;
 
 begin 
 
 clkmap : sdram_clk_gen
  PORT MAP(inclk0=>CLOCK_50, c0=>clk);
  
 U: sdram_controller
 PORT MAP (
   clk=>clk,
	SDRAM_ADDR=>DRAM_ADDR,
	SDRAM_BA=>DRAM_BA,
	SDRAM_CAS=>DRAM_CAS_N,
	SDRAM_CKE=>DRAM_CKE,
	SDRAM_CLK=>DRAM_CLK,
	SDRAM_CS=>DRAM_CS_N,
	DRAM_DATA=>DRAM_DQ,
	DRAM_DQM=>DRAM_DQM,
	DRAM_RAS=>DRAM_RAS_N,
	DRAM_WE=>DRAM_WE_N,
	cmd_address=>address,
	cmd_ready=>'1', cmd_enable=>'1',
	cmd_byte_enable=>"1110",
	cmd_wr=>req_write,
	cmd_data_in=>data_in,
	data_out=>data_out,
	data_out_ready=>data_out_valid);
	
process
 begin
  req_write<='1';
  address<="000000000000000000000001";
  data_in<=x"00000001";
  req_write<='0';
  
  address<="000000000000000000000001";
 
 end process;
 
 end behavioral;