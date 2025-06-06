
	ORG	0c000H

;---------------------------------------------------------------;
;	BASICから使用する。
;
;	処理の先頭にコール処理がある。
;
;	c000h  初期化 (フック接続)
;	
	JP	NDPINI_X1	; フック接続 / 割込み接続
	JP	MSTART		; 演奏開始
	JP	MSTOP		; 演奏停止
	JP	INTRPT		; タイマ割込み処理

	JP	U_ADR_X1	; BGMデータのアドレスをセット(MSX用)
	JP	U_OFF1_X1	; チャンネルミュートCh1 (MSX用)
	JP	U_OFF2_X1	; チャンネルミュートCh2 (MSX用)
	JP	U_OFF3_X1	; チャンネルミュートCh3 (MSX用)
	JP	U_MV_X1		; マスター音量セット(MSX用)
	JP	U_MFO_X1	; フェードアウトセット (MSX用)
	JP	U_MFI_X1	; フェードインセット(フレーム数指定)(MSX用)
	JP	U_SE_X1		; 効果音発声(MSX用)

	JP	CH1OFF		; チャンネルミュートCh1 (直接用)
	JP	CH2OFF		; チャンネルミュートCh2 (直接用)
	JP	CH3OFF		; チャンネルミュートCh3 (直接用)
	JP	MVSET		; マスター音量セット (直接用)
	JP	MFOSET		; フェードアウトセット (直接用)
	JP	RDSTAT		; 演奏状態取得 (戻り値をどうやる？)
	JP	RDENDT		; 終了トラック取得
	JP	RDLOOP		; 現在のループ回数
	JP	ADRSET		; BGMデータのアドレスをセット
	JP	MPLAYF		; フェードインセット(フレーム数指定)
	JP	SEPLAY		; 効果音発声
	JP	VSET		; 音色データをセット

	JP	SYSVER		; システムバージョンを取得
	JP	NDPOFF_X1	; フック切り離し / 割込み解除
	JP	SETHF		; 多重実行フラグセット

	JP	IMAIN		; 直接音処理呼び出し


;---------------------------------------------------------------;
;---------------------------------------------------------------;
	END

