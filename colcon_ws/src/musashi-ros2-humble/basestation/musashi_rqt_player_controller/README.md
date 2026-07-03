[← Back to basestation](../README.md)

# musashi_rqt_player_controller

## 概要
**各プレイヤーロボットへのコマンド送信を管理するrqtプラグインパッケージです。**

basestationの重要なアクチュエータハブとして機能し、RefereeBoxから受け取ったゲームコマンドと内部の戦術判断をプレイヤー固有のフォーマットに変換し、UDP通信で5台のプレイヤーロボットに送信します。RefereeBoxコマンド、キックオフ位置指示、ロボット個別指令などを統合管理し、試合を一元的に制御します。

### 主な機能
- **コマンド変換**: RefereeBoxコマンドをプレイヤーフォーマットに変換
- **UDP送信**: 複数ロボットへの並行送信
- **コマンド送信**:
  - 全ロボット向けコマンド
  - ロボット個別指令（位置移動、キック指示など）
  - 戦術コマンド
- **リアルタイム制御**: GUIからの直接指令も対応
- **通信ログ**: 送信コマンドの履歴管理

## ノード

### rqt_player_controller
各プレイヤーへのコマンド送信を担当するrqtプラグインノードです。

#### 実行方法

**方法1: rqt GUI内でプラグインとして実行（推奨）**
```bash
rqt
```
rqt GUIが起動したら、Plugins → Hibikino-Musashi → PlayerController を選択してロードします。

**方法2: スタンドアローン実行**
```bash
ros2 run musashi_rqt_player_controller player_controller
```

#### サブスクライブ
| topic | message type | description |
|-------|--------------|-------------|
| `/refcmd` | `musashi_msgs.RefereeCmd` | RefereeBoxから受信したコマンド |

## basestation → Player間の通信仕様

### コマンド送信フロー

```
RefereeBox Command
    ↓
RefereeBoxClient (受信・解析)
    ↓
PlayerController (変換・制御)
    ↓
Player Robot (UDP送信)
```

### basestation → Player（送信）

RefereeBoxから送られてきたコマンドに基づいて、各プレイヤーへコマンドを送信します。この時、Hibikino-Musashi内で取り決められたコマンドフォーマットに変換して送る必要があります。

#### コマンドフォーマット

**詳細仕様**: [musashi_player/communication](../../musashi_player/communication) を参照

#### 対応コマンド一覧

| RefereeBoxコマンド | Player向けコマンド | 説明 |
|-----------------|-----------------|------|
| `START` / `STOP` | `START` / `STOP` | 試合開始・停止 |
| `DROP_BALL` | `DROP_BALL` | ボールドロップ |
| `KICKOFF` | `KICKOFF_POSITION` | キックオフ位置移動 |
| `FREEKICK` | `FREEKICK_POSITION` | フリーキック位置移動 |
| `GOALKICK` | `GOALKICK_POSITION` | ゴールキック位置移動 |
| `THROWIN` | `THROWIN_POSITION` | スロー・イン位置移動 |
| `CORNER` | `CORNER_POSITION` | コーナーキック位置移動 |
| `PENALTY` | `PENALTY_POSITION` | ペナルティキック位置移動 |
| `PARK` | `PARK_POSITION` | 駐車位置移動 |
| その他 | カスタムコマンド | ロボット固有の指令 |

## UI機能

rqtプラグインとしてロードすると、以下のGUI機能が利用可能です：

### コマンド送信
- **全ロボット向けコマンド**: 複数ロボットへの統一コマンド送信
- **ロボット個別指令**: 特定ロボット（#1～#5）への個別指令
- **位置移動指示**: キックオフ位置、ゴールキック位置など戦術位置の指定
- **ボール操作**: キック指示、ボール保持状態の指令

### 表示・ログ
- **コマンド送信ログ**: 送信したコマンドの履歴表示
- **ロボット状態表示**: 各ロボットの現在状態（オンライン/オフライン）
- **通信統計**: 送受信パケット数、遅延情報

## ディレクトリ構成

```
musashi_rqt_player_controller/
├── README.md
├── package.xml
├── plugin.xml
├── resource/
│   └── musashi_rqt_player_controller
├── scripts/
│   └── player_controller
├── setup.cfg
├── setup.py
├── src/
│   └── musashi_rqt_player_controller/
│       ├── __init__.py
│       └── rqt_player_controller.py
└── test/
    ├── test_copyright.py
    ├── test_flake8.py
    └── test_pep257.py
```

## 依存関係

- `rclpy`: ROS2 Pythonクライアント
- `python_qt_binding`: Qtバインディング
- `rqt_gui`: rqt GUIフレームワーク
- `musashi_msgs`: カスタムメッセージ定義
