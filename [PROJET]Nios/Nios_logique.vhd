library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Nios_logique is
   port (	in_freq_anemo 								: in std_logic; 
				clk, chipselect, write_n, reset_n 	: in std_logic;
				writedata 									: in std_logic_vector (31 downto 0);
				readdata 									: out std_logic_vector (31 downto 0);
				address										: in std_logic_vector (1 downto 0)
);
end entity Nios_logique;

architecture rtl of Nios_logique is

component anemometre_modes is
	port (clk_50MHZ	: in std_logic;
			raz       	: in std_logic;
			in_frq    	: in std_logic;
			continu		: in std_logic;
			start_stop	: in std_logic;
			data_valid 	: out std_logic;
			vitesse    	: out std_logic_vector (7 downto 0)
		);
end component anemometre_modes;

-- Avalon --------------------------------------------	
signal Ni_raz 			:	 std_logic ;
signal Ni_in_frq 		:	 std_logic ;
signal Ni_continu 	: 	 std_logic ;
signal Ni_start_st	: 	 std_logic ;
signal Ni_data_valid : 	 std_logic ;
signal Ni_vitesse		: 	 std_logic_vector (7 downto 0);

begin
	uAnemo : anemometre_modes
		port map (	clk_50MHz 	=> clk ,
						raz       	=> Ni_raz ,
						in_frq    	=> in_freq_anemo ,
						continu		=> Ni_continu ,
						start_stop	=> Ni_start_st ,
						data_valid 	=> Ni_data_valid ,
						vitesse    	=> Ni_vitesse 
		);


-- ecriture registres --------------------------------
process_write: process (clk, reset_n)
	begin
		if reset_n = '0' then
			Ni_continu <= '0' ;
			Ni_start_st <= '0' ;
			Ni_raz <= '0' ;
		elsif (clk'event and clk = '1') then
			if write_n = '0' then
				if (address = "00") then
					Ni_raz <= writedata(0) ;
					Ni_continu <= writedata(1) ;
					Ni_start_st <= writedata(2) ;
				end if;
			end if;
		end if;
end process;

readdata <= X"00000" & "000" & Ni_data_valid & Ni_vitesse ; 
-- 32 bits    20 bits   3bits    1 bit          8 bits

end architecture rtl;