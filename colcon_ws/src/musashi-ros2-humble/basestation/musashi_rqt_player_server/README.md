[← Back to basestation](../README.md)

# musashi_rqt_player_server

## 概要
**各プレイヤーロボットからのデータ受信を管理するrqtプラグインパッケージです。**

basestationの重要なセンサーハブとして機能し、5台のプレイヤーロボットからUDP通信で受信した状態データを処理・集約します。各ロボットの位置、向き、ボール認識、障害物検知などの情報を一元管理し、ROS2トピック`/player_states`で配信します。

### 主な機能
- **UDP通信**: 複数ロボットからの並行通信受け取り
- **データ解析**: カンマ区切り形式のロボット状態データをパース
- **リアルタイム集約**: 全ロボットの状態を`PlayerStates`メッセージに集約
- **マルチインターフェース対応**: 複数ネットワークインターフェース環境に対応
- **GUI制御**: Start/Stopボタンによる明示的な通信制御

## ノード

### rqt_player_server
各プレイヤーからのデータ受信を担当するrqtプラグインノードです。

#### 実行方法

**方法1: rqt GUI内でプラグインとして実行（推奨）**
```bash
rqt
```
rqt GUIが起動したら、Plugins → Hibikino-Musashi → PlayerServer を選択してロードします。

**方法2: スタンドアローン実行**
```bash
ros2 run musashi_rqt_player_server player_server
```

#### パブリッシュ
| topic | message type | description |
|-------|--------------|-------------|
| `/player_states` | `musashi_msgs.PlayerStates` | 全プレイヤーの状態 |

## Player → basestation間の通信仕様

### データフォーマット

各プレイヤーロボットからはUDPで**カンマ（`,`）区切りのテキスト形式**で状態データが送信されます。

#### フォーマット詳細
```
color,id,action,state,ball_distance,ball_angle,goal_distance,goal_angle,mygoal_distance,mygoal_angle,pos_x,pos_y,pos_angle,role,haveBall,target_x,target_y,target_angle,obs_distance,obs_angle
```

#### データ仕様表

| # | フィールド | 説明 | 単位/値 |
|---|-----------|------|--------|
| 1 | `color` | チームカラー | CYAN: 0, MAGENTA: 1 |
| 2 | `id` | ロボットID | 1～5 |
| 3 | `action` | ロボットのアクション | Action定数値 |
| 4 | `state` | ロボットの状態 | State定数値 |
| 5 | `ball_distance` | ボールとの直線距離 | [m] |
| 6 | `ball_angle` | ボールの角度 | [rad] |
| 7 | `goal_distance` | ゴールとの直線距離 | [m] |
| 8 | `goal_angle` | ゴールの角度 | [rad] |
| 9 | `mygoal_distance` | 自身のゴールとの直線距離 | [m] |
| 10 | `mygoal_angle` | 自身のゴールの角度 | [rad] |
| 11 | `pos_x` | 自己位置X座標 | [m] |
| 12 | `pos_y` | 自己位置Y座標 | [m] |
| 13 | `pos_angle` | ロボット姿勢 | [rad] |
| 14 | `role` | ロボットのロール | Role定数値 |
| 15 | `haveBall` | ボール保持の有無 | 0: 未保持, 1: 保持 |
| 16 | `target_x` | 目標X座標 | [m] |
| 17 | `target_y` | 目標Y座標 | [m] |
| 18 | `target_angle` | 目標姿勢 | [rad] |
| 19 | `obs_distance` | 障害物までの直線距離 | [m] |
| 20 | `obs_angle` | 障害物の角度 | [rad] |

#### 受信処理
- **パース方法**: カンマ（`,`）で分割して処理
- **データ型変換**: 受信後に文字列を整数値/浮動小数点値に変換
- **可変長対応**: フィールドの文字数は固定ではないため、分割後の長さを確認してから変換

### 今後の改善予定
現在のテキスト形式からバイナリデータへの移行を計画しており、通信速度の大幅な向上が期待できます。

## UI機能

rqtプラグインとしてロードすると、以下のGUI機能が利用可能です：

### サーバ制御
- **Start/Stopボタン**: UDP通信サーバの明示的な開始・停止
- **自動起動なし**: 起動時には通信を開始せず、GUIからの指示で開始

### ネットワーク設定
- **Bind IP（Own IP）入力欄**: バインドするIPアドレスを指定
- **Port入力欄**: バインドするポート番号を指定
- **マルチインターフェース対応**: 複数ネットワークインターフェース環境に対応

### 状態表示
- **受信状態表示**: 各プレイヤーからのデータ受信状態
- **接続ログ**: 接続・切断イベントの履歴

## 主な機能

### Start / Stop ボタン
GUI上で明示的な **Start / Stop** ボタンが用意されています。
起動時に自動でサーバを立ち上げず、GUI から明示的に開始・停止できます。

### バインド設定
複数インターフェース環境では、以下をGUIから設定してください：
- **Bind IP (Own IP)**: バインドするIPアドレス
- **Port**: バインドするポート番号

## Player → basestation間の通信について

basestationとPlayerはUDPで通信を行っています。

### Player → CoachBox（受信）
各プレイヤーからは各プレイヤーの状態データが格納された文字列データが送られてきます。
（※バイナリデータになっていないことに注意）

#### 通信フォーマット
カンマ（","）区切りで以下の順に整数文字が入った文字列で送られてきます：

| index | value | detail |
|-------|-------|--------|
| 1 | color | チームカラー。CYAN: 0、MAGENTA: 1 |
| 2 | id | ロボットのID |
| 3 | action | ロボットのアクション（Action名前空間の定数値） |
| 4 | state | ロボットのステート（State名前空間の定数値） |
| 5 | ball.distance | ボールとの直線距離 |
| 6 | ball.angle | ボールの角度 |
| 7 | goal.distance | ゴールとの直線距離 |
| 8 | goal.angle | ゴールの角度 |
| 9 | myGoal.distance | 自身のゴールとの直線距離 |
| 10 | myGoal.angle | 自身のゴールの角度 |
| 11 | position.x | 自己位置x座標 |
| 12 | position.y | 自己位置y座標 |
| 13 | position.angle | 姿勢θ |
| 14 | role | ロボットのロール（Role名前空間の定数値） |
| 15 | haveBall | ボール保持の有無 |
| 16 | moveto_position.x | ロボットの目標x座標 |
| 17 | moveto_position.y | ロボットの目標y座標 |
| 18 | moveto_position.angle | ロボットの目標姿勢θ |
| 19 | obstacle.distance | 障害物までの直線距離 |
| 20 | obstacle.angle | 障害物の角度 |

#### 処理上の注意
coachBox側では、受信後に","でsplitして文字列から整数値への変換が必要になります。
一つの変数が何文字なのかは","でsplitするまでわかりません。

#### 将来の改善
**いずれバイナリデータで送受信する方法に修正し通信速度の高速化を図る必要があります。**

## ディレクトリ構成

```
musashi_rqt_player_server/
├── README.md
├── package.xml
├── plugin.xml
├── resource/
│   └── musashi_rqt_player_server
├── scripts/
│   └── player_server
├── setup.cfg
├── setup.py
├── src/
│   └── musashi_rqt_player_server/
│       ├── __init__.py
│       ├── player_server.py
│       └── rqt_player_server.py
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

## 最近の更新
- **PlayerServer**: GUI上で明示的な **Start / Stop** ボタンを追加
- **PlayerServer**: **Bind IP** と **Port** 入力欄で複数インターフェース対応が可能に
