GPIO_BASE_ADDR_H    EQU 0x8000
GPIO_OUT_OFFSET     EQU 0x4
DELAY_OUTER_CYCLE   EQU 0x000000FA
DELAY_INNER_CYCLE   EQU 0x00000d05
LED_TOP             EQU 0x00000080

    ; Set R0 = 0
    XORR    r0,r0,r0
    ; Set R1 = GPIO_BASE_ADDR 0x8000_0000
    ORI     r0,r1,GPIO_BASE_ADDR_H
    SHLLI   r1,r1,16
    ; Set R2 = 0x0000_0001
    ORI     r0,r2,0x0001
    ORI     r0,r5,DELAY_INNER_CYCLE
    ORI     r0,r6,DELAY_OUTER_CYCLE
    ORI     r0,r7,LED_TOP

MAIN_LOOP:
    STW     r1,r2,GPIO_OUT_OFFSET

    ; Set R3 = 0x0000_0000
    ; R3 Outer loop counter
    XORR    r3,r3,r3
DELAY_OUTER_LOOP:
        ; R3++;
        ADDUI   r3,r3,0x0001
        ; R4 Inner loop counter
        XORR    r4,r4,r4
DELAY_INNER_LOOP:
            ADDUI   r4,r4,0x0001
            BUGT    r4,r5,DELAY_INNER_LOOP
            ANDR    r0,r0,r0
        BUGT    r3,r6,DELAY_OUTER_LOOP
        ANDR        r0,r0,r0
    
    BE      r2,r7,RESTORE_LED
    ANDR    r0,r0,r0
    SHLLI   r2,r2,0x0001
    BE      r0,r0,MAIN_LOOP
    ANDR    r0,r0,r0
RESTORE_LED:
    ORI     r0,r2,0x0001
    BE      r0,r0,MAIN_LOOP
    ANDR    r0,r0,r0