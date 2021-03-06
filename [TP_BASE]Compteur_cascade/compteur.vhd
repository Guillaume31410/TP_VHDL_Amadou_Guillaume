library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
--use ieee.std_logic_vector.all ;

entity COMPTEUR is
generic (LARG : integer := 8) ;
	port( ARst, CLK, EN	:	in std_logic ;
			Q			:  	out std_logic_vector(LARG-1 downto 0)
	) ;
end COMPTEUR ;

architecture DESC of COMPTEUR is
signal CMP : std_logic_vector(LARG-1 downto 0) ;
begin
	PRO_COMPT : process (ARst, CLK)
	begin
		if (ARst = '0') then CMP <= (others => '0') ;
		elsif (CLK='1' and CLK'event) then 
			if EN = '1' then 
				CMP <= CMP+1 ;
			end if;
		end if ;
	end process PRO_COMPT ;
Q <= CMP ;
end DESC ;