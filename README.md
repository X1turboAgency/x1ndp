# x1ndp

PSG音源の表現力をアップするMSX用サウンドエンジン NDPがリリースされました。  
X1/turboはMSXと同じ AY-3-8910を搭載しており、実行できれば楽しそうです。  
そこで、NDPプロジェクトのMSXクライアントを改変し、シャープX1/turbo用の簡易プレイヤーアプリケーションを制作してみました。  

The NDP sound engine for MSX, designed to enhance the expressive capabilities of the PSG chip, has been released.  
Since the Sharp X1 and X1 turbo series also feature the AY-3-8910 sound chip—just like the MSX—it seemed like a fun challenge to try running it on those machines as well.  
So, we created a simple player application to play NDP files on the X1/turbo.  
A modified version of the NDP MSX client, repurposed as a lightweight player application for the Sharp X1/turbo.    

---

## 動作機種 / Supported Platforms

- シャープ X1 / turbo / Zシリーズ
- Sharp X1 / turbo / Z series

- 動作環境：LSX-Dodgers DOS環境
- Requires LSX-Dodgers DOS environment

## 特徴 / Features

- MSX用のNDPクライアントの音源ドライバと基本的な挙動が同じになるようにしています。
- Designed to replicate the sound driver and core behavior of the original MSX NDP client.

- シャープX1用のDOS環境「LSX-Dodgers」上で動作します。
- Runs on the LSX-Dodgers DOS environment for the Sharp X1.

- X1/turboのPSGチップは4MHzで動作しており、オリジナルのMSX 3.57MHzと同様に発生するため波形データを調整しています。
- The PSG chip on the X1/turbo runs at 4 MHz, so waveform data has been adjusted to correct pitch discrepancies from the original MSX’s 3.57 MHz clock.

- 波形データは、hex125(293)さんから提供頂いた音程データを使用しています。
- Pitch correction uses data provided by Mr. hex125.

- 再生テンポはCTC制御でオリジナルのMSXに近い 16.7msec周期にしています。
- Playback timing is controlled via CTC, achieving an interval close to the MSX's 16.7 ms cycle.

- CTC非搭載のX1ではビデオタイミングを変更して60Hz周期で再生するようにしています。
- On X1 systems without a CTC, playback is synchronized to a 60Hz cycle by adjusting the video timing.


---

## Folder Structure / フォルダ構成

プロジェクトは以下のフォルダ構成になっています。  
```  
x1ndp/  
├── app/                      # X1 NDP app file  
│   ├── src/                 # ソースコード（asm） / src file.  
│   ├── x1ndp.com            # アセンブル済みの実行ファイル / exec file. (for LSX-Dodgers)  
│   ├── x1ndp.bin            # アセンブル済みの実行ファイル / exec file. (for CZ-8FB01/02)  
│   ├── make_x1_basic.bat    # .bin作成用の batふぃある / bat file for BASIC make.
│   └── make.bat             # .com作成用の batファイル / bat file for make.  
├── sample/                   # サンプルデータ
│   ├── kira_kira_smp.mml    # サンプルデータMML (キラキラ星)
│   ├── kirakira.ndp         # サンプルデータ NDP
│   └── x1ndp_sample_2d.d88  # CZ-8FB01/CZ-8FB02で使用する呼び出しサンプル用.d88ファイル
├── LICENSE                   # ライセンスフォルダ（MIT） / LICENSE file.  
└── README.md                 # このファイル / this file.  
```

## 実行時のメモリマップ

実行時のメモリマップです。
memory map.

#### LSX-Dodgers時

- 0100h ～ X1 NDPアプリケーション本体
- 4000h ～ NDPデータ

#### BASIC時 (x1ndp.bin)
- c000h ～ X1 NDPライブラリ本体
- e000h ～ NDPデータ(サンプル)、メインメモリ中であれば任意の場所で大丈夫です。

## 使い方 / Usage

#### LSX-Dodgers時

- X1用 LSX-Dodgers環境に実行ファイルと、ndpファイルを転送してください。
- コマンドラインから以下の形式で実行してください。
- Transfer the executable file and your .ndp files to the X1 LSX-Dodgers environment.
- Run the following command from the command line:

```
 x1ndp [NDPファイル名/NDP file]
```

