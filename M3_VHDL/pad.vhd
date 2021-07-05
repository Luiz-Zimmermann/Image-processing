library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pad is
  port (
    i_CLK   : in std_logic;
	 i_addr  : in std_logic_vector(15 downto 0);
    o_VALID : out std_logic
  );
end entity;

architecture arch of pad is

  signal w_MOD : std_logic_vector(15 downto 0);

begin

  -- calcula a posicao na coluna do ultimo pixel
  w_MOD <= std_logic_vector((unsigned(i_addr)) mod to_unsigned(258, i_addr'length));
  
  -- seta a saida quando o contador obedecer as duas condicoes:
  --   contador esta nas linhas iniciais e finais invalidas
  --   contador esta nas colunas inicial e final invalidas
  
  o_VALID <= '1' when unsigned(w_MOD) = to_unsigned(0, w_MOD'length) or
								  unsigned(i_addr) < to_unsigned(258, i_addr'length) or
								  unsigned(w_MOD) = to_unsigned(258-1, w_MOD'length) or 
								  unsigned(i_addr) >= to_unsigned(258*258-258, i_addr'length) 
                          
             else '0';
  
  
end architecture;