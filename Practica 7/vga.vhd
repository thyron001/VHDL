library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga is
    Port ( CLK_100M : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR(0 to 11); -- Interruptores para controlar colores
           vgaRed : out STD_LOGIC_VECTOR(3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR(3 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC );
end vga;

architecture Behavioral of vga is

    -- Constantes de temporización VGA para 640x480 @ 60Hz
    constant H_ACTIVA      : integer := 640;   -- Ancho de video activo
    constant H_PORCH_DELANTERO : integer := 16;    -- Ancho del porch delantero
    constant H_PULSO_SINCRONIA : integer := 96;    -- Ancho del pulso de sincronía
    constant H_PORCH_TRASERO  : integer := 48;    -- Ancho del porch trasero
    constant H_TOTAL       : integer := 800;   -- Ancho total de la línea

    constant V_ACTIVA      : integer := 480;   -- Altura de video activo
    constant V_PORCH_DELANTERO : integer := 10;    -- Altura del porch delantero
    constant V_PULSO_SINCRONIA  : integer := 2;     -- Altura del pulso de sincronía
    constant V_PORCH_TRASERO  : integer := 33;    -- Altura del porch trasero
    constant V_TOTAL       : integer := 525;   -- Altura total del cuadro

    -- Divisor de reloj para 25MHz
    signal CLK_25M : STD_LOGIC := '0';
    signal contador_div_reloj : integer := 0;
    constant MAX_DIV_RELOJ : integer := 2;  -- Dividir 100MHz por 4 para obtener 25MHz

    -- Declaración de señales
    signal contador_h : integer range 0 to H_TOTAL-1 := 0;
    signal contador_v : integer range 0 to V_TOTAL-1 := 0;

    -- Tipos de estados para máquinas de estado
    type estado_tipo is (ST0, ST1);
    signal estado_actual_Hsync, estado_siguiente_Hsync : estado_tipo := ST0;
    signal estado_actual_Vsync, estado_siguiente_Vsync : estado_tipo := ST0;

begin

    -- Proceso divisor de reloj
    process(CLK_100M)
    begin
        if rising_edge(CLK_100M) then
            if contador_div_reloj = MAX_DIV_RELOJ-1 then
                CLK_25M <= not CLK_25M;
                contador_div_reloj <= 0;
            else
                contador_div_reloj <= contador_div_reloj + 1;
            end if;
        end if;
    end process;

    -- Proceso de sincronización VGA
    process(CLK_25M)
    begin
        if rising_edge(CLK_25M) then
            -- Contador horizontal
            if contador_h = H_TOTAL-1 then
                contador_h <= 0;
                -- Contador vertical
                if contador_v = V_TOTAL-1 then
                    contador_v <= 0;
                else
                    contador_v <= contador_v + 1;
                end if;
            else
                contador_h <= contador_h + 1;
            end if;
        end if;
    end process;

    -- Máquina de estado para Hsync
    process(CLK_25M)
    begin
        if rising_edge(CLK_25M) then
            estado_actual_Hsync <= estado_siguiente_Hsync;
        end if;
    end process;

    process(estado_actual_Hsync, contador_h)
    begin
        case estado_actual_Hsync is
            when ST0 =>
                if (contador_h >= H_ACTIVA + H_PORCH_DELANTERO and contador_h < H_ACTIVA + H_PORCH_DELANTERO + H_PULSO_SINCRONIA) then
                    Hsync <= '0';
                    estado_siguiente_Hsync <= ST1;
                else
                    Hsync <= '1';
                    estado_siguiente_Hsync <= ST0;
                end if;
            when ST1 =>
                if (contador_h >= H_ACTIVA + H_PORCH_DELANTERO + H_PULSO_SINCRONIA) then
                    Hsync <= '1';
                    estado_siguiente_Hsync <= ST0;
                else
                    Hsync <= '0';
                    estado_siguiente_Hsync <= ST1;
                end if;
            when others =>
                Hsync <= '1';
                estado_siguiente_Hsync <= ST0;
        end case;
    end process;

    -- Máquina de estado para Vsync
    process(CLK_25M)
    begin
        if rising_edge(CLK_25M) then
            estado_actual_Vsync <= estado_siguiente_Vsync;
        end if;
    end process;

    process(estado_actual_Vsync, contador_v)
    begin
        case estado_actual_Vsync is
            when ST0 =>
                if (contador_v >= V_ACTIVA + V_PORCH_DELANTERO and contador_v < V_ACTIVA + V_PORCH_DELANTERO + V_PULSO_SINCRONIA) then
                    Vsync <= '0';
                    estado_siguiente_Vsync <= ST1;
                else
                    Vsync <= '1';
                    estado_siguiente_Vsync <= ST0;
                end if;
            when ST1 =>
                if (contador_v >= V_ACTIVA + V_PORCH_DELANTERO + V_PULSO_SINCRONIA) then
                    Vsync <= '1';
                    estado_siguiente_Vsync <= ST0;
                else
                    Vsync <= '0';
                    estado_siguiente_Vsync <= ST1;
                end if;
            when others =>
                Vsync <= '1';
                estado_siguiente_Vsync <= ST0;
        end case;
    end process;

    -- Establecer colores (Pantalla controlada por interruptores)
    process(CLK_25M)
    begin
        if rising_edge(CLK_25M) then
            if contador_h < H_ACTIVA and contador_v < V_ACTIVA then
                vgaRed <= sw(0 to 3);
                vgaGreen <= sw(4 to 7);
                vgaBlue <= sw(8 to 11);
            else
                vgaRed <= "0000";
                vgaGreen <= "0000";
                vgaBlue <= "0000";
            end if;
        end if;
    end process;

end Behavioral;
