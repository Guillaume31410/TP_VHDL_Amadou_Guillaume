library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity detect_FM is
	PORT(	clk 	: in std_logic ; -- signal d'horloge 50MHz
			E 		: in std_logic ; -- signal d'entrée 
			FM 		: out std_logic -- signal de sortie (E retarde)
		 ) ;
end;
	
	
architecture detection of detect_FM is
signal dE : std_logic ;

begin
	bascule_E : process(clk, E)
	begin
		if (clk'event and clk='1') then dE <= E ;
		end if ;
	end process bascule_E ;
	
FM <= '1' when E = '1' and dE = '0' else '0' ; 
end detection ;