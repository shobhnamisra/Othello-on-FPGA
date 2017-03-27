----------------------------------------------------------------------------------
-- FPGA Design Using VHDL
-- Final Project
--
-- Authors: Eric Beales & James Frank
--
-- Description: Top level entity for project. Interfaces button and PS/2 keyboard 
--              driver input with game logic component, tracks current position, 
--              and generates VGA output using game board array and current player 
--              status.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.final_project_package.all;

entity final_project_top is port(
   clk50    : in  std_logic;
   button   : in  std_logic_vector(3 downto 0);
   ps2_data : in  std_logic;
   ps2_clk  : in  std_logic;
   vga      : out std_logic_vector(7 downto 0);
   vga_hs   : out std_logic;
   vga_vs   : out std_logic );
end final_project_top;

architecture behavioral of final_project_top is

   -- Keyboard constants.
   constant ARROW_U   : std_logic_vector(7 downto 0) := x"75";
   constant ARROW_R   : std_logic_vector(7 downto 0) := x"74";
   constant ARROW_D   : std_logic_vector(7 downto 0) := x"72";
   constant ARROW_L   : std_logic_vector(7 downto 0) := x"6B";
   constant ENTER     : std_logic_vector(7 downto 0) := x"5A";
   constant ESCAPE    : std_logic_vector(7 downto 0) := x"76";

   alias reset : std_logic is button(3);

   -- Counters for debouncing each button.
   signal clk_counter    : unsigned(19 downto 0);
   signal ten_ms_en      : std_logic;
   signal button_0_count : unsigned(2 downto 0);
   signal button_2_count : unsigned(2 downto 0);
   signal button_1_count : unsigned(2 downto 0);

   -- Setup the vga-related variables.
   signal h_count : unsigned(9 downto 0);
   signal v_count : unsigned(9 downto 0); 
   signal vga_en  : std_logic;

   -- Setup the game logic interface.
   signal current_player : std_logic := '0';
   signal game_board : byte_array(63 downto 0);
   signal current_position : unsigned(5 downto 0);
   signal play     : std_logic;
   signal logic_reset : std_logic;
   signal restart_game : std_logic := '0';

   -- Signals for keyboard.
   signal keyboard_data_available : std_logic;
   signal keyboard_data_out       : std_logic_vector(7 downto 0);

