library ieee	;
use ieee.std_logic_1164.all	;
use ieee.std_logic_unsigned.all	; 

entity PWM_freq is
	port(	CLK, Rst, MORE	:	in std_logic ;
			ALPHA 			:	out std_logic_vector(3 downto 0) ; -- rapport cyclique
			SORTIE			:	out std_logic 	-- LED allumee ou eteinte 
	);
end PWM_freq ;

architecture GENERATEUR of PWM_freq is
	signal incr			:	std_logic_vector(3 downto 0) ; -- incrementation du compteur
	signal pro_sortie : 	std_logic ;	-- rattache a la SORTIE
	signal cycle		:	std_logic_vector(3 downto 0) ; -- rattache au alpha
	

	
begin

	process ( CLK, MORE)
	begin
		if		 MORE = '0' 		then 	cycle <= cycle + 1 ;
		elsif	 cycle = "1111" 	then 	cycle <= "0001" ;
		end if ;
	end process ;

	process( CLK, Rst )
	begin
		if Rst = '0' then pro_sortie <= '0' ; -- RAZ si appui sur BP Rst
		elsif (CLK'event and CLK = '1') then 
			if (incr < cycle) then pro_sortie <= '1' ; -- Mise à H tq alpha pas atteint
			else pro_sortie <= '0' ; -- Sinon mise à L
			end if ; 
		if(incr >= "1111") then incr <= "0000" ; -- RAZ si periode atteinte
		else incr <= incr + 1 ; -- Sinon incrementation
		end if ;
	end if ;
	
	end process ;

ALPHA <= cycle ;
SORTIE <= pro_sortie ; -- transfert dans la sortie "reelle"

end GENERATEUR ; 