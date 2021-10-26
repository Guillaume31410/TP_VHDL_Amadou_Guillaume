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
signal dE : std_logic_vector(1 downto 0) ;

begin
	bascule_E : process(clk, E)
	begin
		if (clk'event and clk='1') then dE(0) <= E ;
			dE(1) <= dE(0) ;
		end if ;
	end process bascule_E ;
	
FM <= '1' when dE(0) = '1' and dE(1) = '0' else '0' ; 
end detection ;