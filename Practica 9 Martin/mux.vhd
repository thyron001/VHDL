library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
  Port (sel     :   in std_logic_vector(3 downto 0);
        a       :   in std_logic_vector(2 downto 0);
        b       :   in std_logic_vector(2 downto 0);
        cin     :   in std_logic;
        salida  :   out std_logic_vector(3 downto 0));
end mux;

architecture Behavioral of mux is
  
  component arith_unit
  Port (sel     :   in std_logic_vector(3 downto 0);
        a       :   in std_logic_vector(2 downto 0);
        b       :   in std_logic_vector(2 downto 0);
        cin     :   in std_logic;
        arith   :   out std_logic_vector(3 downto 0));
  end component;
  
  component logic_unit
  Port (
       selector : in std_logic_vector(3 downto 0);
       a, b     : in std_logic_vector(2 downto 0);
       logic    : out std_logic_vector(3 downto 0)
       );
  end component;

signal sal_arith, sal_logic: std_logic_vector(3 downto 0);    
    
begin
comp_arith: arith_unit
Port map (sel => sel,
          a => a,
          b => b,
          cin => cin,
          arith => sal_arith);
comp_logic: logic_unit
Port map (selector => sel,
          a => a,
          b => b,
          logic => sal_logic);

process(sel) is
begin
if sel(3) = '0' then
    salida <= sal_arith;
else
    salida <= sal_logic;
end if;
end process; 
end Behavioral;
