library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_restador is
  Port (
    a    : in  std_logic_vector(2 downto 0);
    resta: out std_logic_vector(3 downto 0)
  );
end full_restador;

architecture Behavioral of full_restador is
  signal c: std_logic_vector(3 downto 0);
  signal b: std_logic_vector(2 downto 0) := "001";
  signal temp_resta: std_logic_vector(3 downto 0);
  
  component restador
    Port (
      a    : in std_logic;
      b    : in std_logic;
      cin  : in std_logic;
      cout : out std_logic;
      resta: out std_logic
    );
  end component;

begin
c(0) <= '0';
resta_x1 : for i in 0 to 2 generate
    restar : restador port map(
        a => a(i),
        b => b(i),
        cin => c(i),
        cout => c(i+1),
        resta => temp_resta(i));
end generate resta_x1;
temp_resta(3) <= c(3);
resta <= temp_resta;
end Behavioral;
