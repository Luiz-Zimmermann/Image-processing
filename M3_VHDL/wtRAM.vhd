library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;
use STD.TEXTIO.all;

entity wtRAM is
  port (
    clock   : in  std_logic;
    we      : in  std_logic;
	 re		: in  std_logic;
    address : in  std_logic_vector(15 downto 0);
    datain  : in  std_logic;
    dataout : out std_logic
  );
end entity wtRAM;

architecture arch of wtRAM is

   type ram_type is array (0 to (2**address'length)-1) of std_logic;
   signal ram : ram_type;

begin

  process(all) is

  file F: TEXT open WRITE_MODE is "resultado.txt";
  variable L: LINE;
  
  begin
    if rising_edge(clock) then
      if we = '1' then
        ram(to_integer(unsigned(address))) <= datain;
        WRITE (L, datain, Left, 2);
        WRITELINE (F, L);
		end if;	    	    
    end if;

  end process;
  
  dataout <= ram(to_integer(unsigned(address))) when (re = '1') else '0';
end architecture arch;