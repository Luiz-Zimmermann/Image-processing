library ieee;
use ieee.std_logic_1164.all;

entity opMorf_environment  is
port(	i_CLK 			: in std_logic;							--Clock geral

		i_RST_n_M		: in std_logic;							--Reset geral
		i_GO_M			: in std_logic;							--Inicia o processamento
		i_continue_M	: in std_logic;							--Permite que o processador volte para o estado inicial
		
		i_kernel       : in std_logic_vector(8 downto 0);  --Kernel a ser utilizado
		
		i_SEL_op_M     : in std_logic;							--Seletor p/ operação

		o_rdy_M			: out std_logic							--Sinal indicando que está livre p/ outro processamento
);
end opMorf_environment;

architecture arch of opMorf_environment is

component opMorf_processor is
port(	i_CLK 			: in std_logic;							--Clock geral

		i_RST_n_M		: in std_logic;							--Reset geral
		i_GO_M			: in std_logic;							--Inicia o processamento
		i_continue_M	: in std_logic;							--Permite que o processador volte para o estado inicial
		
		i_kernel       : in std_logic_vector(8 downto 0);  --Kernel a ser utilizado
		i_pixel_M      : in std_logic;							--Pixel de entrada
		
		i_SEL_op_M     : in std_logic;							--Seletor p/ operação

		o_addr_mem_in_M	: out std_logic_vector(15 downto 0);
		o_addr_mem_out_M	: out std_logic_vector(15 downto 0);
		
		o_rd_mem_M		: out std_logic;
		o_wr_mem_M		: out std_logic;

		o_pixel_M	   : out std_logic;							--Pixel a ser escrito na RAM de saída
		o_rdy_M			: out std_logic							--Sinal indicando que está livre p/ outro processamento
);
end component;

component wtRAM is
  port (
    clock   : in  std_logic;
    we      : in  std_logic;
	 re		: in  std_logic;
    address : in  std_logic_vector(15 downto 0);
    datain  : in  std_logic;
    dataout : out std_logic
  );
end component;

component ROM is
port ( i_rd_addr : in  std_logic_vector(15 downto 0); -- data input
	    i_rd		  : in std_logic;
       o_pixel   : out std_logic);
end component;

signal w_addr_in, w_addr_out : std_logic_vector(15 downto 0);
signal w_rd, w_wt, w_in_pixel, w_out_pixel : std_logic;
signal pixel : std_logic;

begin
	
	 u_processador: opMorf_processor port map(i_CLK		 => i_CLK,
															i_RST_n_M => i_RST_n_M,
															i_GO_M		=> i_GO_M,
															i_continue_M => i_continue_M,
															
															i_kernel 	=> i_kernel,
															i_pixel_M 	=> w_in_pixel,
															
															i_SEL_op_M => i_SEL_op_M,

															o_addr_mem_in_M => w_addr_in,
															o_addr_mem_out_M => w_addr_out,
															o_rd_mem_M	=> w_rd,
															o_wr_mem_M	=> w_wt,
															o_pixel_M	=> w_out_pixel,
															o_rdy_M 		=> o_rdy_M);
														

	u_in_RAM	: ROM port map(i_rd_addr => w_addr_in,
									i_rd => w_rd,
									o_pixel => w_in_pixel);		
			
	u_out_RAM : wtRAM port map( clock => i_CLK,
										 we => w_wt,
										 re => w_rd,
										 address => w_addr_out,
										 datain => w_out_pixel,
										 dataout => pixel);


	
end arch;

