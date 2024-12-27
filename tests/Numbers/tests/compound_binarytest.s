; line with label, opcode, tokens
; objective: correct parsing of different number systems
;
; Basic 1-byte number tests
.org $40000
; Hexadecimal
    ld a, 0xa
    ld a, 0xA
    ld a, 0XA
    ld a, 0x0A
    ld a, 0X0A
    ld a, 0x00A ; test overflow test in operand parsing
    ld a, 0X00A
    ld a, #A
    ld a, #0A
    ld a, #00A
    ld a, $A
    ld a, $0A
    ld a, $00A
    ld a, Ah
    ld a, AH
    ld a, 0Ah
    ld a, 0AH
    ld a, 00Ah
    ld a, 00AH
    ld a, 0bh  ; weird case, needs priority before binary
    ld a, 0bH
    ld a, 0b0h ; idem
    ld a, 0b0H
    ld a, 0b1h ; idem
    ld a, 0b1H
; all numbers for safety
    ld a, 0h
    ld a, 1h
    ld a, 2h
    ld a, 3h
    ld a, 4h
    ld a, 5h
    ld a, 6h
    ld a, 7h
    ld a, 8h
    ld a, 9h
    ld a, ah
    ld a, bh
    ld a, ch
    ld a, dh
    ld a, eh
    ld a, fh
    ld a, 00h
    ld a, 01h
    ld a, 02h
    ld a, 03h
    ld a, 04h
    ld a, 05h
    ld a, 06h
    ld a, 07h
    ld a, 08h
    ld a, 09h
    ld a, 0ah
    ld a, 0bh
    ld a, 0ch
    ld a, 0dh
    ld a, 0eh
    ld a, 0fh
    ld a, 10h
    ld a, 11h
    ld a, 12h
    ld a, 13h
    ld a, 14h
    ld a, 15h
    ld a, 16h
    ld a, 17h
    ld a, 18h
    ld a, 19h
    ld a, 1ah
    ld a, 1bh
    ld a, 1ch
    ld a, 1dh
    ld a, 1eh
    ld a, 1fh
    ld a, 20h
    ld a, 21h
    ld a, 22h
    ld a, 23h
    ld a, 24h
    ld a, 25h
    ld a, 26h
    ld a, 27h
    ld a, 28h
    ld a, 29h
    ld a, 2ah
    ld a, 2bh
    ld a, 2ch
    ld a, 2dh
    ld a, 2eh
    ld a, 2fh
    ld a, 30h
    ld a, 31h
    ld a, 32h
    ld a, 33h
    ld a, 34h
    ld a, 35h
    ld a, 36h
    ld a, 37h
    ld a, 38h
    ld a, 39h
    ld a, 3ah
    ld a, 3bh
    ld a, 3ch
    ld a, 3dh
    ld a, 3eh
    ld a, 3fh
    ld a, 40h
    ld a, 41h
    ld a, 42h
    ld a, 43h
    ld a, 44h
    ld a, 45h
    ld a, 46h
    ld a, 47h
    ld a, 48h
    ld a, 49h
    ld a, 4ah
    ld a, 4bh
    ld a, 4ch
    ld a, 4dh
    ld a, 4eh
    ld a, 4fh
    ld a, 50h
    ld a, 51h
    ld a, 52h
    ld a, 53h
    ld a, 54h
    ld a, 55h
    ld a, 56h
    ld a, 57h
    ld a, 58h
    ld a, 59h
    ld a, 5ah
    ld a, 5bh
    ld a, 5ch
    ld a, 5dh
    ld a, 5eh
    ld a, 5fh
    ld a, 60h
    ld a, 61h
    ld a, 62h
    ld a, 63h
    ld a, 64h
    ld a, 65h
    ld a, 66h
    ld a, 67h
    ld a, 68h
    ld a, 69h
    ld a, 6ah
    ld a, 6bh
    ld a, 6ch
    ld a, 6dh
    ld a, 6eh
    ld a, 6fh
    ld a, 70h
    ld a, 71h
    ld a, 72h
    ld a, 73h
    ld a, 74h
    ld a, 75h
    ld a, 76h
    ld a, 77h
    ld a, 78h
    ld a, 79h
    ld a, 7ah
    ld a, 7bh
    ld a, 7ch
    ld a, 7dh
    ld a, 7eh
    ld a, 7fh
    ld a, 80h
    ld a, 81h
    ld a, 82h
    ld a, 83h
    ld a, 84h
    ld a, 85h
    ld a, 86h
    ld a, 87h
    ld a, 88h
    ld a, 89h
    ld a, 8ah
    ld a, 8bh
    ld a, 8ch
    ld a, 8dh
    ld a, 8eh
    ld a, 8fh
    ld a, 90h
    ld a, 91h
    ld a, 92h
    ld a, 93h
    ld a, 94h
    ld a, 95h
    ld a, 96h
    ld a, 97h
    ld a, 98h
    ld a, 99h
    ld a, 9ah
    ld a, 9bh
    ld a, 9ch
    ld a, 9dh
    ld a, 9eh
    ld a, 9fh
    ld a, a0h
    ld a, a1h
    ld a, a2h
    ld a, a3h
    ld a, a4h
    ld a, a5h
    ld a, a6h
    ld a, a7h
    ld a, a8h
    ld a, a9h
    ld a, aah
    ld a, abh
    ld a, ach
    ld a, adh
    ld a, aeh
    ld a, afh
    ld a, b0h
    ld a, b1h
    ld a, b2h
    ld a, b3h
    ld a, b4h
    ld a, b5h
    ld a, b6h
    ld a, b7h
    ld a, b8h
    ld a, b9h
    ld a, bah
    ld a, bbh
    ld a, bch
    ld a, bdh
    ld a, beh
    ld a, bfh
    ld a, c0h
    ld a, c1h
    ld a, c2h
    ld a, c3h
    ld a, c4h
    ld a, c5h
    ld a, c6h
    ld a, c7h
    ld a, c8h
    ld a, c9h
    ld a, cah
    ld a, cbh
    ld a, cch
    ld a, cdh
    ld a, ceh
    ld a, cfh
    ld a, d0h
    ld a, d1h
    ld a, d2h
    ld a, d3h
    ld a, d4h
    ld a, d5h
    ld a, d6h
    ld a, d7h
    ld a, d8h
    ld a, d9h
    ld a, dah
    ld a, dbh
    ld a, dch
    ld a, ddh
    ld a, deh
    ld a, dfh
    ld a, e0h
    ld a, e1h
    ld a, e2h
    ld a, e3h
    ld a, e4h
    ld a, e5h
    ld a, e6h
    ld a, e7h
    ld a, e8h
    ld a, e9h
    ld a, eah
    ld a, ebh
    ld a, ech
    ld a, edh
    ld a, eeh
    ld a, efh
    ld a, f0h
    ld a, f1h
    ld a, f2h
    ld a, f3h
    ld a, f4h
    ld a, f5h
    ld a, f6h
    ld a, f7h
    ld a, f8h
    ld a, f9h
    ld a, fah
    ld a, fbh
    ld a, fch
    ld a, fdh
    ld a, feh
    ld a, ffh

    ld a, $0
    ld a, $1
    ld a, $2
    ld a, $3
    ld a, $4
    ld a, $5
    ld a, $6
    ld a, $7
    ld a, $8
    ld a, $9
    ld a, $a
    ld a, $b
    ld a, $c
    ld a, $d
    ld a, $e
    ld a, $f
    ld a, $00
    ld a, $01
    ld a, $02
    ld a, $03
    ld a, $04
    ld a, $05
    ld a, $06
    ld a, $07
    ld a, $08
    ld a, $09
    ld a, $0a
    ld a, $0b
    ld a, $0c
    ld a, $0d
    ld a, $0e
    ld a, $0f
    ld a, $10
    ld a, $11
    ld a, $12
    ld a, $13
    ld a, $14
    ld a, $15
    ld a, $16
    ld a, $17
    ld a, $18
    ld a, $19
    ld a, $1a
    ld a, $1b
    ld a, $1c
    ld a, $1d
    ld a, $1e
    ld a, $1f
    ld a, $20
    ld a, $21
    ld a, $22
    ld a, $23
    ld a, $24
    ld a, $25
    ld a, $26
    ld a, $27
    ld a, $28
    ld a, $29
    ld a, $2a
    ld a, $2b
    ld a, $2c
    ld a, $2d
    ld a, $2e
    ld a, $2f
    ld a, $30
    ld a, $31
    ld a, $32
    ld a, $33
    ld a, $34
    ld a, $35
    ld a, $36
    ld a, $37
    ld a, $38
    ld a, $39
    ld a, $3a
    ld a, $3b
    ld a, $3c
    ld a, $3d
    ld a, $3e
    ld a, $3f
    ld a, $40
    ld a, $41
    ld a, $42
    ld a, $43
    ld a, $44
    ld a, $45
    ld a, $46
    ld a, $47
    ld a, $48
    ld a, $49
    ld a, $4a
    ld a, $4b
    ld a, $4c
    ld a, $4d
    ld a, $4e
    ld a, $4f
    ld a, $50
    ld a, $51
    ld a, $52
    ld a, $53
    ld a, $54
    ld a, $55
    ld a, $56
    ld a, $57
    ld a, $58
    ld a, $59
    ld a, $5a
    ld a, $5b
    ld a, $5c
    ld a, $5d
    ld a, $5e
    ld a, $5f
    ld a, $60
    ld a, $61
    ld a, $62
    ld a, $63
    ld a, $64
    ld a, $65
    ld a, $66
    ld a, $67
    ld a, $68
    ld a, $69
    ld a, $6a
    ld a, $6b
    ld a, $6c
    ld a, $6d
    ld a, $6e
    ld a, $6f
    ld a, $70
    ld a, $71
    ld a, $72
    ld a, $73
    ld a, $74
    ld a, $75
    ld a, $76
    ld a, $77
    ld a, $78
    ld a, $79
    ld a, $7a
    ld a, $7b
    ld a, $7c
    ld a, $7d
    ld a, $7e
    ld a, $7f
    ld a, $80
    ld a, $81
    ld a, $82
    ld a, $83
    ld a, $84
    ld a, $85
    ld a, $86
    ld a, $87
    ld a, $88
    ld a, $89
    ld a, $8a
    ld a, $8b
    ld a, $8c
    ld a, $8d
    ld a, $8e
    ld a, $8f
    ld a, $90
    ld a, $91
    ld a, $92
    ld a, $93
    ld a, $94
    ld a, $95
    ld a, $96
    ld a, $97
    ld a, $98
    ld a, $99
    ld a, $9a
    ld a, $9b
    ld a, $9c
    ld a, $9d
    ld a, $9e
    ld a, $9f
    ld a, $a0
    ld a, $a1
    ld a, $a2
    ld a, $a3
    ld a, $a4
    ld a, $a5
    ld a, $a6
    ld a, $a7
    ld a, $a8
    ld a, $a9
    ld a, $aa
    ld a, $ab
    ld a, $ac
    ld a, $ad
    ld a, $ae
    ld a, $af
    ld a, $b0
    ld a, $b1
    ld a, $b2
    ld a, $b3
    ld a, $b4
    ld a, $b5
    ld a, $b6
    ld a, $b7
    ld a, $b8
    ld a, $b9
    ld a, $ba
    ld a, $bb
    ld a, $bc
    ld a, $bd
    ld a, $be
    ld a, $bf
    ld a, $c0
    ld a, $c1
    ld a, $c2
    ld a, $c3
    ld a, $c4
    ld a, $c5
    ld a, $c6
    ld a, $c7
    ld a, $c8
    ld a, $c9
    ld a, $ca
    ld a, $cb
    ld a, $cc
    ld a, $cd
    ld a, $ce
    ld a, $cf
    ld a, $d0
    ld a, $d1
    ld a, $d2
    ld a, $d3
    ld a, $d4
    ld a, $d5
    ld a, $d6
    ld a, $d7
    ld a, $d8
    ld a, $d9
    ld a, $da
    ld a, $db
    ld a, $dc
    ld a, $dd
    ld a, $de
    ld a, $df
    ld a, $e0
    ld a, $e1
    ld a, $e2
    ld a, $e3
    ld a, $e4
    ld a, $e5
    ld a, $e6
    ld a, $e7
    ld a, $e8
    ld a, $e9
    ld a, $ea
    ld a, $eb
    ld a, $ec
    ld a, $ed
    ld a, $ee
    ld a, $ef
    ld a, $f0
    ld a, $f1
    ld a, $f2
    ld a, $f3
    ld a, $f4
    ld a, $f5
    ld a, $f6
    ld a, $f7
    ld a, $f8
    ld a, $f9
    ld a, $fa
    ld a, $fb
    ld a, $fc
    ld a, $fd
    ld a, $fe
    ld a, $ff

    ld a, #0
    ld a, #1
    ld a, #2
    ld a, #3
    ld a, #4
    ld a, #5
    ld a, #6
    ld a, #7
    ld a, #8
    ld a, #9
    ld a, #a
    ld a, #b
    ld a, #c
    ld a, #d
    ld a, #e
    ld a, #f
    ld a, #00
    ld a, #01
    ld a, #02
    ld a, #03
    ld a, #04
    ld a, #05
    ld a, #06
    ld a, #07
    ld a, #08
    ld a, #09
    ld a, #0a
    ld a, #0b
    ld a, #0c
    ld a, #0d
    ld a, #0e
    ld a, #0f
    ld a, #10
    ld a, #11
    ld a, #12
    ld a, #13
    ld a, #14
    ld a, #15
    ld a, #16
    ld a, #17
    ld a, #18
    ld a, #19
    ld a, #1a
    ld a, #1b
    ld a, #1c
    ld a, #1d
    ld a, #1e
    ld a, #1f
    ld a, #20
    ld a, #21
    ld a, #22
    ld a, #23
    ld a, #24
    ld a, #25
    ld a, #26
    ld a, #27
    ld a, #28
    ld a, #29
    ld a, #2a
    ld a, #2b
    ld a, #2c
    ld a, #2d
    ld a, #2e
    ld a, #2f
    ld a, #30
    ld a, #31
    ld a, #32
    ld a, #33
    ld a, #34
    ld a, #35
    ld a, #36
    ld a, #37
    ld a, #38
    ld a, #39
    ld a, #3a
    ld a, #3b
    ld a, #3c
    ld a, #3d
    ld a, #3e
    ld a, #3f
    ld a, #40
    ld a, #41
    ld a, #42
    ld a, #43
    ld a, #44
    ld a, #45
    ld a, #46
    ld a, #47
    ld a, #48
    ld a, #49
    ld a, #4a
    ld a, #4b
    ld a, #4c
    ld a, #4d
    ld a, #4e
    ld a, #4f
    ld a, #50
    ld a, #51
    ld a, #52
    ld a, #53
    ld a, #54
    ld a, #55
    ld a, #56
    ld a, #57
    ld a, #58
    ld a, #59
    ld a, #5a
    ld a, #5b
    ld a, #5c
    ld a, #5d
    ld a, #5e
    ld a, #5f
    ld a, #60
    ld a, #61
    ld a, #62
    ld a, #63
    ld a, #64
    ld a, #65
    ld a, #66
    ld a, #67
    ld a, #68
    ld a, #69
    ld a, #6a
    ld a, #6b
    ld a, #6c
    ld a, #6d
    ld a, #6e
    ld a, #6f
    ld a, #70
    ld a, #71
    ld a, #72
    ld a, #73
    ld a, #74
    ld a, #75
    ld a, #76
    ld a, #77
    ld a, #78
    ld a, #79
    ld a, #7a
    ld a, #7b
    ld a, #7c
    ld a, #7d
    ld a, #7e
    ld a, #7f
    ld a, #80
    ld a, #81
    ld a, #82
    ld a, #83
    ld a, #84
    ld a, #85
    ld a, #86
    ld a, #87
    ld a, #88
    ld a, #89
    ld a, #8a
    ld a, #8b
    ld a, #8c
    ld a, #8d
    ld a, #8e
    ld a, #8f
    ld a, #90
    ld a, #91
    ld a, #92
    ld a, #93
    ld a, #94
    ld a, #95
    ld a, #96
    ld a, #97
    ld a, #98
    ld a, #99
    ld a, #9a
    ld a, #9b
    ld a, #9c
    ld a, #9d
    ld a, #9e
    ld a, #9f
    ld a, #a0
    ld a, #a1
    ld a, #a2
    ld a, #a3
    ld a, #a4
    ld a, #a5
    ld a, #a6
    ld a, #a7
    ld a, #a8
    ld a, #a9
    ld a, #aa
    ld a, #ab
    ld a, #ac
    ld a, #ad
    ld a, #ae
    ld a, #af
    ld a, #b0
    ld a, #b1
    ld a, #b2
    ld a, #b3
    ld a, #b4
    ld a, #b5
    ld a, #b6
    ld a, #b7
    ld a, #b8
    ld a, #b9
    ld a, #ba
    ld a, #bb
    ld a, #bc
    ld a, #bd
    ld a, #be
    ld a, #bf
    ld a, #c0
    ld a, #c1
    ld a, #c2
    ld a, #c3
    ld a, #c4
    ld a, #c5
    ld a, #c6
    ld a, #c7
    ld a, #c8
    ld a, #c9
    ld a, #ca
    ld a, #cb
    ld a, #cc
    ld a, #cd
    ld a, #ce
    ld a, #cf
    ld a, #d0
    ld a, #d1
    ld a, #d2
    ld a, #d3
    ld a, #d4
    ld a, #d5
    ld a, #d6
    ld a, #d7
    ld a, #d8
    ld a, #d9
    ld a, #da
    ld a, #db
    ld a, #dc
    ld a, #dd
    ld a, #de
    ld a, #df
    ld a, #e0
    ld a, #e1
    ld a, #e2
    ld a, #e3
    ld a, #e4
    ld a, #e5
    ld a, #e6
    ld a, #e7
    ld a, #e8
    ld a, #e9
    ld a, #ea
    ld a, #eb
    ld a, #ec
    ld a, #ed
    ld a, #ee
    ld a, #ef
    ld a, #f0
    ld a, #f1
    ld a, #f2
    ld a, #f3
    ld a, #f4
    ld a, #f5
    ld a, #f6
    ld a, #f7
    ld a, #f8
    ld a, #f9
    ld a, #fa
    ld a, #fb
    ld a, #fc
    ld a, #fd
    ld a, #fe
    ld a, #ff

    ld a, 0x0
    ld a, 0x1
    ld a, 0x2
    ld a, 0x3
    ld a, 0x4
    ld a, 0x5
    ld a, 0x6
    ld a, 0x7
    ld a, 0x8
    ld a, 0x9
    ld a, 0xa
    ld a, 0xb
    ld a, 0xc
    ld a, 0xd
    ld a, 0xe
    ld a, 0xf
    ld a, 0x00
    ld a, 0x01
    ld a, 0x02
    ld a, 0x03
    ld a, 0x04
    ld a, 0x05
    ld a, 0x06
    ld a, 0x07
    ld a, 0x08
    ld a, 0x09
    ld a, 0x0a
    ld a, 0x0b
    ld a, 0x0c
    ld a, 0x0d
    ld a, 0x0e
    ld a, 0x0f
    ld a, 0x10
    ld a, 0x11
    ld a, 0x12
    ld a, 0x13
    ld a, 0x14
    ld a, 0x15
    ld a, 0x16
    ld a, 0x17
    ld a, 0x18
    ld a, 0x19
    ld a, 0x1a
    ld a, 0x1b
    ld a, 0x1c
    ld a, 0x1d
    ld a, 0x1e
    ld a, 0x1f
    ld a, 0x20
    ld a, 0x21
    ld a, 0x22
    ld a, 0x23
    ld a, 0x24
    ld a, 0x25
    ld a, 0x26
    ld a, 0x27
    ld a, 0x28
    ld a, 0x29
    ld a, 0x2a
    ld a, 0x2b
    ld a, 0x2c
    ld a, 0x2d
    ld a, 0x2e
    ld a, 0x2f
    ld a, 0x30
    ld a, 0x31
    ld a, 0x32
    ld a, 0x33
    ld a, 0x34
    ld a, 0x35
    ld a, 0x36
    ld a, 0x37
    ld a, 0x38
    ld a, 0x39
    ld a, 0x3a
    ld a, 0x3b
    ld a, 0x3c
    ld a, 0x3d
    ld a, 0x3e
    ld a, 0x3f
    ld a, 0x40
    ld a, 0x41
    ld a, 0x42
    ld a, 0x43
    ld a, 0x44
    ld a, 0x45
    ld a, 0x46
    ld a, 0x47
    ld a, 0x48
    ld a, 0x49
    ld a, 0x4a
    ld a, 0x4b
    ld a, 0x4c
    ld a, 0x4d
    ld a, 0x4e
    ld a, 0x4f
    ld a, 0x50
    ld a, 0x51
    ld a, 0x52
    ld a, 0x53
    ld a, 0x54
    ld a, 0x55
    ld a, 0x56
    ld a, 0x57
    ld a, 0x58
    ld a, 0x59
    ld a, 0x5a
    ld a, 0x5b
    ld a, 0x5c
    ld a, 0x5d
    ld a, 0x5e
    ld a, 0x5f
    ld a, 0x60
    ld a, 0x61
    ld a, 0x62
    ld a, 0x63
    ld a, 0x64
    ld a, 0x65
    ld a, 0x66
    ld a, 0x67
    ld a, 0x68
    ld a, 0x69
    ld a, 0x6a
    ld a, 0x6b
    ld a, 0x6c
    ld a, 0x6d
    ld a, 0x6e
    ld a, 0x6f
    ld a, 0x70
    ld a, 0x71
    ld a, 0x72
    ld a, 0x73
    ld a, 0x74
    ld a, 0x75
    ld a, 0x76
    ld a, 0x77
    ld a, 0x78
    ld a, 0x79
    ld a, 0x7a
    ld a, 0x7b
    ld a, 0x7c
    ld a, 0x7d
    ld a, 0x7e
    ld a, 0x7f
    ld a, 0x80
    ld a, 0x81
    ld a, 0x82
    ld a, 0x83
    ld a, 0x84
    ld a, 0x85
    ld a, 0x86
    ld a, 0x87
    ld a, 0x88
    ld a, 0x89
    ld a, 0x8a
    ld a, 0x8b
    ld a, 0x8c
    ld a, 0x8d
    ld a, 0x8e
    ld a, 0x8f
    ld a, 0x90
    ld a, 0x91
    ld a, 0x92
    ld a, 0x93
    ld a, 0x94
    ld a, 0x95
    ld a, 0x96
    ld a, 0x97
    ld a, 0x98
    ld a, 0x99
    ld a, 0x9a
    ld a, 0x9b
    ld a, 0x9c
    ld a, 0x9d
    ld a, 0x9e
    ld a, 0x9f
    ld a, 0xa0
    ld a, 0xa1
    ld a, 0xa2
    ld a, 0xa3
    ld a, 0xa4
    ld a, 0xa5
    ld a, 0xa6
    ld a, 0xa7
    ld a, 0xa8
    ld a, 0xa9
    ld a, 0xaa
    ld a, 0xab
    ld a, 0xac
    ld a, 0xad
    ld a, 0xae
    ld a, 0xaf
    ld a, 0xb0
    ld a, 0xb1
    ld a, 0xb2
    ld a, 0xb3
    ld a, 0xb4
    ld a, 0xb5
    ld a, 0xb6
    ld a, 0xb7
    ld a, 0xb8
    ld a, 0xb9
    ld a, 0xba
    ld a, 0xbb
    ld a, 0xbc
    ld a, 0xbd
    ld a, 0xbe
    ld a, 0xbf
    ld a, 0xc0
    ld a, 0xc1
    ld a, 0xc2
    ld a, 0xc3
    ld a, 0xc4
    ld a, 0xc5
    ld a, 0xc6
    ld a, 0xc7
    ld a, 0xc8
    ld a, 0xc9
    ld a, 0xca
    ld a, 0xcb
    ld a, 0xcc
    ld a, 0xcd
    ld a, 0xce
    ld a, 0xcf
    ld a, 0xd0
    ld a, 0xd1
    ld a, 0xd2
    ld a, 0xd3
    ld a, 0xd4
    ld a, 0xd5
    ld a, 0xd6
    ld a, 0xd7
    ld a, 0xd8
    ld a, 0xd9
    ld a, 0xda
    ld a, 0xdb
    ld a, 0xdc
    ld a, 0xdd
    ld a, 0xde
    ld a, 0xdf
    ld a, 0xe0
    ld a, 0xe1
    ld a, 0xe2
    ld a, 0xe3
    ld a, 0xe4
    ld a, 0xe5
    ld a, 0xe6
    ld a, 0xe7
    ld a, 0xe8
    ld a, 0xe9
    ld a, 0xea
    ld a, 0xeb
    ld a, 0xec
    ld a, 0xed
    ld a, 0xee
    ld a, 0xef
    ld a, 0xf0
    ld a, 0xf1
    ld a, 0xf2
    ld a, 0xf3
    ld a, 0xf4
    ld a, 0xf5
    ld a, 0xf6
    ld a, 0xf7
    ld a, 0xf8
    ld a, 0xf9
    ld a, 0xfa
    ld a, 0xfb
    ld a, 0xfc
    ld a, 0xfd
    ld a, 0xfe
    ld a, 0xff
