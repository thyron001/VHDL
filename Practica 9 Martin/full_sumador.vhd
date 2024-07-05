library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_sumador is
  Port (
    a    : in  std_logic_vector(2 downto 0);
    b    : in  std_logic_vector(2 downto 0);
    cin  : in  std_logic;
    suma : out std_logic_vector(3 downto 0)
  );
end full_sumador;

architecture Behavioral of full_sumador is
  signal c: std_logic_vector(3 downto 0);
  signal temp_suma: std_logic_vector(3 downto 0);
  
  component sumador
    Port (
      a    : in std_logic;
      b    : in std_logic;
      cin  : in std_logic;
      cout : out std_logic;
      suma : out std_logic
    );
  end component;

begin
c(0) <= cin;

suma_abcin : for i in 0 to 2 generate
sumarcin : sumador port map(
          a => a(i),
          b => b(i),
          cin => c(i),
          cout => c(i+1),
          suma => temp_suma(i));
end generate suma_abcin;

temp_suma(3) <= c(3);
suma <= temp_suma;
end Behavioral;
