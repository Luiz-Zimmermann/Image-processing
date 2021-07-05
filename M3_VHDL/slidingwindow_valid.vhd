------------------------------------------------
-- Design: Sliding Window
-- Entity: slidingwindow_valid
-- Author: Douglas Santos
-- Rev.  : 1.0
-- Date  : 21/05/2020
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slidingwindow_valid is
  generic (
    IMAGE_WIDTH   : integer := 256;
    IMAGE_HEIGHT  : integer := 256;
    WINDOW_WIDTH  : integer := 3;
    WINDOW_HEIGHT : integer := 3
  );
  port (
	 i_addr 	: in std_logic_vector(15 downto 0);
    o_VALID : out std_logic
  );
end entity;

architecture arch of slidingwindow_valid is

  signal w_MOD  : std_logic_vector(15 downto 0);

begin

  -- calcula a posicao na coluna do ultimo pixel
  w_MOD <= std_logic_vector((unsigned(i_addr)) mod IMAGE_WIDTH);
  
  -- seta a saida valida quando o contador obedecer as duas condicoes:
  --   contador passou das linhas iniciais invalidas
  --   contador nao esta nas colunas iniciais invalidas
  o_VALID <= '1' when unsigned(i_addr) >= ((WINDOW_HEIGHT-1) * IMAGE_WIDTH + WINDOW_WIDTH) and
                          unsigned(w_MOD)     >= (WINDOW_WIDTH-1)
             else '0';
  
  
end architecture;