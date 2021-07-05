------------------------------------------------
-- Design: D-type flip-flop with enable
-- Entity: dff
-- Author: Cesar Zeferino
-- Rev.  : 1.0
-- Date  : 04/15/2020
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity register9bits_RST is
port ( i_CLR_n : in  std_logic;  -- clear/reset
       i_CLK   : in  std_logic;  -- clock
       i_LD  : in  std_logic;  -- load
       i_D     : in  std_logic_vector (8 downto 0);  -- data input
       o_Q     : out std_logic_vector (8 downto 0)); -- data output
end register9bits_RST;


architecture arch_1 of register9bits_RST is
begin
  process(i_CLR_n,i_CLK) 
  begin
    if (i_CLR_n ='0') then
      o_Q <= (others =>'0');
	elsif (rising_edge(i_CLK)) then
      if (i_LD= '1') then
         o_Q <= i_D;
      end if;
    end if;
  end process;
end arch_1;
