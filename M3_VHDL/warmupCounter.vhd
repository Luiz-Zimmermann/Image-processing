library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity warmupCounter is
  port (
    i_GO_warm : in std_logic;
    i_CLK   : in std_logic;
    o_warmup_dn : out std_logic;
	 o_addr : out std_logic_vector(15 downto 0)
  );
end entity;

architecture arch of warmupCounter is
  -- calcula o tamanho do registrador necessário para armazenar uma contagem do tamanho da imagem
  constant REPR_SIZE : integer := integer(10);
  signal r_COUNTER : std_logic_vector(REPR_SIZE-1 downto 0);

begin

  process(i_CLK, i_GO_warm)
  begin
    if i_GO_warm = '0' then
	 
      r_COUNTER <= (others => '0');
		o_warmup_dn <= '0';
		
    elsif rising_edge(i_CLK) then
		if unsigned(r_COUNTER) < to_unsigned(515, r_COUNTER'length) then
			if i_GO_warm = '1' then
				r_COUNTER <= std_logic_vector(unsigned(r_COUNTER) + 1);
			end if;
		else
			o_warmup_dn <= '1';
		end if;
    end if;
  end process;
  
  o_addr(REPR_SIZE-1 downto 0) <= r_COUNTER;
  o_addr(15 downto REPR_SIZE) <= (others => '0');
  
end architecture;