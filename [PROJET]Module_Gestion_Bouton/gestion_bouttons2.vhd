library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity gestion_bouttons2 is 

port ( clck,raz :in std_logic;
       bp_babord,bp_tribord,bp_stby:in std_logic;
		 code_fonction : out std_logic_vector(3 downto 0);
		 led_babord,led_tribord,led_stby,out_bip:out std_logic
		);
end gestion_bouttons2;


architecture arch1 of gestion_bouttons is

type state_boutton is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13);

signal bip,double_bip,fin_bip :std_logic;
signal entree_tempo,fin_tempo:std_logic;
begin

g_bouttons:process (clck,raz)

variable state :state_boutton;
begin
if raz='0' then
state:=S0;
  Code_fonction       <= "0000";
  elsif rising_edge(clck) then 
  case state is  
 when S0 =>
      if bp_babord ='0'then
      state :=S1 ;
      code_fonction    <="0001";
		
      end if;
      if bp_tribord= '0' then 
      state:=S2;
      code_fonction    <="0010";
      end if;
	   if bp_stby ='0' then 
      state:= S3 ;
      Code_fonction   <= "0000";
      end if;
      
when S1 =>
      if bp_babord ='1' then
	   state :=S0;
	   Code_fonction   <="0000";	
		end if;
		
when S2=>
      if bp_tribord ='1' then
	   state :=S0;
	   Code_fonction   <="0000";	
		end if;
		
when S3 => 
     if bp_stby ='1' then 
	  state :=S4;
	  code_fonction    <="0011";
	  end if;
	  
when s4=>
      if bp_stby ='0' then
		state:=s5; 
		code_fonction    <="0000";
      end if;
		
     if bp_babord= '0' and bp_tribord='1' then 
	  state:= s6;
	  code_fonction    <="0011";
	  end if;
	  
	  
	  if bp_babord  = '1' and bp_tribord ='0' then 
	  state:= s9;
	  code_fonction    <="0011";
	  end if;	  
when s5 =>
     if bp_stby='1' then 
     state:=s0;
	  code_fonction    <="0000";
	  end if; 
	  
 when s6 =>
     if Bp_Babord='0' then 
     state:=s7;
	  code_fonction <="0101";
	  double_bip<='1';
     end if;
     if bp_Babord='1' then 
      state:=s8;
		code_fonction <="0100";
		bip<='1';
      end if;
 
 when s7 =>
      if fin_bip='1' then 
      state:=s13; 
		code_fonction <="0101"; 
		double_bip<='0';
      end if;
when S8=>
      if bp_babord ='1' then 
		state := s4;
		code_fonction <= "0011";
		end if;
when S9 =>	
	   if bp_tribord ='1' then 
	   state := s11;
		code_fonction <= "0111" ;
		end if;
when s10 =>
      if bp_tribord ='0' then 
		state := s10;
		code_fonction <= "0110";
		end if ;
when s11 =>
      if fin_bip ='1' then
	   state := s12;
	   code_fonction <= "0110";
	  end if ;
when S12 =>
      state :=S4;
	  if bp_tribord ='1' then
	   code_fonction <= "0011"; 
		end if;
when s13 =>
     state :=s4;
	  if bp_babord ='1' then
	  code_fonction <="0011";
	  end if ;
end case ;
end if;
end process;
	 
process(raz,clck)
variable tempo: integer range 0 to 300;
begin
 if raz='0' then
tempo := '0';
fin_tempo <='0';
       elsif (clck'event and clck='1') then 
         if entree_tempo = '1' then
fin_tempo <= fin_tempo+1;
               if fin_tempo <= 200 then fin_tempo <= 0;
				    fin_tempo <='1';
				   end if;
			      else fin_tempo <='0';
			      fin_tempo <='0';
			end if;
  end if;	
end process;
end arch1;
		







 
