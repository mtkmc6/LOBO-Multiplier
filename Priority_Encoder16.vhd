
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PE16 is
	PORT(
		X: in std_logic_vector(15 downto 0);
		Y: out std_logic_vector (3 downto 0):= "0000");
end PE16;

architecture Encoder of PE16 is

begin

process(X)
--variable j: integer;
begin
for i in 0 to 15 loop
	if X(i) = '1' then
		y <= conv_std_logic_vector(i,4);
	end if;
	end loop;
	end process;
	
	




end Encoder;