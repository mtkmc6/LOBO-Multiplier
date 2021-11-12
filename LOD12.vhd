
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity LOD12 is
	PORT(
		Z: in std_logic_vector(11 downto 0);
		P: out std_logic_vector(11 downto 0):= "000000000000" );
end LOD12;

architecture lod of LOD12 is
begin


process(Z)
begin
for i in 0 to 11 loop
	if(Z(11 - i) = '1') then
		P(11 - i) <='1';
		exit;
	end if;
	end loop;
end process;
end lod;
