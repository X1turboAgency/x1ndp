
	ORG	0100H

	JP	START		;0C3H��Z80�ł�JP�����Ai8086�ł�RET�Ȃ̂�

START:				;�ԈႦ��MS-DOS���Ŏ��s���Ă����I���ł���

	; �g�p����CTC�̃A�h���X�����߂�B
	call	check_ctc_adrs

	; �R�}���h�����o�͂���B
	call	print_title_str

	; �Ǎ��t�@�C������\������B
	call	print_read_filename

	; �����Ŏw��̂������t�@�C�����������ɓǍ��ށB
	call	read_arg_file
	cp		0ffh
	jr		z, failed_read_file
;
	call	NDPINI

	ld		de,DATA_ADRS
	call	ADRSET

	; �T�E���h�X�^�[�g
	call	MSTART

	; vtimer�����̏�����
	call	init_vtimer

proc_loop:
	; �T�E���h����
	call	INTRPT

	call	RDSTAT
	or		a
	jr		z, finish_proc
;
	call	check_keyboard
	jr		z, finish_proc
;
	; VINT���̏����^�C�}�[��҂�
	call	wait_vtimer
	jr		proc_loop

; �Ǎ��G���[
failed_read_file:
	call	print_failed_filename

	jr		finish_proc_1

; �I������
finish_proc:
	; �T�E���h�I��
	call	MSTOP

finish_proc_1:
	; 'done'�\��
	call	print_done

	; vtimer�I������
	call	finalize_vtimer

	jp		0000h

;---------------------------------------------------------------;
	END