- NDPファイルを読込んで再生を開始します。
- 曲が終わったら終了するようにしていますが、statusが停止状態にならないので原因を調べてみます。
- 途中で何かキーを押すと終了します。
- The player will load the specified NDP file and begin playback.
- The program is designed to exit after the song ends, but due to a current issue, the status flag may not correctly indicate a stop state. We are investigating this behavior.
- Pressing any key during playback will force the program to exit.

#### BASIC時
- 最初に、BASICからの呼び出しクライアント(x1ndp.bin)を0c000hに読込んでください。
- defusrまたは callで呼出しを行います。
- BASICの実行とは別に非同期に再生を行います。
- ディスクアクセスを行うと割込みが実行されず、再生が正常に行われません。

```
20 sysadr=&HC000:CLEAR sysadr
30 mdpini=sysadr+0*3  ' setup NDP driver
40 mstart=sysadr+1*3  ' start driver
50 mstop=sysadr+2*3  ' stop driver
60 ndpoff=sysadr+25*3 ' finalize driver
70 DEF USR0=sysadr+4*3  'set BGM adrs data.
80 DEF USR1=sysadr+5*3  'mute ch1
90 DEF USR2=sysadr+6*3  'mute ch2
100 DEF USR3=sysadr+7*3  'mute ch3
110 DEF USR4=sysadr+8*3  'set master volume.
120 DEF USR5=sysadr+9*3  'set fadeout
130 DEF USR6=sysadr+10*3 'set fadein
140 '
150 LOADM "x1ndp.bin",sysadr
160 snddata=&HE000
170 LOADM "kirakira.ndp",snddata
180 CALL mdpini
190 snd0=snddata+7
200 x=USR0(snd0)
210 CALL mstart
```

- mdpini を呼び出した時にCTCの設定を行います。
- X1turboであれば 1fa0h, FM音源ボードがあれば 0704hを使用します。
- CTCが搭載されていないX1では再生できません。
- 割込みベクタは 088hを使用していて割込みテーブルとしては、08ehを使用します。
- この場所はCZ-8FB02,CZ-8FB01で使っていても動いていますが、未使用ワークではないと思うので今後も対応が必要です。

終了処理は以下を行います。ndpoffを呼び出すとCTCをリセットします。

```
320 ' Finalize NDP
330 CALL mstop
340 CALL ndpoff
```

##### サンプルデータ
- 同梱のsampleディレクトリにMML,NDP,BASICのサンプルを入れておきました。
- データは「試験に出るX1」からの伝統で「キラキラ星」です。


## プロジェクトソース / Project Source
- make.bat を実行するとソースをアセンブルして実行ファイルを作成します。
- アセンブルには、紅茶羊羹さんのz80asを使用しています。
- Run make.bat to assemble the source and create the executable file.
- This project uses z80as, a Z80 assembler created by Youkan Koucha-san (@youkan700).

## サポート / Support
- 公式ホームページ X1turboAgency ( https://x1turbo-agency.hatenablog.jp ) にて行います。
- Support and updates are available on the official website:

## 謝辞 / Acknowledgements
#### @naruto2413 さん
- PSGの可能性を広げる、NDP環境を構築・公開して頂きました。
- 素晴らしいツール環境を、ありがとうございます。
- Thank you for developing and releasing the NDP environment that expands the possibilities of PSG sound expression.
- We greatly appreciate your excellent tools.

#### @hex125(293) さん
- MSX ⇔ X1との周波数の違いから音程データ,ハードウェアエンベロープ周波数のデータを
- 提供、アドバイスをいただきました。ありがとうございました。
- Thank you for providing and advising on frequency and pitch data adjustments needed for the X1 due to differences from the MSX,
- including hardware envelope frequencies.

##### @youkan700 紅茶羊羹さん
- 開発には紅茶羊羹さんの z80as を使わせて頂いています。いつもありがとうございます。
- We use your assembler z80as for development. Thank you as always for your excellent tool.

## ライセンス / License
- ライセンスはNDPが使用しているMITライセンスを使用しています。
- LICENSEフォルダ内のファイルを参照ください。
- This project is released under the MIT License, the same license used by the original NDP project.
- Please refer to the file in the LICENSE folder for details.

