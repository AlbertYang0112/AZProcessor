GPIO_BASE_ADDR_H    EQU 0x8000
GPIO_OUT_OFFSET     EQU 0x4

    ; Set R0 = 0
    XORR    r0,r0,r0
    ; Set R1 = GPIO_BASE_ADDR
    ORI     r0,r1,GPIO_BASE_ADDR_H
    SHLLI   r1,r1,16
    ; Set R2 = 0x0000_00AA
    ORI     r0,r2,0x0000
    SHLLI   r2,r2,16
    ORI     r2,r2,0x00AA
    ; Set the GPIO
    STW     r1,r2,GPIO_OUT_OFFSET

LOOP:
    BE      r0,r0,LOOP
    ANDR    r0,r0,r0