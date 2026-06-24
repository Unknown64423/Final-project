// ====================================================================
// RISC-V PicoRV32 Firmware - C Language Implementation
// 專題題目：RISC-V Memory-Mapped I/O LED與七段顯示器控制系統
// ====================================================================

// 1. 定義 Memory-Mapped I/O (MMIO) 的暫存器位址 (嚴格對齊階段一的硬體設計)
#define REG_SWITCH    (*(volatile unsigned int *)0x80000000) // 唯讀：指撥開關
#define REG_LED       (*(volatile unsigned int *)0x80000004) // 可讀寫：LED燈
#define REG_SEVENSEG  (*(volatile unsigned int *)0x80000008) // 可讀寫：七段顯示器

int main(void) {
    unsigned int switch_val;

    // 系統主迴圈 (無窮迴圈，反覆監測硬體狀態)
    while (1) {
        // 2. 讀取輸入：從開關位址讀取 4-bit 狀態 (SW0~SW3)
        switch_val = REG_SWITCH & 0x0000000F;

        // 3. 執行運算與邏輯判斷 (對應驗證計畫之需求)
        // 這裡將開關的值直接指派給輸出
        
        // 4. 控制輸出：寫入 LED 暫存器 (控制實體 LED0~LED3 二進位點亮)
        REG_LED = switch_val;

        // 5. 控制輸出：寫入七段顯示器暫存器 (控制實體七段顯示器顯示十六進位數值碼)
        REG_SEVENSEG = switch_val;
        
        // 稍微做個小延遲，防止過度佔用 CPU 匯流排 (選用)
        for (volatile int i = 0; i < 1000; i++);
    }

    return 0;
}