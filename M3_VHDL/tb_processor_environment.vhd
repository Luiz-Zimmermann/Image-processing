
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity tb_imageProcessor_environment is
-- empty
end tb_imageProcessor_environment; 

architecture arch_1 of tb_imageProcessor_environment is

-- DUV component
component opMorf_environment  is
port(	i_CLK 			: in std_logic;							--Clock geral

		i_RST_n_M		: in std_logic;							--Reset geral
		i_GO_M			: in std_logic;							--Inicia o processamento
		i_continue_M	: in std_logic;							--Permite que o processador volte para o estado inicial
		
		i_kernel       : in std_logic_vector(8 downto 0);  --Kernel a ser utilizado
		
		i_SEL_op_M     : in std_logic;							--Seletor p/ operação

		o_rdy_M			: out std_logic							--Sinal indicando que está livre p/ outro processamento
);
end component;

signal w_CLK, w_RST, w_start, w_out, w_conti : std_logic;
signal w_sel_op : std_logic;
signal w_kernel : std_logic_vector(8 downto 0);


constant c_CLK_PERIOD : time := 2 ns;

begin

  -- Connect DUV
  u_DUV: opMorf_environment port map ( i_CLK=> w_CLK,
					i_RST_n_M  => w_RST,
       					i_GO_M  => w_start,
					i_continue_M => w_conti,
					i_kernel => w_kernel,
					i_SEL_op_M => w_sel_op,
					o_rdy_M => w_out);

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
	w_conti <= '0';
	w_start <= '0';
   	w_RST <= '0';
	w_sel_op <= '1';
	w_kernel <= "010111010";
	wait  for c_CLK_PERIOD;
	w_RST <= '1';
	w_start <= '1';
      wait  for c_CLK_PERIOD;
	w_start <= '0';
	
      --wait  for 100 * c_CLK_PERIOD;

	
    wait; -- for the end of simulation 
	w_start <= '0';
   	w_RST <= '0';
	w_sel_op <= '0';
	w_conti <= '0';
	w_kernel <= "000000000";
    end process p_INPUT;

end arch_1;