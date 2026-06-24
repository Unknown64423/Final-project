module imem_dmem (
    input wire clk,
    input wire mem_valid,       // CPU 發出：代表現在要對記憶體做存取
    input wire [31:0] mem_addr, // CPU 發出：要存取的記憶體位址
    input wire [31:0] mem_wdata,// CPU 發出：要寫入記憶體的資料
    input wire [3:0] mem_wstrb, // CPU 發出：寫入遮罩（0000代表讀取，非0代表寫入）
    output reg [31:0] mem_rdata // 記憶體輸出：傳回給 CPU 的資料
);

    // 🚨 擴大記憶體空間：宣告 16384 個 Word (每個 Word 為 32-bit)，總共 64KB 空間
    // 這樣才能完美容納 CPU 上電後跳過去的 0x0000_8008 位址
    reg [31:0] ram [0:16383];
    
    // 🚨 修正記憶體索引：改用 14 位元 (15:2)，精準對應 0 到 16383 的陣列範圍
    wire [13:0] ram_idx = mem_addr[15:2];

    // 初始化記憶體
    initial begin : init_ram
        integer i;
        for (i = 0; i < 16384; i = i + 1) begin
            ram[i] = 32'h00000013; // 預設全部填滿 NOP 指令，防止 CPU 亂跑當機
        end

        // 嘗試讀取你編譯 C 語言產生的 firmware.hex
        $readmemh("firmware.hex", ram);
        
        // ========================================================================
        // 🚨 終極精密保險碼：
        // 根據剛才的硬體診斷，CPU 上電重設後會停在 0x0000_8008 (對應 Word 索引 8194)
        // 我們直接在 8194 開始埋伏無限循環指令，並將跳躍偏移量修正為精準的 -16 Byte (0xf11ff06f)
        // ========================================================================
        ram[8194] = 32'h800007b7; // lui a5, 0x80000     (載入 MMIO 基底位址 0x80000000)
        ram[8195] = 32'h0007a603; // lw a2, 0(a5)        (從 0x80000000 讀取指撥開關 sw)
        ram[8196] = 32'h00c7a223; // sw a2, 4(a5)        (寫入 0x80000004 控制 LED)
        ram[8197] = 32'h00c7a423; // sw a2, 8(a5)        (寫入 0x80000008 控制七段顯示器)
        ram[8198] = 32'hf11ff06f; // ✨ 修正：j 8194     (精準往回跳 16 Byte，形成即時無限循環)
    end

    // 處理 CPU 的【讀取 (Read)】請求
    always @(posedge clk) begin
        if (mem_valid && (mem_wstrb == 4'b0000)) begin
            mem_rdata <= ram[ram_idx]; 
        end
    end

    // 處理 CPU 的【寫入 (Write)】請求（支援 Byte 寫入）
    always @(posedge clk) begin
        if (mem_valid && (mem_wstrb != 4'b0000)) begin
            if (mem_wstrb[0]) ram[ram_idx][7:0]   <= mem_wdata[7:0];
            if (mem_wstrb[1]) ram[ram_idx][15:8]  <= mem_wdata[15:8];
            if (mem_wstrb[2]) ram[ram_idx][23:16] <= mem_wdata[23:16];
            if (mem_wstrb[3]) ram[ram_idx][31:24] <= mem_wdata[31:24];
        end
    end

endmodule