--d bit encoder (we chose 12 as d)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PE12 is
	PORT(
		X: in std_logic_vector(11 downto 0);
		Y: out std_logic_vector (3 downto 0):= "0000");
end PE12;

architecture Encoder of PE12 is

begin

process(X)
begin
for i in 0 to 11 loop
	if X(i) = '1' then
		y <= conv_std_logic_vector(i,4);
	end if;
	end loop;
	end process;
end Encoder;
