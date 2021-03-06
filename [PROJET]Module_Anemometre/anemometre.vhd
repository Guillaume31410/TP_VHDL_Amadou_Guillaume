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
			E 			: in std_logic ; -- signal d'entree 
			FM 		: out std_logic -- signal de sortie (E retarde)
		 ) ;
end component ;

signal	v_mes :std_logic_vector(7 downto 0);
signal  	inf_seconde : std_logic ; -- sortie du comparateur < 1s
signal  	cmp_50M      :std_logic_vector(25 downto 0) ; --sortie a comparer avec 50MHZ
signal 	sFM			: std_logic ; -- signal Front Montant

begin 
cont_1s : Cnt
	generic map (26)
	port map(ARst	=> '0' ,
				Clk	=> clk_50Mhz ,
				SRst	=> inf_seconde ,
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
				Clk	=> clk_50Mhz , 
				SRst	=> inf_seconde ,
				EN		=> (not inf_seconde) and sFM ,	
				Q		=> v_mes
			);
 
inf_seconde <=	'1' when cmp_50M >= 50E6 else '0' ; -- comparaison avec 50e6 (equivalent 1s), mise a 1 du drapeau
 
 refresh : process(inf_seconde, clk_50MHZ)
 begin
		if (clk_50MHZ'event and clk_50MHZ = '1') then
			if inf_seconde = '1' then vitesse <= v_mes ;
			end if ;
		end if ;
 end process ;
 		  
end description;
		 