; Binary
    ld a, 0b0
    ld a, 0B0
    ld a, 0b1
    ld a, 0B1
    ld a, 0b01
    ld a, 0B01
    ld a, 0b10
    ld a, 0B10
    ld a, 0b11111111
    ld a, 0B11111111
    ld a, 0b00000000
    ld a, 0B00000000
    ld a, 0b000000001 ; test overflow test in operand parsing
    ld a, 0B000000001
    ld a, %0
    ld a, %1
    ld a, %01
    ld a, %10
    ld a, %11111111
    ld a, %00000000
    ld a, %000000001 ; test overflow test in operand parsing
    ld a, 0b
    ld a, 0B
    ld a, 1b
    ld a, 1B
    ld a, 01b
    ld a, 01B
    ld a, 10b
    ld a, 10B
    ld a, 11111111b
    ld a, 11111111B
    ld a, 00000000b
    ld a, 00000000B
    ld a, 000000001b ; test overflow test in operand parsing
    ld a, 000000001B
; Decimal
    ld a, 00
    ld a, 01
    ld a, 02
    ld a, 03
    ld a, 04
    ld a, 05
    ld a, 06
    ld a, 07
    ld a, 08
    ld a, 09
    ld a, 0
    ld a, 1
    ld a, 2
    ld a, 3
    ld a, 4
    ld a, 5
    ld a, 6
    ld a, 7
    ld a, 8
    ld a, 9
    ld a, 128
    ld a, 255