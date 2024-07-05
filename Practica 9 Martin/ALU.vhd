library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
  Port (clk     : in std_logic;
        sel     : in std_logic_vector(3 downto 0);
        a       : in std_logic_vector(2 downto 0);
        b       : in std_logic_vector(2 downto 0);
        cin     : in std_logic; 
        segments: out std_logic_vector(6 downto 0);
        LED_a   : out std_logic_vector(2 downto 0);
        LED_b   : out std_logic_vector(2 downto 0);
        LED_out : out std_logic_vector(2 downto 0);
        anode   : out std_logic_vector(3 downto 0));
end ALU;

architecture Behavioral of ALU is
component mux is
  Port (sel     :   in std_logic_vector(3 downto 0);
        a       :   in std_logic_vector(2 downto 0);
        b       :   in std_logic_vector(2 downto 0);
        cin     :   in std_logic;
        salida  :   out std_logic_vector(3 downto 0));
end component;

component BCD_to_7seg is
  Port (BCD : in std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0));
end component;

signal salida_bin: std_logic_vector(3 downto 0);
signal bcd: std_logic_vector(7 downto 0);

signal clk_temp_1ms: std_logic;
signal sum_1ms, sum_display: integer := 0;
signal divisor_1ms: integer := 50000;
 
signal a_to_7seg, b_to_7seg, dec_to_7seg, uni_to_7seg: std_logic_vector(6 downto 0);
signal a_bcd, b_bcd: std_logic_vector(3 downto 0);
 
begin
LED_a <= a;
LED_b <= b;

a_bcd <= "0" & a;
b_bcd <= "0" & b;

comp_mux: mux
Port map (sel => sel,
          a => a,
          b => b,
          cin => cin,
          salida => salida_bin);
          
comp_7seg_a: BCD_to_7seg
Port map (BCD => a_bcd,
          seg => a_to_7seg);

comp_7seg_b: BCD_to_7seg
Port map (BCD => b_bcd,
          seg => b_to_7seg);

comp_7seg_dec: BCD_to_7seg
Port map (BCD => bcd(3 downto 0),
          seg => uni_to_7seg);

comp_7seg_uni: BCD_to_7seg
Port map (BCD => bcd(7 downto 4),
          seg => dec_to_7seg);
 

process(salida_bin)
begin
case salida_bin is
    when "0000" => bcd <= "00000000";
    when "0001" => bcd <= "00000001";
    when "0010" => bcd <= "00000010";
    when "0011" => bcd <= "00000011";
    when "0100" => bcd <= "00000100";
    when "0101" => bcd <= "00000101";
    when "0110" => bcd <= "00000110";
    when "0111" => bcd <= "00000111";
    when "1000" => bcd <= "00001000";
    when "1001" => bcd <= "00001001";
    when "1010" => bcd <= "00010000";
    when "1011" => bcd <= "00010001";
    when "1100" => bcd <= "00010010";
    when "1101" => bcd <= "00010011";
    when "1110" => bcd <= "00010100";
    when "1111" => bcd <= "00010101";
    when others => bcd <= "00000000";
end case;
end process;

    process (clk) is
    begin
        if (clk'event and clk = '1') then
            if sum_1ms < divisor_1ms then 
                sum_1ms <= sum_1ms + 1;
            else
                clk_temp_1ms <= not clk_temp_1ms;
                sum_1ms <= 0;
            end if;
        end if;
    end process;
    
    process (clk_temp_1ms) is
    begin
        if rising_edge(clk_temp_1ms) then
            if sum_display < 3 then
                sum_display <= sum_display + 1;
            else
                sum_display <= 0;
            end if;
        end if;
    end process;
    
    process (sum_display, sel) is
    begin
    if sel(3) = '0' then
        if sum_display = 0 then
            anode <= "1110";
            segments <= uni_to_7seg;
        elsif sum_display = 1 then
            anode <= "1101";
            segments <= dec_to_7seg;
        elsif sum_display = 2 then
            anode <= "1011";
            segments <= b_to_7seg;
        else 
            anode <= "0111";
            segments <= a_to_7seg;
        end if;
    else
        if sum_display = 0 then
            anode <= "1110";
            segments <= "1111111";
        elsif sum_display = 1 then
            anode <= "1101";
            segments <= "1111111";
        elsif sum_display = 2 then
            anode <= "1011";
            segments <= b_to_7seg;
        else 
            anode <= "0111";
            segments <= a_to_7seg;
        end if;
    end if;
    end process;
    
    process(sel)
    begin
        if sel(3) = '0' then
            LED_out <= "000";
        else
            LED_out <= salida_bin(2 downto 0);
        end if;
    end process;
end Behavioral;
