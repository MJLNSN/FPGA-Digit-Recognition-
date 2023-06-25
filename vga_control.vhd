

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY vga_control IS
   PORT (
      org_rgb       : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      display_on    : IN STD_LOGIC;
      pixel_x       : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      pixel_y       : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      ena           : IN STD_LOGIC;
      line_left     : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_right    : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_top      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_bottom   : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_left2    : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_right2   : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_top2     : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_bottom2  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_left3    : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_right3   : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_top3     : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_bottom3  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_left4    : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_right4   : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_top4     : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      line_bottom4  : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
      out_rgb       : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
   );
END vga_control;

ARCHITECTURE trans OF vga_control IS
   
   SIGNAL fig_width    : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_height   : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv     : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv1    : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv2    : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv_tmp_1   : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv1_tmp_1  : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv2_tmp_1  : STD_LOGIC_VECTOR(21 DOWNTO 0);
   
   SIGNAL fig_width_2  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_height_2 : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv_2   : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv1_2  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv2_2  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv_tmp_2   : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv1_tmp_2  : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv2_tmp_2  : STD_LOGIC_VECTOR(21 DOWNTO 0);
   
   SIGNAL fig_width_3  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_height_3 : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv_3   : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv1_3  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv2_3  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv_tmp_3   : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv1_tmp_3  : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv2_tmp_3 : STD_LOGIC_VECTOR(21 DOWNTO 0);
   
   SIGNAL fig_width_4  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_height_4 : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv_4   : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv1_4  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_hdiv2_4  : STD_LOGIC_VECTOR(10 DOWNTO 0);
   SIGNAL fig_vdiv_tmp_4   : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv1_tmp_4  : STD_LOGIC_VECTOR(21 DOWNTO 0);
   SIGNAL fig_hdiv2_tmp_4  : STD_LOGIC_VECTOR(21 DOWNTO 0);
