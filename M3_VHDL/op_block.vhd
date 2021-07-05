library ieee;
use ieee.std_logic_1164.all;

entity op_block is
port(	i_CLK : in std_logic;
		i_RST_R : in std_logic;
		i_LD_R : in std_logic;
		i_kernel : in std_logic_vector(8 downto 0);
		i_pixels : in std_logic_vector(8 downto 0);
		i_SEL_op : in std_logic;
		o_pixel  : out std_logic
);
end op_block;

architecture arch of op_block is

component register9bits_RST is
port ( i_CLR_n : in  std_logic;  -- clear/reset
       i_CLK   : in  std_logic;  -- clock
       i_LD  : in  std_logic;  -- load
       i_D     : in  std_logic_vector (8 downto 0);  -- data input
       o_Q     : out std_logic_vector (8 downto 0)); -- data output
end component;

component or_9bits is
port (  i_entry : in std_logic_vector(8 downto 0);
	     o_out   : out std_logic); 
end component;

component and_9bits is
port (  i_entry : in std_logic_vector(8 downto 0);
		  o_out   : out std_logic); 
end component;

component mux2_1bits is
port ( i_SEL : in  std_logic;  -- selector
       i_A   : in  std_logic;  -- data input
       i_B   : in  std_logic;  -- data input
       o_S   : out std_logic); -- data output
end component;


signal w_i_or2mux, w_i_and2mux: std_logic;
signal w_o_kernel, w_o_ands2or, w_o_ands2and : std_logic_vector(8 downto 0);

begin
	
	
	u_kernel : register9bits_RST port map( i_CLR_n => i_RST_R,
					 	i_CLK => i_CLK,
						i_LD => i_LD_R,  
						i_D => i_kernel,
						o_Q => w_o_kernel);
														
	u_or : or_9bits port map(i_entry	=> w_o_ands2or,		
									 o_out => w_i_or2mux);
									 
	u_and : and_9bits port map(i_entry	=> w_o_ands2and,		
									   o_out => w_i_and2mux);
	
	u_mux : mux2_1bits port map(i_SEL => i_SEL_op,
										 i_A => w_i_or2mux,
										 i_B => w_i_and2mux,
										 o_S => o_pixel);
														
	ands: for i in 0 to 8 generate
		
		w_o_ands2or(i) <= w_o_kernel(i) and i_pixels(i);
		w_o_ands2and(i) <= w_o_kernel(i) and i_pixels(i) when (w_o_kernel(i) = '1') else '1';
		
		
	end generate;
	

end arch;

