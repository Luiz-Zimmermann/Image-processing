library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addrMem_cnt is
  port (
    i_RST_n : in std_logic;
    i_CLK   : in std_logic;
	 i_inc	: in std_logic;
	 i_limit : in std_logic_vector(15 downto 0);
    o_end : out std_logic;
	 o_addr : out std_logic_vector(15 downto 0)
  );
end entity;

architecture arch of addrMem_cnt is
  -- calcula o tamanho do registrador necessário para armazenar uma contagem do tamanho da imagem
  constant REPR_SIZE : integer := integer(16);
  signal r_COUNTER : std_logic_vector(REPR_SIZE-1 downto 0) := "0000000000000000";

begin

  p_count : process(i_CLK, i_inc, i_RST_n)
  begin
    if i_RST_n = '0' then
      r_COUNTER <= (others => '0');
		o_end <= '0';
	 	
    elsif rising_edge(i_CLK) then
		if unsigned(r_COUNTER) < unsigned(i_limit) then
			if i_inc = '1' then
				r_COUNTER <= std_logic_vector(unsigned(r_COUNTER) + 1);
			end if;
		else
			o_end <= '1';
			
		end if;
    end if;
  end process;
  
  o_addr <= r_COUNTER;
  
  
end architecture;