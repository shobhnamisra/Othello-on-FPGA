library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sdram_test is
  port(
		CLOCK_50 : in std_logic;
   -- Host side
		clk_100m0_i : in std_logic; -- Master clock
		--reset_i     : in std_logic; -- Reset, active high
		--refresh  : in std_logic; -- Initiate a refresh cycle, active high
		--rw        : in std_logic; -- Initiate a read or write operation, active high
		--we        : in std_logic; -- Write enable, active low
		--addr_i      : in std_logic_vector(23 downto 0); -- Address from host to SDRAM
		--data_i      : in std_logic_vector(15 downto 0); -- Data from host to SDRAM
		--ube        : in std_logic; -- Data upper byte enable, active low
		--lbe        : in std_logic; -- Data lower byte enable, active low
		ready       : out std_logic; -- Set to '1' when the memory is ready
		done     : out std_logic; -- Read, write, or refresh, operation is done
		data_o      : out std_logic_vector(15 downto 0) -- Data from SDRAM to host
   
   
	);

end entity;

architecture behavioral of sdram_test is

component sdram_controller_whatever 
  Port ( -- Host side
		clk_100m0_i : in std_logic; -- Master clock
		reset_i     : in std_logic; -- Reset, active high
		refresh_i   : in std_logic; -- Initiate a refresh cycle, active high
		rw_i        : in std_logic; -- Initiate a read or write operation, active high
		we_i        : in std_logic; -- Write enable, active low
		addr_i      : in std_logic_vector(23 downto 0); -- Address from host to SDRAM
		data_i      : in std_logic_vector(15 downto 0); -- Data from host to SDRAM
		ub_i        : in std_logic; -- Data upper byte enable, active low
		lb_i        : in std_logic; -- Data lower byte enable, active low
		ready_o     : out std_logic; -- Set to '1' when the memory is ready
		done_o      : out std_logic; -- Read, write, or refresh, operation is done
		data_o      : out std_logic_vector(15 downto 0); -- Data from SDRAM to host
   
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
 signal  address:STD_LOGIC_VECTOR (23 downto 0);
 --signal  req_read:STD_LOGIC;
 signal  req_write:STD_LOGIC;
 signal  data_in:STD_LOGIC_VECTOR (15 downto 0);
 signal clk : std_logic;
 signal we : std_logic;
 signal rw : std_logic;
 signal ube : std_logic;
 signal lbe : std_logic;
 signal refresh : std_logic;
 
 begin 
 
 clkmap : sdram_clk_gen
  PORT MAP(inclk0=>CLOCK_50, c0=>clk);
  
 U: sdram_controller_whatever
 PORT MAP (
   clk_100m0_i=>clk,
	addr_i=>address,
	reset_i=>'0',
	rw_i=>rw,
	data_i=>data_in,
	done_o=>done,
	data_o=>data_o,
	ready_o=>ready,
	ub_i=>ube,
	lb_i=>lbe,
	refresh_i=>refresh,
	we_i=>we
	);
	
process
 begin
  rw<='1';
  we<='0';
  ube<='1';
  lbe<='0';
  address<="000000000000000000000001";
  data_in<="0000000000000001";
  refresh<='0';
  we<='1';
  --done<='1';
  --address<="000000000000000000000001";
 
 end process;
 
 end behavioral;