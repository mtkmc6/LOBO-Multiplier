
library IEEE;
use IEEE.std_logic_1164.all;
 use IEEE.numeric_std.all;


-- 16 bit Barrel shifter
entity barrelshif12 is
  
	port(
	  X: in std_logic_vector(11 downto 0);
	  shiftAm: in std_logic_vector(3 downto 0);
	  PP1: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000");
						
end barrelshif12;


architecture Eqtns of barrelshif12 is 
	
	signal shiftint: integer range 0 to 36;
	signal shiftlimit: integer range 0 to 36;
	begin
	
		 shiftint<= to_integer(unsigned(shiftAm));
	shiftlimit <= shiftint + 11;
	
	process is
	begin
	wait for 25 ns;
	for i in shiftint to  shiftlimit loop
		
		PP1(i) <= X(i-shiftint);
		
	
	end loop;
	wait for 10 ns;
	
	PP1(27)<=  PP1(26);
	
	end process;

end Eqtns;
			
			
	
	