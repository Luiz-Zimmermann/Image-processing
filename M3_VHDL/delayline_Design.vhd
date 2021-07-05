------------------------------------------------
-- Design: Sliding Window
-- Entity: design
-- Author: Douglas Santos
-- Rev.  : 1.0
-- Date  : 04/30/2020
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity delayline_Design is
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
end entity;

architecture arch of delayline_Design is

  ---- COMPONENTS DECLARATION ----
  component slidingwindow_top
    generic (
      IMAGE_WIDTH   : integer;
      IMAGE_HEIGHT  : integer;
      WINDOW_WIDTH  : integer;
      WINDOW_HEIGHT : integer;
      PIXEL_WIDTH   : integer
    );
    port (
      i_VALID : in std_logic;
      i_PIX   : in std_logic;
  
      i_CLK   : in std_logic;
  
      o_PIX   : out std_logic_vector(8 downto 0)
    );
  end component;

begin
  i_SLIDING_WINDOW : slidingwindow_top
  generic map (
    IMAGE_WIDTH   => IMAGE_WIDTH,
    IMAGE_HEIGHT  => IMAGE_HEIGHT,
    WINDOW_WIDTH  => WINDOW_WIDTH,
    WINDOW_HEIGHT => WINDOW_HEIGHT,
    PIXEL_WIDTH   => PIXEL_WIDTH
  )
  port map (
    i_VALID => i_VALID,
    i_PIX   => i_PIX,

    i_CLK   => i_CLK,

    o_PIX   => o_PIX
  );
end architecture;
