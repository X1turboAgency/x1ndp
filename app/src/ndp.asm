;[NDP] - PSG Music Driver for MSX - Programmed by naruto2413

HTIMI	EQU	0FD9FH	;�^�C�}���荞�݃t�b�N
WSIZE	EQU	61	;�e�g���b�N�̃��[�N�G���A�̃T�C�Y
RWSIZE	EQU	5*4	;�e�g���b�N�̃��s�[�g�p���[�N�G���A�̃T�C�Y (1�l�X�g������̃T�C�Y*�l�X�g��)F
CHNUM	EQU	4	;�g�p�`�����l����
DRVADR	EQU	0C000H	;�h���C�o�̊J�n�A�h���X

IF 0

; BSAVE HEADER (���ɃX�L�[����ɂ����C)
	ORG	DRVADR - 7
	db 0feh
	dw 0c000h
	dw END_ADDR
	dw 0c000h

	ORG	DRVADR

ENDIF

INCLUDE "NDP_WRK.ASM"
INCLUDE "NDP_DRV.ASM"

END_ADDR:

	END

