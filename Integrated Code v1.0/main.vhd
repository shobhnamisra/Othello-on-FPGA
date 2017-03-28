LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY main IS
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
				datai			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => 'Z');
				datao			: IN STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
				
				
END main;

ARCHITECTURE Behavioral OF main IS

	--STATE MACHINE STATES FOR SRAM--------------------------------------------------------
	TYPE SRAM_STATES IS (idle, w, r, r_end);
	SIGNAL SRAM, SRAM_NEXT : SRAM_STATES := idle;
	---------------------------------------------------------------------------------------
	
	--STAE MACHINE STATES FOR GAME---------------------------------------------------------
	TYPE GAME_STATES IS (idle, human_delay, reset_all, check_empty, change_user, 
								check_direction, check_change, green, change_square, valid_move);
	SIGNAL GAME, GAME_NEXT : GAME_STATES := reset_all; --Start at reset
	---------------------------------------------------------------------------------------

	SIGNAL selAddr : STD_LOGIC_VECTOR(3 downto 0) := "0000"; --This is the address of the button pushed on the board
	SIGNAL tempAddr : STD_LOGIC_VECTOR (3 downto 0) := "0000"; --This is the address that will be read and written from/to SRAM
	SIGNAL tempData : STD_LOGIC_VECTOR(1 downto 0) := "00"; --This is the data that is read from SRAM
	SIGNAL increment : STD_LOGIC_VECTOR(3 downto 0) := "0000"; --This will be hardcoded for different directions to travel. It will be +- 1 to travel left/right and +-8 to travel up down...
	SIGNAL direction : STD_LOGIC_VECTOR (2 downto 0) := "000"; --This determines the direction of search for a capture. 3 bits for 8 directions
	SIGNAL valid_flag : STD_LOGIC := '0'; --This is used in determining if a valid capture has been found
	
