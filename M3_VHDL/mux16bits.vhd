------------------------------------------------
-- Design: Demux
-- Entity: demux1_2bit
-- Author: Luiz Zimmermann
-- Rev.  : 1.0
-- Date  : 03/27/2020
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux16bits is
port ( i_SEL : in  std_logic;  -- selector
       i_A   : in  std_logic_vector(15 downto 0);  -- data input
       i_B   : in  std_logic_vector(15 downto 0);  -- data input
       o_S   : out std_logic_vector(15 downto 0)); -- data output
end mux16bits;


architecture arch_1 of mux16bits is
begin
  process(i_SEL, i_A, i_B) 
  begin
    if (i_SEL='0') then
      o_S <= i_A;
    else
      o_S <= i_B;
    end if;
  end process;
end arch_1;