
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity radix4_tb is
	port (X,Y : in std_logic_vector(15 downto 0);
		clk: in std_logic;
		O: out std_logic_vector(31 downto 0));
end radix4_tb;

architecture test1 of radix4_tb is

component BoothPartProdGen
	PORT (
		bin3: in STD_LOGIC_VECTOR(2 downto 0);
		a: in STD_LOGIC_VECTOR(15 downto 0);
		product: out STD_LOGIC_VECTOR(17 downto 0)
	);
end component;

component lod16
	PORT(
		Z: in std_logic_vector(15 downto 0);
		P: out std_logic_vector(15 downto 0));
end component;

component LOD12
	PORT(
		Z: in std_logic_vector(11 downto 0);
		P: out std_logic_vector(11 downto 0):= "000000000000" );
end component;

component PE12
	PORT(
		X: in std_logic_vector(11 downto 0);
		Y: out std_logic_vector (3 downto 0):= "0000");
end component;

component PE16
	PORT(
		X: in std_logic_vector(15 downto 0);
		Y: out std_logic_vector (3 downto 0):= "0000");
end component;

component barrelshif
	port(
	  X: in std_logic_vector(15 downto 0);
	  shiftAm: in std_logic_vector(3 downto 0);
	  PP1: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000");
end component;

component barrelshif12
	port(
	  X: in std_logic_vector(11 downto 0);
	  shiftAm: in std_logic_vector(3 downto 0);
	  PP1: out std_logic_vector(31 downto 0) := "00000000000000000000000000000000");
end component;


signal B0: std_logic_vector(11 downto 0);
signal B00: std_logic_vector(11 downto 0);
signal shift16in: std_logic_vector(15 downto 0);
signal shift12in: std_logic_vector(11 downto 0);
signal absB0: std_logic_vector(11 downto 0);
signal booth1: std_logic_vector(2 downto 0);
signal booth2: std_logic_vector(2 downto 0);
signal LOD12Out: std_logic_vector(11 downto 0);
signal LOD16Out: std_logic_vector(15 downto 0);
signal shiftAmt12: std_logic_vector(3 downto 0);
signal shiftAmt16: std_logic_vector(3 downto 0);
signal PP01: std_logic_vector(31 downto 0);
signal PP02: std_logic_vector(31 downto 0);
signal PP1: std_logic_vector(17 downto 0);
signal PP2: std_logic_vector(17 downto 0);
signal absY: std_logic_vector(15 downto 0);
signal extPP1: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal extPP2: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";

signal msbB0: std_logic;
signal msbY: std_logic;
signal xorYB0: std_logic;



begin

booth1(0) <= X(11);	--assigning booth values
booth1(1) <= X(12);
booth1(2) <= X(13);

booth2(0) <= X(13);
booth2(1) <= X(14);
booth2(2) <= X(15);


msbB0 <= B0(11);
msbY <= Y(15);
xorYB0 <= msbY xor msbB0;


--start left side

B0 <= X(11 downto 0);

process is	--xor B0 and B0's MSB
begin
wait for 10 ns;
for i in 0 to 11 loop
absB0(i) <= B0(i) xor msbB0;
end loop;
end process;

process is	--xor Y and Y's MSB
begin
wait for 10 ns;
for i in 0 to 15 loop
absY(i) <= Y(i) xor msbY;
end loop;
end process;

leadingOneB0: lod12 port map (absB0, LOD12Out);	--tmp into 12 bit LOD

process is	--XOR abs(B0) with B0 LOD
begin
wait for 10 ns;
for i in 0 to 11 loop
B00(i) <= LOD12Out(i) xor absB0(i);
end loop;
end process;

process is	--XOR xorYB0 with B00
begin
wait for 10 ns;
for i in 0 to 11 loop
shift12in(i) <= B00(i) xor xorYB0;
end loop;
end process;

process is	--xor xorYB0 and absY
begin
wait for 10 ns;
for i in 0 to 15 loop
shift16in(i) <= xorYB0 xor absY(i);
end loop;
end process;

--begin right side
process is	--XOR Ymsb and Y
begin
wait for 10 ns;
for i in 0 to 15 loop
absY(i) <= Y(i) xor msbY;
end loop;
end process;

leadingOneY: lod16 port map (absY, LOD16Out);	--LOD16 with absY

PEncode16: PE16 port map (LOD16Out, shiftAmt12);	--right priority encode, goes into left shifter

PEncode12: PE12 port map (LOD12Out, shiftAmt16); 	--left priority encode, goes into right barrel shifter

BShift12: barrelshif12 port map (shift12in, shiftAmt12, PP02);

BShift16: barrelshif port map (shift16in, shiftAmt16, PP01);

--end of logarithmic section

Boothcode1: BoothPartProdGen port map (booth1, Y, PP1);
Boothcode2: BoothPartProdGen port map (booth2, Y, PP2);

process is
begin
wait for 10 ns;
for i in 12 to 29 loop
extPP1(i) <= PP1(i-12);

end loop;
end process;


process is
begin
wait for 10 ns;
for i in 14 to 31 loop

extPP2(i) <= PP2(i-14);
end loop;
end process;

O <= extPP1 + extPP2 + PP01 + PP02;	--PP1 and PP2 are radix partial products, PP01 and PP02 are logarithmic, all labeled as in diagram


end test1;