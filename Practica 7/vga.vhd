----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/07/2024 09:27:24 AM
-- Design Name: 
-- Module Name: vga - Behavioral
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

entity vga is
port (
clk : in std_logic;
hsync: out std_logic;
vsync: out std_logic
);
end vga;

architecture Behavioral of vga is
signal CLK_25M : std_logic;
signal contador_25M : integer := 0;

constant HD : integer := 640;    -- Ancho del área de visualización horizontal en píxeles
constant HF : integer := 48;     -- Ancho del porch delantero horizontal en píxeles
constant HB : integer := 16;     -- Ancho del porch trasero horizontal en píxeles
constant HR : integer := 96;     -- Ancho del retroceso horizontal en píxeles
constant HMAX : integer := HD + HF + HB + HR - 1; -- Valor máximo del contador horizontal = 799

-- Definición de los parámetros verticales
constant VD : integer := 480;    -- Longitud del área de visualización vertical en píxeles
constant VF : integer := 10;     -- Longitud del porch delantero vertical en píxeles
constant VB : integer := 33;     -- Longitud del porch trasero vertical en píxeles
constant VR : integer := 2;      -- Longitud del retroceso vertical en píxeles
constant VMAX : integer := VD + VF + VB + VR - 1; -- Valor máximo del contador vertical = 524

-- Señales internas
signal h_count_reg : integer range 0 to HMAX := 0;
signal h_count_next : integer range 0 to HMAX;
signal v_count_reg : integer range 0 to VMAX := 0;
signal v_count_next : integer range 0 to VMAX;



signal hsync_int : STD_LOGIC;
signal vsync_int : STD_LOGIC;

begin

reloj_25M: process(clk)
begin
    if rising_edge(clk) then
        if contador_25M < 2 then
            contador_25M <= contador_25M + 1;
        else
            CLK_25M <= not CLK_25M;
            contador_25M <= 0;
        end if;
    end if;
end process reloj_25M;

-------------------------------------------------------
    -- Proceso para el contador vertical
    process(clk)
    begin
        v_count_reg <= v_count_next;
        h_count_reg <= h_count_next;
--        v_sync_reg  <= v_sync_next;
--        h_sync_reg  <= h_sync_next;
    end process;

    -- Lógica secuencial para el contador horizontal
    process(h_count_reg)
    begin
        if h_count_reg = HMAX  then
            h_count_next <= 0;
        else
            h_count_next <= h_count_reg + 1;
        end if;
    end process;
    
    ----------------------------------------------------------
    
    -- Lógica secuencial para el contador vertical
    process(h_count_reg, v_count_reg)
    begin
        if h_count_reg = HMAX then
            if v_count_reg = VMAX then
                v_count_next <= 0;
            else
                v_count_next <= v_count_reg + 1;
            end if;
        else
            v_count_next <= v_count_reg;
        end if;
    end process;
---------------------------------------------------------------------
hsync <= '0' when (h_count_reg >= (HD + HB) and h_count_reg <= (HD + HB + HR - 1)) else '1';
vsync <= '0' when (v_count_reg >= (VD + VB) and v_count_reg <= (VD + VB + VR - 1)) else '1';

-- h_sync_next asserted within the horizontal retrace area
h_sync_next <= (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
    
-- v_sync_next asserted within the vertical retrace area
v_sync_next <= (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));

end Behavioral;
