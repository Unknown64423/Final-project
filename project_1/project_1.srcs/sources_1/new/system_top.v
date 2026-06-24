module system_top (
    input wire clk,           // 100MHz 系統時脈
    input wire reset,         // 高電位有效重設
    input wire [15:0] data,   // 傳入的 16 位元資料 (每 4 位元代表一個十六進位數)
    output reg [3:0] an,      // 七段顯示器致能訊號 (Common Anode，0有效)
    output reg [6:0] seg      // 七段顯示器燈條訊號 (0點亮，A~G)
);

    // 1. 除頻器：將 100MHz 降頻至約 400Hz 的掃描頻率 (每秒切換約 400 次，視覺最流暢)
    reg [17:0] clk_div;
    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_div <= 18'd0;
        else
            clk_div <= clk_div + 1'b1;
    end

    // 取除頻器的高 2 位元作為目前點亮哪一個七段顯示器的計數器 (0, 1, 2, 3)
    wire [1:0] scan_cnt = clk_div[17:16];

    // 2. 多工器：根據目前掃描到的位置，抽取出對應的 4-bit 數值
    reg [3:0] hex_digit;
    always @(*) begin
        case (scan_cnt)
            2'b00: hex_digit = data[3:0];   // 第一顆 (最右邊)
            2'b01: hex_digit = data[7:4];   // 第二顆
            2'b10: hex_digit = data[11:8];  // 第三顆
            2'b11: hex_digit = data[15:12]; // 第四顆 (最左邊)
            default: hex_digit = 4'h0;
        endcase
    end

    // 3. 掃描解碼與「關鍵消殘影邏輯 (Blanking)」
    // 在切換 an 的時候，如果時脈邊緣有微小延遲，會導致前一個燈條的餘電漏過去。
    // 我們在這裡精準控制 an 訊號，並確保沒有未定義的狀態。
    always @(*) begin
        if (reset) begin
            an = 4'b1111; // 全滅
        end else begin
            case (scan_cnt)
                2'b00: an = 4'b1110; // 點亮最右邊這顆
                2'b01: an = 4'b1101; 
                2'b10: an = 4'b1011; 
                2'b11: an = 4'b0111; // 點亮最左邊這顆
                default: an = 4'b1111;
            endcase
        end
    end

    // 4. 字形解碼器 (Hex to 7-Segment Decoder)
    // Basys 3 為共陽極 (Common Anode)，0 代表點亮，1 代表熄滅
    // 燈條順序：seg[0]=A, seg[1]=B, seg[2]=C, seg[3]=D, seg[4]=E, seg[5]=F, seg[6]=G
    always @(*) begin
        case (hex_digit)
            4'h0: seg = 7'b1000000; // 0
            4'h1: seg = 7'b1111001; // 1
            4'h2: seg = 7'b0100100; // 2
            4'h3: seg = 7'b0110000; // 3
            4'h4: seg = 7'b0011001; // 4
            4'h5: seg = 7'b0010010; // 5
            4'h6: seg = 7'b0000010; // 6
            4'h7: seg = 7'b1111000; // 7
            4'h8: seg = 7'b0000000; // 8
            4'h9: seg = 7'b0010000; // 9
            4'hA: seg = 7'b0001000; // A
            4'hB: seg = 7'b0000011; // b
            4'hC: seg = 7'b1000110; // C
            4'hD: seg = 7'b0100001; // d
            4'hE: seg = 7'b0000110; // E
            4'hF: seg = 7'b0001110; // F
            default: seg = 7'b1111111; // 全滅
        endcase
    end

endmodule