library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity detect_FM is
	PORT(	clk 	: in std_logic ; -- signal d'horloge 50MHz
			E 		: in std_logic ; -- signal d'entrée 
			O 		: out std_logic -- signal de sortie (E retarde)
		 ) ;
end;
		 
architecture detection of detect_FM is
signal sortie : std_logic ;

begin
	bascule_D : process(clk, E)
	begin
		if(clk'event and clk='1') then 
			if (E='1') then
				if(sortie='0') then sortie <= '1' ;
				else sortie <= '0' ;
				end if ;
			end if ;
		end if ;
	end process bascule_D ;
	
	O <= sortie ;
end detection ;