----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/15/2024 09:40:38 PM
-- Design Name: 
-- Module Name: main_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_TB is
--  Port ( );
end main_TB;

architecture Behavioral of main_TB is

component main is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           JA : in STD_LOGIC_VECTOR (7 downto 0);
           JB : out STD_LOGIC_VECTOR (7 downto 0));
end component;


begin
componente: main port map(
    clk => ;
    
);
process
begin

end process;

end Behavioral;
