;---------------------------------------------------------------;
;	�V�X�e����`
;---------------------------------------------------------------;

; LSX-Dodgers Define.

SYSTEM					equ		0005h		; �V�X�e���R�[��
FCB1					equ		005Ch		; 1�Ԗڂ̈�����FCB
FCB2					equ		006Ch		; 2�Ԗڂ̈�����FCB
DTA1					equ		0080h

CMD_FILE_OPEN			equ		00fh
CMD_SET_DATA_ADRS		equ		01ah
CMD_READ_RAND_BLOCK		equ		027h
CMD_FILE_CLOSE			equ		010h
CMD_STR_OUT				equ		009h
CMD_CHECK_KEY			equ		00bh

; �f�[�^�Ǎ��A�h���X
; .ndp�t�@�C����MSX��BSAVE�`���̂��ߐ擪��7byte�̃w�b�_���t������Ă���B
; X1�ōĐ�����ۂ̓w�b�_���X�L�b�v����B
BUFAD					equ		4000h
BUFSZ					equ		0400h
DATA_ADRS				equ		BUFAD + 07h

; X1/turbo �V�X�e��
INT_VECTOR1_CTC			equ		00058h	; CZ-8FB01 v1.0 / v2.0
INT_VECTOR2_CTC			equ		00018h	; CZ-8FB02

CRTC_ADRS				equ		01800h
PSG_ADRS				equ		01c00h
CTC_TURBO_ADRS			equ		01fa0h
CTC_X1_ADRS				equ		00704h

CTC_VSYNC_FRAME			equ		167

;---------------------------------------------------------------;
END

