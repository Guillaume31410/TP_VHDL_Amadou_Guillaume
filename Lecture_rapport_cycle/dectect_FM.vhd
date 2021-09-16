library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity detect_FM is
	PORT(	E : in std_logic ; -- signal d'entrée 
			O : out std_logic -- signal de sortie (E retarde)
		 ) ;