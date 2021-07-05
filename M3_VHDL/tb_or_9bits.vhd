
library ieee;
use ieee.std_logic_1164.all;
 
entity tb_or_9bits  is
-- empty
end tb_or_9bits; 

architecture arch_1 of tb_or_9bits  is

-- DUT component
component or_9bits is
port ( i_entry : in std_logic_vector(8 downto 0);
       o_out   : out std_logic);
end component;

signal  w_i: std_logic_vector( 8 downto 0);
signal  w_o: std_logic;

begin

  -- Connect DUT
  u_DUT: or_9bits  port map(    i_entry   => w_i,
                            o_out    => w_o);
  process
  begin
   
    w_i 	<= "111111111";
    wait  for 1 ns;
    assert(w_o='1') report "Fail @ 00 at S1" severity error;

    w_i 	<= "011111111"; 
    wait  for 1 ns;
    assert(w_o='1') report "Fail @ 01 at S1" severity error;

    w_i 	<= "111101111"; 
    wait  for 1 ns;
    assert(w_o='1') report "Fail @ 01 at S1" severity error;

    w_i 	<= "000000000";
    wait  for 1 ns;
    assert(w_o='0') report "Fail @ 01 at S1" severity error;

    w_i 	<= "000001000";
    wait  for 1 ns;
    assert(w_o='1') report "Fail @ 01 at S1" severity error;

    w_i 	<= "000001001";
    wait  for 1 ns;
    assert(w_o='1') report "Fail @ 01 at S1" severity error;

    -- Clear inputs
    w_i 	<= "000000000";
 
    assert false report "Test done." severity note;
    wait;
  end process;
end arch_1;