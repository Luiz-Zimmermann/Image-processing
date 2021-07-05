library ieee;
use ieee.std_logic_1164.all;

entity datapath is
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
end datapath;

architecture arch of datapath is

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

component addrCounter is
  port (
    i_RST_n : in std_logic;
    i_CLK   : in std_logic;
	 i_inc	: in std_logic;
    o_end : out std_logic;
	 o_warmup_dn : out std_logic;
	 o_addr : out std_logic_vector(15 downto 0)
  );
end component;

component linebBlock is
port(	i_CLK : in std_logic;
		i_pixels : in std_logic;
		i_valid : in std_logic;	
		o_pixel  : out std_logic_vector(8 downto 0)
);
end component;

component RAM is
  port (
    clock   : in  std_logic;
    we      : in  std_logic;
    re      : in  std_logic;
    address : in  std_logic_vector(15 downto 0);
    datain  : in  std_logic;
    dataout : out std_logic
  );
end component;

component op_block_control is
port( -- Entradas vindas de fora
		i_RST_ctrl : in std_logic;
		i_CLK      : in std_logic;
		i_end		  : in std_logic;
		i_init_ap  : in std_logic;
		-- Saída p/ opblock
		o_rd_px  : out std_logic;
		o_wt_px  : out std_logic;
		-- Saída p/ controlador 
		o_OP_dn	: out std_logic

);
end component;

component mux2_1bits is
port ( i_SEL : in  std_logic;  -- selector
       i_A   : in  std_logic;  -- data input
       i_B   : in  std_logic;  -- data input
       o_S   : out std_logic); -- data output
end component;

component mux16bits is
port ( i_SEL : in  std_logic;  							-- selector
       i_A   : in  std_logic_vector(15 downto 0);  -- data input
       i_B   : in  std_logic_vector(15 downto 0);  -- data input
       o_S   : out std_logic_vector(15 downto 0)); -- data output
end component;

component demux is
port ( i_SEL : in  std_logic;  -- selector
       i_A   : in  std_logic;  -- data input    
       o_S1   : out std_logic; -- data output
       o_S2   : out std_logic); -- data output
end component;

component or_2bits is
port ( i_A   : in  std_logic;  -- data input
       i_B   : in  std_logic;  -- data input    
       o_S   : out std_logic); -- data output
end component;

component and_1bit is
port ( i_A   : in  std_logic;  -- data input
       i_B   : in  std_logic;  -- data input    
       o_S   : out std_logic); -- data output
end component;

component pad is
  port (
    i_CLK   : in std_logic;
	 i_addr  : in std_logic_vector(15 downto 0);
    o_VALID : out std_logic
  );
end component;

component addr_offset is
port ( i_input   : in  std_logic_vector(15 downto 0);  -- data input    
       o_output   : out std_logic_vector(15 downto 0)); -- data output
end component;

component slidingwindow_valid is
  generic (
    IMAGE_WIDTH   : integer := 256;
    IMAGE_HEIGHT  : integer := 256;
    WINDOW_WIDTH  : integer := 3;
    WINDOW_HEIGHT : integer := 3
  );
  port (
	 i_addr 	: in std_logic_vector(15 downto 0);
    o_VALID : out std_logic
  );
end component;

signal w_pixels : std_logic_vector(8 downto 0);
signal w_addr_MEM, w_addr_offset, w_addr_offMux : std_logic_vector(15 downto 0);
signal w_wt_aux, w_and_aux_wt, w_wt_mem, w_rd_aux, w_rd_mem: std_logic; 
signal w_rd_px, w_wt_px, w_end_img, w_read_px2linebuf : std_logic;
signal w_valid : std_logic;
signal w_out_pixel, w_pixel_aux2buf, w_pixel2buf: std_logic;

