# x1ndp

A modified version of the NDP MSX client, repurposed as a lightweight player application for the Sharp X1/turbo.  
NDPプロジェクトのMSXクライアントを改変し、シャープX1/turbo用の簡易プレイヤーアプリケーションを制作しています。  

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
  
x1ndp/  
├── app/              # X1 NDP app file  
│   ├── src/         # ソースコード（asm） / src file.  
│   ├── x1ndp.com    # アセンブル済みの実行ファイル / exec file. (for LSX-Dodgers)  
│   └── make.bat     # .com作成用の batファイル / bat file for make.  
├── LICENSE           # ライセンスフォルダ（MIT） / LICENSE file.  
└── README.md         # このファイル / this file.  

- 

