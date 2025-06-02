;---------------------------------------------------------------;
;---------------------------------------------------------------;
NDPINI_X1:
	call	NDPINI
	call	check_ctc_adrs
	call	setup_int
	ret

NDPOFF_X1:
	call	NDPOFF
	call	release_ctc
	ret

;---------------------------------------------------------------;
;	�����̃t�@�C�����������ɓǍ���
; �߂�l:
;	Areg:
;		0ffh �Ǎ����s
;		01h �Ō�܂œǂݏI�����
;---------------------------------------------------------------;
read_arg_file:
	ld		c,CMD_FILE_OPEN		;�t�@�C���̃I�[�v��(_fopen)
	call	file_system
	cp		0ffh
	jr		z, exit_read	; ���s������߂�B
;
	ld		hl,1
	ld		(FCB1+14),hl	;���R�[�h�T�C�Y��1�ɂ���

	ld		hl,0		;FCB1���g���ꍇ�̓����_�����R�[�h������������
	ld		(FCB1+33),hl	;�����_�����R�[�h��0�ɂ���
	ld		(FCB1+35),hl

	ld		hl,BUFAD	; �Ǐo����A�h���X
loop_read:
	push	hl
	ex		de,hl
	ld		c,CMD_SET_DATA_ADRS		;dta�̐ݒ�(_setdta)
	call	SYSTEM

	ld		hl,BUFSZ	;��x�ɓǂݏo���T�C�Y�i�o�C�g�P�ʁj
	ld		c,CMD_READ_RAND_BLOCK	;�����_���u���b�N�ǂݏo��(_rdblk)
	call	file_system

	pop		de			; HLreg: ���ۂɓǍ��܂ꂽ�T�C�Y
	add		hl,de

	cp		0ffh
	jr		z,exit_read	;���s������I��
;
	; Areg:
	;	0: �w��T�C�Y��Ǎ��ł���(=�c�肪�܂�����)
	;	1: �Ǎ��ł��Ȃ�����(=�܂��c���Ă���)

	or		a
	jr		z,loop_read
;
exit_read:
	push	af
	ld		c,CMD_FILE_CLOSE	;�t�@�C���̃N���[�Y(_fclose)
	call	file_system
	pop		af
	ret

file_system:
	ld		de,FCB1
	jp		SYSTEM

print_title_str:
	ld		de, str_title
print_system:
	ld		c, CMD_STR_OUT
	jp		SYSTEM

str_title:
	db		"** X1/turbo NDP player (v14.103) **",0dh,0ah
	db		" usage: Press any key to quit.",0dh,0ah
	db		0dh,0ah, '$' 

print_read_filename:
	ld		de,str_filename
	ld		hl,FCB1+01h
	call	set_filename

	ld		de, str_read_filename
	call	print_system

	ld		de, str_filename
	jp		print_system

print_failed_filename:
	ld		de,str_filename
	ld		hl,FCB1+01h
	call	set_filename

	ld		de, str_failed_filename
	call	print_system

	ld		de, str_filename
	jp		print_system

set_filename:
	ld		bc,008h
	ldir
	inc		de
	ld		bc,003h
	ldir
	ret

print_done:
	ld		de, str_done
	jp		print_system

str_read_filename:
	db		" Read NDP file: $"

str_failed_filename:
	db		"   Can't Read NDP file: $"

str_filename:
	ds		8,20h
	db		'.'
	ds		3,20h

	db		0dh,0ah
	db		'$'

str_done:
	db		" Done.",0dh,0ah,'$'

; �L�[�{�[�h�̃`�F�b�N
; �߂�l:
;	�L�[��������Ă���ꍇ (Areg: 00h) , Zflag
;	������Ă��Ȃ��ꍇ (Areg: 01h) NZero
check_keyboard:
	ld		c,CMD_CHECK_KEY
	call	SYSTEM
	inc		a
	ret

;---------------------------------------------------------------;
;	CTC�𓋍ڂ��Ă��邩�ǂ����̔���
;����
;	ctc_adrs_work : �g�p����CTC�̃A�h���X
;		X1turbo �� 1fa0h
;		X1(FM�����{�[�h����) �� 0704h
;		�m�[�}��X1 �� 0000h
;---------------------------------------------------------------;
check_ctc_adrs:
	ld		bc, CTC_TURBO_ADRS
	ld		de, 07a0h	; CTC�`�F�b�N�l: Ereg��0�ȊO�̔C�Ӓl
	call	check_ctc_latch
	jr		z,set_ctc_adrs
;
	ld		bc, CTC_X1_ADRS
	call	check_ctc_latch
	jr		z,set_ctc_adrs
;
	ld		bc,0000h
set_ctc_adrs:
	ld		(ctc_adrs_work),bc
	ret

; CTC�̃��b�`�`�F�b�N
check_ctc_latch:
	out		(c),d
	out		(c),e
	in		a,(c)
	xor		e
	ret

; ���ۂɎg�p����CTC�A�h���X���i�[����B
;  X1turbo 1fa0h
;  X1 (FM�����{�[�h) CTC  0704h
;  X1 (CTC�񓋍�)  0000h
ctc_adrs_work:
	dw		0000h

;---------------------------------------------------------------;
;	�T�E���h�p�����݂��Z�b�g�A�b�v
;---------------------------------------------------------------;
setup_int:
	di

	; f81e���犄�荞�݃e�[�u���Ƃ��Ĉ����B(CZ-8FB02)
	; 0068���犄�荞�݃e�[�u���Ƃ��Ĉ����B(CZ-8FB01 v1.0)

	ld		de,intrpt_x1

	; Ireg��BASIC��ނ𔻕ʂ���B
	ld		a,i
	ld		h,a

	ld		l, INT_VECTOR1_CTC + 06h	; CZ-8FB01�̏ꍇ
	or		a
	jr		z,se_in_1
;
	ld		l, INT_VECTOR2_CTC + 06h	; CZ-8FB02�̏ꍇ
se_in_1:
	ld		(hl),e
	inc		l
	ld		(hl),d

	; �����݃x�N�g���l�����߂�B
	ld		a,l
	sub		07h

	call	init_ctc_interrupt

	ei
	ret

intrpt_x1:
	di
	call	IMAIN
	ei
int_none:
	reti

;---------------------------------------------------------------;
;	CRTC�𒲐����� 60Hz�̎����ɕύX����B
;	R5�� 2��10�Ɏw�肵�āA�����X�^���𒲐�����B(X1,15KHz�̏ꍇ)
;---------------------------------------------------------------;
adjust_crtc:
	ld		bc, CRTC_ADRS
	ld		de, 050ah
	out		(c),d
	inc		c
	out		(c),e

	ret

;---------------------------------------------------------------;
;---------------------------------------------------------------;
finalize_vtimer:
	ld		a,(ctc_adrs_work)
	or		a
	ret		nz
;
;---------------------------------------------------------------;
;	CRTC�𒲐����� 60Hz�̎����ɕύX����B
;	R5�� 2�Ɏw�肵�āA�����X�^����W���ɖ߂��B(X1,15KHz�̏ꍇ)
;---------------------------------------------------------------;
restore_crtc:
	ld		bc, CRTC_ADRS
	ld		de, 0502h
	out		(c),d
	inc		c
	out		(c),e

	ret

;---------------------------------------------------------------;
;---------------------------------------------------------------;
init_vtimer:
	ld		a,(ctc_adrs_work)
	or		a
	jp		nz, init_ctc
;
	jr		adjust_crtc

;---------------------------------------------------------------;
;	�T�E���h�p�����݂�����
;---------------------------------------------------------------;
release_ctc:
	ld		bc, (ctc_adrs_work)

	ld		h,04h
	ld		a,03h	; CTC�̊ech�����Z�b�g�B
rc_1:
	out		(c),a
	inc		c
	dec		h
	jr		nz,rc_1
;
	ret

;---------------------------------------------------------------;
; VSync�J�n���玟��VSync�̊��荞�݂��Z�b�g����B
; BCreg,DEreg�̂ݔj��
;---------------------------------------------------------------;
init_ctc:
	ld		bc, (ctc_adrs_work)

	; 00010111
	; ch0: �����݂Ȃ�,�^�C�}�[���[�h,�v���X�P�[��16,
	; ���Z�b�g��A�㑱�^�C���R���X�^���g�ݒ�㓮��J�n�B
	; (25*16)/4MHz=100us
	ld		de, 01700h + 25
	out		(c),d
	out		(c),e

	; ch3�A�h���X( +03h)
	inc		c
	inc		c
	inc		c

	; 01010111
	; ch3: �����݂Ȃ�,�J�E���^���[�h
	; ���Z�b�g��A�㑱�^�C���R���X�^���g�ݒ�㓮��J�n�B
	; 00h����̌��Z�J�E���^�ŁA���Z�b�g��̌Œ�^�C�}�[�Ƃ��Ďg�p����B
	ld		de, 05700h + 00h
	out		(c),d
	out		(c),e

	ret

;---------------------------------------------------------------;
; �T�E���h�Đ��p�̊����݂��Z�b�g�A�b�v����B
;	Areg: �����݃x�N�g���l (058h or 018h)
;
; BCreg,DEreg�̂ݔj��
;---------------------------------------------------------------;
init_ctc_interrupt:
	ld		bc, (ctc_adrs_work)

	; 00011000
	; ch0: �����݂Ȃ�,�J�E���^���[�h,�����݃x�N�^�w��
	; bit0=0 ���͊��荞�݃x�N�^���w�肷��B
;;	ld		a, INT_VECTOR_CTC & 0ffh
	out		(c),a

	; 00010111
	; ch0: �����݂Ȃ�,�^�C�}�[���[�h,�v���X�P�[��16,
	; ���Z�b�g��A�㑱�^�C���R���X�^���g�ݒ�㓮��J�n�B
	; (25*16)/4MHz=100us
	ld		de, 01700h + 25
	out		(c),d
	out		(c),e

	; ch3�A�h���X( +03h)
	inc		c
	inc		c
	inc		c

	; 11010111
	; ch3: �����݂���,�J�E���^���[�h
	; ���Z�b�g��A�㑱�^�C���R���X�^���g�ݒ�㓮��J�n�B
	; 100us * 167=16.7ms���ƂɊ����݁B
	ld		de, 0d700h + 167
	out		(c),d
	out		(c),e

	ret

;---------------------------------------------------------------;
;	VSync�Ɠ����� 16.7ms�̎��Ԍo�߂��`�F�b�N����B
;---------------------------------------------------------------;
wait_vtimer:
	ld		bc,(ctc_adrs_work)
	ld		a,c
	or		a
	jr		z,vtimer_x1
;
	add		a,03h
	ld		c,a
wvf_loop:
	in		a,(c)
	neg		; 256 - �_�E���J�E���^ (0ffh,0feh,0fdh,0fch,0fb...)
	cp		CTC_VSYNC_FRAME
	jr		c,wvf_loop
;
	; ����Frame���o�p�Ƀ^�C�}�[�����Z�b�g����B
	call	init_ctc

	ret

vtimer_x1:
	; 1a01h pb7 ����������ԐM��
	ld		bc, 1a01h

	; ����������ԐM���̏I�� (L��H��҂�)
	; VBlank�̏I����҂B
wa_ve_1:
	in		a,(c)			; 12
	jp		p, wa_ve_1
;
;		VSync�J�n��҂B
	; ����������ԐM���̊J�n (H��L��҂�)
	; VBlank�̊J�n��҂B
wa_vs_1:
	in		a,(c)			; 12
	jp		m, wa_vs_1
;
	ret

;---------------------------------------------------------------;
;	�n�[�h�E�F�A�G���x���[�v�o��
;---------------------------------------------------------------;
HENVP:
	; �n�[�h�E�F�A�G���x���[�v(L)
	ld		A,(hl)
	ld		(HENVPW),a
	inc		hl

	; �n�[�h�E�F�A�G���x���[�v(H)
	ld		a,(hl)
	or		a
	ld		(HENVPW+1),a
	jr		nz,henvp_1
;
	; MSX�p�̃n�[�h�E�F�A�G���x���[�v�l����A
	; X1 PSG�p�p�����[�^�ɒu��������
	push	hl
	ld		hl,(HENVPW)
	ld		h, henv_table >> 8
	ld		a,(hl)
	ld		(HENVPW),a
	pop		hl
henvp_1:
	call	HEPWT
	inc		hl

	jp		READ1

;---------------------------------------------------------------;
;	PSG�����f�[�^ (4MHz�p)
;	@hex125����̃f�[�^�Ɠ���ւ� (2025/05/17)
;---------------------------------------------------------------;
PTABLE:
; MSX NDP -> X1 NDP �������g���ϊ��e�[�u��
; X1/turbo�p (PSG�N���b�N4MHz)
;		c     c+    d     d+    e     f     f+    g     g+    a     a+    b
	DW	0EEFH,0E18H,0D4EH,0C8FH,0BDAH,0B30H,0A8FH,09F8H,0968H,08E1H,0862H,07E9H	; o1
	DW	0778H,070CH,06A7H,0648H,05EDH,0598H,0548H,04FCH,04B4H,0471H,0431H,03F5H	; o2
	DW	03BCH,0386H,0354H,0324H,02F7H,02CCH,02A4H,027EH,025AH,0239H,0219H,01FBH	; o3
O4C:
	DW	01DEH,01C3H,01AAH,0192H,017CH,0166H,0152H,013FH,012DH,011DH,010DH,00FEH	; o4
	DW	00EFH,00E2H,00D5H,00C9H,00BEH,00B3H,00A9H,00A0H,0097H,008FH,0087H,007FH	; o5
	DW	0078H,0071H,006BH,0065H,005FH,005AH,0055H,0050H,004CH,0048H,0044H,0040H	; o6
	DW	003CH,0039H,0036H,0033H,0030H,002DH,002BH,0028H,0026H,0024H,0022H,0020H	; o7
	DW	001EH,001DH,001BH,001AH,0018H,0017H,0016H,0014H,0013H,0012H,0011H,0010H	; o8

;---------------------------------------------------------------;
;	PSG �n�[�h�E�F�A�G���x���[�v�f�[�^ (4MHz�p)
;	@hex125����̃f�[�^�Ɠ���ւ� (2025/05/17)
;---------------------------------------------------------------;
align 256
henv_table:
	;	+x0  +x1  +x2  +x3  +x4  +x5  +x6  +x7  +x8  +x9  +xa  +xb  +xc  +xd  +xe  +xf
	DB	000H,001H,003H,004H,005H,006H,007H,008H,009H,00AH,00CH,00DH,00EH,00FH,010H,011H	;0x
	DB	012H,013H,014H,015H,016H,017H,019H,01AH,01BH,01CH,01DH,01EH,020H,021H,022H,023H	;1x
	DB	024H,025H,026H,027H,028H,029H,02BH,02CH,02DH,02EH,02FH,030H,031H,032H,033H,034H	;2x
	DB	035H,037H,038H,039H,03AH,03BH,03CH,03DH,03FH,040H,041H,042H,043H,044H,045H,046H	;3x
	DB	047H,049H,04AH,04BH,04CH,04DH,04EH,04FH,050H,052H,053H,054H,055H,056H,057H,059H	;4x
	DB	05AH,05BH,05CH,05DH,05EH,05FH,060H,061H,062H,063H,065H,066H,067H,068H,069H,06AH	;5x
	DB	06BH,06CH,06EH,06FH,070H,071H,072H,073H,074H,075H,076H,078H,078H,07AH,07BH,07CH	;6x
	DB	07DH,07EH,07FH,081H,082H,083H,084H,085H,086H,087H,088H,08AH,08BH,08CH,08DH,08EH	;7x
	DB	08EH,090H,091H,092H,093H,094H,095H,096H,097H,099H,09AH,09BH,09DH,09DH,09EH,0A0H	;8x
	DB	0A0H,0A2H,0A3H,0A4H,0A5H,0A6H,0A7H,0A8H,0A9H,0ABH,0ACH,0ADH,0AEH,0B0H,0B1H,0B2H	;9x
	DB	0B3H,0B4H,0B5H,0B6H,0B7H,0B8H,0B9H,0BBH,0BCH,0BDH,0BEH,0BFH,0C0H,0C1H,0C3H,0C4H	;ax
	DB	0C5H,0C6H,0C7H,0C8H,0C9H,0CAH,0CBH,0CCH,0CEH,0CFH,0D0H,0D1H,0D2H,0D3H,0D4H,0D5H	;bx
	DB	0D5H,0D5H,0D9H,0DAH,0DBH,0DCH,0DDH,0DEH,0E0H,0E1H,0E2H,0E3H,0E4H,0E5H,0E6H,0E7H	;cx
	DB	0E8H,0E9H,0EAH,0ECH,0EDH,0EEH,0EFH,0F0H,0F1H,0F2H,0F3H,0F4H,0F6H,0F7H,0F8H,0F9H	;dx
	DB	0FAH,0FBH,0FCH,0FDH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FEH,0FFH	;ex
	DB	0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH,0FFH	;fx

;---------------------------------------------------------------;
	END

