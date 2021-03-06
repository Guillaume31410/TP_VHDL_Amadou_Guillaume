library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity INCREM is
	port(
		CLK, ARst : in std_logic ;
		AFF : out std_logic_vector(6 downto 0)
	) ;
end INCREM ;


architecture CASCADE of COMPTEUR is
component COMPTEUR is
	port( ARst, CLK, EN0, EN1	:	in std_logic ;
			Q0, Q1 :  out std_logic_vector(7 downto 0)
	) ;
end component;

signal Q1 : std_logic_vector(25 downto 0) ; -- pour la frequence
signal Q2 : std_logic_vector(4 downto 0) ; -- pour le compte
signal K1 : std_logic ; -- sortie du comparateur
	
begin
	
	u0Cnt : COMPTEUR generic map (25) -- compter 1s
	port map( ARst => ARst, CLK => CLK, EN	=> EN0,
			Q => Q0
	) ;
	u1Cnt : COMPTEUR generic map (4) -- compter 15
	port map( ARst => ARst, CLK => CLK, EN	=> EN1,
			Q => Q1
	) ;

	-- ici comparaison, mise ? '1' de K1
	when (Q1 >= 50e6) then K1 <= '1' ;
	others K1 <= '0' ;
	-- *************************
	
	with Q1 select
		AFF <= 	"1000000" when "0000",
				"1111001" when "0001",
				"0100100" when "0010";
			
	
end CASCADE ;