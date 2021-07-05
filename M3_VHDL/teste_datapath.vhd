library ieee;
use ieee.std_logic_1164.all;

entity teste_datapath is
port(	i_CLK 			: in std_logic;							--Clock geral

		i_RST_n_M		: in std_logic;							--Reset geral
		i_RST_addrCount: in std_logic;							--Reset do contador de endereço
		i_RST_linebuf  : in std_logic;							--Reset do contador warmup
		
		i_LD_R_kernel  : in std_logic;							--Carrega kernel
		i_kernel       : in std_logic_vector(8 downto 0);  --Kernel a ser utilizado
		
		i_init_ap_M		: in std_logic;							--Sinal p/ inicio do processo
		i_GO_warm_M		: in std_logic;							--Sinal p/ iniciciar warmup
		i_SEL_op_m     : in std_logic;							--Seletor p/ operação
		i_SEL_mem 		: in std_logic;							--Seletor p/ as memórias
		
		
		o_OP_dn_M		: out std_logic;							--Sinal indicando que a operação foi concluída
		o_warmup_dn_M	: out std_logic;							--Sinal indicando que o warmup foi concluído
		
		o_pixel_m	   : out std_logic							--Pixel a ser escrito na RAM de saída
);
end teste_datapath;

architecture arch of teste_datapath is


component datapath is
port(	i_CLK 			: in std_logic;							--Clock geral

		i_RST_n_M		: in std_logic;							--Reset geral
		i_RST_addrCount: in std_logic;							--Reset do contador de endereço
		i_RST_linebuf  : in std_logic;							--Reset do contador warmup
		
		i_LD_R_kernel  : in std_logic;							--Carrega kernel
		i_kernel       : in std_logic_vector(8 downto 0);  --Kernel a ser utilizado
		i_pixels_M     : in std_logic;							--Pixel de entrada
		
		i_init_ap_M		: in std_logic;							--Sinal p/ inicio do processo
		i_GO_warm_M		: in std_logic;							--Sinal p/ iniciciar warmup
		i_SEL_op_m     : in std_logic;							--Seletor p/ operação
		i_SEL_mem 		: in std_logic;							--Seletor p/ as memórias
		
		
		o_addr_mem 		: out std_logic_vector(15 downto 0);--Endereço p/ as memórias de entrada e saída
		o_rd_mem			: out std_logic;							--Sinal de leitura p/ as memórias 
		o_wr_mem			: out std_logic;							--Sinal de escrita p/ as memórias 
		o_OP_dn_M		: out std_logic;							--Sinal indicando que a operação foi concluída
		o_warmup_dn_M	: out std_logic;							--Sinal indicando que o warmup foi concluído
		
		o_pixel_m	   : out std_logic							--Pixel a ser escrito na RAM de saída
);
end component;


component ROM is
port ( i_rd_addr : in  std_logic_vector(15 downto 0); -- data input
	    i_rd		  : in std_logic;
       o_pixel    : out std_logic);
end component;

signal w_pixel, w_rd, w_wt : std_logic;
signal w_go_warmup : std_logic;
signal w_addr : std_logic_vector(15 downto 0);

begin
	
	u_rom : ROM port map(i_rd_addr => w_addr,
								i_rd => w_rd,
								o_pixel => w_pixel);
	
	u_datapath : datapath port map(i_CLK => i_CLK, 

											i_RST_n_M => i_RST_n_M,
											i_RST_addrCount => i_RST_addrCount,
											i_RST_linebuf => i_RST_linebuf,
											
											i_LD_R_kernel => i_LD_R_kernel,
											i_kernel => i_kernel,
											i_pixels_M => w_pixel,
											
											i_init_ap_M => i_init_ap_M,
											i_GO_warm_M => i_GO_warm_M,
											i_SEL_op_m => i_SEL_op_m,
											i_SEL_mem => i_SEL_mem,
							
											o_addr_mem => w_addr,
										
											o_rd_mem => w_rd,
											o_wr_mem => w_wt,
											o_OP_dn_M => o_OP_dn_M,
											o_warmup_dn_M => o_warmup_dn_M,
											
											o_pixel_m => o_pixel_m);
end arch;

