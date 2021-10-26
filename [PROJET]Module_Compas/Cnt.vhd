library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

entity Cnt is 
	generic ( N : integer := 8 ) ;			-- Definition de la taille du vecteur sur N bits (8 par defaut)
	port(	ARst	:	in	std_logic	;		-- Reset asynchrone 
			Clk		:	in	std_logic	; 		
			SRst		:	in	std_logic	;		-- Reset synchrone 
			EN			:	in std_logic	;		-- Autorisation d'incrementation
			Q			: 	out std_logic_vector(N-1 downto 0) -- Sortie du compteur sur N bits (8 par defaut)
		) ;
end entity Cnt	;

architecture rtl of Cnt is
	
signal sQ	:std_logic_vector(N-1 downto 0)	;

begin
	pCnt : process(Clk, ARst)
	begin
		if ARst = '0' then sQ <= (others => '0') ;	-- RAZ asynchrone
		elsif (Clk'event and Clk='1') then 
			if SRst = '1' then sQ <= (others => '0') ;-- RAZ synchrone
			elsif EN = '1' then sQ <= sQ + 1 ;		-- Incrementation
			end if ;
		end if ;
	end process pCnt ;
Q <= sQ ;		-- Chargement dans le port de sortie 
end architecture rtl ;