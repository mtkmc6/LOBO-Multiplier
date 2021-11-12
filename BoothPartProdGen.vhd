library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity BoothPartProdGen is
PORT (
bin3: in STD_LOGIC_VECTOR(2 downto 0);
a: in STD_LOGIC_VECTOR(15 downto 0);
product: out STD_LOGIC_VECTOR(17 downto 0)
);
end BoothPartProdGen;

architecture Behavioral of BoothPartProdGen is
constant ONE17: STD_LOGIC_VECTOR(17 downto 0) := "000000000000000001";
--signal temp: std_logic_vector (16 downto 0);
signal temp2: std_logic_vector (16 downto 0):= "00000000000000000";
signal temp3: std_logic_vector (0 downto 0);
signal temp4: STD_LOGIC_VECTOR(17 downto 0);
begin

--temp <= "0" & a;
temp2 <= "0" & a;

PROCESS(bin3, temp2)
BEGIN

if bin3 = "001" or bin3 = "010" then
temp4 <= "0" & temp2;
elsif bin3 = "011" then
temp4 <= temp2 & '0';
elsif bin3 = "101" or bin3 = "110" then
temp4 <= std_logic_vector(unsigned(not('0' & temp2)) + unsigned(ONE17));
elsif bin3 = "100" then
temp4 <= std_logic_vector(unsigned(not(temp2 & '0')) + unsigned(ONE17));
else
temp4 <= (others => '0');
end if;


END PROCESS;


PROCESS IS
BEGIN
Wait for 10 ns;
temp3(0)<=  a(15) XOR '0';  


wait for 10 ns;
product(17) <= temp3(0);


for i in 0 to 16 loop
product(i) <= temp4(i);
end loop;


END PROCESS;


end Behavioral;