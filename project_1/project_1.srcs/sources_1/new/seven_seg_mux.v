module seven_seg_mux (
    input wire clk,           // 來自開發板的 100MHz 實體時脈
    input wire reset,         // 重設訊號
    input wire [15:0] data,   // 來自 CPU 暫存器的 16 位元資料（4個十六進位數字）
    output reg [3:0] an,      // 輸出給開發板：控制哪一顆七段顯示器亮 (Common Anode, 低電位有效)
    output reg [6:0] seg      // 輸出給開發板：控制顯示的圖案 (A~G 燈條, 低電位有效)
);

    // 1. 定義一個時脈分頻計數器，用來產生適當的動態掃描速度
    // 100MHz / 2^18 約等於 380Hz，4個燈輪流亮，每個燈閃爍頻率約 95Hz，肉眼完全看不出閃爍
    reg [19:0] refresh_counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    // 取計數器的最高兩位元來當作選擇器（00, 01, 10, 11），每隔一段時間就會自動加一
    wire [1:0] led_activating_counter = refresh_counter[19:18];

    // 2. 第一步分時多工：決定現在由哪一個顯示器發亮，並擷取對應的 4-bit 資料
    reg [3:0] current_nibble; // 當前要顯示的 4 位元數字

    always @(*) begin
        case(led_activating_counter)
            2'b00: begin
                an = 4'b1110;                   // 亮最右邊那顆 (AN0)
                current_nibble = data[3:0];     // 顯示資料的第 0~3 位元
            end
            2'b01: begin
                an = 4'b1101;                   // 亮右邊數來第二顆 (AN1)
                current_nibble = data[7:4];     // 顯示資料的第 4~7 位元
            end
            2'b10: begin
                an = 4'b1011;                   // 亮左邊數來第二顆 (AN2)
                current_nibble = data[11:8];    // 顯示資料的第 8~11 位元
            end
            2'b11: begin
                an = 4'b0111;                   // 亮最左邊那顆 (AN3)
                current_nibble = data[15:12];   // 顯示資料的第 12~15 位元
            end
            default: begin
                an = 4'b1111;                   // 全滅
                current_nibble = 4'b0000;
            end
        endcase
    end

    // 3. 第二步解碼器：將 4-bit 的數字（0~F）轉換為七段顯示器的燈條訊號（seg）
    // Basys 3 的七段顯示器是「共陽極（Common Anode）」，也就是 0 代表亮，1 代表滅
    always @(*) begin
        case(current_nibble)
            4'b0000: seg = 7'b1000000; // "0"
            4'b0001: seg = 7'b1111001; // "1"
            4'b0010: seg = 7'b0100100; // "2"
            4'b0011: seg = 7'b0110000; // "3"
            4'b0100: seg = 7'b0011001; // "4"
            4'b0101: seg = 7'b0010010; // "5" (7'b0010010)
            4'b0110: seg = 7'b0000010; // "6"
            4'b0111: seg = 7'b1111000; // "7"
            4'b1000: seg = 7'b0000000; // "8"
            4'b1001: seg = 7'b0010000; // "9"
            4'b1010: seg = 7'b0001000; // "A"
            4'b1011: seg = 7'b0000011; // "b"
            4'b1100: seg = 7'b1000110; // "C"
            4'b1101: seg = 7'b0100001; // "d"
            4'b1110: seg = 7'b0000110; // "E"
            4'b1111: seg = 7'b0001110; // "F"
            default: seg = 7'b1111111; // 全滅
        endcase
    end

endmodule