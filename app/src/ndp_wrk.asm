;[NDP] - PSG Music Driver for MSX - Programmed by naruto2413

;=====================================
;�R�[���G���g���^���[�N�G���A�^�e�[�u��
;�iNDP.ASM �� NDP_DRV.ASM ���ʓr�K�v�j
;=====================================

	JP	NDPINI
	JP	MSTART
	JP	MSTOP
	JP	INTRPT

	JP	U_ADR
	JP	U_OFF1
	JP	U_OFF2
	JP	U_OFF3
	JP	U_MV
	JP	U_MFO
	JP	U_MFI
	JP	U_SE

	JP	CH1OFF
	JP	CH2OFF
	JP	CH3OFF
	JP	MVSET
	JP	MFOSET
	JP	RDSTAT
	JP	RDENDT
	JP	RDLOOP
	JP	ADRSET
	JP	MPLAYF
	JP	SEPLAY
	JP	VSET

	JP	SYSVER
	JP	NDPOFF
	JP	SETHF

	JP	IMAIN

;------	���[�N�G���A

CH1WRK:	;���Y���g���b�N
	DW	0	;0-1	���t�f�[�^�ǂݍ��݃A�h���X
	DB	0	;2	�m�[�g�ԍ�
	DB	0	;3
	DB	0	;4	�����J�E���^
	DB	0	;5	����1�o�C�g���������ǂ���
	DB	0	;6	255�Ȃ烊�Y��
	DB	0	;7	���K�[�g
	DB	0	;8
	DB	0	;9
	DB	0	;10	�`�����l���L��/����
	DB	0	;11
	DB	0	;12	���K�[�g�x���t���O
	NOP		;13
	NOP		;14
	NOP		;15
	DW	0	;16 17	�\�t�g�G���x���[�v�|�C���^
	NOP		;18
	NOP		;19
	NOP		;20
	NOP		;21
	NOP		;22
	NOP		;23
	NOP		;24
	NOP		;25
	NOP		;26
	NOP		;27
	NOP		;28
	NOP		;29
	NOP		;30
	NOP		;31
	DB	0	;32	���s�[�g�l�X�g��
RVOLW:	DS	26,0	;33-58	���Y��26��ނ̉���
	NOP		;59
	NOP		;60

CH2WRK:	;�ʏ�g���b�N
	DW	0	;+0 1	���t�f�[�^�ǂݍ��݃A�h���X
	DB	0	;+2	�m�[�g�ԍ�
	DB	0	;+3	�ݒ艹�� (0=v15, 1=V14, 2=V13 �c 15=v0)
	DB	0	;+4	�����J�E���^
	DB	0	;+5	����1�o�C�g���������ǂ���
	DB	0	;+6	���F�ԍ� (90�`9FH�̏ꍇ�̓n�[�h�G���x�ԍ�)
	DB	0	;+7	���K�[�g
	DB	0	;+8	�T�X�e�B��
	DB	0	;+9	Q(�N�I���^�C�Y)�̒l
	DB	0	;+10	�`�����l���L��/���� 0=���� 1=�L�� 2=���ʉ������� 3�`255=�ꎞ�~���[�g(�t���[����)
	DB	0	;+11	�s�b�`�G���x�ԍ� (bit7=�s�b�`��߂��H bit6=�s�b�`�X�V����H bit5=����������̑��Βl�H)
	DB	0	;+12	���K�[�g�m�F�p�t���O�i+7�̃��K�[�g�ݒ�̒l��1�����Ƃɓ���j
	DW	0	;+13 14	�������̉����i���W�X�^�l�j
	DB	0	;+15	�������̉���
	DW	0	;+16 17	�\�t�g�G���x���[�v�|�C���^ / �n�[�h�G���x���ʔ����J�E���^
	DB	0	;+18	�\�t�g�G���x���[�v�E�F�C�g�J�E���^
	DW	0	;+19 20	�f�`���[��
	DW	0	;+21 22	�s�b�`�G���x���[�v�|�C���^
	DB	0	;+23	�s�b�`�G���x���[�v�f�B���C�J�E���^
	DB	0	;+24	�����[�X����
	DB	0	;+25	�����[�X�J�E���^�ݒ�l
	DB	0	;+26	�����[�X�J�E���^
	DW	0	;+27 28	�����[�X�f�B���C�p�s�b�`
	DB	0	;+29	�����[�X�f�B���C�p�X�C�b�`���w��t���[����
	DB	0	;+30	�����[�X���ʐݒ�
	DB	0	;+31	�L�[�I�����̉������W�X�^�X�V�t���O
	DB	0	;+32	���s�[�g�l�X�g��
	DB	0	;+33	�|���^�����g���Z�l(����)
	DB	0	;+34	�|���^�����g���Z�l
	DW	0	;+35 36	�|���^�����g�p�̌��݉��� (13-14�Ɍ������ĉ����Z)
	DB	0	;+37	�|���^�����g�ݒ�l(����)
	DB	0	;+38	�|���^�����g�ݒ�l���X�C�b�` (0=OFF)
	DB	0	;+39	�|���^�����g�P���t���O
	DB	0	;+40	@Q(�������N�I���^�C�Y)�̒l
	DB	0	;+41	�L�[�I�����O�̃m�[�g�ԍ��i�����[�X�f�B���C�p�j
	DB	0	;+42	���ʃC���^�[�o���ݒ�l
	DB	0	;+43	�m�[�g�G���x�ԍ�
	DW	0	;+44 45	�m�[�g�G���x���[�v�|�C���^
	DB	0	;+46	�m�[�g�G���x���[�v�E�F�C�g�J�E���^
	DB	0	;+47	���ʃC���^�[�o���̃J�E���^
	DB	0	;+48	���ʃC���^�[�o���̉��ʒl
	DW	0	;+49 50	�O��̃f�`���[���l
	DB	0	;+51	�����[�X�f�B���C�p�J�E���^
	DB	0	;+52	�Q�[�g�^�C�� (Q����v�Z���ăL�[�I�����ɐݒ�)
	DB	0	;+53	�����[�X�f�B���C�X�L�b�v�p�J�E���^
	DW	0	;+54 55	�s�b�`�G���x�K�p�O�̉����i���W�X�^�l�j
	DB	0	;+56	���ʃC���^�[�o�����B�l
	DB	0	;+57	�Œ�Q�[�g�^�C��
	DB	0	;+58	�p�����[�^�̑ޔ�̈�
	DB	0	;+59	�����[�X�f�B���C�����t���O
	DB	0	;+60	*n�i�~�b�N�X���[�h�j�̒l
CH3WRK: DS	WSIZE,0
CH4WRK: DS	WSIZE,0

SE1WRK:	DS	WSIZE*3,0

CH1RWK:
	DW	0	;0-1	���s�[�g1�J�n�A�h���X
	DW	0	;2-3	���s�[�g1�I���A�h���X
	DB	0	;4	���s�[�g1��
	DW	0	;5-6	���s�[�g2�J�n�A�h���X
	DW	0	;7-8	���s�[�g2�I���A�h���X
	DB	0	;9	���s�[�g2��
	DW	0	;10-11	���s�[�g3�J�n�A�h���X
	DW	0	;12-13	���s�[�g3�I���A�h���X
	DB	0	;14	���s�[�g3��
	DW	0	;15-16	���s�[�g4�J�n�A�h���X
	DW	0	;17-18	���s�[�g4�I���A�h���X
	DB	0	;19	���s�[�g4��
CH2RWK:	DS	RWSIZE,0
CH3RWK:	DS	RWSIZE,0
CH4RWK:	DS	RWSIZE,0

;->*************** MSTART ����������0�N���A���镨

FFFLG:	DB	0	;������t���O
ENDTR:	DB	0	;���t�f�[�^���I�[�܂ŒB�����g���b�N�̃r�b�g������ (0000321RB) ��1���[�v�Ń��Z�b�g
ENDTRW:	DB	0	;�V ��1���[�v������Z�b�g���Ȃ�
ENDTRR:	DB	0	;�V ���Z�b�g���ɏ����߂��l (�ȊJ�n���ɖ��g�p�g���b�N�̃t���O�𗧂ĂĂ������l)
MCOUNT:	DB	0	;���[�v��
MVOL:	DB	0	;�}�X�^�[���� (���̒l�����Z)
MFADE:	DB	0	;�t�F�[�h�ݒ� (0=�t�F�[�h���Ȃ� 1�`255=�t�F�[�h�J�E���g)
FCOUNT:	DB	0	;�t�F�[�h�J�E���^
LCOUNT:	DB	0	;�t�F�[�h���[�v�J�E���^
SLWPRM:	DB	0	;�X���[�ݒ�
SLWCNT:	DB	0	;�X���[�Đ��p�J�E���^
NFREQW:	DB	0	;�m�C�Y���g��
VISPAN:	DB	0	;���ʃC���^�[�o������

RNON:	DB	0	;���Y�����������ǂ��� (0=�������Ȃ� 1=�����I�����ăs�b�`��߂� 2=������ 3=1�t�������ʏ�g�[��)
RSVOL:	DB	0	;���Y����炷�O�̉��ʑޔ�
RPITCH:	DW	0	;���Y����炷�O�̉����ޔ�

HENVSW:	DB	0	;�n�[�h�G���x�ԍ�

CLREND:

;<-***************

RVWRK:	DB	0	;���Y�����ʔ��f�p
RITRK:	DB	1	;���荞�܂�g���b�N (1=CH.C 2=CH.B 3=CH.A)
RVREG:	DB	10	;���Y���g���b�N�̉��ʃ��W�X�^�ԍ�
RPREG:	DB	5	;���Y���g���b�N�̎��g�����W�X�^�ԍ�(���)
RHENV:	DB	0	;���Y������S�R�}���h�����s����Ă��Ȃ����0�ɂȂ�

OLDTH:	DS	5,0C9H	;���^�C�}���荞�݃t�b�N
HKFLG:	DB	0	;�t�b�N�Ƀh���C�o��ڑ��ς݂��ǂ���

STATS:	DB	0	;���t��� (0:��~ 1:�Đ�)

FINOUT:	DB	0	;0=�t�F�[�h�A�E�g 1=�t�F�[�h�C��

MIXNMH:	DB	1	;�n�[�h�G���x�g�p����*n�i�~�b�N�X���[�h�j�̒l

MIXWRK:	DB	10111000B	;10NNNTTT 0=ON/1=OFF
MIXWRS:	DB	10111000B	;���ʉ��p�~�b�N�X���[�N

HENVPW:	DW	1024	;�n�[�h�G���x����

SEMODE:	DB	0	;���t���[�h (0:BGM 1:SE) �����荞�ݓ��Őݒ�
SEBAKT:	DS	CHNUM,0	;���ʉ��Ɋ��荞�܂�鑤�̃g���b�N�L���t���O�������ɑޔ�
SEBAKR:	DB	0	;���Y���̃L�[�I�t����SE�I�����̃��W�X�^���Z�b�g�𑖂点�邩�ǂ���
SECNT:	DB	0	;���ʉ��̃g���b�N�J�E���^�i���Ă���Œ��̌��ʉ��̃g���b�N���j

VADTBL:	DS	32,0	;���ʃG���x�A�h���X�e�[�u��
RADTBL:	DS	64,0	;���Y�����F�A�h���X�e�[�u��
PADTBL:	DS	32,0	;�s�b�`�G���x�A�h���X�e�[�u��
NADTBL:	DS	32,0	;�m�[�g�G���x�A�h���X�e�[�u��

BGMADR:	DW	04000H	;�ȃf�[�^�擪�A�h���X

;------	�����e�[�u��

IF 0

PTABLE:
;		c     c+    d     d+    e     f     f+    g     g+    a     a+    b
	DW	0D5DH,0C9CH,0BE7H,0B3CH,0A9BH,0A02H,0973H,08EBH,086BH,07F2H,0780H,0714H	;O1
	DW	06AFH,064EH,05F4H,059EH,054EH,0501H,04BAH,0476H,0436H,03F9H,03C0H,038AH	;O2
	DW	0357H,0327H,02FAH,02CFH,02A7H,0281H,025DH,023BH,021BH,01FDH,01E0H,01C5H	;O3
O4C:	DW	01ACH,0194H,017DH,0168H,0153H,0140H,012EH,011DH,010DH,00FEH,00F0H,00E3H	;O4
	DW	00D6H,00CAH,00BEH,00B4H,00AAH,00A0H,0097H,008FH,0087H,007FH,0078H,0071H	;O5
	DW	006BH,0065H,005FH,005AH,0055H,0050H,004CH,0047H,0043H,0040H,003CH,0039H	;O6
	DW	0035H,0032H,0030H,002DH,002AH,0028H,0026H,0024H,0022H,0020H,001EH,001CH	;O7
	DW	001BH,0019H,0018H,0016H,0015H,0014H,0013H,0012H,0011H,0010H,000FH,000EH	;O8

ENDIF
