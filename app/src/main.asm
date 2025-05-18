
	ORG	0100H

	JP	START		;0C3HはZ80ではJPだが、i8086ではRETなので

START:				;間違えてMS-DOS環境で実行しても即終了できる

	; 使用するCTCのアドレスを求める。
	call	check_ctc_adrs

	; コマンド名を出力する。
	call	print_title_str

	; 読込ファイル名を表示する。
	call	print_read_filename

	; 引数で指定のあったファイルをメモリに読込む。
	call	read_arg_file
	cp		0ffh
	jr		z, failed_read_file
;
	call	NDPINI

	ld		de,DATA_ADRS
	call	ADRSET

	; サウンドスタート
	call	MSTART

	; vtimer処理の初期化
	call	init_vtimer

proc_loop:
	; サウンド処理
	call	INTRPT

	call	RDSTAT
	or		a
	jr		z, finish_proc
;
	call	check_keyboard
	jr		z, finish_proc
;
	; VINT分の処理タイマーを待つ
	call	wait_vtimer
	jr		proc_loop

; 読込エラー
failed_read_file:
	call	print_failed_filename

	jr		finish_proc_1

; 終了処理
finish_proc:
	; サウンド終了
	call	MSTOP

finish_proc_1:
	; 'done'表示
	call	print_done

	; vtimer終了処理
	call	finalize_vtimer

	jp		0000h

;---------------------------------------------------------------;
	END

