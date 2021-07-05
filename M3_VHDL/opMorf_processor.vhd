library ieee;
use ieee.std_logic_1164.all;

entity opMorf_processor is
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
end opMorf_processor;

architecture arch of opMorf_processor is

component opMorf_control is
port( -- Entradas vindas de fora
		i_RST_n    : in std_logic;
		i_CLK      : in std_logic;
		i_go		  : in std_logic;
		i_SEL_op	  : in std_logic;
		i_continue : in std_logic;

		-- Entradas vindas do datapath
		i_warmup_dn	  : in std_logic;
		i_OP_dn		  : in std_logic;
		-- Saída p/ datapath
		o_GO_warm  : out std_logic;
		o_SEL_mem  : out std_logic;
		o_sw_op    : out std_logic;
		o_init_ap  : out std_logic;
		o_RST_cnt  : out std_logic;
		o_LD_kernel: out std_logic;
		-- Saída p/ exterior 
		o_rdy		  : out std_logic

);
end component;


component datapath is 
port(	i_CLK 			: in std_logic;							--Clock geral

		i_RST_n_M		: in std_logic;							--Reset geral
		i_RST_addrCount: in std_logic;							--Reset do contador de endereço
		
		i_LD_R_kernel  : in std_logic;							--Carrega kernel
		i_kernel       : in std_logic_vector(8 downto 0);  --Kernel a ser utilizado
		i_pixels_M     : in std_logic;							--Pixel de entrada
		
		i_init_ap_M		: in std_logic;							--Sinal p/ inicio do processo
		i_GO_warm_M		: in std_logic;							--Sinal p/ iniciciar warmup
		i_SEL_op_m     : in std_logic;							--Seletor p/ operação
		i_SEL_mem 		: in std_logic;							--Seletor p/ as memórias
		
		o_addr_mem_in 	: out std_logic_vector(15 downto 0);--Endereço p/ a memória de entrada
		o_addr_mem_out : out std_logic_vector(15 downto 0);--Endereço p/ a memória de saída
		
		o_rd_mem			: out std_logic;							--Sinal de leitura p/ as memórias 
		o_wr_mem			: out std_logic;							--Sinal de escrita p/ as memórias 
		o_OP_dn_M		: out std_logic;							--Sinal indicando que a operação foi concluída
		o_warmup_dn_M	: out std_logic;							--Sinal indicando que o warmup foi concluído
		
		o_pixel_m	   : out std_logic							--Pixel a ser escrito na RAM de saída
);
end component;

signal w_sel_opr, w_sel_mem, w_OP_dn : std_logic;
signal w_warmup_go, w_warmup_dn, w_init_ap : std_logic;
signal w_load_kernel, w_rst_cnt : std_logic;


begin
	
	 u_opMcontrol : opMorf_control port map(i_RST_n => i_RST_n_M,	 
														i_CLK => i_CLK,
														i_go => i_GO_M,
														i_SEL_op => i_SEL_op_M,
														i_continue => i_continue_M,														
														i_warmup_dn	=> w_warmup_dn,
														i_OP_dn => 	w_OP_dn,					
														o_GO_warm => w_warmup_go,
														o_SEL_mem => w_sel_mem,
														o_sw_op   => w_sel_opr,
														o_init_ap => w_init_ap,
														o_RST_cnt => w_rst_cnt,
														o_LD_kernel => w_load_kernel,                                                                                  											
														o_rdy => o_rdy_M);

	 u_datapath : datapath port map(	i_CLK => i_CLK,
											i_RST_n_M => i_RST_n_M,
											i_RST_addrCount => w_rst_cnt,
											i_LD_R_kernel => w_load_kernel,
											i_kernel => i_kernel,
											i_pixels_M => i_pixel_M,											
											i_init_ap_M	=> w_init_ap,
											i_GO_warm_M	=> w_warmup_go,
											i_SEL_op_m  => w_sel_opr,
											i_SEL_mem   =>	w_sel_mem,																					
											o_addr_mem_in  => o_addr_mem_in_M,
											o_addr_mem_out => o_addr_mem_out_M,
											o_rd_mem		=> o_rd_mem_M,
											o_wr_mem		=> o_wr_mem_M,
											o_OP_dn_M	=> w_OP_dn,
											o_warmup_dn_M => w_warmup_dn,						
											o_pixel_m 	=> o_pixel_M);
										

	
end arch;

