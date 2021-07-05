------------------------------------------------
-- Design: Demux
-- Entity: demux1_2bit
-- Author: Luiz Zimmermann
-- Rev.  : 1.0
-- Date  : 03/27/2020
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addr_offset is
port ( i_input   : in  std_logic_vector(15 downto 0);  -- data input    
       o_output   : out std_logic_vector(15 downto 0)); -- data output
end addr_offset;


architecture arch_1 of addr_offset is
begin
  
  o_output <= std_logic_vector(unsigned(i_input) - to_unsigned(514, i_input'length));
  
end arch_1;
