------------------------------------------------
-- Design: Sliding Window
-- Entity: slidingwindow_top
-- Author: Douglas Santos
-- Rev.  : 1.0
-- Date  : 21/05/2020
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity slidingwindow_top is
  generic (
    IMAGE_WIDTH   : integer := 100;
    IMAGE_HEIGHT  : integer := 100;
    WINDOW_WIDTH  : integer := 3;
    WINDOW_HEIGHT : integer := 3;
    PIXEL_WIDTH   : integer := 1
  );
  port (
    i_VALID : in std_logic;
    i_PIX   : in std_logic;

    i_CLK   : in std_logic;
	 
    o_PIX   : out std_logic_vector(8 downto 0)
  );
end entity;

architecture arch of slidingwindow_top is
  ---- TYPES DECLARATION ----
  -- cria um tipo array 2D para atribuir os sinais da janela
  type t_WINDOW is array(WINDOW_WIDTH-1 downto 0, WINDOW_HEIGHT-1 downto 0) of std_logic;
  -- cria um tipo array 1D para atribuir os sinais de saida dos buffers de linha
  type t_ROWBUF_OUTS is array(WINDOW_HEIGHT-2 downto 0) of std_logic;
  
  ---- SIGNALS DECLARATION ----
  signal w_WINDOW      : t_WINDOW;
  signal w_ROWBUF_OUTS : t_ROWBUF_OUTS;
  signal w_VALID       : std_logic;


  component rowbuffer
    generic (
      IMAGE_WIDTH : integer;
      PIXEL_WIDTH : integer
    );
    port (
      i_VALID : in std_logic;
      i_PIX   : in std_logic;
  
      i_CLK   : in std_logic;
  
      o_PIX   : out std_logic
    );
  end component rowbuffer;
  
  component pixreg
    generic (
      PIXEL_WIDTH : integer
    );
    port (
      i_VALID : in std_logic;
      i_PIX   : in std_logic;
      i_CLK   : in std_logic;
      o_PIX   : out std_logic
    );
  end component;
  
begin
  
  ----------------------------------------------------------------
  ----------------------- BUFFERS DE LINHA -----------------------
  ----------------------------------------------------------------
  
  -- instancia o primeiro buffer de linha, que tem como entrada i_PIX
  -- a saida do buffer de linha vai para um array que possui todas as saidas de buffers
  u_FIRST_ROWBUFFER : rowbuffer
  generic map (
    IMAGE_WIDTH => IMAGE_WIDTH,
    PIXEL_WIDTH => PIXEL_WIDTH
  )
  port map (
    i_VALID => i_VALID,
    i_PIX   => i_PIX,
    i_CLK   => i_CLK,
    o_PIX   => w_ROWBUF_OUTS(WINDOW_HEIGHT-2)
  );
  
  -- gera as instancias dos proximos buffers de linha
  gen_ROWBUFFERS : for i in WINDOW_HEIGHT-3 downto 0 generate
    -- cada buffer de linha possui como entrada a saida do buffer anterior
    -- a saida do buffer de linha vai para um array que possui todas as saidas de buffers, em sua respectiva posicao
    u_ROWBUFFER : rowbuffer
    generic map (
      IMAGE_WIDTH => IMAGE_WIDTH,
      PIXEL_WIDTH => PIXEL_WIDTH
    )
    port map (
      i_VALID => i_VALID,
      i_PIX   => w_ROWBUF_OUTS(i+1),
      i_CLK   => i_CLK,
      o_PIX   => w_ROWBUF_OUTS(i)
    );
  end generate;
  
  ----------------------------------------------------------------
  -------------------- REGISTRADORES DA JANELA -------------------
  ----------------------------------------------------------------
  
  -- instancia um registrador para o pixel de entrada do sistema
  -- esse pixel e o equivalente a posicao mais superior a esquerda da janela
  -- a saida e atribuida para o array 2D que armazena a janela (w_WINDOW)
  u_PIXREG_INPUT : pixreg
  generic map ( PIXEL_WIDTH => PIXEL_WIDTH )
  port map (
    i_VALID => i_VALID,
    i_PIX   => i_PIX,
    i_CLK   => i_CLK,
    o_PIX   => w_WINDOW(WINDOW_HEIGHT-1, WINDOW_WIDTH-1)
  );
  
  -- instancia os primeiros registradores para as colunas iniciais das outras linhas da janela
  -- a origem dos pixels dessas linhas da janela sao do buffer de suas respectivas posicoes
  -- a saida desses registradores vai para a sua respectiva posicao na janela
  gen_WINDOW_FROM_BUFFERS : for i in WINDOW_HEIGHT-2 downto 0 generate
    
    u_PIXREG_INPUT : pixreg
    generic map ( PIXEL_WIDTH => PIXEL_WIDTH )
    port map (
      i_VALID => i_VALID,
      i_PIX   => w_ROWBUF_OUTS(i),
      i_CLK   => i_CLK,
      o_PIX   => w_WINDOW(i, WINDOW_WIDTH-1)
    );
  end generate;
  
  -- gera os outros registradores da janela
  -- esse for generate percorre todas as linhas
  gen_REGISTERS_IN_WINDOW : for i in WINDOW_HEIGHT-1 downto 0 generate
    -- esse for generate percorre todas as colunas
    -- somente as colunas iniciais (que ja foram instanciadas anteriormente) nao sao inclusas
    gen_WINDOW_COLS : for j in WINDOW_WIDTH-2 downto 0 generate
      -- o registrador instanciado armazena o pixel a sua esquerda da janela quando dado o sinal valid
      -- o pixel de saida e atribuido para sua posicao na janela
      u_PIXREG_INPUT : pixreg
      generic map ( PIXEL_WIDTH => PIXEL_WIDTH )
      port map (
        i_VALID => i_VALID,
        i_PIX   => w_WINDOW(i, j+1),
        i_CLK   => i_CLK,
        o_PIX   => w_WINDOW(i, j)
      );
      
    end generate;
  end generate;
  
  o_PIX(0)   <= w_WINDOW(2, 2);
  o_PIX(1)   <= w_WINDOW(1, 2);
  o_PIX(2)   <= w_WINDOW(0, 2);
  o_PIX(3)   <= w_WINDOW(2, 1);
  o_PIX(4)   <= w_WINDOW(1, 1);
  o_PIX(5)   <= w_WINDOW(0, 1);
  o_PIX(6)   <= w_WINDOW(2, 0);
  o_PIX(7)   <= w_WINDOW(1, 0);
  o_PIX(8)   <= w_WINDOW(0, 0);
  
  
end architecture;
