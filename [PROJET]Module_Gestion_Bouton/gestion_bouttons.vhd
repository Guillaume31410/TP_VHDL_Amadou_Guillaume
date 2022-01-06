library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity gestion_bouttons is 

port ( clck,raz,bp_babord,bp_tribord,bp_stby  :in std_logic;
      led_babord,led_tribord,led_stby,out_bip :out std_logic;
		     code_fonction : out std_logic_vector(3 downto 0));		
end gestion_bouttons;
architecture arch of gestion_bouttons is
type   state_boutton is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13);
type   bip_type is (veille,simple,double);
signal simple_bip, double_bip, fin_bip :std_logic;
signal clk_100 ,clk_50,clk_1,tmp_100,fin_tempo ,bip :std_logic;
signal cnt_tempo:unsigned(5 downto 0); 
signal icode_fonction:std_logic_vector(3 downto 0);
signal count_100: integer;
signal bip_cnt  : integer range 0 to 200;
signal etat_bip :bip_type;
signal led_faible, led_intense : std_logic;
signal intensite  :std_logic_vector (7 downto 0); 
signal cmpt :integer:=1;

begin
g_bouttons:process (clck,raz)
variable state :state_boutton;
begin
if raz ='0' then
      state:=S0;
      iCode_fonction    <= "0000";
  elsif rising_edge(clck) then 
  case state is  
 when S0 =>
      if bp_babord ='0'then
      state :=S1 ;
      icode_fonction    <="0001";
      end if;
      if bp_tribord= '0' then 
      state:=S2;
      icode_fonction    <="0010";
      end if;
	   if bp_stby ='0' then 
      state:= S3 ;
      iCode_fonction   <= "0000";
      end if;
     led_stby <=clk_1;led_tribord <= led_faible; led_babord <= led_faible;    
when S1 =>
      if bp_babord ='1' then
	   state :=S0;
	   iCode_fonction   <="0000";
		end if;	
	  led_stby <=clk_1;led_tribord <= clk_50;led_babord <=clk_50;
when S2=>
      if bp_tribord ='1' then
	   state :=S0;
	   iCode_fonction   <="0000";		
		end if;
     led_stby <= clk_1;led_tribord <= led_intense;led_babord <=led_intense;
when S3 => 
     if bp_stby ='1' then 
	  state :=S4;
	  icode_fonction    <="0011";
	  end if;
	  led_tribord <= clk_50;led_babord <= clk_50;
when s4=>
      if bp_stby ='0' then
		state:=s5; 
		icode_fonction    <="0000";
      end if;
     if bp_babord= '0' and bp_tribord='1' then 
	  state:= s6;
	  icode_fonction    <="0011";
	  end if;  	  
	  if bp_babord  = '1' and bp_tribord ='0' then 
	  state:= s9;
	  icode_fonction    <="0011";
	  end if;	  
when s5 =>
     if bp_stby='1' then 
     state:=s0;
	  icode_fonction    <="0000";
	  end if; 
 when s6 =>
     if Bp_Babord='0' then 
     state:=s7;
	  icode_fonction <="0101";
	  double_bip<='1';
     end if;
     if bp_Babord='1' then 
      state:=s8;
		icode_fonction <="0100";
		bip<='1';
      end if;
    led_tribord <= clk_50;
 when s7 =>
      if fin_bip='1' then 
      state:=s13; 
		icode_fonction <="0101"; 
		double_bip<='0';
      end if;
		led_tribord <= clk_50;
when S8=>
      if bp_babord ='1' then 
		state := s4;
		icode_fonction <= "0011";
		end if;
      led_Babord <= clk_50;
when S9 =>	
	   if bp_tribord ='1' then 
	   state := s11;
		icode_fonction <= "0111" ;
		end if;
		led_Babord <= clk_50;
when s10 =>
      if bp_tribord ='0' then 
		state := s10;
		icode_fonction <= "0110";
		end if ;
     led_Babord <= clk_50;led_tribord <= clk_50;
when s11 =>
      if fin_bip ='1' then
	   state := s12;
	   icode_fonction <= "0110";
	  end if ;
     led_Babord <= clk_50;led_tribord <= clk_50;
when S12 =>
      state :=S4;
	  if bp_tribord ='1' then
	   icode_fonction <= "0011"; 
		end if;
	  led_stby <= clk_1;led_Babord <= clk_50;led_tribord <= clk_50;
when s13 =>
     state :=s4;
	  if bp_babord ='1' then
	  icode_fonction <="0011";
	  end if ;
	  led_stby <= clk_1;led_Babord <= clk_50;led_tribord <= clk_50;
end case ;
end if;
end process;
	---temporisation-------------------------
----------------------------------------------	
process(raz,clck)
begin
 if raz='0' then
fin_tempo <='0';
       elsif (clck'event and clck='1') then
            if icode_fonction = "0110" or icode_fonction = "0011" then
				cnt_tempo <= cnt_tempo + 1;
			    else 
				cnt_tempo <= (others => '0');
			   end if;	
		 end if; 
end process; 
code_fonction <= icode_fonction;
fin_tempo <= '1' when cnt_tempo > 50 else '0';
------clk_100-----------
gene_100:process(clck,raz)
 begin
        if raz= '0' then
        count_100<=1;
        tmp_100<='0';
        elsif rising_edge(clck) then
            count_100<= count_100 +1;
            if (count_100 <=  249999 )then
                tmp_100 <= NOT tmp_100;
                count_100 <= 1;
            end if;
        end if;
        clk_100 <= tmp_100; 
    end process gene_100;
--------------	clk_50hz------
gene_50: process (clk_100,raz)
begin
if raz= '0' then
clk_50 <= '0';
elsif clk_100'event and clk_100='1' then
clk_50 <= not clk_50;
end if;
end process gene_50; 
--------clk_1hz------

gene_1: process (clk_100,raz)
variable count_1 : integer range 0 to 50;
BEGIN
if raz = '0' then
count_1:= 0;
elsif clk_100'event and clk_100='1' then
count_1:= count_1 +1;
if count_1 = 49 then
clk_1 <= not(clk_1);
count_1:= 0;
end if;
end if;
end process gene_1;
-----led------
led: process(clk_100,raz)
begin
    if (raz = '0') 
        then
            cmpt <= 0;
            intensite <= (others =>'0');
    elsif rising_edge(clk_100)
        then
            cmpt <= cmpt + 1;
            if(cmpt = 6) then
                cmpt <=0;
            end if;
       
    case cmpt is
        when 0 => intensite <="10000000";
        when 1 => intensite <="11000000";
        when 2 => intensite <="11100000";
        when 3 => intensite <="11110000";
        when 4 => intensite <="11111000";
        when 5 => intensite <="11111100";
        when 6 => intensite <="11111110";
        when others => intensite <= (others =>'0');
    end case; 
    end if;
    led_faible <= intensite(1);
    led_intense <= intensite(6);
    end process led;                                          	 
end arch;