begin
	
	
	-- Controlador aux do bloco de operações
	u_ctrl    : op_block_control port map (i_RST_ctrl => i_RST_n_M, 	--Reset geral
														i_CLK => i_CLK, 				--clock
														i_end => w_end_img,		   --Sinal q indica final da imagem
														i_init_ap => i_init_ap_M, 	--Sinal de entrada p/ começar o processamento 
														o_rd_px => w_rd_px,			--Sinal para ler
														o_wt_px => w_wt_px,			--Sinal para escrever
														o_OP_dn => o_OP_dn_M);     --Sinal q indica final da operação
														
	-- Contador utilizado p/ saber a posição a ser lida/escrita													
	u_cnt 	 : addrCounter port map(i_RST_n => i_RST_addrCount, 		--Reset do contador de endereço
												 i_CLK => i_CLK, 						--clock
												 i_inc => w_read_px2linebuf, 		--Possivel problema
												 o_end => w_end_img, 				--Sinal q indica final da imagem
												 o_warmup_dn => o_warmup_dn_M, 	--Sinal q avisa o termino do warmup
												 o_addr => w_addr_MEM);	   		--Endereço da imagem
	
	-- Bloco que realiza as operações de erosão e dilatação
	u_opblock : op_block port map	(i_CLK => i_CLK, 							--Clock
											i_RST_R => i_RST_n_M, 					--Reset geral
											i_LD_R => i_LD_R_kernel, 				--Sinal de load. Carrega o kernel no registrador
											i_kernel => i_kernel, 					--Kernel a ser usado
											i_pixels => w_pixels, 					--Pixels a ser usados na operação. janela.
											i_SEL_op => i_SEL_op_m, 				--Seletor da operação a ser realizada.
											o_pixel => w_out_pixel);				--Resultado						 
	
	-- Bloco que faz o warmup e linebuffer/slidWindow
	u_lineblock : linebBlock port map(i_CLK => i_CLK, 						--Clock
												i_pixels => w_pixel2buf, 			--Pixel de entrada																							
												i_valid => w_read_px2linebuf, -----Talvez precise de um clock de sync --W -----------												
												o_pixel  => w_pixels); 				--Janela de pixels
												
	-- RAM auxiliar para guardar resultado intermediario											
	u_auxram : RAM port map( clock => i_CLK, 									--Clock
								 we => w_and_aux_wt, 										--Habilita escrita
								 re  => w_rd_aux,										--Habilita leitura
								 address => w_addr_offMux, 						--Endereço p/ leitura/escrita
								 datain => w_out_pixel, 							--Pixel a ser armazenado
								 dataout => w_pixel_aux2buf); 					--Pixel de saida
								 
	--Mux p/ escolher da onde vai vir o pixel a ser usado. RAM inicial ou RAM aux.							 
	u_mux_2buf : mux2_1bits port map( i_SEL => i_SEL_mem, 				--Seletor. Se 0, utiliza o pixel da RAM, se 1, utiliza a RAM aux  --W
												 i_A => i_pixels_M, 					--Pixel vindo da RAM inicial.
												 i_B => w_pixel_aux2buf, 			--Pixel vindo da RAM aux.
												 o_S => w_pixel2buf); 				--Pixel de saida escolhido.
								 							
								 
	--Demux p/ escolher se escreve na aux ou na RAM resultado 							 
	u_demux_wt_mem : demux port map( i_SEL => i_SEL_mem, 					--Seletor. Se 0, escreve na RAM aux, se 1, escreve na RAM final  --W
												 i_A => w_wt_px, 						--Sinal de escrita.
												 o_S1 => w_wt_aux, 					--Sinal p/ RAM aux
												 o_S2 => w_wt_mem); 					--Sinal p/ RAM final
	
	--Demux p/ escolher se le da aux ou da RAM inicial
	u_demux_rd_mem : demux port map(i_SEL => i_SEL_mem, 					--Seletor. Se 0, lê da RAM inicial, se 1, lê da RAM aux --W
											 i_A => w_read_px2linebuf, 							--Sinal de leitura
											 o_S1 => w_rd_mem, 						--Sinal para RAM inicial
											 o_S2 => w_rd_aux); 						--Sinal para RAM aux
											 
	--OR p/ acionar os registradores do linebuffer.
	--Os registradores devem carregar os valores das entradas durante 
	--a fase de warmup ou quando for realizada a leitura de uma RAM.
	u_OR_rd_px : or_2bits port map( i_A => i_GO_warm_M,					--Sinal de warmup
											  i_B => w_rd_px,							--Sinal de leitura da RAM
											  o_S => w_read_px2linebuf);   		--Sinal de ativação do regs

	u_addrOffset : addr_offset port map(i_input => w_addr_MEM,   
													 o_output => w_addr_offset); 
			 
	u_mux_offset :  mux16bits port map ( i_SEL => i_SEL_mem,
													 i_A => w_addr_offset,
													 i_B => w_addr_MEM,
													 o_S => w_addr_offMux); 
													 
	u_valid : slidingwindow_valid port map(i_addr  => w_addr_MEM,
														o_VALID => w_valid);
														
	u_and_wt : and_1bit port map( i_A => w_valid,
											i_B => w_wt_aux,
											o_S => w_and_aux_wt);


	
												
	o_addr_mem_in <= w_addr_MEM; 		--Sinal p/ fora do datapath. Conectado na RAM inicial 
	o_addr_mem_out <= w_addr_offset; --Sinal p/ fora do datapath. Conectado na RAM final 
		
	o_rd_mem <= w_rd_mem; 					--Sinal p/ fora do datapath. Conectado a RAM inicial.
	o_wr_mem <= w_wt_mem and w_valid; 	--Sinal p/ fora do datapath. Conectado a RAM final
	o_pixel_m <= w_out_pixel; 				--Resultado a ser escrito na RAM final --W 
	
end arch;

