library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sdram_test is
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

end entity;

architecture behavioral of sdram_test is

component sdram_controller 
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

component sdram_clk_gen
  PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
end component;

component main
  
end component;

 signal  address:STD_LOGIC_VECTOR (23 downto 0);
 signal  req_write:STD_LOGIC;
 signal req:std_logic;
 signal  data_in:STD_LOGIC_VECTOR (15 downto 0);
 signal clk : std_logic;
 signal dqm : std_logic_vector(1 downto 0);
 
 begin 
 
 clkmap : sdram_clk_gen
  PORT MAP(inclk0=>CLOCK_50, c0=>clk);
  
 U: sdram_controller
 PORT MAP (
   clk_100m0_i=>clk,
	sdaddr_o=>DRAM_ADDR,
	sdBs_o=>DRAM_BA,
	sdCas_bo=>DRAM_CAS_N,
	sdCke_o=>DRAM_CKE,
	sdCe_bo=>DRAM_CS_N,
	sdData_io=>DRAM_DQ,
	sdDqmh_o=>dqm(1),
	sdDqml_o=>dqm(0),
	sdRas_bo=>DRAM_RAS_N,
	sdWe_bo=>DRAM_WE_N,
	addr_i=>address,
   data_i=>data_in,
	done_o => data_out_valid,
	data_o=>data_out,
	rw_i=>req,
	we_i=>req_write,
	ub_i=>'1',
	lb_i=>'0'
	);
	
DRAM_DQM<=dqm;
DRAM_CLK<=clk;
address(23 downto 4)<=x"00000";
data_in(15 downto 2)<="00000000000000";

process(CLOCK_50)
begin
	
  if(we='1' and oe='1') then 
      req<='0'; req_write<='0'; 
  elsif(we='0' and oe='1') then 
      req<='1'; req_write<='1'; 
      address(3 downto 0)<=raddr;
      data_in(1 downto 0)<=data;
  elsif(we='1' and oe='0') then  
      req<='1'; req_write<='0'; 
      address(3 downto 0)<=raddr;
  end if;
end process;

 
 end behavioral;