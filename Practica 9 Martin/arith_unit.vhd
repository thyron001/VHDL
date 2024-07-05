library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity arith_unit is
  Port (sel     :   in std_logic_vector(3 downto 0);
        a       :   in std_logic_vector(2 downto 0);
        b       :   in std_logic_vector(2 downto 0);
        cin     :   in std_logic;
        arith   :   out std_logic_vector(3 downto 0));
end arith_unit;

architecture Behavioral of arith_unit is

signal resta_a_1, resta_b_1: std_logic_vector(3 downto 0);
signal suma_a_1, suma_b_1, suma_a_b, suma_a_b_c: std_logic_vector(3 downto 0);

component full_restador is
  Port (
    a    : in  std_logic_vector(2 downto 0);
    resta: out std_logic_vector(3 downto 0)
  );
end component;

component full_sumador is
  Port (
    a    : in  std_logic_vector(2 downto 0);
    b    : in  std_logic_vector(2 downto 0);
    cin  : in  std_logic;
    suma : out std_logic_vector(3 downto 0)
  );
end component;

begin
comp_resta_a_1: full_restador
        Port map (
            a => a,
            resta => resta_a_1
        );
comp_resta_b_1: full_restador
        Port map (
            a => b,
            resta => resta_b_1
        );
comp_suma_a_1: full_sumador
        Port map (
            a => a,
            b => "001",
            cin => '0',
            suma => suma_a_1
        );
comp_suma_b_1: full_sumador
        Port map (
            a => b,
            b => "001",
            cin => '0',
            suma => suma_b_1
        );

comp_suma_a_b: full_sumador
        Port map (
            a => a,
            b => b,
            cin => '0',
            suma => suma_a_b
        );

comp_suma_a_b_c: full_sumador
        Port map (
            a => a,
            b => b,
            cin => cin,
            suma => suma_a_b_c
        );

process(sel,a,b,resta_a_1, resta_b_1,suma_a_1, suma_b_1, suma_a_b, suma_a_b_c) is
begin
if sel = "0000" then
    arith <= "0" & a;
elsif sel = "0001" then
    arith <= suma_a_1;
elsif sel = "0010" then
    arith <= resta_a_1;
elsif sel = "0011" then
    arith <= "0" & b;
elsif sel = "0100" then
    arith <=  suma_b_1;
elsif sel = "0101" then
    arith <= resta_b_1;
elsif sel = "0110" then
    arith <= suma_a_b;
elsif sel = "0111" then
    arith <= suma_a_b_c;
else
    arith <= "0000";
end if;
end process;
end Behavioral;
