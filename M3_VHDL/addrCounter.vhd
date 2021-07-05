library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addrCounter is
  port (
    i_RST_n : in std_logic;
    i_CLK   : in std_logic;
	 i_inc	: in std_logic;
    o_end : out std_logic;
	 o_warmup_dn : out std_logic;
	 o_addr : out std_logic_vector(15 downto 0)
  );
end entity;

architecture arch of addrCounter is
  -- calcula o tamanho do registrador necessário para armazenar uma contagem do tamanho da imagem
  constant REPR_SIZE : integer := integer(17);
  signal r_COUNTER : std_logic_vector(REPR_SIZE-1 downto 0) := "00000000000000000";

begin

  p_warm: process(i_CLK)
  begin
		
		if unsigned(r_COUNTER) > to_unsigned(515, r_COUNTER'length) then
			o_warmup_dn <= '1';
		else
			o_warmup_dn <= '0';
			
		end if;	
  end process;

  p_count : process(i_CLK, i_inc, i_RST_n)
  begin
    if i_RST_n = '0' then
      r_COUNTER <= (others => '0');
		o_end <= '0';
	 	
    elsif rising_edge(i_CLK) then
		if unsigned(r_COUNTER) < to_unsigned((2**16) + 514, r_COUNTER'length) then
			if i_inc = '1' then
				r_COUNTER <= std_logic_vector(unsigned(r_COUNTER) + 1);
			end if;
		else
			o_end <= '1';
			
		end if;
    end if;
  end process;
  
  o_addr <= r_COUNTER(15 downto 0);
  
  
end architecture;