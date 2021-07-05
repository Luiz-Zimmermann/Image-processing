library ieee;
use ieee.std_logic_1164.all;

entity and_9bits is
port (  i_entry : in std_logic_vector(8 downto 0);
	o_out   : out std_logic); 
end and_9bits;


architecture arch_1 of and_9bits is
begin
  process(i_entry) 
  
  variable result : std_logic;
  
  begin
  
	  result := i_entry(0);
	  
	  lp: for i in 1 to 8 loop
			result := result and i_entry(i);
	  end loop lp;
			
	  o_out <= result;
	  
  end process;
  
  
end arch_1;
