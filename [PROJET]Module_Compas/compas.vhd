library ieee ;
use ieee.std_logic_1164.all ;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity COMPAS is
	port( CLK_50M, RAZ, IN_PWM, CONTINU, START_STOP	:	in std_logic ;
			DATA_VALID												:	out std_logic ;
			DATA_COMPAS												: 	out std_logic_vector(8 downto 0) 
	) ;
end COMPAS ;


architecture DESCR of COMPAS is

component Cnt generic( N : integer := 8 ) ;
port(	ARst		:	in std_logic ;
		Clk		:	in std_logic ;
		SRst		:	in	std_logic ;
		EN			:	in	std_logic ; 
		Q			:	out std_logic_vector(N-1 downto 0) 
	) ;
end component ;
	
component detect_FM
port(	clk 	: 	in std_logic ; -- signal d'horloge 50MHz
		E 		: 	in std_logic ; -- signal d'entrée 
		FM 	: 	out std_logic -- signal de sortie (E retarde)
	 ) ;
	end component ;
	 
constant length_tempo		: integer := 13 ; --il faut compter jusqu'a 5000 pour avoir 0.1ms (donc 1degre)
constant length_angular 	: integer := 9 ; -- il faut 9 bits pour contenir les 360 degres
	
signal tempo_time			: std_logic_vector(length_tempo - 1 downto 0) ; 
signal out_compare		: std_logic ;
signal angle				: std_logic_vector(length_angular - 1 downto 0) ;
signal reset_synchrone 	: std_logic ;
signal FM					: std_logic ;
signal s_in_frq			: std_logic ;
	
begin 
front_mont : detect_FM
	port map(		clk	=>	CLK_50M	,	
						E		=>	s_in_frq	,
						FM		=> FM
				) ;
				
Cnt_time	:	Cnt -- Compteur compte 0.1ms
	generic map(length_tempo)
	port map(		ARst		=> '0'			,
						Clk 		=>	CLK_50M		,
						SRst		=> out_compare or FM ,
						En			=> s_in_frq		,
						Q			=>	tempo_time	
				) ;
		
Cnt_degre : Cnt -- Compteur incremente de 1deg
	generic map(length_angular)
	port map(		ARst		=> '0'			,
						Clk 		=>	CLK_50M		,
						SRst		=> FM ,
						En			=> out_compare 	,
						Q			=>	angle	
				) ;	
					
synchronise : process (clk_50M) -- pour synchroniser le signal d'entree à l'horloge
	begin
		if rising_edge(clk_50M) then
			s_in_frq <= in_PWM;
		end if;
	end process;
					
out_compare <=	'1' when tempo_time >= 5000 else '0' ; -- comparaison avec 5000 (equivalent 1ms), mise a 1 du drapeau
-- on retire l'assignation du out_compare du process car il sera synchrone, de toutes manieres grâce a tempo_time
							
compare : process(clk_50M, tempo_time) -- genere signal de periode 0.1ms
	begin		
		if (clk_50M'event and clk_50M = '1') then
			if(FM = '1') then DATA_COMPAS <= angle + 1 ;
			end if;
		end if ;
	end process ; 
		
end architecture DESCR ;
		