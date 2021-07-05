library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity opMorf_control is
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
end opMorf_control;

architecture arch of opMorf_control is 

	type t_STATE is (s_init, s_warmup1, s_OP1, s_RST, s_warmup2, s_OP2, s_end);
	signal r_STATE : t_STATE;
	signal w_NEXT  : t_STATE; 

	
begin
	 
	p_STATE: process(i_RST_n, i_CLK)
	begin
		if(i_RST_n = '0') then
			
			r_STATE <= s_init;
		
		elsif(rising_edge(i_CLK)) then
			
			r_STATE <= w_NEXT;
			
		end if;
	end process;

	
	p_NEXT: process (r_STATE, i_go, i_SEL_op, i_continue, i_warmup_dn, i_OP_dn)
	begin 
		case(r_STATE) is 
			
			when s_init => if(i_go = '1') then
									w_NEXT <= s_warmup1;
								else 
									w_NEXT <= s_init;
								end if;
								
			when s_warmup1 => if(i_warmup_dn = '1') then
										w_NEXT <= s_OP1;
								  else
										w_NEXT <= s_warmup1;
								  end if;
								  
								  
			when s_OP1 => if(i_OP_dn = '1') then
									w_NEXT <= s_RST;
							  else
									w_NEXT <= s_OP1;
							  end if;
							  
			when s_RST => w_NEXT <= s_warmup2;				  
							  
			when s_warmup2 => if(i_warmup_dn = '1') then
										w_NEXT <= s_OP2;
								  else
										w_NEXT <= s_warmup2;
								  end if;
								  							 					  
			when s_OP2 => if(i_OP_dn = '1') then               
									w_NEXT <= s_end;
							  else
									w_NEXT <= s_OP2;
							  end if;
							  
			when s_end => if(i_continue = '1') then
									w_NEXT <= s_init;
							  else
									w_NEXT <= s_end;
							  end if;
						
			
		end case;
	end process;
			
			
	o_rdy <= '1' when (r_STATE = S_init) else '0';
	o_LD_kernel <= '1' when (r_STATE = s_warmup1) else '0';
	o_GO_warm <= '1' when (r_STATE = s_warmup1 or r_STATE = s_warmup2) else '0';
	o_sw_op <= i_SEL_op when (r_STATE = s_OP1 or r_STATE = s_warmup1) else not(i_SEL_op) when(r_STATE = s_OP2 or r_STATE = s_warmup2) else '0';
	o_RST_cnt <= '0' when (r_STATE = s_init or r_STATE = s_RST) else '1';
	o_init_ap <= '1' when (r_STATE = s_OP1 or r_STATE = s_OP2) else '0';
	o_SEL_mem <= '1' when (r_STATE = s_OP2) else '0';
			
			
end arch;