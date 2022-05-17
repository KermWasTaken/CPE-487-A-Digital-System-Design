library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Numberle is
    Port ( SW : in STD_LOGIC_VECTOR (4 downto 0);
           BTN : in STD_LOGIC_VECTOR (4 downto 0);
           anode: out STD_LOGIC_VECTOR (7 downto 0);
           seg: out STD_LOGIC_VECTOR (7 downto 0));  
end Numberle;

architecture Behavioral of Numberle is

signal random_num: STD_LOGIC_VECTOR(2 downto 0);
signal random_temp: STD_LOGIC_VECTOR(2 downto 0) := (2 => '1', others => '0');
signal temp: STD_LOGIC;

type state_type is (s0,s1);
signal current_state, next_state: state_type;

begin

P1: process(BTN(2))
begin
    if BTN(2)'event and BTN(2) = '1' then
        temp <= (random_temp(2) XOR random_temp(1));
        random_temp(2 downto 1) <= random_temp(1 downto 0);
        random_temp(0) <= temp;
    end if;
    random_num <= random_temp;
end process;        

P2: process(current_state, next_state, BTN(1))
begin
    if(BTN(1)'event and BTN(1)='1')then
        current_state <= next_state;    
    end if;
end process;

P3: process(current_state, next_state)
begin
    case current_state is
        when s0 =>
            anode <= "01111111";
            next_state <= s1;
            case SW(2 downto 0) is --input
               when "000" => seg <= "11000000";--0
               when "001" => seg <= "11111001";--1
               when "010" => seg <= "10100100";--2        
               when "011" => seg <= "10110000";--3
               when "100" => seg <= "10011001";--4
               when "101" => seg <= "10010010";--5
               when "110" => seg <= "10000010";--6
               when "111" => seg <= "11111000";--7
               when others => seg <= "11111111";--
           end case; 
    
        when s1 =>
            anode <= "10111111";
            next_state <= s0;        
            case random_num(2 downto 0) is --random number
                when "000" => seg <= "11000000";--0
                when "001" => seg <= "11111001";--1
                when "010" => seg <= "10100100";--2        
                when "011" => seg <= "10110000";--3
                when "100" => seg <= "10011001";--4
                when "101" => seg <= "10010010";--5
                when "110" => seg <= "10000010";--6
                when "111" => seg <= "11111000";--7
                when others => seg <= "11111111";
            end case;
    end case;
end process;

end Behavioral;