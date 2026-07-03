[Home](../README.md)  
# basestation（旧コーチボックス）

## 概要
**basestationは、RoboCupサッカーロボットの試合を管制するコーチボックス実装です。**

RoboCup MSL（Middle Size League）の試合管制システムとして機能し、RefereeBoxからのゲームコマンドを受信・解析し、5台のプレイヤーロボットへの指令配信、プレイヤーロボットの状態監視、および試合状況の可視化を統合管理します。

### 主な機能
- **RefereeBox通信**: TCP/IPによるゲームコマンド受信
- **ロボット制御**: UDP通信による複数ロボットへの並行制御
- **状態監視**: ロボット位置・姿勢・ボール保持状態のリアルタイム監視
- **3D可視化**: RViz2による試合状況のリアルタイム表示
- **統合管理**: 単一ベースステーションですべての通信・制御を一元化

## システムアーキテクチャ

```
RefereeBox (TCP)
    ↓ (Commands)
    ↓
RefereeBoxClient ─────┐
                      │
                      → ROS2 Topic (/refcmd)
                      │
PlayerController  ←───┘
    ↓ (UDP Commands)
    ↓
[Player1][Player2][Player3][Player4][Player5]
    ↓ (UDP States)
    ↓
PlayerServer
    ↓ (ROS2 Topic /player_states)
    ↓
RViz (3D Visualization)
```

## パッケージ一覧

basestationは以下の4つの専門化パッケージで構成されています：

| パッケージ | 説明 | 役割 | 通信 |
|-----------|------|------|------|
| 📡 [musashi_rqt_refereebox_client](./musashi_rqt_refereebox_client/README.md) | RefereeBox通信管理 | RefereeBoxからのコマンド受信・解析 | TCP/IPv4 |
| 📤 [musashi_rqt_player_controller](./musashi_rqt_player_controller/README.md) | プレイヤーコマンド送信 | ロボットへのコマンド変換・送信 | UDP/IPv4 |
| 📥 [musashi_rqt_player_server](./musashi_rqt_player_server/README.md) | プレイヤーデータ受信 | ロボット状態データの受信・監視 | UDP/IPv4 |
| 🎨 [musashi_rviz](./musashi_rviz/README.md) | 3D可視化 | フィールド・ロボット表示・監視 | ROS2 TF |

## 動作構成

basestationは以下の**2つの独立した画面**で構成されており、両方を起動することで試合の管制と可視化の完全な機能が実現されます。

**⚠️ 重要：両画面を同時に起動する必要があります。どちらか一方だけでは、RefereeBox → basestation → Player への通信パイプラインが構築されず、試合が開始できません。**

| Display | パッケージ | 役割 | 説明 |
|---------|-----------|------|------|
| **RViz** | musashi_rviz | 可視化 | 3Dフィールドビュー。フィールドとプレイヤーの状態をリアルタイムに可視化 |
| **rqt GUI** | rqt plugins | 管制 | コントローラー画面。RefereeBox通信、プレイヤー監視、コマンド送信を管理 |

## 実行方法

### ステップ1: RViz画面起動（フィールド可視化）
```bash
ros2 launch musashi_rviz bringup_launch.py
```
フィールドと5台のプレイヤーロボットが表示されるRViz画面が起動します。  
詳細は [musashi_rviz/README.md](./musashi_rviz/README.md) を参照してください。

### ステップ2: rqt GUI画面起動（コマンド・監視）
```bash
rqt
```
空のrqt GUI画面が起動します。

**プラグインのロード手順:**
1. **Plugins** メニューをクリック
2. **Hibikino-Musashi** カテゴリを展開
3. 以下の3つのプラグインを順番にロード：
   - **RefereeBoxClient** - RefereeBox通信管理
   - **PlayerServer** - プレイヤー状態監視
   - **PlayerController** - プレイヤーコマンド送信

**重要な初期化手順:**
1. RefereeBoxClient で接続設定を確認
2. PlayerServer でBind IP・Portを設定後、**Start** ボタンをクリック
3. チーム情報、プレイヤーIPアドレスを全て確認
4. その後、RefereeBox から "START" コマンドを送信

## ディレクトリ構成
```
basestation/
├── README.md (このファイル)
├── musashi_rqt_player_controller/
│   ├── README.md
│   ├── scripts/
│   ├── src/
│   └── ...
├── musashi_rqt_player_server/
│   ├── README.md
│   ├── scripts/
│   ├── src/
│   └── ...
├── musashi_rqt_refereebox_client/
│   ├── README.md
│   ├── scripts/
│   ├── src/
│   └── ...
└── musashi_rviz/
    ├── README.md
    ├── launch/
    ├── config/
    └── ...
```

## 最近の重要な更新

### RefereeBoxClient (musashi_rqt_refereebox_client)
- TCP通信の堅牢化：NULL終端文字対応で部分受信や複数メッセージ連結に対応
- JSON形式コマンド解析の実装完了

### PlayerServer (musashi_rqt_player_server)
- GUI上で明示的な **Start / Stop** ボタンが追加
- **Bind IP** と **Port** 入力欄で複数ネットワークインターフェース対応が可能に
- UDP受信バッファの堅牢化

### PlayerController (musashi_rqt_player_controller)
- RefereeBoxコマンドからPlayer形式への変換処理実装
- ロボット個別制御コマンドサポート

### musashi_rviz
- `player_num` 起動引数でプレイヤー数を動的に設定可能（デフォルト5）
- TFフレーム階層の整理・標準化

## 運用時のベストプラクティス

### 起動順序
1. **RViz** を先に起動
2. その後 **rqt** を起動
3. rqtプラグインを順番にロード

### ネットワーク設定確認
- RefereeBox PC のIPアドレス・ポート番号を確認
- basestation のNetwork Interface を確認
- 全プレイヤーロボットのIPアドレス設定確認
- ネットワーク接続性を `ping` で事前確認

### 通信開始手順
1. RefereeBoxClient: 接続状態を確認
2. PlayerServer: **Start** ボタンで受信開始
3. 全プレイヤーのオンライン状態を確認
4. RefereeBox から試合開始コマンド("START")を送信

### トラブルシューティング

**ロボットが通信してこない場合:**
- PlayerServer のインターフェース設定（Bind IP）を確認
- ファイアウォール設定を確認
- プレイヤーロボット側のネットワーク設定を確認

**RefereeBox から通信が来ない場合:**
- RefereeBoxClient の接続設定（IP・ポート）を確認
- RefereeBox サーバーが起動しているか確認
- NULL終端文字（`\0`）がメッセージ末尾に付与されているか確認

## 通信仕様リファレンス

- [RefereeBox通信](./musashi_rqt_refereebox_client/README.md#refereboxとの通信仕様)
- [Player通信（受信）](./musashi_rqt_player_server/README.md#player--basestation間の通信仕様)
- [Player通信（送信）](./musashi_rqt_player_controller/README.md#basestation--player間の通信仕様)


