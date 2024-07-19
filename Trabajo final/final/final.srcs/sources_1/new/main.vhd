library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port ( clk    : in STD_LOGIC;       -- Reloj del sistema
           btn    : in STD_LOGIC;       -- Bot�n para resetear
           JA     : in STD_LOGIC_VECTOR (7 downto 0);  -- Se�ales anal�gicas de entrada
           sw     : in STD_LOGIC_VECTOR (1 downto 0);  -- Interruptores para seleccionar la longitud del promedio m�vil
           SD     : out std_logic;      -- Salida serial de datos
           CLK_SD : out std_logic;      -- Reloj para la salida serial de datos
           CLEAR  : out std_logic;      -- Se�al de limpieza
           LATCH  : out std_logic       -- Se�al de latch (captura de datos)
           );
end main;

architecture Behavioral of main is
    -- Componente ADC (convertidor anal�gico a digital)
    COMPONENT xadc_wiz_0
      PORT (
        di_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Datos de entrada
        daddr_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0); -- Direcci�n de lectura
        den_in : IN STD_LOGIC;                      -- Se�al de habilitaci�n de datos
        dwe_in : IN STD_LOGIC;                      -- Se�al de habilitaci�n de escritura
        drdy_out : OUT STD_LOGIC;                   -- Se�al de datos listos
        do_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- Datos de salida
        dclk_in : IN STD_LOGIC;                     -- Reloj del ADC
        reset_in : IN STD_LOGIC;                    -- Se�al de reset
        convst_in : IN STD_LOGIC;                   -- Se�al de inicio de conversi�n
        vp_in : IN STD_LOGIC;                       -- Entrada positiva del ADC
        vn_in : IN STD_LOGIC;                       -- Entrada negativa del ADC
        vauxp5 : IN STD_LOGIC;                      -- Entrada auxiliar positiva 5
        vauxn5 : IN STD_LOGIC;                      -- Entrada auxiliar negativa 5
        channel_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- Salida del canal
        eoc_out : OUT STD_LOGIC;                    -- Se�al de fin de conversi�n
        alarm_out : OUT STD_LOGIC;                  -- Se�al de alarma
        eos_out : OUT STD_LOGIC;                    -- Se�al de fin de secuencia
        busy_out : OUT STD_LOGIC                    -- Se�al de ocupado
      );
    END COMPONENT;

    -- Componente final para procesamiento de datos
    component final is
    Port(
        clk_in : in std_logic;         -- Reloj de entrada
        eoc: in std_logic;             -- Se�al de fin de conversi�n
        data_in: std_logic_vector(11 downto 0); -- Datos de entrada
        len_lpf: in std_logic_vector(1 downto 0); -- Longitud del filtro LPF
        data_out: out std_logic_vector(11 downto 0) -- Datos de salida
    );
    end component;
        
    -- Se�ales internas
    signal channel_out  : std_logic_vector(4 downto 0); -- Canal de salida del ADC
    signal daddr_in : std_logic_vector(6 downto 0);     -- Direcci�n de lectura para el ADC
    signal eoc_out : std_logic;                         -- Se�al de fin de conversi�n del ADC
    signal do_out : std_logic_vector(15 downto 0);      -- Datos de salida del ADC
    signal anal_p, anal_n, convst, drdy: std_logic;     -- Se�ales de control
    signal count : integer range 0 to 999;              -- Contador para la generaci�n de se�ales
    signal x, y : std_logic_vector(11 downto 0);        -- Datos procesados

    -- Se�ales para el env�o de datos seriales
    signal clk_serial: STD_LOGIC;         -- Reloj para datos seriales
    signal contador_2M : integer range 0 to 63;  -- Contador para el reloj serial
    signal contador_12: integer range 0 to 12;   -- Contador para los bits de datos seriales
    
begin

-- Configuraci�n de la direcci�n de lectura para el ADC
daddr_in <= "00" & channel_out;
-- Configuraci�n de las entradas anal�gicas
anal_p <= JA(4);
anal_n <= JA(0);

-- Instanciaci�n del componente final para el filtrado de datos
filtro_variable : final
  PORT MAP(clk_in   => clk,
           eoc      => eoc_out,
           data_in  => x,
           len_lpf  => sw,
           data_out => y);

-- Instanciaci�n del ADC
your_adc : xadc_wiz_0
  PORT MAP (
    di_in => "0000000000000000",   -- Datos de entrada del ADC
    daddr_in => daddr_in,          -- Direcci�n de lectura del ADC
    den_in => eoc_out,             -- Habilitaci�n de datos del ADC
    dwe_in => '0',                 -- Deshabilitado (no se escribe en el ADC)
    drdy_out => open,              -- Se�al de datos listos (no se usa)
    do_out => do_out,              -- Datos de salida del ADC
    dclk_in => clk,                -- Reloj del ADC
    reset_in => btn,               -- Se�al de reset
    convst_in => convst,           -- Se�al de inicio de conversi�n
    vp_in => '0',                  -- Entrada positiva del ADC (vacio)
    vn_in => '0',                  -- Entrada negativa del ADC (vacio)
    vauxp5 => anal_p,              -- Entrada auxiliar positiva
    vauxn5 => anal_n,              -- Entrada auxiliar negativa
    channel_out => channel_out,    -- Canal de salida del ADC
    eoc_out => eoc_out,            -- Se�al de fin de conversi�n
    alarm_out => open,             -- Se�al de alarma (no se usa)
    eos_out => open,               -- Se�al de fin de secuencia (no se usa)
    busy_out => open               -- Se�al de ocupado (no se usa)
  );
  
-- Procesar datos del ADC
x  <= do_out(15 downto 4);

-- Generaci�n de se�al de reloj de 100KHz (Frecuencia de muestreo)
process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
            convst <= '0';
            if count = 999 then
                count <= 0;
                convst <= '1'; -- Inicia la conversi�n en el ADC
            end if;
        end if;
    end process;

-- Generaci�n de se�al de reloj para el env�o de datos seriales
process(clk)
  begin
      if rising_edge(clk) then
          if eoc_out = '1' then
              contador_2M <= 0;
              contador_12 <= 0;
          end if;

          if contador_12 < 12 then
              contador_2M <= contador_2M + 1;
              if contador_2M = 24 then
                  contador_2M <= 0;
                  clk_serial <= not clk_serial;
                  if clk_serial = '1' then
                      contador_12 <= contador_12 + 1;
                  end if;
              end if;
          else
              clk_serial <= '0';
          end if;
      end if;
  end process;
  
-- Enviar datos serialmente
process (clk_serial) is
    variable count_serial : integer := 0;
    begin
    if rising_edge(clk_serial) then
        if count_serial = 11 then
            count_serial := 0;
            SD <= '0';  -- Termina el env�o de datos
        else 
            SD <= y(count_serial); -- Env�a el bit correspondiente de los datos
            count_serial := count_serial + 1;
        end if;
    end if;
end process;

-- Salidas de se�ales de reloj y control
CLK_SD  <= clk_serial;   -- Salida del reloj para datos seriales
LATCH   <= eoc_out;      -- Se�al de captura de datos
CLEAR   <= '1';         -- Se�al de limpieza (siempre activa)
  
end Behavioral;
