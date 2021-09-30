library ieee ;
use ieee.std_logic_1164.all ;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity COMPAS is
	port( CLK_50M, RAZ_n, IN_PWM, CONTINU, START_STOP	:	in std_logic ;
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
	 
	constant tempo		: integer := 13 ; --il faut compter jusqu'a 5000 pour avoir 0.1ms (donc 1degre)
	constant angular 	: integer := 9 ; -- il faut 9 bits pour contenir les 360 degres
	
	signal tempo_time			: std_logic_vector(tempo - 1 downto 0) ; 
	signal out_compare		: std_logic ;
	signal angle				: std_logic_vector(angular - 1 downto 0) ;
	signal reset_synchrone 	: std_logic ;
	signal FM					: std_logic ;
	
begin 
	front_mont : detect_FM
		port map(		clk	=>	CLK_50M	,	
							E		=>	IN_PWM	,
							FM		=> FM
					) ;
				
	Cnt_time	:	Cnt
		generic map(tempo)
		port map(		ARst		=> '0'			,
							Clk 		=>	CLK_50M		,
							SRst		=> out_compare or FM ,
							En			=> IN_PWM		,
							Q			=>	tempo_time	
					) ;
		
	Cnt_degre : Cnt
		generic map(angular)
		port map(		ARst		=> '0'			,
							Clk 		=>	CLK_50M		,
							SRst		=> FM ,
							En			=> out_compare 	,
							Q			=>	angle	
					) ;	
							
		compare : process(tempo_time) 
		begin
			if tempo_time >= 5000 then out_compare <= '1';
			else out_compare <= '0' ;
			end if ;
		end process compare ;
								
	DATA_COMPAS <= angle ; 
end architecture DESCR ;
		