BEGIN


	--#######################################################################################
	--This process acts the on the rising edge to trigger updates to the states of the FSMs in
	--the next process.
	PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk = '1') THEN
			SRAM <= SRAM_NEXT; --Update GAME state
			GAME <= GAME_NEXT; --Update SRAM state
		END IF;
	END PROCESS;
	--########################################################################################
	
	
	--########################################################################################
	--This 8x6 bit ROM is used to easily go through all the different directions to search for
	--a valid capture. It is update immediatly whenever direction is incremented.
	
	WITH direction SELECT
		increment <= "1100" WHEN "000", --up					(-4)
						 "0100" WHEN "001", --down 				( 4)
						 "1111" WHEN "010", --left				(-1)
						 "0001" WHEN "011", --right 			( 1)
						 "1011" WHEN "100", --upper left		(-5)
						 "1101" WHEN "101", --upper right		(-3)
						 "0011" WHEN "110", --lower left		( 3)
						 "0101" WHEN "111", --lower right		( 5)
						 "0000" WHEN OTHERS;
	--########################################################################################
						 
						 
						 
	--###############################################################################################
	--This process is the last section in this code. It contains all Reversi Game logic and the
	--logic to read and write from the SRAM. It is partitioned in 2 distinct Finite State Machines:
	--GAME FSM, and SRAM FSM. 
	--
	--The SRAM FSM sits idle (write disabled, output disabled) until the
	--GAME FSM changes its state to either read or write to it. When it is set to write, it will 
	--send the address in 'tempAddr' to the SRAM and the write the data in 'user'. It will then
	--return to idle mode. When read is selected, it will send the address in 'tempAddr' to SRAM 
	--and put whatever data recieved into 'tempData' and return to idle mode.
	--
	--The GAME FSM will only act IF THE SRAM FSM IS IN IDLE MODE!! It will wait for any read
	--or write command to finish before it continues. It also starts in an idle mode where it 
	--waits for human input. It listens for any board button press, reset button press, or pass
	--button press. 
	--
	--When the reset button is pressed, it goes into 'reset_all' mode where it will
	--count from "000000" to "111111" and write to each address. With the exception for 4 addresses, 
	--the data written will be "00". On these other 4 addresses, 2 will be user 1 and 2 will be user
	--2. It then waits until user is not pushing any more buttons and then returns to idle. mode.
	--
	--When the pass button is pressed, it will go to change_user mode and then wait for no more
	--user input and the go to idle mode. 
	--
	--When the board button is pressed, it will store the address pushed and read from SRAM.
	--If the location contains anything other than "00", then it will display an error light and
	--wait for no more user input and then return to idle mode. If the location is empty, it will
	--then start looking in 8 directions, 1 at a time. If it finds a sequence (1 or more) of the 
	--other user's pieces directly after the button pressed and then finds a user's piece, it will
	--flip all of the pieces in between and assign the button pressed to the user. It then proceeds
	--in the next direction. If the above sequence is not found exactly, then it proceeds to look
	--in the next direction. After all 8 directions have been searched, it again reads the button 
	--pressed from SRAM. Now, if the location is empty, an invalid move has been tried so it displays
	--an error light and DOES NOT change the user and then waits for no more user input and then 
	--returns to idle mode. If the data read belongs to the user, then a valid move has been made and
	--it turns off any error light, waits for no more user input and then returns to idle mode.
	-------------------------------------------------------------------------------------------------
	PROCESS(clk)
	BEGIN
		IF(clk'EVENT AND clk = '0') THEN		--Only acts on rising edge
			
			IF(SRAM = idle AND SRAM_NEXT = idle) THEN --Only updates the Game if the SRAM is idle						
				
				CASE GAME IS
						
					--IDLE CASE-----------------------------------------------------------------
					WHEN idle => --Waits for user input
					
						IF(reset = '0') THEN
							tempAddr <= "0000";
							user <= "00"; --Set to 00 to clear all sqaures
							error <= '0'; --Clear any invalid move light
							SRAM_NEXT <= w; -- So it will reset "000000" also
							GAME_NEXT <= reset_all;
							
						ELSIF(button = '1') THEN
							tempAddr <=  baddr; --store the pushed address
							GAME_NEXT <= check_empty; --check the address once read
							SRAM_NEXT <= r; --read the pushed address from SRAM
							
						ELSIF(pass = '0') THEN
							GAME_NEXT <= change_user;
						END IF;	
					----------------------------------------------------------------------------


					--RESET_ALL CASE------------------------------------------------------------	
					WHEN reset_all =>
						SRAM_NEXT <= w; --Write to the box


						--The address are -1 because it increments 1 at the end of this Case
						CASE tempAddr IS
							WHEN "0101" => --Initialize player 1's pieces
								user <= "01";
							WHEN "1011" => --Initialize player 1's pieces
								user <= "01";								
								
							WHEN "0110" => --initialize player 2's pieces
								user <= "10";
							WHEN "1010" => --initialize player 2's pieces
								user <= "10";
								
							WHEN "1111" => --Quit condition: we have traveled through all the pieces
								user <= "01";
								SRAM_NEXT <= idle;--lose
								GAME_NEXT <= human_delay;
								
							WHEN OTHERS => --Clear values in every other spot
								user <= "00";
						END CASE;
					
						tempAddr <= tempAddr + 1; --Go to next box	
					----------------------------------------------------------------------------																																								------------------------------------------------
						
					
					--CHECK_EMPTY CASE----------------------------------------------------------
					WHEN check_empty => --Make sure the location is originally empty before it proceeds
						IF(tempData = "00") THEN
							selAddr <= tempAddr; --Initialize the board address
							direction <= "000"; --Make sure direction counter is reset
							valid_flag <= '0'; --lose change below
							GAME_NEXT <= check_change; --If empty then start searching for a flip
						ELSE
							error <= '1'; --If it is not empty then write an invalid move
							GAME_NEXT <= human_delay;
						END IF;
					----------------------------------------------------------------------------
				

					--CHECK_DIRECTION CASE---------------------------------------------------
					WHEN check_direction =>
						valid_flag <= '0'; --reset the valid flag
						GAME_NEXT <= check_change;
						tempAddr <= selAddr; --move back to the address to look for the next piece
						
						IF(direction = "111") THEN --It will be true AFTER it has search direction "111"
							SRAM_NEXT <= r; --After all changing is done, it will read the value to see if it is changed
							GAME_NEXT <= valid_move;
						END IF;
						
						direction <= direction + 1; --check the next direction
					-------------------------------------------------------------------------
	
				
					--CHECK_CHANGE CASE------------------------------------------------------
					WHEN check_change =>
						tempAddr <= tempAddr + increment; --Increment the address counter
						GAME_NEXT <= green; --Go back to evaluate the data
						SRAM_NEXT <= r; --Read the data
					--------------------------------------------------------------------------
					
					
					--GREEN CASE--------------------------------------------------------------
					WHEN green =>
						IF(tempData = NOT user) THEN --The spot belongs to the other player
							valid_flag <= '1';
							GAME_NEXT <= check_change;
							
						ELSIF(tempData = user) THEN --It is the player's spot
							IF(valid_flag = '1') THEN
								GAME_NEXT <= change_square; --Dont looking this direction but found squares to change
							ELSE
								GAME_NEXT <= check_direction; --Done looking this direction
							END IF;
						ELSE --It is no ones spot
							GAME_NEXT <= check_direction; --Dont looking this direction
						END IF;
					----------------------------------------------------------------------------
					
					
					--CHANGE_SQUARE CASE--------------------------------------------------------
					WHEN change_square =>
						IF(tempAddr /= selAddr) THEN --If there are still more boxes to change
							SRAM_NEXT <= w;
							tempAddr <= tempAddr - increment; --Go backwards through the 
						ELSE
							GAME_NEXT <= check_direction;
						END IF;
					----------------------------------------------------------------------------

					
					--VALID_MOVE CASE-----------------------------------------------------------
					WHEN valid_move =>
						IF(tempData = "00") THEN --After all checking and flipping, the value has not changed
							error <= '1'; --send an error light
							GAME_NEXT <= human_delay; 
						ELSE
							error <= '0'; --Turn error light off because the value has been changed
							GAME_NEXT <= change_user; --Change user only on a valid switch
						END IF; 
					----------------------------------------------------------------------------
					
					
					--CHANGE_USER CASE----------------------------------------------------------
					WHEN change_user =>
						user <= NOT user;
						GAME_NEXT <= human_delay;
					----------------------------------------------------------------------------


					--HUMAN_DELAY CASE-----------------------------------------------------------	
					WHEN human_delay => --Must wait until human has let go of button before contiuing
						IF(button = '0' AND reset = '1' AND pass = '1') THEN
							GAME_NEXT <= idle;
						END IF;
					----------------------------------------------------------------------------
					
						
					--OTHERS CASE----------------------------------------------------------------
					WHEN OTHERS =>
						GAME_NEXT <= human_delay;
					-----------------------------------------------------------------------------	
				
				END CASE;
			END IF; --//The if to make sure SRAM is idle
			--END GAME FINITE STATE MACHINE
			--####################################################################################

			
			
			--####################################################################################
			--START SRAM FINITE STATE MACHINE
			CASE SRAM IS
				
				--IDLE CASE---------------------------------------------------------------------
				WHEN idle =>
					we <= '1'; --turn off write enable
					oe <= '1'; --turn off read enable
					raddr <= tempAddr; --send the address
					datao <= user; --send the data
					
				--------------------------------------------------------------------------------
				
				
				--W (WRITE) CASE----------------------------------------------------------------
				WHEN w =>
					we <= '0'; --turn on write enable
					oe <= '1'; --turn off output enable
					raddr <= tempAddr; --send address
					datai <= user; --send data
					
					SRAM_NEXT <= idle;
				--------------------------------------------------------------------------------
				
				
				--R (READ) CASE-----------------------------------------------------------------
				WHEN r =>
					we <= '1'; --turn off write enable
					oe <= '0'; --turn on output enable 
					raddr <= tempAddr; --send address
					datai <= (OTHERS => 'Z'); --stop forcing data so data may be read
					
					SRAM_NEXT <= r_end; --finish reading
				--------------------------------------------------------------------------------	
				
				
				--R_END CASE--------------------------------------------------------------------
				WHEN r_end =>
					tempData <= datai; --get data from bus
					we <= '1'; --turn off write enable
					oe <= '0'; --turn on output enable
					raddr <= tempAddr; --keep sending address
					datai <= (OTHERS => 'Z'); --stop forcing data
					
					SRAM_NEXT <= idle; 
				--------------------------------------------------------------------------------
				
				
				--OTHERS CASE-------------------------------------------------------------------
				WHEN OTHERS =>
					we <= '1';
					oe <= '1';
					raddr <= "0000";
					datai <= (OTHERS => 'Z');
					
					SRAM_NEXT <= idle;
				--------------------------------------------------------------------------------	
				
			END CASE;
			--END SRAM FINITE STATE MACHINE
			--##################################################################################
			
		END IF; --End the falling edge clock if 
							
	END PROCESS;
	--################################################################################
				
	
END Behavioral; 
