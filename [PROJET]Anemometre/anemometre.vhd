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

	port(	ARst_N	:	in	std_logic	;		-- Reset asynchrone 
			Clk		:	in	std_logic	; 		
			SRst		:	in	std_logic	;		-- Reset synchrone 
			EN			:	in std_logic	;		-- Autorisation d'incrementation
			Q			: 	out std_logic_vector(N-1 downto 0) -- Sortie du compteur sur N bits (8 par defaut)
		) ;
end component ;

signal anemo :std_logic_vector(7 downto 0);
signal  data :std_logic;
signal  inf_seconde : std_logic ; -- sortie du comparateur < 1s
signal  cmp_50M      :std_logic_vector(25 downto 0) ; --sortie a comparer avec 50MHZ

begin 
cont_1s : Cnt
	generic map (26)
	port map(ARst_N	=> '0' ,
				Clk		=> clk_50Mhz ,
				SRst		=> not inf_seconde ,
				EN			=> '1',	
				Q			=> cmp_50M
			);
			
mesure_freq : Cnt
	generic map (8) 
	port map(ARst_N	=> '0' ,
				Clk		=> in_frq, 
				SRst		=> not inf_seconde ,
				EN			=> inf_seconde ,	
				Q			=> anemo
			);
			
compare :process( cmp_50M)

 begin 
        if cmp_50M >= 50E6 then inf_seconde <='1';
	     else inf_seconde <='0';
	     end if ;
 end process;
 
     vitesse <= anemo when inf_seconde ='0' ;
		  
end description;
		 