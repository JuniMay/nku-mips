main:
    addiu $2, $0, 0x100
    addiu $3, $0, 0x200
    div $3, $2
    mflo $4
    mfhi $5
    addiu $6, $0, 0xff00 # -0x100
    addiu $7, $0, 0x200
    div $7, $6
    mflo $8
    mfhi $9
    j 0x34
    