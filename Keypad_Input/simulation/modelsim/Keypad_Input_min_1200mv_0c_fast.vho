-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"

-- DATE "03/09/2017 20:13:19"

-- 
-- Device: Altera EP4CE22F17C6 Package FBGA256
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_ASDO_DATA1~	=>  Location: PIN_C1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_FLASH_nCE_nCSO~	=>  Location: PIN_D2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DCLK~	=>  Location: PIN_H1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DATA0~	=>  Location: PIN_H2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCEO~	=>  Location: PIN_F16,	 I/O Standard: 2.5 V,	 Current Strength: 8mA


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~padout\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~padout\ : std_logic;
SIGNAL \~ALTERA_DATA0~~padout\ : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_DATA0~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	Keypad_Input IS
    PORT (
	data_in1 : IN std_logic;
	data_in2 : IN std_logic;
	data_in3 : IN std_logic;
	data_in4 : IN std_logic;
	data_in5 : IN std_logic;
	data_in6 : IN std_logic;
	data_in7 : IN std_logic;
	data_in8 : IN std_logic;
	enable : IN std_logic;
	green_led1 : OUT std_logic;
	green_led2 : OUT std_logic;
	green_led3 : OUT std_logic;
	green_led4 : OUT std_logic;
	green_led5 : OUT std_logic;
	green_led6 : OUT std_logic;
	green_led7 : OUT std_logic;
	green_led8 : OUT std_logic
	);
END Keypad_Input;

-- Design Ports Information
-- green_led1	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- green_led2	=>  Location: PIN_J13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- green_led3	=>  Location: PIN_G16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- green_led4	=>  Location: PIN_L16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- green_led5	=>  Location: PIN_F14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- green_led6	=>  Location: PIN_G15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- green_led7	=>  Location: PIN_F1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- green_led8	=>  Location: PIN_E10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in1	=>  Location: PIN_E16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- enable	=>  Location: PIN_J15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in2	=>  Location: PIN_E15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in3	=>  Location: PIN_J16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in4	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in5	=>  Location: PIN_N14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in6	=>  Location: PIN_K16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in7	=>  Location: PIN_K15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- data_in8	=>  Location: PIN_F13,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF Keypad_Input IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_data_in1 : std_logic;
SIGNAL ww_data_in2 : std_logic;
SIGNAL ww_data_in3 : std_logic;
SIGNAL ww_data_in4 : std_logic;
SIGNAL ww_data_in5 : std_logic;
SIGNAL ww_data_in6 : std_logic;
SIGNAL ww_data_in7 : std_logic;
SIGNAL ww_data_in8 : std_logic;
SIGNAL ww_enable : std_logic;
SIGNAL ww_green_led1 : std_logic;
SIGNAL ww_green_led2 : std_logic;
SIGNAL ww_green_led3 : std_logic;
SIGNAL ww_green_led4 : std_logic;
SIGNAL ww_green_led5 : std_logic;
SIGNAL ww_green_led6 : std_logic;
SIGNAL ww_green_led7 : std_logic;
SIGNAL ww_green_led8 : std_logic;
SIGNAL \green_led1~output_o\ : std_logic;
SIGNAL \green_led2~output_o\ : std_logic;
SIGNAL \green_led3~output_o\ : std_logic;
SIGNAL \green_led4~output_o\ : std_logic;
SIGNAL \green_led5~output_o\ : std_logic;
SIGNAL \green_led6~output_o\ : std_logic;
SIGNAL \green_led7~output_o\ : std_logic;
SIGNAL \green_led8~output_o\ : std_logic;
SIGNAL \enable~input_o\ : std_logic;
SIGNAL \data_in1~input_o\ : std_logic;
SIGNAL \LED1~0_combout\ : std_logic;
SIGNAL \data_in2~input_o\ : std_logic;
SIGNAL \LED2~0_combout\ : std_logic;
SIGNAL \data_in3~input_o\ : std_logic;
SIGNAL \LED3~0_combout\ : std_logic;
SIGNAL \data_in4~input_o\ : std_logic;
SIGNAL \LED4~0_combout\ : std_logic;
SIGNAL \data_in5~input_o\ : std_logic;
SIGNAL \LED5~0_combout\ : std_logic;
SIGNAL \data_in6~input_o\ : std_logic;
SIGNAL \LED6~0_combout\ : std_logic;
SIGNAL \data_in7~input_o\ : std_logic;
SIGNAL \LED7~0_combout\ : std_logic;
SIGNAL \data_in8~input_o\ : std_logic;
SIGNAL \LED8~0_combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_data_in1 <= data_in1;
ww_data_in2 <= data_in2;
ww_data_in3 <= data_in3;
ww_data_in4 <= data_in4;
ww_data_in5 <= data_in5;
ww_data_in6 <= data_in6;
ww_data_in7 <= data_in7;
ww_data_in8 <= data_in8;
ww_enable <= enable;
green_led1 <= ww_green_led1;
green_led2 <= ww_green_led2;
green_led3 <= ww_green_led3;
green_led4 <= ww_green_led4;
green_led5 <= ww_green_led5;
green_led6 <= ww_green_led6;
green_led7 <= ww_green_led7;
green_led8 <= ww_green_led8;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X53_Y22_N2
\green_led1~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED1~0_combout\,
	devoe => ww_devoe,
	o => \green_led1~output_o\);