BEGIN

    
   PROCESS (line_right, line_left, line_bottom, line_top, line_right2, line_left2, line_bottom2, line_top2, line_right3, line_left3, line_bottom3, line_top3, line_right4, line_left4, line_bottom4, line_top4, fig_width, fig_height, fig_width_2, fig_height_2, fig_width_3, fig_height_3, fig_width_4, fig_height_4 )
   BEGIN
      
       fig_width <= line_right - line_left;
       fig_height <= line_bottom - line_top;
       fig_vdiv_tmp_1 <= fig_width * "10001000100";
       fig_vdiv <= line_left + fig_vdiv_tmp_1(21 downto 11); -- Shift right by 11 bits 
       fig_hdiv1_tmp_1 <= fig_height * "01001100110";
       fig_hdiv1 <= line_top + fig_hdiv1_tmp_1(21 downto 11); -- Shift right by 11 bits  
       fig_hdiv2_tmp_1 <= fig_height * "10110011001";
       fig_hdiv2 <= line_top + fig_hdiv2_tmp_1(21 downto 11); -- Shift right by 11 bits
       
       fig_width_2 <= line_right2 - line_left2;
       fig_height_2 <= line_bottom2 - line_top2;
       fig_vdiv_tmp_2 <= fig_width_2 * "10001000100";
       fig_vdiv_2 <= line_left2 + fig_vdiv_tmp_2(21 downto 11);
       fig_hdiv1_tmp_2 <= fig_height_2 * "01001100110";
       fig_hdiv1_2 <= line_top2 + fig_hdiv1_tmp_2(21 downto 11);
       fig_hdiv2_tmp_2 <= fig_height_2 * "10110011001";
       fig_hdiv2_2 <= line_top2 + fig_hdiv2_tmp_2(21 downto 11);
       
       fig_width_3 <= line_right3 - line_left3;
       fig_height_3 <= line_bottom3 - line_top3;
       fig_vdiv_tmp_3 <= fig_width_3 * "10001000100";
       fig_vdiv_3 <= line_left3 + fig_vdiv_tmp_3(21 downto 11);
       fig_hdiv1_tmp_3 <= fig_height_3 * "01001100110";
       fig_hdiv1_3 <= line_top3 + fig_hdiv1_tmp_3(21 downto 11);
       fig_hdiv2_tmp_3 <= fig_height_3 * "10110011001";
       fig_hdiv2_3 <= line_top3 + fig_hdiv2_tmp_3(21 downto 11);
       
       fig_width_4 <= line_right4 - line_left4;
       fig_height_4 <= line_bottom4 - line_top4;
       fig_vdiv_tmp_4 <= fig_width_3 * "10001000100";
       fig_vdiv_4 <= line_left4 + fig_vdiv_tmp_4(21 downto 11);
       fig_hdiv1_tmp_4 <= fig_height_4 * "01001100110";
       fig_hdiv1_4 <= line_top4 + fig_hdiv1_tmp_4(21 downto 11);
       fig_hdiv2_tmp_4 <= fig_height_4 * "10110011001";
       fig_hdiv2_4 <= line_top4 + fig_hdiv2_tmp_4(21 downto 11);
          
   END PROCESS;
   

   
   PROCESS (display_on, ena, pixel_x, line_left, line_right, pixel_y, line_top, line_bottom, fig_vdiv, fig_hdiv1, fig_hdiv2, line_left2, line_right2, line_top2, line_bottom2, fig_vdiv_2, fig_hdiv1_2, fig_hdiv2_2, line_left3, line_right3, line_top3, line_bottom3, fig_vdiv_3, fig_hdiv1_3, fig_hdiv2_3, line_left4, line_right4, line_top4, line_bottom4, fig_vdiv_4, fig_hdiv1_4, fig_hdiv2_4, org_rgb)
   BEGIN
      IF (display_on = '1') THEN
         IF (ena = '1') THEN
            IF ((pixel_x = line_left OR pixel_x = line_right) AND (pixel_y > line_top) AND (pixel_y < line_bottom)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_y = line_top OR pixel_y = line_bottom) AND (pixel_x > line_left) AND (pixel_x < line_right)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_x = fig_vdiv) AND (pixel_y > line_top) AND (pixel_y < line_bottom)) THEN
               out_rgb <= "000000001111";
            ELSIF ((pixel_y = fig_hdiv1 OR pixel_y = fig_hdiv2) AND (pixel_x > line_left) AND (pixel_x < line_right)) THEN
               out_rgb <= "000000001111";
            ELSIF ((pixel_x = line_left2 OR pixel_x = line_right2) AND (pixel_y > line_top2) AND (pixel_y < line_bottom2)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_y = line_top2 OR pixel_y = line_bottom2) AND (pixel_x > line_left2) AND (pixel_x < line_right2)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_x = fig_vdiv_2) AND (pixel_y > line_top2) AND (pixel_y < line_bottom2)) THEN
               out_rgb <= "000000001111";
            ELSIF ((pixel_y = fig_hdiv1_2 OR pixel_y = fig_hdiv2_2) AND (pixel_x > line_left2) AND (pixel_x < line_right2)) THEN
               out_rgb <= "000000001111";
            ELSIF ((pixel_x = line_left3 OR pixel_x = line_right3) AND (pixel_y > line_top3) AND (pixel_y < line_bottom3)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_y = line_top3 OR pixel_y = line_bottom3) AND (pixel_x > line_left3) AND (pixel_x < line_right3)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_x = fig_vdiv_3) AND (pixel_y > line_top3) AND (pixel_y < line_bottom3)) THEN
               out_rgb <= "000000001111";
            ELSIF ((pixel_y = fig_hdiv1_3 OR pixel_y = fig_hdiv2_3) AND (pixel_x > line_left3) AND (pixel_x < line_right3)) THEN
               out_rgb <= "000000001111";
            ELSIF ((pixel_x = line_left4 OR pixel_x = line_right4) AND (pixel_y > line_top4) AND (pixel_y < line_bottom4)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_y = line_top4 OR pixel_y = line_bottom4) AND (pixel_x > line_left4) AND (pixel_x < line_right4)) THEN
               out_rgb <= "111100000000";
            ELSIF ((pixel_x = fig_vdiv_4) AND (pixel_y > line_top4) AND (pixel_y < line_bottom4)) THEN
               out_rgb <= "000000001111";
            ELSIF ((pixel_y = fig_hdiv1_4 OR pixel_y = fig_hdiv2_4) AND (pixel_x > line_left4) AND (pixel_x < line_right4)) THEN
               out_rgb <= "000000001111";
            ELSE
               out_rgb <= org_rgb;
            END IF;
         ELSE
            out_rgb <= org_rgb;
         END IF;
      ELSE
         out_rgb <= "000000000000";
      END IF;
   END PROCESS;
END trans;   