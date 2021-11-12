
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity LOD16 is
	PORT(
		Z: in std_logic_vector(15 downto 0);
		P: out std_logic_vector(15 downto 0):= "0000000000000000" );
end LOD16;

architecture lod of LOD16 is
begin


process(Z)
begin
for i in 0 to 15 loop
	if(Z(15 - i) = '1') then
		P(15 - i) <='1';
		exit;
	end if;
	end loop;
end process;
end lod;