;[NDP] - PSG Music Driver for MSX - Programmed by naruto2413

;=====================================
;�h���C�o�{��
;�iNDP.ASM �� NDP_WRK.ASM ���ʓr�K�v�j
;=====================================

;------	�ȃf�[�^�̃A�h���X�ݒ�

;USR�֐��p (HL<-�ȃf�[�^���A�h���X���i�[���Ă��郁�����̃A�h���X-2)

U_ADR:
	INC	HL
	INC	HL
U_ADR_X1:
	LD	E,(HL)
	INC	HL
	LD	D,(HL)

;���ڃR�[���p (DE<-�ȃf�[�^�̃A�h���X)

ADRSET:
	LD	(BGMADR),DE
	RET

;------	�}�X�^�[���ʃZ�b�g

;USR�֐��p (HL<-�}�X�^�[���ʂ�ۑ����Ă��郁�����̃A�h���X-2)

U_MV:
	INC	HL
	INC	HL
U_MV_X1:
	LD	A,(HL)

;���ڃR�[���p (A<-�}�X�^�[����)

MVSET:
	LD	(MVOL),A
	RET

;------	�t�F�[�h�A�E�g�Z�b�g

;USR�֐��p (HL<-�t�F�[�h�A�E�g�̃t���[������ۑ����Ă��郁�����̃A�h���X-2)

U_MFO:
	INC	HL
	INC	HL
U_MFO_X1:
	LD	A,(HL)

;���ڃR�[���p (A<-�t�F�[�h�̃t���[����)

MFOSET:
	LD	(MFADE),A
	LD	A,1
	LD	(LCOUNT),A
	XOR	A
	LD	(FINOUT),A
	RET

;------	�t�F�[�h�C���Z�b�g

;USR�֐��p (HL<-�t�F�[�h�C���̃t���[������ۑ����Ă��郁�����̃A�h���X-2)

U_MFI:
	INC	HL
	INC	HL
U_MFI_X1:
	LD	A,(HL)

;���ڃR�[���p (A<-�t�F�[�h�̃t���[����)

MPLAYF:
	PUSH	AF
	CALL	MSTART
	POP	AF
	LD	(MFADE),A
	LD	A,1
	LD	(LCOUNT),A
	LD	(FINOUT),A
	LD	A,15
	LD	(MVOL),A
	RET

;------	�`�����l���~���[�g

;USR�֐��p (�~���[�g����t���[�������i�[���Ă��郁�����̃A�h���X-2)

U_OFF1:
	INC	HL
	INC	HL
U_OFF1_X1:
	LD	D,(HL)
	JR	CH1OFF
U_OFF2:
	INC	HL
	INC	HL
U_OFF2_X1:
	LD	D,(HL)
	JR	CH2OFF
U_OFF3:
	INC	HL
	INC	HL
U_OFF3_X1:
	LD	D,(HL)
	JR	CH3OFF

;���ڃR�[���p (D<-�~���[�g����t���[����)

CH1OFF:
	LD	E,8
	LD	C,3
	LD	HL,CH1WRK+WSIZE+10
	JR	CHMUTE

CH2OFF:
	LD	E,9
	LD	C,2
	LD	HL,CH1WRK+WSIZE*2+10
	JR	CHMUTE

CH3OFF:
	LD	E,10
	LD	C,1
	LD	HL,CH1WRK+WSIZE*3+10

CHMUTE:
	LD	A,D
	OR	A
	RET	Z

	LD	A,(RITRK)
	CP	C
	LD	A,D
	JR	NZ,CHMUT1	;���Y�����荞�܂�g���b�N�łȂ���΃X�L�b�v
	LD	(CH1WRK+10),A	;���荞�܂�g���b�N�Ȃ烊�Y���g���b�N�̃~���[�g����J�E���g����ݒ�
CHMUT1:
	LD	(HL),A		;�m�[�}���g���b�N�̃~���[�g����J�E���g����ݒ�
	XOR	A
	DI
	CALL	WPSG

	LD	A,11
	SUB	E
	LD	B,A
	CALL	MIXT
	AND	00111111B	;�ŏ�ʃr�b�g��0�ɂ���ƁA
	LD	(MIXWRK),A	;�~�b�N�X���[�h�̏������ݔ����i�~���[�g���̓g�[���ɂ���j

	EI
	RET

;------	�t�b�N�ڑ�

NDPINI:
	DI

	LD	A,(HKFLG)	;�ȈՓI�ȑ��d���s�΍�
	OR	A
	RET	NZ

IF 0
	LD	HL,HTIMI
	LD	DE,OLDTH
	LD	BC,5
	LDIR

	LD	A,0C3H		;JP
	LD	HL,INTRPT	;�h���C�o���荞�݃��[�`���A�h���X
	LD	(HTIMI),A
	LD	(HTIMI+1),HL
ENDIF

	LD	A,1
SETHF:
	LD	(HKFLG),A

	EI
	RET

;------	�t�b�N�؂藣���E������~

NDPOFF:
	LD	A,(HKFLG)	;�ȈՓI�ȑ��d���s�΍�
	OR	A
	RET	Z

IF 0
	DI

	LD	HL,OLDTH
	LD	DE,HTIMI
	LD	BC,5
	LDIR
ENDIF

	XOR	A
	LD	(HKFLG),A

	CALL	MSTOP

	EI
	RET

;------	���t��~�i�t�b�N���삹���j

MSTOP:
	LD	B,CHNUM
	LD	HL,CH1WRK+10
MSTP2L:
	LD	(HL),0
	LD	DE,WSIZE
	ADD	HL,DE
	DJNZ	MSTP2L

	XOR	A
	LD	(MFADE),A
	LD	(STATS),A

;(PSG������)

PSGINI:
	LD	E,7		;R#7
	LD	A,10111000B	;10NNNTTT 0=ON/1=OFF
	LD	(MIXWRK),A
	LD	(MIXWRS),A
	CALL	WPSG

	XOR	A
	LD	B,4
PSGINL:
	INC	E		;R#8�`11=0
	CALL	WPSG
	DJNZ	PSGINL

	INC	E		;R#12=4
	LD	A,4
	JP	WPSG

;------	���t�J�n�i�t�b�N���삹���j

MSTART:
	DI

	CALL	PSGINI

	XOR	A		;���ɃX�L�[����ɂ��o�C�g���팸��K�p
	LD	HL,CH1WRK
	LD	DE,CH1WRK+1
	LD	BC,CLREND-CH1WRK-1
	LD	(HL),A		;LD (HL),0
	LDIR			;CH1WRK�`CLREND�܂ł̃��[�N���N���A

	INC	A		;LD A,1
	LD	(RITRK),A	;���Y�����荞�܂�g���b�N=1
	LD	(STATS),A	;���t���=1
	LD	(MIXNMH),A	;���ʔ������̃~�b�N�X���[�h�ޔ�p
	LD	A,5
	LD	(RPREG),A	;5
	ADD	A,A
	LD	(RVREG),A	;10

	LD	IX,CH1WRK
	LD	HL,(BGMADR)
	LD	B,CHNUM
	CALL	INIADR		;�ȃf�[�^�擪�A�h���X�ݒ�
	CALL	VSET0		;���F�A�h���X�ݒ�

	EI
	RET

;(���F�A�h���X�ݒ�)

VSET0:
	LD	HL,(BGMADR)
	PUSH	HL
	LD	DE,8
	ADD	HL,DE
	LD	E,(HL)		;���F�g���b�N�A�h���X��ǂݏo��
	INC	HL
	LD	A,(HL)
	CP	40H		;���F�g���b�N�A�h���X��4000H�ȏ�Ȃ���A�h���X�A4000H�ȉ��Ȃ�BGM�擪�A�h���X����̃I�t�Z�b�g�l
	POP	HL
	JR	NC,VSETA
	LD	D,A
	ADD	HL,DE		;HL=���F�g���b�N���A�h���X (BGM�A�h���X�擪�A�h���X+�I�t�Z�b�g)
	JR	VSET
VSETA:
	LD	H,A
	LD	L,E		;HL=���F�g���b�N���A�h���X

VSET:
	LD	A,(HL)		;���F�w�b�_��ǂ� (255�Ȃ特�F�f�[�^�I��)
	CP	255
	RET	Z

	INC	HL
	EX	DE,HL

	ADD	A,A
	LD	B,0
	LD	C,A

	LD	HL,VADTBL	;���F�w�b�_��0�`15�Ȃ�m�[�}�����F�ԍ�
	CP	32
	JR	C,VSET1
	LD	HL,RADTBL-32	;���F�w�b�_��16�`47�Ȃ烊�Y�����F�ԍ�
	CP	96
	JR	C,VSET1
	LD	HL,PADTBL-96	;���F�w�b�_��48�`63�Ȃ�s�b�`�G���x�ԍ�
	CP	128
	JR	C,VSET1
	LD	HL,NADTBL-128	;���F�w�b�_��64�`�Ȃ�m�[�g�G���x�ԍ�
VSET1:
	ADD	HL,BC
	LD	A,(DE)		;�f�[�^����ǂ�
	INC	DE
	LD	(HL),E
	INC	HL
	LD	(HL),D
	EX	DE,HL
	LD	D,0
	LD	E,A
	ADD	HL,DE
	JR	VSET

;------	�ȃf�[�^�̃A�h���X�����ݒ� (IX�����[�N�擪 HL���ȃf�[�^�擪�A�h���X B���g���b�N��)

INIADR:
	PUSH	HL
	POP	IY		;IY�ɋȃf�[�^�ǂݍ��݃A�h���X������
	LD	C,B		;�g���b�N����C�ɑޔ�

INIWRK:
	LD	E,(HL)		;�eCH�I�t�Z�b�g�l��ǂݏo�� (HL=�ȃf�[�^���A�h���X)
	INC	HL
	LD	D,(HL)
	INC	HL
	LD	A,E
	OR	D
	LD	A,1
	JR	NZ,INIW1	;�I�t�Z�b�g�l��0000H�łȂ���΃g���b�N�L��

	LD	A,C		;�w��g���b�N�����m�F����
	CP	CHNUM		;4�g���b�N�����Ȃ���ʉ��Ȃ̂�
	JR	C,INIW0		;�g���b�N�����������s���i�I���t���O�͐G��Ȃ��j

	LD	E,16		;�I�t�Z�b�g�l��0000H�Ȃ�
	LD	D,B		;�I���t���O�X�V
INIWR:
	SRL	E
	DJNZ	INIWR
	LD	B,D
	LD	A,(ENDTR)
	OR	E
	LD	(ENDTR),A	;���g�p�g���b�N�̃t���O�𗧂ĂĂ���
	LD	(ENDTRR),A	;���Z�b�g���ɏ����߂��l��ޔ�
INIW0:
	XOR	A		;�g���b�N����
INIW1:
	LD	(IX+10),A	;�g���b�N�L��/�������Z�b�g
	LD	(IX+9),8	;Q8

	PUSH	HL

	PUSH	IY
	POP	HL
	ADD	HL,DE
	LD	(IX+0),L	;CH�J�n�A�h���X
	LD	(IX+1),H

	POP	HL
INIW2:
	LD	DE,WSIZE
	ADD	IX,DE
	DJNZ	INIWRK

	RET

;------	���t��Ԏ擾 (0=��~�� 1=���t�� ->A)

RDSTAT:
	LD	A,(STATS)
	RET

;------	�I���g���b�N�擾 (0000321R �ŏI�[�܂ŒB�����g���b�N�̃r�b�g������ ->A)

RDENDT:
	LD	A,(ENDTRW)
	RET

;------	���[�v�񐔎擾 �i���[�v���Ȃ��Ȃł�255��Ԃ�)

RDLOOP:
	LD	A,(MCOUNT)
	RET

;------	�o�[�W�����擾

SYSVER:
	LD	HL,0103H	;v1.03

	;��ʃo�C�g�����W���[�o�[�W�����A���ʃo�C�g���}�C�i�[�o�[�W����
	;��ʃo�C�g��0�Ȃ�0.9�Ƃ��Ĉ����A���ʃo�C�g�̓r���h�o�[�W�����Ƃ���
	;���ʃo�C�g�͏��2���Ƃ��Ĉ���

	RET

;------	�ȃf�[�^�̃A�h���X�ݒ�

;USR�֐��p (HL<-�ȃf�[�^���A�h���X���i�[���Ă��郁�����̃A�h���X-2)

U_SE:
	INC	HL
	INC	HL
U_SE_X1:
	LD	E,(HL)
	INC	HL
	LD	D,(HL)

;���ڃR�[���p (DE<-�ȃf�[�^�̃A�h���X)

SEPLAY:
	JP	SEPSUB

;------	PSG�������� (E�����W�X�^ A���f�[�^ C�j��)

;(���Y���g���b�N�������̂�PSG���W�X�^�ɏ�������)

WPSGMR:
	LD	C,A

	LD	A,(RITRK)
	CP	B
	JR	NZ,WPSGM1	;���荞�܂�g���b�N�łȂ����PSG���W�X�^�ɏ�������

	LD	A,(RNON)
	OR	A
	RET	NZ		;���荞�܂�g���b�N�Ń��Y���������Ȃ�RET

	LD	A,C

;(���C�����[�`���pPSG��������)

WPSGM:
	LD	C,A
WPSGM1:
	LD	A,(IX+10)
	CP	2
	LD	A,C
	RET	NC		;�g���b�N�L���t���O��2�����̎��̂�PSG���W�X�^�ɏ�������

;(�ʏ�pPSG��������)

IF 0
WPSG:
	LD	C,0A0H		;PSG�|�[�g
	OUT	(C),E
	INC	C
	OUT	(C),A

	RET
ELSE
;---------------------------------------------------------------;
;	PSG�փf�[�^���o�͂���B
;
;	Ereg: PSG ���W�X�^No�w��
;	Areg: PSG �f�[�^
;---------------------------------------------------------------;
WPSG:
	push	bc
	ld		bc,01c00h
	out		(c),e		; PSG�|�[�g
	dec		b
	out		(c),a		; PSG�f�[�^
	pop		bc

	RET
ENDIF

;------	�^�C�}���荞�݃��[�`��

INTRPT:
	DI
	CALL	IMAIN

IF 0
	CALL	OLDTH
ENDIF

	EI
	RET

IMAIN:
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX
	PUSH	IY

	LD	A,(SLWPRM)
	RRCA
	LD	(SLWPRM),A
	JR	C,INTEND	;�X���[�Đ������i�r�b�g�������Ă���h���C�o�������Ȃ��j

INT0:
	;(BGM����)
MINT:
	XOR	A
	LD	(SEMODE),A	;0=BGM���[�h

	LD	B,CHNUM
	LD	IX,CH1WRK
MLOOP:
	PUSH	BC

	LD	A,(IX+10)	;�`�����l���L���Ȃ�NMAIN���Ă�
	OR	A
	CALL	NZ,NMAIN

	LD	DE,WSIZE	;CH���[�N�̃C���f�b�N�X�����[�N�T�C�Y���i�߂�
	ADD	IX,DE

	POP	BC
	DJNZ	MLOOP

	LD	A,(FFFLG)	;������t���O��
	OR	A		;�����Ă�����
	JR	NZ,INT0		;���荞�݂̓��ɖ߂�

	LD	A,(MFADE)	;�t�F�[�h�l��
	OR	A		;0�Ȃ�
	JR	Z,MINTED	;�t�F�[�h�����͔�΂�

	LD	C,A		;C�Ƀt�F�[�h�l��ޔ�
	LD	A,(FCOUNT)
	OR	A
	JR	NZ,MFADE1

	LD	A,(FINOUT)	;0�Ȃ�t�F�[�h�A�E�g�A1�Ȃ�t�F�[�h�C��
	OR	A
	LD	A,(MVOL)
	JR	Z,MFOUT
	OR	A
	JR	Z,MFEND
	DEC	A
	JR	MFADE0
MFEND:
	LD	(MFADE),A	;�t�F�[�h�l��0��
	JR	MINTED
MFOUT:
	INC	A
	CP	15
	CALL	NC,MSTOP
MFADE0:
	LD	(MVOL),A
	LD	A,C
MFADE1:
	DEC	A
	LD	(FCOUNT),A
MINTED:

	;(���ʉ�����)
SINT:
	XOR	A
	LD	(SECNT),A	;SE�̎g�p�g���b�N�����[���N���A
	INC	A
	LD	(SEMODE),A	;1=SE���[�h

	LD	B,CHNUM-1
	LD	IX,SE1WRK
SECHK1:
	LD	A,(IX+10)	;�`�����l���L���Ȃ�SE�pMAIN���Ă�
	OR	A
	CALL	NZ,MAINSE

	LD	DE,WSIZE	;CH���[�N�̃C���f�b�N�X�����[�N�T�C�Y���i�߂�
	ADD	IX,DE

	DJNZ	SECHK1
SINTED:

INTEND:
	POP	IY
	POP	IX
	POP	HL
	POP	DE
	POP	BC
	POP	AF

	RET

;------	�h���C�o�{��

MAINSE:
	LD	HL,SECNT
	INC	(HL)		;���ʉ��̎g�p�g���b�N�������Z

NMAIN:
	CP	2		;�g���b�N�L���t���O���m�F (IX+10�̓��e��A�ɓ����Ă���)
	JR	C,MAIN01	;2�����Ȃ�ʏ폈���ɃW�����v

	CP	255
	JR	NC,MAIN01	;�g���b�N�L���t���O��255�Ȃ�~���[�g�J�E���^���X�V���Ȃ�

	DEC	A		;�g���b�N�L���t���O��2�`254�Ȃ�ꎞ�~���[�g�J�E���^�Ƃ��Ĉ���
	LD	(IX+10),A
	CP	2		;���Z���ʂ��Ċm�F
	JR	NC,MAIN01	;2�ȏ�Ȃ烌�W�X�^���A���Ȃ�

	LD	A,(RITRK)
	CP	B
	JR	NZ,MAINR	;���Y���g���b�N�Ɠ����`�����l���łȂ���΃��W�X�^���A

	LD	A,(RNON)
	OR	A
	JR	Z,MAINR		;���Y���������łȂ���΃��W�X�^���A

	LD	A,255
	LD	(SEBAKR),A	;���Y���������Ȃ烊�Y���L�[�I�t��Ƀ��W�X�^���A����t���O���Z�b�g

	JR	MAIN01

MAINR:
	CALL	PRRET1		;���W�X�^���A
	CALL	PRRET0

	LD	A,(IX+60)
	CALL	MIXSUB		;�~�b�N�X���[�h���A

	LD	A,(IX+2)	;���W�X�^���A����
	OR	A		;�x���łȂ����
	JR	NZ,MAINR1	;�X�L�b�v
	LD	(IX+26),1	;�x���Ȃ烊���[�X�J�E���^�������I��1�ɂ���
MAINR1:
	LD	A,(IX+6)
	CP	90H
	JR	NC,MAIN01
	LD	A,11
	SUB	B
	LD	E,A
	LD	A,16
	CALL	WPSGM		;�n�[�h�G���x�Ȃ特�ʃ��W�X�^��16��

	LD	A,(IX+17)	;���ʔ����J�E���^�ݒ�
	OR	A
	JR	Z,MAIN01	;0�Ȃ�X�L�b�v

	LD	A,(IX+16)	;���ʔ����J�E���^
	OR	A
	CALL	Z,PITCH0	;0�Ȃ���g����0��

MAIN01:
	LD	A,(IX+4)	;�����J�E���^�`�F�b�N
	OR	A
	JP	Z,MAIN1

	LD	A,(RNON)
	OR	A
	JR	NZ,MAIN0A	;���Y���������Ȃ�R#7�ւ̏������݂̓X�L�b�v

	CALL	MIX_IY
	LD	A,(IY)		;�~�b�N�X���[�h�m�F
	BIT	7,A
	JR	NZ,MAIN0A	;�ŏ�ʃr�b�g��0�łȂ���΃X�L�b�v
	OR	80H		;0�Ȃ�1�ɂ���
	LD	(IY),A		;���[�N�ɕۑ���
	LD	E,7		;R#7�ɂ�
	CALL	WPSGM		;��������
MAIN0A:
	LD	A,(NFREQW)	;�m�C�Y���g���m�F
	CP	32
	JR	C,MAIN0B	;32�����Ȃ�X�L�b�v
	AND	31
	LD	(NFREQW),A	;32�ȏ�Ȃ�31�ȉ��Ɋۂ߂ă��[�N�ɕۑ�
	LD	E,6
	CALL	WPSGM		;�m�C�Y���g����������
MAIN0B:
	LD	A,B		;���Y���`�����l���Ȃ烊�Y�����[�h�p�̃G���x��
	CP	CHNUM
	JP	Z,RENV

;�����J�E���g�E�G���x���[�v

	LD	A,(IX+2)	;�x���`�F�b�N
	OR	A
	JP	NZ,ENV		;�x���łȂ���΃G���x���[�v������
REST:
	CALL	RDELAY

	LD	A,(IX+25)	;�����[�X�J�E���^�ݒ肪0�Ȃ烊���[�X�����X�L�b�v
	OR	A
	JR	Z,ENVRR1

	DEC	(IX+26)		;�����[�X�J�E���^
	JP	NZ,ENVRR4

	INC	A
	LD	(IX+26),A	;�����[�X�J�E���^��0�ɂȂ����烊���[�X�J�E���^�ݒ�l�ɖ߂�

	LD	A,(IX+6)	;���F��
	CP	90H		;�n�[�h�G���x���ǂ������m�F����
	JR	C,REST0		;�n�[�h�G���x�Ȃ�L�[�I�t���Ƀ~�b�N�X���[�h���g�[���ɂ���
	CALL	MIXTWT
REST0:
	LD	A,(IX+24)	;�����[�X����
	OR	A
	LD	D,A		;���ʂ�D�ɑޔ�
	JR	Z,ENVRR1
	DEC	A
	LD	(IX+24),A	;�����[�X���ʍX�V
ENVRR1:
	LD	A,(RITRK)
	CP	B
	JR	NZ,ENVRR2	;���荞�܂�g���b�N����Ȃ���Ζ������ŉ��ʃ��W�X�^�X�V

	LD	A,D
	LD	(RSVOL),A	;���荞�܂�g���b�N�Ȃ�ޔ����ʂ�ۑ�

	LD	A,(RNON)
	OR	A
	JP	NZ,ENVRR4	;���Y���������Ȃ特�ʃ��W�X�^�X�V���Ȃ�
ENVRR2:
	CALL	REGV
	LD	A,(MVOL)
	LD	C,A
	LD	A,D		;�ޔ����Ă��������ʂ�PSG�ɏ�������
	SUB	C
	JR	NC,ENVRR3
	XOR	A
ENVRR3:
	LD	(IX+15),A
	CALL	WPSGM
ENVRR4:
	LD	A,(IX+11)	;�s�b�`�G���x���L���Ȃ�x���Ńs�b�`�G���x�쓮
	OR	A
	JP	Z,COUNTL
	AND	80H
	JP	NZ,COUNTL	;�s�b�`�G���x�̃r�b�g7�������Ă�����|���Ȃ�

	LD	A,(IX+29)
	OR	A
	JP	Z,PENV		;�s�b�`�G���x�L���Ȃ�L�[�I�t���̃s�b�`�ݒ肵�Ȃ�
	LD	E,(IX+27)	;�L�[�I�t���̃s�b�`�ݒ�
	LD	A,(IX+28)
	LD	D,A
	OR	E
	JP	Z,PENV		;0�Ȃ珈�����Ȃ�
	LD	(IX+13),E
	LD	(IX+14),D
	JP	PENV

;�����[�X�f�B���C�����i�ݒ�s�b�`�����W�X�^�ɏ������݁j

RDELAY:
	LD	A,(RNON)
	OR	A
	RET	NZ		;���Y���������Ȃ烊���[�X�f�B���C�������Ȃ�

	LD	A,(IX+29)
	OR	A
	RET	Z		;�����[�X�f�B���C�t���O��0�Ȃ烊���[�X�f�B���C�������Ȃ�

	LD	A,(IX+59)
	OR	A
	RET	Z
	DEC	(IX+59)

	CALL	REGP
	LD	A,(IX+28)
	OR	(IX+27)
	JR	NZ,RDELY2	;�s�b�`��0����Ȃ���΃W�����v

PWRITE:
	LD	A,(IX+14)
	CALL	WPSGM		;�������W�X�^��ʂɌ��݂̃s�b�`����������
	DEC	E
	LD	A,(IX+13)
	JP	WPSGM		;�������W�X�^���ʂɌ��݂̃s�b�`����������

RDELY2:
	LD	A,(IX+28)
	LD	(IX+55),A
	CALL	WPSGM		;�������W�X�^��ʂɃ����[�X�f�B���C�p�s�b�`����������
	DEC	E
	LD	A,(IX+27)
	LD	(IX+54),A
	CALL	WPSGM		;�������W�X�^���ʂɃ����[�X�f�B���C�p�s�b�`����������

	LD	A,(RITRK)
	CP	B
	RET	NZ

	LD	A,(SEMODE)
	OR	A
	RET	NZ

	LD	A,(IX+27)	;���荞�܂�g���b�N�Ȃ烊�Y��������ɉ�����߂����߂̃s�b�`�l��ޔ�
	LD	(RPITCH),A
	LD	A,(IX+28)
	LD	(RPITCH+1),A
	RET

;�\�t�g�G���x (���ʃC���^�[�o��)

ENV:
	LD	A,(IX+42)	;���ʃC���^�[�o��
	OR	A
	JR	Z,VENV

	LD	C,A
	AND	7FH
	CP	64
	JR	C,VIE0

	LD	A,(VISPAN)
	INC	A
	LD	(VISPAN),A
	CP	2
	JR	C,VENV
	XOR	A
	LD	(VISPAN),A
VIE0:
	LD	A,(IX+47)	;���ʃC���^�[�o���p�J�E���^
	DEC	A
	JR	Z,VIE
	LD	(IX+47),A	;0����Ȃ���΃��[�N�ɕۑ�����
	JR	VENV		;�X�L�b�v
VIE:
	LD	A,C
	AND	7FH
	LD	(IX+47),A	;0�Ȃ�J�E���^�Đݒ�

	LD	A,(IX+48)	;���ʉ��Z�l
	INC	A
	CP	15
	JR	C,VIE1
	LD	A,15
VIE1:
	LD	(IX+48),A

;�\�t�g�G���x (���F)

VENV:
	LD	A,(IX+52)	;�Q�[�g�^�C��
	OR	A
	JR	NZ,ENV0		;0����Ȃ���΃G���x����

	LD	A,(IX+7)
	OR	A
	JP	Z,REST		;���K�[�g���łȂ���΋x������

ENV0:
	LD	A,(IX+6)	;���F�ԍ���
	CP	90H		;�n�[�h�G���x�łȂ����
	JR	C,ENV00		;�\�t�g�G���x�ɃW�����v

	LD	A,(IX+16)	;�n�[�h�G���x�Ȃ特�ʔ����J�E���^���m�F
	OR	A
	JP	Z,ENVEND	;�J�E���^���ݒ肳��ĂȂ���΃G���x���������ɃW�����v
	DEC	(IX+16)
	JP	NZ,ENVEND	;�J�E���g��0�ɂȂ��Ă��Ȃ���΃G���x���������ɃW�����v

	LD	A,(RITRK)
	CP	B
	JR	NZ,ENVH00	;���荞�܂�g���b�N�łȂ���Ζ������ɉ��ʔ����p�̃��W�X�^��������

	LD	A,(RNON)
	OR	A
	JR	Z,ENVH00	;���荞�܂�g���b�N�Ń��Y���������łȂ���Ή��ʔ����p�̃��W�X�^��������

	CALL	MIX_IY
	CALL	MIXT		;���荞�܂�g���b�N�Ń��Y���������Ȃ�ޔ����ʃ��[�N�̂ݏ�������
	LD	(IY),A
	JR	ENVH01
ENVH00:
	CALL	PITCH0		;�g�[���L���E�m�C�Y������
	CALL	MIXTWT

	LD	A,(RITRK)
	CP	B
	JP	NZ,ENVEND	;���荞�܂�g���b�N�łȂ���Ώ����X�L�b�v
ENVH01:
	XOR	A
	LD	(RPITCH),A
	LD	(RPITCH+1),A	;���荞�܂�g���b�N�Ȃ�ޔ�������0��
	JP	ENVEND

ENV00:
	LD	A,(IX+18)	;�G���x���[�v�E�F�C�g�J�E���^���`�F�b�N
	OR	A
	JR	Z,ENV1
	DEC	(IX+18)
	JP	ENVEND
ENV1:
	LD	L,(IX+16)	;�G���x���[�v�|�C���^��HL��
	LD	H,(IX+17)
ENV10:
	LD	A,(HL)		;�G���x���[�v�f�[�^��A��
	CP	0F0H
	JR	C,ENV11
	LD	D,0		;���4�r�b�g��F�Ȃ�f�[�^�I�[�A����4�r�b�g�̓G���x�J�E���^��߂��l
	AND	0FH
	LD	E,A
	SBC	HL,DE
	JR	ENV10
ENV11:
	INC	HL

	CP	0A0H
	JR	NZ,ENV1Z0

	LD	(IX+16),L
	LD	(IX+17),H	;�G���x���[�v�|�C���^��ۑ�
	JP	ENVEND

ENV1Z0:
	CP	0A1H		;0A1H=���g����0�ɂ���
	JR	NZ,ENV1Z1

	CALL	PITCH0
	XOR	A
	LD	(IX+13),A
	LD	(IX+14),A
	
	LD	A,(RITRK)
	CP	B
	JP	NZ,ENV10

	XOR	A
	LD	(RPITCH),A
	LD	(RPITCH+1),A

	JP	ENV10
ENV1Z1:
	CP	0A3H		;0A3H=�s�b�`�G���x�K�p�O�̉����ɖ߂�
	JR	NZ,ENV11I

	CALL	REGP
	LD	A,(IX+55)
	LD	D,A
	CALL	WPSGM
	DEC	E
	LD	A,(IX+54)
	CALL	WPSGM

	LD	E,A

	LD	A,(RITRK)
	CP	B
	JP	NZ,ENV10

	LD	A,E
	LD	(RPITCH),A
	LD	A,D
	LD	(RPITCH+1),A

	JP	ENV10
ENV11I:
	CP	0A5H		;0A5H=���ʑJ�ڃC���^�[�o��
	JR	NZ,ENV11N

	LD	A,(HL)
	INC	HL
	LD	(IX+42),A	;�ݒ�l
	LD	C,A
	AND	01111111B
	LD	(IX+47),A	;�J�E���^
	JR	ENV10

ENV11N:
	CP	0A4H		;0A4H=�m�[�g�G���x���[�v
	JR	NZ,ENV11P
	LD	C,1
	CALL	SETNES
	JR	ENV10

ENV11P:
	CP	0A2H		;0A2H=�s�b�`�G���x���[�v
	JR	NZ,ENV11A
	LD	C,1
	CALL	SETPES
	JP	ENV10

ENV11A:
	CP	0D0H
	JR	C,ENV11B	;D0-EFH=�m�C�Y���g��

	SUB	0D0H
	LD	(NFREQW),A	;�m�C�Y���g����ۑ�
	LD	E,6
	CALL	WPSGM		;��������
	JP	ENV10

ENV11B:
	CP	0C0H
	JR	C,ENV11C	;C0�`C3H=�~�b�N�X���[�h

	AND	3
	CALL	MIXSWT

	LD	A,(RNON)
	OR	A
	JP	NZ,ENV10	;���Y���������Ȃ烌�W�X�^�������݂͍s��Ȃ�
	LD	A,C
	OR	80H
	LD	E,7
	CALL	WPSGM		;�~�b�N�X���[�h��������
	JP	ENV10

ENV11C:
	LD	(IX+16),L
	LD	(IX+17),H	;�G���x���[�v�|�C���^��i�߂ĕۑ�

	CP	0B0H		;B0�`BFH=�n�[�h�G���x�`��
	JR	C,ENV11Z

	AND	0FH		;�n�[�h�G���x�`���
	LD	(HENVSW),A	;���[�N�G���A�ɃZ�b�g����
	LD	E,13		;R#13��
	CALL	WPSG		;��������
ENV11X:
	CALL	REGV
	LD	A,(RITRK)
	CP	B
	JR	NZ,ENV11H	;���荞�܂�g���b�N�łȂ���΃��W�X�^��������

	LD	A,(RNON)
	OR	A
	JR	NZ,ENV11R	;���Y���������Ȃ烊�Y���I�����̒l�̂ݐݒ肷��
ENV11H:
	LD	A,16		;���ʃ��W�X�^��16��
	CALL	WPSGM		;��������
	JR	ENVEND
ENV11R:
	LD	A,E
	LD	(RVREG),A
	LD	A,16
	LD	(RSVOL),A
	JR	ENVEND

ENV11Z:
	LD	D,A
	SRL	A
	SRL	A
	SRL	A
	SRL	A
	LD	(IX+18),A	;�G���x���[�v�E�F�C�g�J�E���^��ۑ�
	LD	A,D
	AND	0FH
	LD	D,(IX+3)	;�`�����l�����ʂ�D�ɓ����
	SUB	D		;�G���x���[�v���ʂ������
	JR	NC,ENV12
	XOR	A		;0�����������0��
ENV12:
	LD	D,A		;���ʂ�D�ɑޔ�
	LD	A,(IX+42)	;���ʃC���^�[�o���ݒ�l��
	AND	80H		;�r�b�g7�������Ă��邩
	JR	NZ,ENV3M	;�r�b�g7�������Ă��Ȃ���Ό��Z

	LD	A,(IX+56)	;���ʃC���^�[�o�����B�l��
	OR	A		;0�łȂ����
	JR	NZ,ENV3P	;�ݒ�l���ő�l�ɔ��f
	LD	A,(IX+3)	;0�Ȃ�
	XOR	15		;�ݒ艹�ʂ��ő�l�ɔ��f
ENV3P:
	LD	C,A
	LD	A,D		;�ޔ��������ʂ�A�ɖ߂�
	ADD	A,(IX+48)	;���ʃC���^�[�o���̃��[�N�������Z
	CP	C
	JR	C,ENV4
	LD	A,C
	JR	ENV4
ENV3M:
	LD	A,D		;�ޔ��������ʂ�A�ɖ߂�
	SUB	(IX+48)		;���ʃC���^�[�o���̃��[�N�������Z
	JR	NC,ENV4
	XOR	A
ENV4:
	LD	(IX+15),A	;���ʂ����ʃ��[�N�ɕۑ�
	LD	D,A		;���ʂ�D�ɑޔ�

	LD	A,(RITRK)
	CP	B
	JR	NZ,ENV2		;���荞�܂�g���b�N����Ȃ���΃G���x�����W�X�^�ɏ�������

	LD	A,D
	LD	(RSVOL),A	;���Y�������O�̉��ʂ�ޔ�

	LD	A,(RNON)
	OR	A
	JR	NZ,ENVEND	;���Y���������t���O�������Ă�����G���x�����X�L�b�v
ENV2:
	CALL	REGV
	LD	A,(MVOL)
	LD	C,A
	LD	A,D		;D�ɑޔ����Ă��鉹�ʂ�ǂݍ����
	SUB	C		;MVOL�������炷
	JR	NC,ENV3
	XOR	A
ENV3:
	CALL	WPSGM
ENVEND:
	LD	A,(IX+7)
	OR	A
	JP	NZ,PORWT	;���K�[�g���Ȃ�Q�[�g�^�C���͌��炳�Ȃ�

	DEC	(IX+52)		;�Q�[�g�^�C�������炷
	JP	NZ,PORWT	;0����Ȃ���΃L�[�I�t���̃����[�X�ݒ�̓X�L�b�v

	CALL	NOTER

	LD	A,(IX+6)
	CP	90H
	JR	C,ENVED1	;�n�[�h�G���x�łȂ���΃X�L�b�v

	LD	A,(IX+25)
	OR	A
	JR	Z,ENVED1	;�����[�XOFF�Ȃ�X�L�b�v

	LD	A,(IX+17)	;���ʔ����J�E���^
	OR	A
	JR	Z,ENVEH1	;0�Ȃ�X�L�b�v

	LD	A,(IX+29)	;�����[�X�f�B���C
	OR	A
	JR	NZ,ENVEH1	;0�ȊO�Ȃ�X�L�b�v

	CALL	REGP
	CALL	PWRITE		;�s�b�`��߂�

ENVEH1:
	LD	A,(RITRK)
	CP	B
	JR	NZ,ENVED1	;���荞�܂�g���b�N�łȂ���΃s�b�`�ޔ����Ȃ�

	LD	A,(IX+13)
	LD	(RPITCH),A
	LD	A,(IX+14)
	LD	(RPITCH+1),A

ENVED1:
	LD	A,(IX+11)	;�s�b�`�G���x�ԍ�
	AND	80H		;�ŏ�ʃr�b�g�ɂ���ăL�[�I�t���ɉ�����߂����ǂ��������߂�
	JP	Z,PORWT

	LD	L,(IX+54)	;�L�[�I�t���ɉ�����߂�
	LD	H,(IX+55)
	LD	(IX+13),L
	LD	(IX+14),H

	JP	PSET

;�����[�X�ݒ�

NOTER:
	LD	A,(IX+6)
	CP	90H
	JR	C,NOTERS
	LD	A,15
	JR	NOTER0
NOTERS:
	LD	A,(IX+15)	;�\�t�g�G���x�Ȃ猻�݂̉��ʂ���ɂ���
NOTER0:
	SUB	(IX+30)		;��L�̉���-�����[�X���ʐݒ�������[�X���ʂ�
	JR	NC,NOTER1
	XOR	A
NOTER1:
	LD	(IX+24),A	;�����[�X���ʂ�ۑ�
NOTES:
	LD	A,(IX+8)	;�����[�X����
	LD	(IX+25),A	;�����[�X�J�E���^�ݒ�l
	LD	(IX+26),1	;�����[�X�J�E���^
	RET

;�|���^�����g�����Z

PORWT:
	LD	A,(IX+34)	;�|���^�����g�l(������)
	OR	A
	JP	Z,POREND	;�|���^�����g�l��0�Ȃ�|���^�����g�������X�L�b�v
PORWT1:
	PUSH	BC

	LD	L,(IX+35)	;���݉���
	LD	H,(IX+36)

	LD	C,(IX+13)	;�ړI����
	LD	B,(IX+14)

	LD	A,H
	CP	B		;���ݒl�Ɠ��B�l�̏�ʂ��r
	JR	C,PPLUS		;���ݒl����������Ή��Z������
	JR	NZ,PMINUS	;�łȂ���Ό��Z������
	LD	A,L
	CP	C		;���ݒl�Ɠ��B�l�̉��ʂ��r
	JR	Z,PJUST		;���B���Ă���I��
	JR	C,PPLUS		;���ݒl����������Ή��Z������

PMINUS:
	LD	D,0
	LD	E,(IX+34)
	SBC	HL,DE		;���Z

	JR	C,PJUST

	LD	A,B		;�ړI�l�̏�ʃo�C�g��
	CP	H		;���ݒl�̏�ʃo�C�g���r
	JR	NZ,PSETP
	LD	A,C		;�ړI�l�̉��ʃo�C�g��
	CP	L		;���ݒl�̉��ʃo�C�g���r
	JR	NC,PJUST
	JR	PSETP

PPLUS:
	LD	D,0
	LD	E,(IX+34)
	ADD	HL,DE		;���Z

	LD	A,L
	SUB	C
	LD	A,H
	SBC	A,B
	JR	C,PSETP

PJUST:
	LD	(IX+34),0
	LD	(IX+33),0

	LD	A,(IX+31)	;�L�[�I�����̉������W�X�^�X�V�t���O�������Ă�����
	OR	A		;�|���^�����g�̉�����ݒ肵�Ȃ�
	JR	NZ,PSETP

	LD	L,C		;HL���W�X�^�ɓ��B������ݒ�
	LD	H,B

PSETP:
	POP	BC

	LD	A,(RITRK)
	CP	B
	JR	NZ,PSETP1	;���荞�܂�g���b�N�ȊO�Ȃ��Ƀ|���^�����g�̃��W�X�^�������ݎ��s

	LD	A,(RNON)	;���荞�܂�g���b�N�Ń��Y���������Ȃ烌�W�X�^�������݂̓X�L�b�v
	OR	A
	JR	NZ,PSEND
PSETP1:
	CALL	REGP
	LD	A,H
	CALL	WPSGM		;�������W�X�^��ʂɏ�������
	DEC	E
	LD	A,L
	CALL	WPSGM		;�������W�X�^���ʂɏ�������

PSEND:
	LD	(IX+35),L
	LD	(IX+36),H	;���ݒl���X�V

POREND:

;�m�[�g�G���x���[�v

NENV:
	LD	A,(IX+43)
	OR	A
	JP	Z,NEEND		;�m�[�g�G���x�X�C�b�`��OFF�Ȃ�X�L�b�v
	LD	C,A

	AND	80H
	JR	NZ,NEEND	;�m�[�g�G���x�I���t���O�������Ă�����X�L�b�v

	LD	L,(IX+44)	;�m�[�g�G���x�|�C���^
	LD	H,(IX+45)
NENV1:
	LD	A,(HL)		;�f�[�^��ǂ�
	INC	HL
	CP	80H
	JR	NZ,NENV3	;�f�[�^��80H�Ȃ�|�C���^���w��o�C�g�߂�
	LD	A,(HL)		;�߂��o�C�g��
	OR	A
	JR	NZ,NENV2
	LD	A,C
	OR	80H
	LD	(IX+43),A	;�߂��o�C�g����0�Ȃ�m�[�g�G���x�I���t���O�𗧂Ă�
	JP	NEEND
NENV2:
	LD	D,0		;�w��o�C�g���߂�
	LD	E,A
	SBC	HL,DE
	JR	NENV1
NENV3:
	LD	(IX+44),L	;�m�[�g�G���x�|�C���^�X�V
	LD	(IX+45),H
	JR	NC,NENV4

	LD	D,(IX+2)
	ADD	A,D		;�m�[�g�ԍ������Z
	CP	95
	JR	C,NENV5
	LD	A,95
	JR	NENV5

NENV4:
	NEG
	LD	D,A
	LD	A,(IX+2)
	SUB	D		;�m�[�g�ԍ������Z
	JR	C,NENV4A
	OR	A
	JR	NZ,NENV5
NENV4A:
	LD	A,1
NENV5:
	CALL	NTOP
	LD	(IX+13),L	;�s�b�`�X�V
	LD	(IX+14),H
	LD	(IX+54),L
	LD	(IX+55),H
	JP	PSET
NEEND:

;�s�b�`�G���x���[�v

PENV:
	LD	A,(IX+11)
	OR	A
	JP	Z,PEEND		;�s�b�`�G���x�X�C�b�`��OFF�Ȃ�X�L�b�v
	LD	C,A

	LD	A,(IX+6)
	CP	90H
	JR	C,PENV0		;�n�[�h�G���x�����Ȃ�s�b�`�G���x�쓮

	LD	A,(IX+17)
	OR	A
	JP	NZ,PEEND	;�n�[�h�G���x�L���ŉ��ʔ����J�E���^���ݒ肳��Ă�����X�L�b�v

PENV0:
	DEC	(IX+23)		;�s�b�`�G���x�f�B���C�J�E���^
	JP	NZ,PEEND	;�s�b�`�f�B���C�J�E���^��0�łȂ���΃X�L�b�v
	LD	(IX+23),1	;�s�b�`�G���x�f�B���C�J�E���^��1�ɂ���i���DEC�Ŗ��񔭓�����悤�ɂȂ�j

	BIT	6,C		;�s�b�`�G���x�ԍ��̃r�b�g6�������Ă�����
	JP	NZ,PSET		;�f�B���C�J�E���^�����i�߂ăs�b�`�G���x�������Ȃ�

	BIT	5,C		;�s�b�`�G���x�ԍ��̃r�b�g5�������Ă��Ȃ����
	JR	Z,PENVF		;�O�t���[���̃s�b�`���ێ�

	LD	L,(IX+54)
	LD	H,(IX+55)	;���̉�����
	LD	(IX+13),L
	LD	(IX+14),H	;���H��s�b�`�ɔ��f

PENVF:
	LD	L,(IX+21)	;�s�b�`�G���x�|�C���^
	LD	H,(IX+22)
PENV1:
	LD	A,(HL)		;�f�[�^��ǂ�
	INC	HL
	CP	80H
	JR	NZ,PENV3	;�f�[�^��80H�Ȃ�|�C���^���w��o�C�g�߂�
	LD	D,0
	LD	E,(HL)		;�߂��o�C�g��
	SBC	HL,DE
	JR	PENV1
PENV3:
	LD	(IX+21),L	;�s�b�`�G���x�|�C���^�X�V
	LD	(IX+22),H

	PUSH	AF

	LD	A,C		;�s�b�`�G���x�ԍ���A�ɖ߂���
	AND	00100000B	;�r�b�g5�������Ă�����
	JR	NZ,PENVZ	;�O�t���[���łȂ����̃s�b�`����̑J��

	LD	L,(IX+13)
	LD	H,(IX+14)
	JR	PENV3A
PENVZ:
	LD	L,(IX+54)
	LD	H,(IX+55)
PENV3A:
	POP	AF
	JR	C,PENVA		;�����Z�̕���

	NEG			;���Z�̂��߂ɕ������]
	LD	D,A
	LD	A,L		;�s�b�`���ʂ�ǂݍ����
	SUB	D		;�s�b�`���Z
	LD	(IX+13),A	;�s�b�`���ʃ��[�N�X�V
	JP	NC,PSET
	LD	A,H		;�����ӂꎞ��
	SUB	1		;�s�b�`��ʂ����Z
	JR	C,PENV4		;��ʂ̌����ӂ���m�F
	LD	(IX+14),A
	JP	PSET
PENV4:
	XOR	A
	LD	(IX+13),A
	LD	(IX+14),A
	JR	PSET

PENVA:
	LD	D,A
	LD	A,L		;���݂̃s�b�`���ʂ�ǂݍ����
	ADD	A,D		;�s�b�`���Z
	LD	(IX+13),A	;�s�b�`���ʃ��[�N�X�V
	JR	NC,PSET
	LD	A,H		;�����ӂꎞ��
	INC	A		;�s�b�`��ʂ����Z
	CP	16
	JR	C,PENV5		;��ʂ̌����ӂ���m�F
	LD	(IX+13),255
	LD	(IX+14),15
	JR	PSET
PENV5:
	LD	(IX+14),A
	JR	PSET
PEEND:

;�L�[�I�����̃s�b�`�X�V����

KONCHK:
	LD	A,(IX+31)	;�L�[�I�����̃s�b�`�X�V�t���O���m�F
	OR	A
	JP	Z,COUNT

;�s�b�`�ƃn�[�h�G���x�����W�X�^�ɐݒ�

PSET:
	LD	A,(IX+6)	;���F�ԍ����n�[�h�G���x�p���ǂ���
	CP	90H
	JR	C,PSETS
	LD	D,A

	LD	A,(IX+52)	;�n�[�h�G���x���ɃQ�[�g�^�C����
	OR	A		;0�łȂ����
	JP	NZ,PSET0	;�n�[�h�G���x���Z�b�g���邩�ǂ����m�F

	LD	A,(IX+31)	;�Q�[�g�^�C����0�Ȃ�
	OR	A		;�L�[�I���t���O���m�F����
	JP	Z,PSETS		;�L�[�I�t(%1�̉����łȂ�)�Ȃ特���̂݃Z�b�g
PSET0:
	LD	A,(IX+2)	;�x���Ȃ�
	OR	A		;�n�[�h�G���x�̓Z�b�g������
	JP	Z,PSETS		;�������Z�b�g

	LD	A,(IX+12)	;���K�[�g���łȂ����
	OR	A		;�n�[�h�G���x��
	JP	Z,PSETH0	;�Z�b�g

	LD	A,(IX+17)	;���K�[�g���Ȃ特�ʔ������L�����ǂ�����
	OR	A		;�m�F����
	JR	Z,PSETS		;����������ݒ肵�ĂȂ���Ή������Z�b�g
	LD	(IX+31),0	;���Ă�����L�[�I���t���O�������Z�b�g
	JP	COUNTL
PSETH0:
	LD	A,(IX+31)	;�L�[�I�������W�X�^�X�V�t���O��
	OR	A		;�����Ă��Ȃ����
	JR	Z,PSET1		;�n�[�h�G���x�̓Z�b�g���Ȃ�

	LD	A,D
	AND	0FH
	LD	(HENVSW),A	;�n�[�h�G���x�ԍ���ޔ�
	LD	E,13
	CALL	WPSGMR		;R#13�ɃG���x���[�v�ԍ���ݒ�

PSET1:
	LD	A,(MVOL)
	OR	A
	JR	NZ,PSET2

	LD	A,11
	SUB	B
	LD	E,A
	LD	A,16
	CALL	WPSGMR		;�n�[�h�G���x�Ȃ特�ʃ��W�X�^��16��ݒ�

	LD	A,(RITRK)
	CP	B
	JP	NZ,PSET2	;���荞�܂�g���b�N�ȊO�Ȃ烊�Y���p�̉��ʑޔ��̓X�L�b�v
	LD	A,16
	LD	(RSVOL),A
PSET2:
	LD	A,(IX+17)	;���ʔ����J�E���^�ݒ���m�F
	LD	(IX+16),A	;�r�b�g7�̃t���O�������ăJ�E���^�ݒ�
	OR	A
	JR	NZ,PSETH	;�ݒ肳��Ă�����W�����v

	LD	A,(IX+25)
	OR	A
	JR	Z,PSETS		;�����[�X�ݒ肳��ĂȂ���΃X�L�b�v

	LD	A,(MIXNMH)	;���ʔ������ݒ肳��Ă��Ȃ���΃~�b�N�X���[�h��߂�
	CALL	MIXSUB
	JR	PSETH1
PSETH:
	CALL	MIXOFF		;���ʔ������ݒ肳��Ă�����L�[�I�����g�[���m�C�YOFF
PSETH1:
	CALL	MIXWT

PSETS:
	LD	(IX+31),0	;�L�[�I���t���O�����Z�b�g
PSETS1:
	CALL	REGP
	LD	A,(IX+34)	;�|���^�����g�����ǂ���
	OR	A
	JP	NZ,PSETPO

	LD	A,(IX+14)
	CALL	WPSGMR		;�������W�X�^��ʂɏ�������(�ʏ펞)
	DEC	E
	LD	A,(IX+13)
	CALL	WPSGMR		;�������W�X�^���ʂɏ�������(�ʏ펞)
	JP	COUNTL
PSETPO:
	LD	A,(IX+36)
	CALL	WPSGMR		;�������W�X�^��ʂɏ�������(�|���^�����g��)
	DEC	E
	LD	A,(IX+35)
	CALL	WPSGMR		;�������W�X�^���ʂɏ�������(�|���^�����g��)
	JP	COUNTL

;���Y���G���x���[�v

RENV:
	LD	A,(IX+2)	;�x���`�F�b�N
	OR	A
	JP	Z,COUNTR

	LD	A,(RNON)
	CP	2
	JP	Z,RENV0		;���Y���������t���O��2�Ȃ�G���x����
	OR	A
	CALL	NZ,RHYOFF	;���Y���������t���O��1�Ȃ�ʏ폈���ɖ߂�
	JP	COUNTR
RENV0:
	LD	L,(IX+16)	;�G���x���[�v�|�C���^��HL��
	LD	H,(IX+17)
RENV1:
	LD	A,(HL)		;�G���x���[�v�f�[�^��A��

	INC	HL
	LD	(IX+16),L
	LD	(IX+17),H	;�G���x���[�v�|�C���^��i�߂ĕۑ�

	CP	255		;�f�[�^�I����
	JP	Z,REEND

RENV2:
	CP	10H		;1�t���[�����̏����I��
	JP	Z,COUNTR

	LD	E,A		;E���W�X�^�ɑޔ� (���W�X�^�ԍ������˂�)

	AND	20H
	JR	Z,RENV2S	;2xH����Ȃ���΃X�L�b�v

	LD	C,B		;2xH�Ȃ�~�b�N�X���[�h
	LD	A,(RITRK)
	LD	B,A
	PUSH	HL
	LD	A,E
	AND	3
	CALL	MIXSUB
	POP	HL
	LD	B,C
	LD	E,7
	CALL	WPSGM		;�~�b�N�X���[�h��������
	JR	RENV1

RENV2S:
	LD	A,E
	CP	6		;���W�X�^#6�ȍ~���ǂ���
	JR	C,RENV3		;6�����Ȃ�X�L�b�v
	CP	13
	JR	NZ,RENV2D	;13�ȊO�i6�`12�j�Ȃ�t���O�͑��삹���ɒ����W�X�^��������
	LD	(RHENV),A	;13�Ȃ烊�Y�����n�[�h�G���x�g�p�t���O�𗧂ĂĒ����W�X�^��������
RENV2D:
	LD	A,(HL)		;�f�[�^��ǂݍ���
	JR	RENVZ		;���W�X�^#6�ȍ~�Ȃ璼�ɒl����������

RENV3:
	CP	1
	JR	Z,RENVV		;1�Ȃ特�ʁA2�Ȃ特��

	LD	A,(RPREG)
	LD	E,A		;�s�b�`���W�X�^��ʂ�ݒ�
	LD	A,(HL)		;�s�b�`�f�[�^��ʂ�ǂݍ���
	CALL	WPSGM
	INC	HL
	LD	A,(HL)		;�s�b�`�f�[�^���ʂ�ǂݍ���
	DEC	E		;�s�b�`���W�X�^���ʂ�ݒ�
	JR	RENVZ

RENVV:
	LD	A,(RVREG)
	LD	E,A		;���ʃ��W�X�^��ݒ�

	LD	A,(HL)		;�f�[�^��ǂݍ���ł���
	CP	16
	JR	Z,RENVZ		;�n�[�h�G���x�Ȃ特�ʎw���}�X�^�[���ʂ𔽉f�����Ȃ�
	LD	D,A
	LD	A,(RVWRK)
	LD	C,A
	LD	A,(MVOL)
	ADD	A,C
	LD	C,A
	LD	A,D
	SUB	C
	JR	NC,RENVZ
	XOR	A
RENVZ:
	CALL	WPSGM
	INC	HL		;�G���x���[�v�|�C���^��i�߂�
	JP	RENV1

;���Y��������

RHYOFF:
	XOR	A
	LD	(RNON),A

	LD	A,(NFREQW)	;�m�C�Y���g���������݃t���O�𗧂Ă�
	OR	32
	LD	(NFREQW),A

	LD	A,(RPREG)	;���Y�������O�̉����ɖ߂�
	LD	E,A
	LD	A,(RPITCH+1)
	CALL	WPSGM
	DEC	E
	LD	A,(RPITCH)
	CALL	WPSGM

	LD	E,7		;�~�b�N�X���[�h��߂�
	LD	A,(MIXWRK)
	OR	80H
	CALL	WPSGM

	LD	A,(RVREG)	;���Y�������O�̉��ʂɖ߂�
	LD	E,A
	LD	A,(MVOL)
	LD	C,A
	LD	A,(RSVOL)
	SUB	C
	JR	NC,RHYOFM
	XOR	A
RHYOFM:
	CALL	WPSGM

	CP	16		;���ʂ�16(�n�[�h�G���x)�Ȃ�
	JR	Z,RHYOFH	;�n�[�h�G���x�֘A���W�X�^��߂�

	LD	A,(RHENV)	;���Y�����F����
	OR	A		;R#13�ւ̏������݂����s���Ă��Ȃ����
	JR	Z,RHYOF0	;�ȉ��������Ȃ�
RHYOFH:
	CALL	HEPWT		;�n�[�h�G���x������߂�
	INC	E		;�n�[�h�G���x�`���߂�
	LD	A,(HENVSW)
	CALL	WPSGM

RHYOF0:
	LD	A,(SEBAKR)
	OR	A
	JR	Z,RHYOF1

	CALL	PRRET1		;���W�X�^���A
	CALL	PRRET0

	XOR	A
	LD	(SEBAKR),A
RHYOF1:
	RET

HEPWT:
	LD	E,11		;�n�[�h�G���x������߂�
	LD	A,(HENVPW)
	CALL	WPSGM
	INC	E
	LD	A,(HENVPW+1)
	JP	WPSGM

REEND:
	LD	A,1		;�f�[�^�I�[�Ȃ�
	LD	(RNON),A	;���Y�������t���O��1�� (1=�������Z�b�g)

;�����J�E���g

COUNTR:
	DEC	(IX+4)		;�����J�E���^�����炷�i���Y���p�j
	RET	NZ

	LD	A,(IX+2)
	OR	A
	CALL	NZ,RHYOFF	;�x���ȊO���J�E���^��0�ɂȂ����烊�Y��������

	JR	MAIN1

COUNTL:
	LD	A,(IX+7)
	LD	(IX+12),A	;���K�[�g�X�V
COUNT:
	LD	A,(IX+51)	;�����[�X�f�B���C�J�E���^��
	OR	A		;0�Ȃ�
	JR	Z,COUNT1	;�X�L�b�v
	CP	255
	JR	Z,COUNT1	;255�ł��X�L�b�v

	DEC	(IX+51)		;�����[�X�f�B���C�J�E���^���f�N�������g����
	JR	NZ,COUNT1	;0�łȂ���Ώ������Ȃ�

	LD	A,(IX+29)
	LD	(IX+51),A	;�J�E���^��߂�

	LD	A,(IX+2)
	OR	A
	JR	NZ,COUNT0
	LD	A,(IX+41)
COUNT0:
	CALL	NTOP
	LD	(IX+27),L
	LD	(IX+28),H	;������i�߂�
	LD	(IX+59),1

COUNT1:
	DEC	(IX+4)		;�����J�E���^�����炷
	RET	NZ

;�f�[�^�ǂݍ���

MAIN1:
	LD	L,(IX+0)
	LD	H,(IX+1)	;���t���A�h���X
MAIN1A:
	LD	A,(IX+5)
	OR	A
	JR	Z,READ		;����1�o�C�g���J�E���^����Ȃ���Ύ��̃f�[�^��ǂ�
	XOR	A
	LD	(IX+5),A	;����1�o�C�g���J�E���^���ǂ����̃t���O�����Z�b�g����
	JP	NOTE2		;�J�E���g�ݒ�ɔ��

READ:
	LD	A,B
	CP	4		;�ʏ�`�����l�����ǂ���
	JR	NZ,READ1

;���Y���`�����l���p�f�[�^�ǂݍ���

READR:
	LD	A,(HL)
	INC	HL

	OR	A
	JP	Z,RREST		;00H	�x��

	CP	40H
	JP	C,RNOTE		;001nnnnnb (20-3FH) n�ԃ��Y���𔭉��i�����C�Ӄo�C�g�������j

	CP	60H
	JP	C,RVOLAD	;010nnnnnb (40-5FH) n�ԃ��Y���̉��ʌ��Z�i����1�o�C�g�����Βl�j

	CP	80H
	JP	C,RVOLS		;011nnnnnb (60-7FH) n�ԃ��Y���̉��ʉ��Z�i����1�o�C�g�����Βl�j

	CP	0C0H
	JP	C,RVOL		;101nnnnnb (A0-BFH) n�ԃ��Y���̉��ʁi����1�o�C�g�����ʁj

	JP	TBLJFX

;�ʏ�`�����l���p�f�[�^�ǂݍ���

READ1:
	LD	A,(HL)
	INC	HL

	CP	60H
	JP	C,NOTE		;00-5FH	���� (�����C�Ӄo�C�g������)

	CP	70H
	JP	C,VOL		;60-6FH	����

	CP	80H
	JP	C,TONE		;70-7FH	���F�ԍ�

	CP	90H
	LD	DE,CTBL8-080H*2
	JP	C,TBLJ		;80-8FH	�e�[�u���̊e�R�}���h

	CP	0A0H
	JP	C,HENV		;90-9FH	�n�[�h�G���x

	CP	0B0H
	LD	DE,CTBLA-0A0H*2
	JR	C,TBLJ		;A0-AFH	�e�R�}���h

	CP	0C0H
	JP	C,VOLP		;B0-BFH ���ʉ��Z

	CP	0D0H
	JP	C,VOLM		;C0-CFH ���ʌ��Z

TBLJFX:
	LD	DE,CTBLF-0F0H*2	;F0-FFH �e�[�u���̊e�R�}���h
TBLJ:
	PUSH	HL
	LD	H,0
	LD	L,A
	ADD	HL,HL
	ADD	HL,DE
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	PUSH	DE
	POP	IY
	POP	HL
	JP	(IY)

CTBL8:	DW	SETPED,MIXMOD,SETPEV,NFREQ ,LEGATO,LEGATO,QGATE ,DETUNE,PORTA ,DTUNER,SDELAY,SDELAY,SDLY_S,RRSET ,DTUNE2,PENV6B	;80-8F
CTBLA:	DW	HENVP ,PORTA2,Q2GATE,SUS   ,SETNEV,SETVI ,FRQSET,VIMAX ,PORTAP,RDPRST,Q3GATE,PRMSAV,SEPLY			;A0-AC
CTBLF:	DW	FSET  ,REPSTA,REPESC,REPEND,RITSET,CHEND ,CHEND ,CHEND ,CHEND ,CHEND ,CHEND ,CHEND ,YCMD  ,SLWSET,FFSET ,CHEND	;F0-FF

;�L�[�I��

NOTE:
	PUSH	HL

	LD	D,A		;�V�����m�[�g�ԍ���D�ɑޔ�

	LD	A,(IX+2)	;�Â��m�[�g�ԍ���ǂ�
	OR	A
	JR	Z,NOTE0
	LD	(IX+41),A	;�x���łȂ���Εۑ�
NOTE0:
	LD	C,A		;�Â��m�[�g�ԍ���C�ɑޔ�
	LD	A,D		;�V�����m�[�g�ԍ���ǂ�
	LD	(IX+2),A	;�V�����m�[�g�ԍ���ۑ�
	OR	A
	LD	D,A
	JP	Z,NOTE1P	;�x���Ȃ�L�[�I���t���O�Ȃǂ��Z�b�g���Ȃ�

	LD	(IX+59),1
	LD	(IX+31),A	;�L�[�I���t���O���Z�b�g

	LD	A,(IX+29)	;�����[�X�f�B���C�ݒ�l��
	LD	(IX+51),A	;�����[�X�J�E���^�ɃZ�b�g

NOTE1:
	LD	A,(IX+38)	;�|���^�����g�l��
	OR	A		;�ݒ肳��Ă����
	JR	Z,NOTE11	;�|���^�����g���Z�l��
	LD	(IX+34),A	;�ݒ������

NOTE11:
	LD	A,(IX+39)	;�|���^�����g�P���t���O
	OR	A		;��
	JR	Z,NOTE1P	;0�Ȃ�X�L�b�v

	INC	(IX+39)		;���Z���c
	CP	1		;���Z�O�̒l��1�ł�
	JR	Z,NOTE1P	;�X�L�b�v

	XOR	A		;�P���t���O�������Ă���
	LD	(IX+39),A	;�O��ƈႤ�����Ȃ�
	LD	(IX+38),A	;�|���^�����g�I�t
	LD	(IX+33),A
	LD	(IX+34),A

NOTE1P:
	LD	A,(IX+12)	;���K�[�g�m�F
	OR	A
	JR	NZ,NOTE1R	;���K�[�g���Ȃ�X�L�b�v���邩�ǂ����̔���ɔ��

	CALL	DTNSAV
	JR	NOTE12		;���K�[�g���łȂ���΃L�[�I�����̊e��ݒ�ɔ��

NOTE1R:
	LD	A,(IX+13)
	OR	(IX+14)
	JR	Z,NOTE1E	;���̉������W�X�^�l�̃��[�N��0�Ȃ�s�b�`�X�V�����X�L�b�v

	LD	A,D
	CP	C
	JR	NZ,NOTE13	;�i���K�[�g���Łj�O��ƈႤ�����Ȃ�s�b�`�X�V

	LD	A,(IX+19)
	CP	(IX+49)
	JR	NZ,NOTE1C	;�i���K�[�g���Łj�O��ƈႤ�f�`���[���l�Ȃ�s�b�`�X�V

	LD	A,(IX+20)
	CP	(IX+50)
	JR	Z,NOTE1E	;���K�[�g���őO��Ɠ����f�`���[���l�Ȃ�s�b�`�X�V�����X�L�b�v
NOTE1C:
	CALL	DTNSAV

	LD	A,D
NOTE13:
	CALL	NPSET		;�s�b�`�ݒ�

	LD	A,(IX+11)	;�s�b�`�G���x��
	AND	00100000B	;�O�̃t���[������̑��Βl�łȂ����̉�������̏ꍇ��
	JR	NZ,NOTE1E	;�r�u���[�g�̍Đݒ�����Ȃ�

	LD	C,1		;�r�u���[�g�f�B���C���������܂Ȃ�
	CALL	SETPA2

	JR	NOTE1E
NOTE12:
	LD	A,D
	CALL	NPSET		;���K�[�g���łȂ���΃s�b�`�ݒ�

NOTE2S:
	LD	A,(IX+6)	;���F�ԍ�
	LD	E,A
	CP	90H
	JR	C,NOTES0	;90H�����Ȃ�\�t�g�G���x

	LD	A,(IX+2)
	OR	A
	JR	Z,NOTE2R	;�x���Ȃ�~�b�N�X���[�h�̐ݒ���X�L�b�v�A�s�b�`�G���x�̍Đݒ�����Ȃ�

	LD	A,(IX+17)	;���ʔ���
	OR	A		;��
	JR	Z,NOTES2	;�ݒ肳��Ă��Ȃ���΃X�L�b�v
	CALL	MIXOFF
	CALL	MIXWT		;���ʔ������ݒ肳��Ă�����L�[�I�����̃~�b�N�X���[�h��ݒ�
	JR	NOTES2

NOTES0:
	CALL	SETVAD		;���F�A�h���X�ݒ�
NOTES1:
	LD	A,(IX+2)
	OR	A
	JR	Z,NOTE2R	;�x���Ȃ�s�b�`�G���x�̍Đݒ�����Ȃ�

NOTES2:
	LD	C,0		;�r�u���[�g�f�B���C�L��
	CALL	SETPAD		;�s�b�`�G���x�A�h���X�ݒ�
	CALL	SETNAD		;�m�[�g�G���x�A�h���X�w��
NOTE2R:

	XOR	A
	LD	(IX+48),A	;���ʃC���^�[�o�������Z�b�g
	LD	(VISPAN),A	;���ʃC���^�[�o�����������Z�b�g

	LD	A,(IX+42)	;���ʃC���^�[�o���J�E���^��ݒ�
	AND	01111111B
	LD	(IX+47),A

NOTE1E:
	POP	HL
NOTE2:
	LD	A,(HL)
	INC	HL
	LD	(IX+4),A	;�����Z�b�g
	OR	A
	JP	Z,MAIN1A	;������0�t���[���łȂ���΃Q�[�g�^�C������ݒ肹���Ɏ��̃f�[�^��ǂ�
	CP	255
	JP	C,NOTE3
	LD	(IX+5),A	;����1�o�C�g������
	LD	(IX+52),A	;�Q�[�g�^�C����255��
	LD	A,(HL)
	CP	255		;�X�Ɏ���1�o�C�g��255�Ȃ�N�I���^�C�Y�͌v�Z���Ȃ�
	JP	Z,MEND
	LD	A,255
NOTE3:
	PUSH	HL

	LD	H,A		;������H��

	LD	A,B
	CP	CHNUM
	JR	Z,NOTE2E	;���Y���g���b�N�Ȃ�Q�[�g�^�C���v�Z���Ȃ�

	LD	A,(IX+57)	;�Œ�Q�[�g�^�C��
	OR	A		;��
	JR	Z,NOTEQ		;0�Ȃ�ʏ�̃N�I���^�C�Y�ݒ��

	CP	H		;�����ƌŒ�Q�[�g�^�C�����r
	JR	C,NOTEGT	;�Œ�Q�[�g�^�C���̂ق����Z����΂��̂܂܃W�����v
	LD	A,H		;������ΌŒ�Q�[�g�^�C���������Ɠ����ɂ���
	JR	NOTEGT
NOTEQ:
	LD	A,(IX+9)	;Q�̒l
	CP	8
	JR	NZ,NOTE3A

	LD	A,(IX+40)	;@Q�̒l��
	CP	129		;129�ȉ��Ȃ�
	JR	C,NOTE40	;���Z��
	JR	NOTEGT		;129�ȏ�ł�Q8�̂Ƃ��͉��Z���Ȃ�
NOTE3A:
	LD	D,H
	LD	E,0		;�Œ菬���p
	SRL	D
	RR	E		;/2
	SRL	D
	RR	E		;/4
	SRL	D
	RR	E		;/8
	LD	HL,0
	LD	C,B		;B���W�X�^��ޔ�
	LD	B,A		;Q�̒l
NOTE4:
	ADD	HL,DE
	DJNZ	NOTE4
	LD	B,C		;B���W�X�^��߂�

	LD	A,(IX+40)	;@Q�̒l���m�F����
	CP	129		;129�ȉ��Ȃ�
	JR	C,NOTE40	;���Z��

	SUB	128		;129�ȏ�Ȃ�128������
	ADD	A,H		;���Z
	JR	NC,NOTEGT
	LD	A,254
	JR	NOTEGT

NOTE40:
	LD	A,H
	SUB	(IX+40)		;�Q�[�g�^�C�����Z(@Q)
	JR	C,NOTE41
	JR	NZ,NOTEGT
NOTE41:
	LD	A,1
NOTEGT:
	LD	(IX+52),A	;�Q�[�g�^�C��

	CP	(IX+29)		;�����[�X�f�B���C�̐ݒ�t���[���Ɣ�r����
	JR	C,NOTE22	;�����̂ق�����������΃W�����v
	LD	(IX+53),1	;�������Ȃ���΃����[�X�f�B���C�X�L�b�v�t���O���Z�b�g
NOTE22:
	LD	(IX+53),0	;��������΃����[�X�f�B���C�X�L�b�v�t���O�����Z�b�g

	LD	A,(RITRK)
	CP	B
	JR	NZ,NOTE2E

	LD	A,(SEMODE)
	OR	A
	JR	NZ,NOTE2E

	LD	A,(IX+13)	;���荞�܂�g���b�N�Ȃ烊�Y��������ɉ�����߂����߂̃s�b�`�l��ޔ�
	LD	(RPITCH),A
	LD	A,(IX+14)
	LD	(RPITCH+1),A
NOTE2E:
	POP	HL
NOTE5:
	JP	MEND

NPSET:
	OR	A
	RET	Z

	CALL	NTOP		;�m�[�g�ԍ�����s�b�`���擾����HL��

	LD	A,(IX+53)	;�����[�X�f�B���C�X�L�b�v�t���O��
	OR	A		;0�Ȃ�
	JR	Z,NPSET1	;�ʏ�̃s�b�`�ݒ�

	LD	(IX+27),L	;�����[�X�f�B���C�p�̉�����
	LD	(IX+28),H	;�ŐV�̉����ɂ���
	LD	(IX+53),0	;�����[�X�f�B���C�X�L�b�v�t���O��������
	JR	NPSET2
NPSET1:
	PUSH	HL
	LD	A,(IX+41)
	CALL	NTOP
	LD	(IX+27),L
	LD	(IX+28),H
	POP	HL
NPSET2:
	LD	(IX+13),L	;���[�N�Ƀs�b�`��ۑ�
	LD	(IX+14),H
	LD	(IX+54),L
	LD	(IX+55),H

	RET

;���Y���x��

RREST:
	PUSH	HL
	LD	(IX+2),0
	JP	NOTE1E

;���Y���L�[�I��

RNOTE:
	PUSH	HL
	AND	11111B
	INC	A
RNSET1:
	LD	(IX+2),A	;�m�[�g�ԍ���ۑ�

	LD	D,0
	LD	E,A
	LD	HL,RVOLW-1
	ADD	HL,DE		;���Y�����ʂ̃��[�N���Z�o
	LD	A,(HL)
	LD	(RVWRK),A	;���f�p�̃��Y�����ʂ�ۑ�

	SLA	E
	LD	HL,RADTBL-2
	ADD	HL,DE		;���Y�����F�̃e�[�u�����Z�o
	LD	A,(HL)
	LD	(IX+16),A
	INC	HL
	LD	A,(HL)
	LD	(IX+17),A	;�G���x���[�v�|�C���^��ݒ�

	LD	A,2
	LD	(RNON),A	;���Y���������t���O��2�� (2=���Y��������)
	XOR	A
	LD	(RHENV),A	;���Y�����n�[�h�G���x�g�p�t���O�����Z�b�g

	JP	NOTE1E

;����

VOL:
	AND	0FH
VOL1:
	LD	(IX+3),A	;���ʂ�ݒ�
	JP	READ1

VOLP:
	AND	0FH		;���ʂ����Z
	ADD	A,(IX+3)
	CP	15
	JR	C,VOL1
	LD	A,15
	JR	VOL1

VOLM:
	AND	0FH		;���ʂ����Z
	LD	D,A
	LD	A,(IX+3)
	SBC	A,D
	JR	NC,VOL1
	XOR	A
	JR	VOL1

;���Y������ (101xxxxxb ����1�o�C�g�����ʁj

RVOL:
	LD	C,(HL)		;���ʒl
	INC	HL

	PUSH	HL

	AND	11111B
	CP	31
	JR	Z,RVOL0

	CALL	RVADDR
	LD	(HL),C

	POP	HL
	JP	READR

RVOL0:
	LD	D,B
	CALL	RVOLA
	LD	B,D

	POP	HL
	JP	READR

;�S���Y������ (C<-����)

RVOLA:
	LD	B,26
	LD	HL,RVOLW
RVOLA0:
	LD	(HL),C
	INC	HL
	DJNZ	RVOLA0
	RET

;���Y�����ʉ��Z (011xxxxxb ����1�o�C�g�����ʁj

RVOLAD:
	LD	C,(HL)		;���ʉ��Z�l
	INC	HL

	PUSH	HL

	AND	11111B
	CP	31
	JR	Z,RVOLA2

	CALL	RVADDR
	LD	A,(HL)
	ADD	A,C
	AND	0FH
	LD	(HL),A
	POP	HL
	JP	READR

;�S���Y�����ʉ��Z (C<-����)

RVOLA2:
	LD	D,B

	LD	B,26
	LD	HL,RVOLW
RVOLAA0:
	LD	A,(HL)
	ADD	A,C
	AND	0FH
	LD	(HL),A
	INC	HL
	DJNZ	RVOLAA0

	LD	B,D

	POP	HL
	JP	READR

;���Y�����ʌ��Z (111xxxxxb ����1�o�C�g�����ʁj

RVOLS:
	LD	C,(HL)		;���ʌ��Z�l
	INC	HL

	PUSH	HL

	AND	11111B
	CP	31
	JR	Z,RVOLS2

	CALL	RVADDR
	LD	A,(HL)
	SUB	C
	AND	0FH
	LD	(HL),A
	POP	HL
	JP	READR

;�S���Y�����ʌ��Z (C<-����)

RVOLS2:
	LD	D,B

	LD	B,26
	LD	HL,RVOLW
RVOLSA0:
	LD	A,(HL)
	SUB	C
	AND	0FH
	LD	(HL),A
	INC	HL
	DJNZ	RVOLSA0

	LD	B,D

	POP	HL
	JP	READR

;���Y�����ʃA�h���X��HL�ɕԂ� (D<-���Y���ԍ�)

RVADDR:
	LD	HL,RVOLW
	LD	D,0
	LD	E,A
	ADD	HL,DE
	RET

;���F�w��

TONE:
	LD	C,(IX+6)	;�����F�ԍ���C�ɑޔ�

	AND	0FH
	LD	(IX+6),A	;���F�ԍ���ݒ�

	PUSH	HL
	LD	E,A
	LD	A,(IX+12)	;���K�[�g�m�F
	OR	A
	CALL	NZ,SETVAD	;���K�[�g���Ȃ瑦���ɉ��F�A�h���X�ݒ�

	LD	A,C		;�����F�ԍ���
	CP	90H		;�n�[�h�G���x�łȂ����
	JR	C,TONE1		;�X�L�b�v
	LD	A,(IX+17)	;���ʔ����J�E���^�ݒ肪
	OR	A		;0�Ȃ�
	JR	Z,TONE1		;�X�L�b�v
	CALL	MIXTWT		;0�ȊO�Ȃ�g�[���L���E�m�C�Y������
TONE1:
	POP	HL

	JP	READ1

;�n�[�h�G���x�w��

HENV:
	LD	(IX+6),A	;���F�ԍ���ݒ�

	LD	A,(HL)
	INC	HL
	LD	(IX+16),A	;�����J�E���^
	LD	(IX+17),A	;�����J�E���^�ݒ�

	JP	READ1

IF 0
;�n�[�h�G���x����

HENVP:
	LD	A,(HL)
	LD	(HENVPW),A
	INC	HL
	LD	A,(HL)
	LD	(HENVPW+1),A
	CALL	HEPWT
	INC	HL
	JP	READ1
ENDIF

;�T�X�e�B��

SUS:
	LD	A,(HL)		;�T�X�e�B���l
	INC	HL
	LD	(IX+8),A
	CALL	NOTES
	JP	READ1

;���ʃC���^�[�o��

SETVI:
	LD	A,(HL)		;�r�b�g7�������Ă���}�C�i�X�A�����łȂ���΃v���X�A�r�b�g0�`6�Ńt���[����
	OR	A
	JR	NZ,SETVI1
	LD	(IX+56),A	;�ݒu�l��0�Ȃ瓞�B���ʂ�0�ɂ���
SETVI1:
	LD	(IX+42),A	;�ݒ�l
	AND	01111111B
	LD	(IX+47),A	;�J�E���^
	INC	HL
	JP	READ1

;�m�C�Y���g��

NFREQ:
	LD	A,(HL)
	LD	(NFREQW),A
	INC	HL
	JP	READ1

;�s�b�`�G���x�w��

SETPEV:
	CALL	SETPES
	LD	C,(IX+12)	;���K�[�g���Ȃ瑦���Ƀs�b�`�G���x�A�h���X�ݒ�
	JP	READ1

SETPES:
	LD	A,(HL)		;�s�b�`�G���x�l
	INC	HL
	LD	(IX+11),A

	LD	A,C
	OR	A
	LD	C,0
	PUSH	HL
	CALL	NZ,SETPAD	;C��0�ȊO�Ȃ瑦���Ƀs�b�`�G���x�A�h���X�ݒ�
	POP	HL
	RET

;�m�[�g�G���x�w��

SETNEV:
	CALL	SETNES
	LD	C,(IX+12)	;���K�[�g���Ȃ瑦���Ƀm�[�g�G���x�A�h���X�ݒ�
	JP	READ1

SETNES:
	LD	A,(HL)		;�m�[�g�G���x�l
	INC	HL
	LD	(IX+43),A

	LD	A,C
	OR	A
	PUSH	HL
	CALL	NZ,SETNAD	;C��0�ȊO�Ȃ瑦���Ƀm�[�g�G���x�A�h���X�ݒ�
	POP	HL
	RET

;���K�[�g

LEGATO:
	AND	1		;���K�[�gON/OFF
	LD	(IX+7),A
	JP	READ1

;�N�I���^�C�Y�i8�i�K�Q�[�g�^�C���j

QGATE:
	LD	(IX+57),0	;;�Œ�Q�[�g�^�C���I�t

	LD	A,(IX+9)
	OR	A
	JR	NZ,QGATE2
	LD	(IX+7),0	;���s����Q0�Ȃ烌�K�[�g�I�t
QGATE2:
	LD	A,(HL)		;�N�I���^�C�Y�l
	INC	HL
	LD	(IX+9),A
	OR	A
	JP	NZ,READ1

	INC	A
	LD	(IX+7),A	;Q0�Ȃ烌�K�[�g�I��

	JP	READ1

;�N�I���^�C�Y2�i���Z�Q�[�g�^�C���j

Q2GATE:
	LD	(IX+57),0	;;�Œ�Q�[�g�^�C���I�t

	LD	A,(HL)
	INC	HL
	LD	(IX+40),A
	JP	READ1

;�N�I���^�C�Y3�i�Œ�Q�[�g�^�C���j

Q3GATE:
	LD	A,(HL)
	INC	HL
	LD	(IX+57),A
	JP	READ1

;�f�`���[��

DETUNE:
	CALL	DTNSAV

	LD	A,(HL)
	INC	HL
	LD	(IX+19),A	;�f�`���[��(0=OFF)

	CP	80H
	JR	C,DETUN1

	LD	(IX+20),255
	JP	READ1
DETUN1:
	LD	(IX+20),0
	JP	READ1

;�f�`���[��(2�o�C�g�p)

DTUNE2:
	CALL	DTNSAV
	LD	A,(HL)
	LD	(IX+19),A
	INC	HL
	LD	A,(HL)
	LD	(IX+20),A
	INC	HL

	JP	READ1

;�O��̃f�`���[���l��ۑ�

DTNSAV:
	LD	A,(IX+19)
	LD	(IX+49),A
	LD	A,(IX+20)
	LD	(IX+50),A
	RET

;���΃f�`���[��

DTUNER:
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	HL

	PUSH	HL

	LD	L,(IX+19)
	LD	(IX+49),L
	LD	H,(IX+20)
	LD	(IX+50),H	;�O��̃f�`���[���l��HL�ɓ�����[�N�ɕۑ�

	ADD	HL,DE

	LD	(IX+19),L
	LD	(IX+20),H

	POP	HL

	JP	READ1

;�s�b�`�G���x�ԍ��̃r�b�g6��ݒ�

PENV6B:
	LD	A,(HL)
	INC	HL
	OR	A
	LD	A,(IX+11)
	JR	Z,PENV6Z
	OR	01000000B
	JR	PENV6S
PENV6Z:
	AND	10111111B
PENV6S:
	LD	(IX+11),A
	JP	READ1

;�s�b�`�G���x�̃f�B���C�l����������

SETPED:
	LD	C,(HL)
	INC	HL

	LD	A,(IX+11)
	OR	A
	JP	Z,READ1

	PUSH	HL
	CALL	GETPAD
	LD	(HL),C
	POP	HL

	JP	READ1

;�|���^�����g

PORTA:
	LD	A,(HL)
	INC	HL
	LD	(IX+37),0	;�|���^�����g�l(������)
	LD	(IX+38),A	;�|���^�����g�l(������, 0=OFF)

	OR	A
	JP	Z,PORTA1	;P0�Ȃ烊�Z�b�g����

	LD	A,(IX+13)
	LD	E,(IX+14)
	OR	E
	JR	NZ,PORTA0

	LD	A,(O4C+1)
	LD	E,A
	LD	A,(O4C)
PORTA0:
	LD	(IX+35),A
	LD	(IX+36),E	;�J�n�s�b�`��ݒ�

	LD	(IX+39),0	;�|���^�����g�P���t���O��OFF
	JP	READ1
PORTA1:
	LD	(IX+34),A	;�|���^�����g���Z�l��
	LD	(IX+33),A	;0�ɂ���
	JP	READ1

;�|���^�����g2

PORTA2:
	LD	(IX+39),1	;�|���^�����g�P���t���O��ON

	LD	A,(HL)
	INC	HL
	LD	(IX+37),A	;�|���^�����g�ݒ�l(������)

	LD	A,(HL)
	INC	HL
	LD	(IX+38),A	;�|���^�����g�ݒ�l(������, 0=OFF)

;�|���^�����g�s�b�`�ݒ�

PORTAP:
	LD	A,(HL)		;�m�[�g�ԍ����擾
	INC	HL

	PUSH	HL
	CALL	NTOP		;�����f�[�^���擾����
	LD	(IX+35),L	;�J�n�s�b�`��ݒ�
	LD	(IX+36),H
	POP	HL

	JP	READ1

;�����[�X�f�B���C�̃s�b�`�����Z�b�g

RDPRST:
	LD	(IX+53),1
	JP	READ1

;�p�����[�^�ޔ��E���A

PRMSAV:
	LD	A,(HL)
	INC	HL

	AND	80H
	JR	Z,PRMSV1

	LD	A,(IX+58)	;�ޔ�l��
	LD	(IX+3),A	;�ݒ艹�ʂɕ��A
	JP	READ1
PRMSV1:
	LD	A,(IX+3)	;�ݒ艹�ʂ�
	LD	(IX+58),A	;�ޔ�
	JP	READ1

;���ʃC���^�[�o���ő�l��ݒu

VIMAX:
	LD	A,(HL)
	INC	HL
	LD	(IX+56),A
	JP	READ1

;���g���e�[�u����������

FRQSET:
	LD	D,0
	LD	E,(HL)
	INC	HL
	PUSH	HL
	LD	HL,PTABLE
	ADD	HL,DE
	EX	DE,HL		;�����f�[�^���特���e�[�u���̃A�h���X�����߂�HL��
	POP	HL

	LD	A,B
	LDI
	LDI
	LD	B,A
	JP	READ1

;�����[�X�f�B���C

SDELAY:
	AND	1
	JR	Z,SDLY1
	LD	A,255		;�f�t�H���g�ł͉�����i�܂���t���[������255�ɂ���i255=�i�܂��Ȃ��j
SDLY1:
	LD	(IX+29),A	;�����[�X�f�B���C�l
	JP	READ1

;�����[�X�f�B���C�i�f�B���C�l��ݒ�j

SDLY_S:
	LD	A,(HL)		;�f�B���C�l���w�肷��ꍇ
	INC	HL
	JR	SDLY1

;�~�b�N�X���[�h

MIXMOD:
	LD	D,(HL)
	LD	A,(IX+6)
	CP	90H
	LD	A,D
	JR	C,MIXMD1
	LD	(MIXNMH),A
MIXMD1:
	INC	HL
	CALL	MIXSWT
	JP	READ1

MIXTWT:
	CALL	MIXT
	CALL	MIXWT
	RET
MIXSWT:
	PUSH	HL
	CALL	MIXSUB
	CALL	MIXWT
	POP	HL
	RET

MIXWT:
	LD	C,A
	CALL	MIX_IY
	LD	(IY),C
	RET

MIX_IY:
	LD	IY,MIXWRK	;���ʉ����[�h���ǂ����Ń~�b�N�X���[�h�̃��[�N�𔻒f����IY�ɕԂ�
	LD	A,(SEMODE)
	OR	A
	RET	Z
	INC	IY
	RET

MIXSUB:
	OR	A
	JR	Z,MIXOFF
	CP	1
	JR	Z,MIXT
	LD	(IX+60),A	;*n�̒l��ۑ�
	CP	2
	JR	Z,MIXN
MIXON:
	LD	HL,MIXTB3-1
	LD	E,B
MIXAND:
	LD	D,0
	ADD	HL,DE
	CALL	MIX_IY
	LD	A,(IY)
	AND	(HL)
	RET
MIXOFF:
	LD	HL,MIXTB0-1
	LD	E,B
	LD	D,0
	LD	(IX+60),D	;*0��ۑ�
	ADD	HL,DE
	CALL	MIX_IY
	LD	A,(IY)
	AND	00111111B
	JR	MIXAO1
MIXT:
	LD	HL,MIXTB1-2
	LD	(IX+60),1	;*1��ۑ�
MIXAO:
	LD	A,B
	ADD	A,A
	LD	E,A
	CALL	MIXAND
	INC	HL
MIXAO1:
	OR	(HL)
	RET
MIXN:
	LD	HL,MIXTB2-2
	JR	MIXAO

;		ChCBACBA
;		10NNNTTT
MIXTB0:
	DB	00100100B;	CH.C OR �g�[��OFF �m�C�YOFF
	DB	00010010B;	CH.B OR �g�[��OFF �m�C�YOFF
	DB	00001001B;	CH.A OR �g�[��OFF �m�C�YOFF
MIXTB1:
	DB	00111011B;	CH.C AND �g�[��ON
	DB	00100000B;	CH.C  OR �m�C�YOFF
	DB	00111101B;	CH.B AND �g�[��ON
	DB	00010000B;	CH.B  OR �m�C�YOFF
	DB	00111110B;	CH.A AND �g�[��ON
	DB	00001000B;	CH.A  OR �m�C�YOFF
MIXTB2:
	DB	00011111B;	CH.C AND �m�C�YON
	DB	00000100B;	CH.C  OR �g�[��OFF
	DB	00101111B;	CH.B AND �m�C�YON
	DB	00000010B;	CH.B  OR �g�[��OFF
	DB	00110111B;	CH.A AND �m�C�YON
	DB	00000001B;	CH.A  OR �g�[��OFF
MIXTB3:
	DB	00011011B;	CH.C AND �g�[��ON �m�C�YON
	DB	00101101B;	CH.B AND �g�[��ON �m�C�YON
	DB	00110110B;	CH.A AND �g�[��ON �m�C�YON

;Y�R�}���h

YCMD:
	LD	E,(HL)
	INC	HL
	LD	A,(HL)
	INC	HL
	CALL	WPSGM
	JP	READRT

;�����[�X���ʐݒ�

RRSET:
	LD	A,(HL)
	INC	HL

	CP	128
	JR	C,RRSET1	;�r�b�g7�������Ă��Ȃ���ΐݒ�l�ɔ��f
	AND	15
	LD	(IX+24),A	;�����Ă����猻�݂̒l����������
	LD	(IX+26),1
	JP	READ1
RRSET1:
	LD	(IX+30),A
	CALL	NOTER
	JP	READ1

;�t�F�[�h�A�E�g�ݒ�

FSET:
	LD	E,(HL)		;�t�F�[�h�l
	INC	HL
	LD	D,(HL)		;���[�v��
	INC	HL

	LD	A,(LCOUNT)	;���[�N�̃��[�v����0�Ȃ�l�Z�b�g
	OR	A
	JR	NZ,MFSET1

	LD	A,(MFADE)
	OR	A
	JP	NZ,READRT

	LD	A,D
MFSET1:
	DEC	A
	LD	(LCOUNT),A
	JP	NZ,READRT

	LD	A,E
	LD	(MFADE),A
	JP	READRT

;�X���[�ݒ�

SLWSET:
	LD	A,(HL)
	INC	HL
	LD	(SLWPRM),A
	JP	READRT

;������ݒ�

FFSET:
	LD	A,(HL)
	INC	HL
	LD	(FFFLG),A
	JP	READRT

;���荞�݃g���b�N�I��

RITSET:
	LD	A,(HL)
	INC	HL
	LD	(RITRK),A	;���荞�܂�g���b�N (1=CH.C 2=CH.B 3=CH.A)

	LD	C,A
	LD	A,11
	SUB	C
	LD	(RVREG),A	;���Y���g���b�N�̉��ʃ��W�X�^

	SUB	8
	ADD	A,A
	INC	A
	LD	(RPREG),A	;���Y���g���b�N�̎��g�����W�X�^(���)

	JP	READRT

;SE�𔭉�

SEPLY:
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	HL

	CALL	SEPSUB

	JP	READRT

;SE�����T�u�iDE�����ʉ��f�[�^�擪�A�h���X�j

SEPSUB:
	PUSH	IX
	PUSH	HL
	PUSH	BC

	PUSH	DE

	LD	IX,SE1WRK
	LD	IY,CH2WRK
	LD	HL,SEBAKT
	LD	DE,WSIZE
	LD	B,CHNUM-1
SEPLY1:
	LD	A,(IX+10)	;���ʉ���
	OR	A		;�������łȂ����
	JR	Z,SEPLY2	;�X�L�b�v����

	LD	A,(HL)		;���ʉ��������Ȃ�
	LD	(IY+10),A	;BGM���̃g���b�N�L���t���O��߂�
SEPLY2:
	ADD	IX,DE
	ADD	IY,DE
	INC	HL
	DJNZ	SEPLY1

	POP	DE

	LD	A,D
	CP	40H
	JR	C,SEPLY3	;���ʉ��A�h���X��4000H�����Ȃ瑊�Βl�Ƃ��Ĉ���

	LD	H,D
	LD	L,E
	JR	SEPLY4
SEPLY3:
	LD	HL,(BGMADR)
	ADD	HL,DE
SEPLY4:
	LD	IX,SE1WRK
	LD	B,CHNUM-1
	CALL	INIADR		;���ʉ��f�[�^�擪�A�h���X�ݒ�

	LD	IX,CH2WRK
	LD	IY,SE1WRK
	LD	HL,SEBAKT
	LD	DE,WSIZE
	LD	B,CHNUM-1
SEMOF1:
	LD	A,(IX+10)	;BGM�̃`�����l���L���t���O
	LD	(HL),A
	OR	A
	JR	Z,SEMOFL	;0�Ȃ�X�L�b�v

	LD	A,(IY+10)	;SE�̃`�����l���L���t���O
	OR	A
	JR	Z,SEMOFL	;0�Ȃ�X�L�b�v
	LD	(IX+10),255	;0�łȂ����BGM�����~���[�g��Ԃ�

SEMOFL:
	ADD	IX,DE
	ADD	IY,DE
	INC	HL
	DJNZ	SEMOF1

	LD	A,(MIXWRK)
	AND	00111111B	;�ŏ�ʃr�b�g��0�ɂ���
	LD	(MIXWRS),A	;���ʉ��p�~�b�N�X���[�N�ɓ]��
	POP	BC
	POP	HL
	POP	IX

	RET

;���s�[�g�J�n

REPSTA:
	INC	(IX+32)		;�l�X�g���Z
	CALL	REPADD
	LD	(IY),L
	LD	(IY+1),H	;���s�[�g�J�n�A�h���X�ݒ�
	LD	(IY+4),255	;���s�[�g�񐔂�255�ɉ��ݒ�

	JP	READRT

;���s�[�g�I��

REPEND:
	CALL	REPADD
	LD	A,(IY+4)	;���s�[�g�񐔊m�F
	CP	255
	JR	NZ,REPEN1

	LD	A,(HL)		;���s�[�g�񐔂����ݒ�̏��(255)�Ȃ�w�肵���񐔂�ǂݏo����
	LD	(IY+4),A	;���[�N�ɕۑ�����

	INC	HL
	LD	(IY+2),L	;�I���A�h���X��ۑ�
	LD	(IY+3),H

REPEN1:
	DEC	A		;���s�[�g�񐔂����Z����
	LD	(IY+4),A	;���[�N�ɕۑ�����
	JR	Z,REPEN2

	LD	L,(IY)		;���s�[�g�񐔂�0����Ȃ����
	LD	H,(IY+1)	;�|�C���^�����s�[�g�J�n�A�h���X�ɖ߂�
	JP	READRT

REPEN2:
	LD	L,(IY+2)	;�|�C���^�����s�[�g�I���A�h���X�ɂ���
	LD	H,(IY+3)
	DEC	(IX+32)		;�l�X�g���Z
	JP	READRT

;���s�[�g�E�o

REPESC:
	CALL	REPADD
	LD	A,(IY+4)
	CP	2
	JR	C,REPEN2	;���s�[�g�񐔂�1�ȉ��Ȃ�|�C���^�����s�[�g�I���A�h���X��
	JP	READRT

;���s�[�g�̃l�X�g�����烏�[�N�G���A�Q�ƃA�h���X���Z

REPADD:
	LD	IY,CH1RWK

	LD	A,4
	SUB	B
	JR	Z,REPAD2

	LD	C,B
	LD	B,A
	LD	DE,RWSIZE
REPAD1:
	ADD	IY,DE
	DJNZ	REPAD1
	LD	B,C
REPAD2:
	LD	A,(IX+32)
	DEC	A
	LD	D,A
	ADD	A,A
	ADD	A,A
	ADD	A,D
	LD	D,0
	LD	E,A
	ADD	IY,DE

	RET

;�g���b�N�ɉ����ēǂݍ��ݏ����ɃW�����v

READRT:
	LD	A,B
	CP	4		;�ʏ�`�����l�����ǂ���
	JP	Z,READR
	JP	READ1

;���F�A�h���X�ݒ� (E<-���F�ԍ�)

SETVAD:
	LD	HL,VADTBL	;���F�A�h���X�e�[�u����
	LD	D,0
	SLA	E		;���F�ԍ�*2
	ADD	HL,DE		;�����Z
	LD	A,(HL)
	LD	(IX+16),A
	INC	HL
	LD	A,(HL)
	LD	(IX+17),A	;���F�A�h���X��ݒ�
	RET

;�s�b�`�G���x�A�h���X�ݒ�
;(C<-0 �f�B���C�l��ݒ肷�� C<-1 �f�B���C�l��ݒ肵�Ȃ��AC<-2�ȏ� �f�B���C�����̒l�ɂ���)

SETPAD:
	XOR	A
	LD	(IX+18),A	;�G���x���[�v�E�F�C�g�J�E���^�����Z�b�g

SETPA2:
	LD	A,(IX+11)	;�s�b�`�G���x�ԍ�
	OR	A
	RET	Z

	CALL	GETPAD

	LD	A,C
	CP	1
	JR	C,SETPA4
	JR	Z,SETPA1
	JR	SETPA3
SETPA4:
	LD	A,(HL)
SETPA3:
	LD	(IX+23),A	;�s�b�`�G���x�f�B���C�J�E���^��ݒ�
SETPA1:
	INC	HL
	LD	(IX+21),L	;�s�b�`�G���x�|�C���^���ʂ�ݒ�
	LD	(IX+22),H	;�s�b�`�G���x�|�C���^��ʂ�ݒ�
	RET

;�s�b�`�G���x�̎��A�h���X���擾

GETPAD:
	AND	00011111B
	DEC	A
	ADD	A,A
	LD	D,0
	LD	E,A
	LD	HL,PADTBL	;�s�b�`�G���x�ԍ�����A�h���X�����߂�
	ADD	HL,DE

	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	EX	DE,HL
	RET

;�m�[�g�G���x�A�h���X�w�� (A<-�m�[�g�G���x�ԍ�)

SETNAD:
	LD	A,(IX+43)
	OR	A
	RET	Z

	AND	7FH
	LD	(IX+43),A

	DEC	A
	ADD	A,A
	LD	D,0
	LD	E,A
	LD	HL,NADTBL
	ADD	HL,DE

	LD	A,(HL)
	LD	(IX+44),A	;�m�[�g�G���x�|�C���^���ʂ�ݒ�
	INC	HL
	LD	A,(HL)
	LD	(IX+45),A	;�m�[�g�G���x�|�C���^��ʂ�ݒ�

	RET

;A���m�[�g�ԍ� ���g�����W�X�^�l��HL

NTOP:
	OR	A
	RET	Z

	ADD	A,A
	LD	D,0
	LD	E,A
	LD	HL,PTABLE-2
	ADD	HL,DE		;�����f�[�^���特���e�[�u���̃A�h���X�����߂�HL��

	LD	E,(HL)		;�����f�[�^��ǂݍ���
	INC	HL
	LD	D,(HL)
	EX	DE,HL

	LD	E,(IX+19)	;�f�`���[���l��
	LD	D,(IX+20)	;DE�ɓǂݍ���
	ADD	HL,DE		;���Z
	RET

;���g�����W�X�^��0��

PITCH0:
	CALL	REGP
	XOR	A
	CALL	WPSGM
	DEC	E
	JP	WPSGM		;���g����0��

;B����e���W�X�^�����߂�E��

REGP:
	LD	A,3
	SUB	B
	ADD	A,A
	LD	E,A
	INC	E		;�������W�X�^
	RET

REGV:
	LD	A,3
	SUB	B
	ADD	A,8
	LD	E,A		;���ʃ��W�X�^
	RET

;�SPSG���W�X�^��߂��i���g�p�j
;	IX=CH���[�N�擪�A�h���X

PRRETA:
	LD	IX,CH1WRK
	LD	B,CHNUM-1
PRRETL:
	CALL	PRRET1

	LD	DE,WSIZE
	ADD	IX,DE

	DJNZ	PRRETL

PRRET0:
	LD	E,6		;R#6
	LD	A,(NFREQW)	;�m�C�Y���g��
	CALL	WPSG

	LD	A,(MIXWRK)	;�~�b�N�X���[�h�̃��[�N��ǂ��
	AND	00111111B	;�ŏ�ʃr�b�g��0�ɂ���
	LD	(MIXWRK),A	;���[�N�ɖ߂��i���C���擪�Ń��W�X�^�������ݔ����j

	LD	A,(IX+6)
	CP	90H
	RET	C

	LD	E,11		;R#11
	LD	A,(HENVPW)	;�n�[�h�G���x��������
	CALL	WPSG
	INC	E		;R#12
	LD	A,(HENVPW+1)	;�n�[�h�G���x�������
	CALL	WPSG

	INC	E		;R#13
	LD	A,(HENVSW)	;�n�[�h�G���x�ԍ�
	CALL	WPSG
	RET

PRRET1:
	LD	A,B
	CP	CHNUM
	RET	NC

	CALL	REGP
	LD	A,(IX+14)	;�������̉������W�X�^���
	CALL	WPSG

	DEC	E		;R#1 R#3 R#5
	LD	A,(IX+13)	;�������̉������W�X�^����
	CALL	WPSG

	CALL	REGV
	XOR	A		;���ʂ�0��
	CALL	WPSG

	RET

;�g���b�N�I��

CHEND:
	LD	A,(SEMODE)
	OR	A
	JR	Z,CHEBGM	;BGM���[�h�Ȃ�BGM�I�[������

	LD	(IX+10),255	;SE�̏I�[�Ȃ�g���b�N�L���t���O��255��

	PUSH	BC
	PUSH	IX
SEMON:
	LD	IX,CH2WRK
	LD	IY,SE1WRK
	LD	HL,SEBAKT

	LD	DE,WSIZE
	LD	B,CHNUM-1
SEMON1:
	LD	A,(IY+10)	;SE�g���b�N�L���t���O
	CP	255
	JR	NZ,SEMON3	;255�łȂ���΃X�L�b�v
	XOR	A
	LD	(IY+10),A	;255�Ȃ�0�ɂ���

	LD	A,(HL)
	CP	1
	JR	NZ,SEMON2
	INC	A
SEMON2:
	LD	(IX+10),A	;BGM���̃g���b�N�L���t���O��ޔ����Ă������l�ɖ߂�
	OR	A
	;JR	NZ,SEMON3

	LD	A,11		;����BGM����
	SUB	B		;���g�p�g���b�N�Ȃ�
	LD	E,A		;���ʃ��W�X�^��
	XOR	A		;0�ɂ���
	CALL	WPSGM

SEMON3:
	ADD	IX,DE
	ADD	IY,DE
	INC	HL

	DJNZ	SEMON1

	POP	IX
	POP	BC

	RET

CHEBGM:
	LD	E,16
	LD	C,B
CHEND0:
	SRL	E
	DJNZ	CHEND0
	LD	B,C
	LD	A,(ENDTRW)	;���[�U�[�Q�Ɨp�̏I�[���B�t���O��
	OR	E		;���Ă�
	LD	(ENDTRW),A	;�ۑ�

	LD	A,(ENDTR)
	OR	E
	CP	1111B
	JR	NZ,CHEND1	;���ׂẴ`�����l�����I����Ă��邩�ǂ���

	EX	DE,HL
	LD	HL,MCOUNT	;�Ȃ��I����Ă����烋�[�v�񐔂𑀍�

	LD	IY,(BGMADR)
	LD	A,(IY+11)	;BGM�f�[�^���疳�����[�v�t���O�𓾂�
	AND	1
	JR	Z,CHEL1
	LD	(HL),255	;�������[�v���Ȃ��ȂȂ烋�[�v��=255
	JR	CHEL2
CHEL1:
	INC	(HL)		;�������[�v����ȂȂ烋�[�v��+1
CHEL2:
	EX	DE,HL
	LD	A,(ENDTRR)	;���[�v����Ƃ��̓t���O���ȊJ�n�̏�ԂɃ��Z�b�g
CHEND1:
	LD	(ENDTR),A	;�I���g���b�N���X�V

	LD	E,(HL)		;���[�v�A�h���X����
	INC	HL
	LD	D,(HL)		;���[�v�A�h���X���

	LD	A,E
	OR	D
	JR	Z,CHEND2	;���[�v�A�h���X��0�Ȃ�񃋁[�v�̏I�[������

	LD	HL,(BGMADR)
	ADD	HL,DE		;���[�v�A�h���X��0�łȂ���Ή��t�A�h���X�̃I�t�Z�b�g�Ƃ��Ĉ���
	LD	(IX+0),L	;���t�A�h���X���X�V
	LD	(IX+1),H

	LD	A,B
	CP	4
	JP	Z,READR		;���Y���g���b�N���ǂ����Ŗ߂���I��
	JP	READ1

CHEND2:
	LD	HL,RESTDATA	;�x���𑖂点�邽�߂̃f�[�^

	LD	A,B
	CP	4
	JP	Z,RREST		;���Y���g���b�N���ǂ����Ŗ߂���I��
	XOR	A
	JP	NOTE

;���C�����[�`���I��

MEND:
	LD	(IX+0),L	;���t�A�h���X���X�V
	LD	(IX+1),H
	RET

;------	�I�[�p�f�[�^

RESTDATA:
	DB	254,255	;254=����254�t���[��, 255=�g���b�N�I��
	DW	0	;0=���[�v�A�h���X�Ȃ�(�񃋁[�v�p�I�[�����ɃW�����v)
