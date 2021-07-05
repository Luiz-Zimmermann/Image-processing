library ieee;
use ieee.std_logic_1164.all;
 
entity tb_op_block is
-- empty
end tb_op_block; 

architecture arch_1 of tb_op_block is

-- DUV component
component op_block is
port(	i_CLK : in std_logic;
		i_RST_R : in std_logic;
		i_LD_R : in std_logic;
		i_kernel : in std_logic_vector(8 downto 0);
		i_pixels : in std_logic_vector(8 downto 0);
		i_SEL_op : in std_logic;
		o_pixel  : out std_logic
);
end component;

signal w_CLK, w_RST, w_SEL, w_LD, w_out : std_logic;
signal w_kernel, w_pixels: std_logic_vector(8 downto 0);

constant c_CLK_PERIOD : time := 2 ns;

begin

  -- Connect DUV
  u_DUV: op_block port map ( i_CLK   => w_CLK,
						i_RST_R  => w_RST,
						i_LD_R => w_LD,
						i_kernel => w_kernel,
       						i_pixels  => w_pixels,
						i_SEL_op => w_SEL,
						o_pixel    => w_out
						);

  --Processo do clock
  p_CLK: process
  begin
  	w_CLK <= '0';
    wait for c_CLK_PERIOD/2;  
    w_CLK <= '1';
    wait for c_CLK_PERIOD/2;  
  end process p_CLK;


  p_INPUT: process
    begin

   	w_RST <= '1';
	w_kernel <= "010111010";
	w_LD <= '1';
	w_pixels <= "111111111";
	w_SEL <= '0';
	wait  for c_CLK_PERIOD;

	w_pixels <= "110000000";

      wait  for c_CLK_PERIOD;

	w_pixels <= "101111111";
w_SEL <= '1';
	
	wait  for c_CLK_PERIOD;
w_pixels <= "011111111";

wait  for c_CLK_PERIOD;

    wait; -- for the end of simulation 
   	w_RST <= '0';
	w_SEL <= '0';
	w_LD <= '0';
	w_kernel <= "000000000";
	w_pixels <= "000000000";
    end process p_INPUT;

end arch_1;