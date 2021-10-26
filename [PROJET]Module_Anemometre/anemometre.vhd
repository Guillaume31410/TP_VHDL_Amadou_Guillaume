library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity anemometre is 

port (clk_50MHZ : in std_logic;
      raz_n     : in std_logic;
      in_frq    : in std_logic;
      continu   : in std_logic;
		start_stop  : in std_logic;
		data_valid   :out std_logic;
		data_anemometre :out std_logic_vector (7 downto 0);
		vitesse         :out std_logic_vector (7 downto 0)
);
end anemometre;

architecture description of anemometre is 

component Cnt generic(N : integer := 8);
	port(	ARst	:	in	std_logic	;		-- Reset asynchrone 
			Clk	:	in	std_logic	; 		
			SRst	:	in	std_logic	;		-- Reset synchrone 
			EN		:	in std_logic	;		-- Autorisation d'incrementation
			Q		: 	out std_logic_vector(N-1 downto 0) -- Sortie du compteur sur N bits (8 par defaut)
		) ;
end component ;

component detect_FM
 	PORT(	clk 		: in std_logic ; -- signal d'horloge 50MHz
			E 			: in std_logic ; -- signal d'entrée 
			FM 		: out std_logic -- signal de sortie (E retarde), ou front montant
		 ) ;
end component ;

signal	v_mes 		:std_logic_vector(7 downto 0);
signal  	une_seconde : std_logic ; -- sortie du comparateur < 1s
signal  	cmp_50M     :std_logic_vector(25 downto 0) ; --sortie a comparer avec 50MHZ
signal 	sFM			: std_logic ; -- signal front montant

begin 
cont_1s : Cnt
	generic map (26)
	port map(ARst	=> '0' ,
				Clk	=> clk_50MHZ ,
				SRst	=> une_seconde ,
				EN		=> '1',	
				Q		=> cmp_50M
			);

front_montant : detect_FM
	port map(clk	=> clk_50Mhz , 
				E		=> in_frq ,
				FM		=> sFM
			);

			
mesure_freq : Cnt
	generic map (8) 
	port map(ARst	=> '0' ,
				Clk	=> clk_50MHZ , 
				SRst	=> une_seconde ,
				EN		=> (not une_seconde) and sFM ,	
				Q		=> v_mes
			);
			
compare :process( cmp_50M, clk_50MHZ)
	begin 
			if cmp_50M >= 50E6 then une_seconde <='1';
			else une_seconde <='0';
			end if ;
	end process;
 
refresh : process( une_seconde, clk_50MHZ)
	begin
			if (clk_50MHZ'event and clk_50MHZ = '1') then
				if une_seconde = '1' then vitesse <= v_mes ;
				end if ;
			end if ;
	end process ;
	
end description;
		 