library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity op_block_control is
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
end op_block_control;

architecture arch of op_block_control is 

	type t_STATE is (s_init, s_read, s_apply, s_write, s_idle);
	signal r_STATE : t_STATE;
	signal w_NEXT  : t_STATE; 

	
begin
	 
	p_STATE: process(i_RST_ctrl, i_CLK)
	begin
		if(i_RST_ctrl = '0') then
			
			r_STATE <= s_init;
		
		elsif(rising_edge(i_CLK)) then
			
			r_STATE <= w_NEXT;
			
		end if;
	end process;

	
	p_NEXT: process (r_STATE, i_init_ap, i_end)
	begin 
		case(r_STATE) is 
			
			when s_init => if(i_init_ap = '1') then
									w_NEXT <= s_read;
								else 
									w_NEXT <= s_init;
								end if;
								
			when s_read => w_NEXT <= s_apply;
			
			when s_apply => w_NEXT <= s_write;
								 			  
			when s_write => if(i_end = '1') then
										w_NEXT <= s_idle;
								 else
										w_NEXT <= s_read;
								 end if;
													 			  
			when s_idle => w_NEXT <= s_init;							 					
			
		end case;
	end process;
				
	o_rd_px <= '1' when (r_STATE = s_read) else '0';
	o_wt_px <= '1' when (r_STATE = s_write) else '0';
	o_OP_dn <= '1' when (r_STATE = s_idle) else '0';
	
			
end arch;