
	ORG	0c000H

;---------------------------------------------------------------;
;	BASIC����g�p����B
;
;	�����̐擪�ɃR�[������������B
;
;	c000h  ������ (�t�b�N�ڑ�)
;	
	JP	NDPINI_X1	; �t�b�N�ڑ� / �����ݐڑ�
	JP	MSTART		; ���t�J�n
	JP	MSTOP		; ���t��~
	JP	INTRPT		; �^�C�}�����ݏ���

	JP	U_ADR_X1	; BGM�f�[�^�̃A�h���X���Z�b�g(MSX�p)
	JP	U_OFF1_X1	; �`�����l���~���[�gCh1 (MSX�p)
	JP	U_OFF2_X1	; �`�����l���~���[�gCh2 (MSX�p)
	JP	U_OFF3_X1	; �`�����l���~���[�gCh3 (MSX�p)
	JP	U_MV_X1		; �}�X�^�[���ʃZ�b�g(MSX�p)
	JP	U_MFO_X1	; �t�F�[�h�A�E�g�Z�b�g (MSX�p)
	JP	U_MFI_X1	; �t�F�[�h�C���Z�b�g(�t���[�����w��)(MSX�p)
	JP	U_SE_X1		; ���ʉ�����(MSX�p)

	JP	CH1OFF		; �`�����l���~���[�gCh1 (���ڗp)
	JP	CH2OFF		; �`�����l���~���[�gCh2 (���ڗp)
	JP	CH3OFF		; �`�����l���~���[�gCh3 (���ڗp)
	JP	MVSET		; �}�X�^�[���ʃZ�b�g (���ڗp)
	JP	MFOSET		; �t�F�[�h�A�E�g�Z�b�g (���ڗp)
	JP	RDSTAT		; ���t��Ԏ擾 (�߂�l���ǂ����H)
	JP	RDENDT		; �I���g���b�N�擾
	JP	RDLOOP		; ���݂̃��[�v��
	JP	ADRSET		; BGM�f�[�^�̃A�h���X���Z�b�g
	JP	MPLAYF		; �t�F�[�h�C���Z�b�g(�t���[�����w��)
	JP	SEPLAY		; ���ʉ�����
	JP	VSET		; ���F�f�[�^���Z�b�g

	JP	SYSVER		; �V�X�e���o�[�W�������擾
	JP	NDPOFF_X1	; �t�b�N�؂藣�� / �����݉���
	JP	SETHF		; ���d���s�t���O�Z�b�g

	JP	IMAIN		; ���ډ������Ăяo��


;---------------------------------------------------------------;
;---------------------------------------------------------------;
	END

