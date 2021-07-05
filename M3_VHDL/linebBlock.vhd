library ieee;
use ieee.std_logic_1164.all;

entity linebBlock is
port(	i_CLK : in std_logic;
		i_pixels : in std_logic;			
		i_valid : in std_logic;
		
		o_pixel  : out std_logic_vector(8 downto 0)
);
end linebBlock;

architecture arch of linebBlock is


component delayline_Design is

  generic (
    IMAGE_WIDTH   : integer := 256;
    IMAGE_HEIGHT  : integer := 256;
    WINDOW_WIDTH  : integer := 3;
    WINDOW_HEIGHT : integer := 3;
    PIXEL_WIDTH   : integer := 1
  );
  port (
    i_VALID  : in std_logic;
    i_PIX    : in std_logic;
    i_CLK    : in std_logic;
    o_PIX   : out std_logic_vector(8 downto 0)
  );
end component;


signal w_pixels : std_logic_vector(8 downto 0);
signal w_in_pixel : std_logic;

begin
	
																																	 
	u_delayline : delayline_Design port map (i_VALID => i_valid,
														 i_PIX   => i_pixels,
														 i_CLK   => i_CLK,
														 o_PIX   =>  o_pixel);										 
					
end arch;

