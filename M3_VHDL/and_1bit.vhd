------------------------------------------------
-- Design: Demux
-- Entity: demux1_2bit
-- Author: Luiz Zimmermann
-- Rev.  : 1.0
-- Date  : 03/27/2020
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity and_1bit is
port ( i_A   : in  std_logic;  -- data input
       i_B   : in  std_logic;  -- data input    
       o_S   : out std_logic); -- data output
end and_1bit;


architecture arch_1 of and_1bit is
begin
  process(i_A, i_B) 
  begin
    if (i_A and i_B) then
      o_S <= '1';
    else
      o_S <= '0';
         
    end if;
  end process;
end arch_1;