begin

   -- Reset game logic on full reset or on restart game signal
   logic_reset <= reset or restart_game;

   -- Take in any external inputs.
   process(clk50,reset)
      variable keyup : std_logic := '0';
   begin
      if(reset = '1') then
         current_position <= (others => '0');
         play <= '0';
         restart_game <= '0';
         button_0_count <= (others => '0');
         button_1_count <= (others => '0');
         button_2_count <= (others => '0');
         keyup := '0';

      elsif(rising_edge(clk50)) then
         -- Handle keyboard input if available
         if( keyboard_data_available = '1' ) then
            -- Ignore repeated keys
            if( keyboard_data_out = x"E0" ) then
               -- Beginning of BREAK code, prepare to ignore next input
               keyup := '1';
            elsif( keyup = '1' ) then
               -- This is a BREAK code, so ignore it
               keyup := '0';

            -- Handle navigational keys
            elsif( keyboard_data_out = ARROW_R ) then
               current_position <= current_position + 1;
            elsif( keyboard_data_out = ARROW_L ) then
               current_position <= current_position - 1;
            elsif( keyboard_data_out = ARROW_D ) then
               current_position <= current_position + 8;
            elsif( keyboard_data_out = ARROW_U ) then
               current_position <= current_position - 8;

            -- Handle play key
            elsif( keyboard_data_out = ENTER ) then
               play <= '1';
            -- Handle restart key
            elsif( keyboard_data_out = ESCAPE ) then
               current_position <= (others => '0');
               restart_game <= '1';
            end if;
         end if;

         if( ten_ms_en = '1' ) then

            -- Handle button 0 (increment current position)
            if(button(0) = '0') then
               button_0_count <= (others => '0');
            elsif( button_0_count = "100") then
               current_position <= current_position + 1;
               button_0_count <= (others => '1');
            elsif( button_0_count /= "111") then
               button_0_count <= button_0_count + 1;
            end if;
            
            -- Handle button 1 (decrement current position)
            if(button(1) = '0') then
               button_1_count <= (others => '0');
            elsif( button_1_count = x"4") then
               current_position <= current_position - 1;
               button_1_count <= (others => '1');
            elsif( button_1_count /= "111") then
               button_1_count <= button_1_count + 1;
            end if;

            -- Handle button 2 (Play - Interrupt Picoblaze)
            if(button(2) = '0') then
               button_2_count <= (others => '0');
            elsif( button_2_count = x"4") then
               play <= '1';
               button_2_count <= (others => '1');
            elsif( button_2_count /= "111") then
               button_2_count <= button_2_count + 1;
            end if;

         end if;

         -- Clear the play signal
         if play  = '1' then
            play <= '0';
         end if;
         
         -- Clear the restart game signal
         if restart_game  = '1' then
            restart_game <= '0';
         end if;

      end if;
   end process;

   -- 10 milliseconds clock scaler code.
   process(clk50, reset)
   begin
      if reset = '1' then -- Reset
         clk_counter <= (others => '0');
         ten_ms_en   <= '0';

      elsif rising_edge(clk50) then
         ten_ms_en <= '0';
         clk_counter <= clk_counter + 1;
         if clk_counter = 500000 then
            ten_ms_en <= '1';
            clk_counter <= (others => '0');
         end if;
      end if;
   end process;

   -- Generate the VGA enable signal (25 MHz)
   process(clk50,reset)
   begin
      if(reset = '1') then
         vga_en <= '0';
      elsif(rising_edge(clk50)) then
         vga_en <= vga_en xor '1';
      end if;
   end process;

   -- Count across the horizontal (0-799) and vertical (0-524) lines.
   process(clk50, reset)
   begin
      if(reset = '1') then
         h_count <= (others => '0');
         v_count <= (others => '0');

      elsif(rising_edge(clk50)) then
         if(vga_en = '1') then
            if(h_count <= x"31F") then
               h_count <= h_count + 1;
            else
               h_count <= (others => '0');
               if(v_count <= x"20C") then
                  v_count <= v_count + 1;
               else
                  v_count <= (others => '0');
               end if;
            end if;
         end if;
      end if;
   end process;

   -- Create Vsync and Hsync based on the vcount and hcount.
   vga_hs <= '0' when (h_count < x"60") else '1';
   vga_vs <= '0' when (v_count < x"02") else '1';

   -- Put out the pixel.
   process(h_count, v_count, current_position, current_player, game_board)
     variable hori_off     : unsigned(5 downto 0);
     variable vert_off     : unsigned(5 downto 0);
     variable block_number : unsigned(5 downto 0);
     variable display_enum : unsigned(3 downto 0);
     
   begin
      -- Put blank for pixels outside the gameboard. (syncs,porches,borders)
      if((h_count  < x"090") or (h_count >= x"310") or
         (v_count  < x"023") or (v_count >= x"203")) then
         vga <= "00000000"; -- Black

      -- Adding a single pixel border around the spaces
      elsif( h_count = x"2C0" or v_count = x"1C7" or
             h_count = x"270" or v_count = x"18B" or
             h_count = x"220" or v_count = x"14F" or
             h_count = x"1D0" or v_count = x"113" or
             h_count = x"180" or v_count = x"0D7" or
             h_count = x"130" or v_count = x"09B" or
             h_count = x"0E0" or v_count = x"05F" ) then
         vga <= "11000000"; -- Blue
         
      -- Show current player marker (16x16 square)
      elsif( h_count > x"2FA" and v_count > x"28" and 
             h_count < x"30A" and v_count < x"38" ) then
         if( current_player = '0' ) then
            vga <= "11111111"; -- White
         else
            vga <= "00000000"; -- Black
         end if;
         
      -- Add border around current player marker
      elsif( h_count >= x"2FA" and v_count >= x"28" and 
             h_count <= x"30A" and v_count <= x"38" ) then
         vga <= "11000000"; -- Blue

      else
         -- Calculate the horizontal block offset
         if   (h_count > x"2C0") then hori_off := "000111";
         elsif(h_count > x"270") then hori_off := "000110";
         elsif(h_count > x"220") then hori_off := "000101";
         elsif(h_count > x"1D0") then hori_off := "000100";
         elsif(h_count > x"180") then hori_off := "000011";
         elsif(h_count > x"130") then hori_off := "000010";
         elsif(h_count > x"0E0") then hori_off := "000001";
         else                         hori_off := "000000";
         end if;

         -- Calculate the vertical block offset
         if   (v_count > x"1C7") then vert_off := "111000";
         elsif(v_count > x"18B") then vert_off := "110000";
         elsif(v_count > x"14F") then vert_off := "101000";
         elsif(v_count > x"113") then vert_off := "100000";
         elsif(v_count > x"0D7") then vert_off := "011000";
         elsif(v_count > x"09B") then vert_off := "010000";
         elsif(v_count > x"05F") then vert_off := "001000";
         else                         vert_off := "000000";
         end if;

         -- Combine the vertical and horizontal into the block number (between 0 & 63).
         block_number := vert_off + hori_off;
         
         -- Grab the enum from the game board based on the current position.
         if (current_position = block_number) then
            display_enum := game_board(to_integer(block_number))(7 downto 4);
         else 
            display_enum := game_board(to_integer(block_number))(3 downto 0);
         end if;

         -- Put out the right color based on the enum.
         case display_enum is
            when x"0"         => vga <= "00000111"; -- Red (No Play)
            when SPACE_BOARD  => vga <= "00100000"; -- Green (Board)
            when SPACE_WHITE  => vga <= "11111111"; -- White
            when SPACE_BLACK  => vga <= "00000000"; -- Black
            when x"4"         => vga <= "11110111"; -- Light Pink (White Can Play)
            when x"5"         => vga <= "00000001"; -- Dark Pink (Black Can Play)
            when others       => vga <= "11000000"; -- Blue
         end case;
      end if;
   end process;
   
   -- Game logic interface
   logic : entity game_logic
   port map( clk => clk50,
             reset => logic_reset,
             play => play,
             current_player => current_player,
             game_board_out => game_board,
             current_position => current_position );

   -- Keyboard interface
   keyboard : entity ps2_keyboard 
   port map( reset => reset,
             clk => clk50,
             ps2_data => ps2_data,
             ps2_clk => ps2_clk,
             available => keyboard_data_available,
             out_byte => keyboard_data_out );

end behavioral;