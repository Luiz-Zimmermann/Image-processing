------------------------------------------------
-- Design: Demux
-- Entity: demux1_2bit
-- Author: Luiz Zimmermann
-- Rev.  : 1.0
-- Date  : 03/27/2020
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity demux is
port ( i_SEL : in  std_logic;  -- selector
       i_A   : in  std_logic;  -- data input    
       o_S1   : out std_logic; -- data output
       o_S2   : out std_logic); -- data output
end demux;


architecture arch_1 of demux is
begin
  process(i_SEL, i_A) 
  begin
    if (i_SEL='0') then
      o_S1 <= i_A;
      o_S2 <= '0';
    else
      o_S1 <= '0';
      o_S2 <= i_A;
    end if;
  end process;
end arch_1;