-- Location: IOOBUF_X53_Y16_N9
\green_led2~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED2~0_combout\,
	devoe => ww_devoe,
	o => \green_led2~output_o\);

-- Location: IOOBUF_X53_Y20_N23
\green_led3~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED3~0_combout\,
	devoe => ww_devoe,
	o => \green_led3~output_o\);

-- Location: IOOBUF_X53_Y11_N9
\green_led4~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED4~0_combout\,
	devoe => ww_devoe,
	o => \green_led4~output_o\);

-- Location: IOOBUF_X53_Y24_N23
\green_led5~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED5~0_combout\,
	devoe => ww_devoe,
	o => \green_led5~output_o\);

-- Location: IOOBUF_X53_Y20_N16
\green_led6~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED6~0_combout\,
	devoe => ww_devoe,
	o => \green_led6~output_o\);

-- Location: IOOBUF_X0_Y23_N2
\green_led7~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED7~0_combout\,
	devoe => ww_devoe,
	o => \green_led7~output_o\);

-- Location: IOOBUF_X45_Y34_N16
\green_led8~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \LED8~0_combout\,
	devoe => ww_devoe,
	o => \green_led8~output_o\);

-- Location: IOIBUF_X53_Y14_N1
\enable~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_enable,
	o => \enable~input_o\);

-- Location: IOIBUF_X53_Y17_N8
\data_in1~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in1,
	o => \data_in1~input_o\);

-- Location: LCCOMB_X52_Y20_N8
\LED1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED1~0_combout\ = (\enable~input_o\ & \data_in1~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \enable~input_o\,
	datad => \data_in1~input_o\,
	combout => \LED1~0_combout\);

-- Location: IOIBUF_X53_Y17_N1
\data_in2~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in2,
	o => \data_in2~input_o\);

-- Location: LCCOMB_X52_Y20_N18
\LED2~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED2~0_combout\ = (\data_in2~input_o\ & \enable~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \data_in2~input_o\,
	datad => \enable~input_o\,
	combout => \LED2~0_combout\);

-- Location: IOIBUF_X53_Y14_N8
\data_in3~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in3,
	o => \data_in3~input_o\);

-- Location: LCCOMB_X52_Y16_N8
\LED3~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED3~0_combout\ = (\enable~input_o\ & \data_in3~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \enable~input_o\,
	datad => \data_in3~input_o\,
	combout => \LED3~0_combout\);

-- Location: IOIBUF_X53_Y22_N8
\data_in4~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in4,
	o => \data_in4~input_o\);

-- Location: LCCOMB_X52_Y19_N8
\LED4~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED4~0_combout\ = (\enable~input_o\ & \data_in4~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \enable~input_o\,
	datac => \data_in4~input_o\,
	combout => \LED4~0_combout\);

-- Location: IOIBUF_X53_Y6_N22
\data_in5~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in5,
	o => \data_in5~input_o\);

-- Location: LCCOMB_X52_Y19_N2
\LED5~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED5~0_combout\ = (\data_in5~input_o\ & \enable~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \data_in5~input_o\,
	datad => \enable~input_o\,
	combout => \LED5~0_combout\);

-- Location: IOIBUF_X53_Y12_N1
\data_in6~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in6,
	o => \data_in6~input_o\);

-- Location: LCCOMB_X52_Y15_N24
\LED6~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED6~0_combout\ = (\enable~input_o\ & \data_in6~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010000010100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \enable~input_o\,
	datac => \data_in6~input_o\,
	combout => \LED6~0_combout\);

-- Location: IOIBUF_X53_Y13_N8
\data_in7~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in7,
	o => \data_in7~input_o\);

-- Location: LCCOMB_X52_Y19_N12
\LED7~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED7~0_combout\ = (\data_in7~input_o\ & \enable~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \data_in7~input_o\,
	datad => \enable~input_o\,
	combout => \LED7~0_combout\);

-- Location: IOIBUF_X53_Y21_N22
\data_in8~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_data_in8,
	o => \data_in8~input_o\);

-- Location: LCCOMB_X52_Y21_N0
\LED8~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \LED8~0_combout\ = (\enable~input_o\ & \data_in8~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \enable~input_o\,
	datad => \data_in8~input_o\,
	combout => \LED8~0_combout\);

ww_green_led1 <= \green_led1~output_o\;

ww_green_led2 <= \green_led2~output_o\;

ww_green_led3 <= \green_led3~output_o\;

ww_green_led4 <= \green_led4~output_o\;

ww_green_led5 <= \green_led5~output_o\;

ww_green_led6 <= \green_led6~output_o\;

ww_green_led7 <= \green_led7~output_o\;

ww_green_led8 <= \green_led8~output_o\;
END structure;


