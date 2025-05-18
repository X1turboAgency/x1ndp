;[NDP] - PSG Music Driver for MSX - Programmed by naruto2413

HTIMI	EQU	0FD9FH	;タイマ割り込みフック
WSIZE	EQU	61	;各トラックのワークエリアのサイズ
RWSIZE	EQU	5*4	;各トラックのリピート用ワークエリアのサイズ (1ネストあたりのサイズ*ネスト数)F
CHNUM	EQU	4	;使用チャンネル数
DRVADR	EQU	0C000H	;ドライバの開始アドレス

IF 0

; BSAVE HEADER (うにスキーさんによる改修)
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

