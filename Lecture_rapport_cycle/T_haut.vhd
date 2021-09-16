library ieee ;
use ieee.std_logic_1164.all ;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity T_haut is
	port( CLK_50M, RAZ_n, IN_PWM, CONTINU, START_STOP	:	in std_logic ;
			DATA_VALID												:	out std_logic ;
			DATA_COMPAS												: 	out std_logic_vector(8 downto 0) 
	) ;
end T_haut ;


architecture DESCR of T_HAUT is
	component Cnt generic( N : integer := 8 ) ;
	port(	ARst_N	:	in std_logic ;
			Clk		:	in std_logic ;
			SRst		:	in	std_logic ;
			EN			:	in	std_logic ; 
			Q			:	out std_logic_vector(N-1 downto 0) 
		) ;
	end component ;
	 
	constant degre		: integer := 13 ; --il faut compter jusqu'a 5000 pour avoir 0.1ms (donc 1degre)
	constant angular : integer := 9 ; -- il faut 9 bits pour contenir les 360 degres
	
	signal tempo_time	: std_logic_vector(degre - 1 downto 0) ; 
	signal out_compare: std_logic ;
	signal angle		: std_logic_vector(angular - 1 downto 0) ;
	signal reset_synchrone : std_logic ;
	
begin 
	uCnt1	:	Cnt
		generic map(degre)
		port map(		ARst_N	=> '0'			,
							Clk 	=>	CLK_50M		,
							SRst	=> out_compare ,
							En		=> Start_Stop	,
							Q		=>	tempo_time	
					) ;
		
	uCnt2 : Cnt
		generic map(angular)
		port map(		ARst_N	=> '0'			,
							Clk 	=>	CLK_50M		,
							SRst	=> rising_edge(START_STOP) ,
							En		=> out_compare 	,
							Q		=>	angle	
					) ;	
							
							
		compare : process(tempo_time) 
		begin
			if tempo_time >= 5000 then out_compare <= '1';
			else out_compare <= '0' ;
			end if ;
			
			--out_compare <= '1' when tempo_time >= 5000 else '0' ;
		end process compare ;
								
	DATA_COMPAS <= angle ; 
end architecture DESCR ;
		