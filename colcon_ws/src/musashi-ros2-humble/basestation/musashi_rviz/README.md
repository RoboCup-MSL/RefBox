[← Back to basestation](../README.md)

# musashi_rviz

## 概要
**RViz2上でフィールドとプレイヤーロボットを可視化するパッケージです。**

試合中のフィールド状態およびプレイヤーロボットの位置・姿勢をリアルタイムに3D表示します。複数のlaunchファイルにより、フィールド設定やプレイヤー数を柔軟に変更できます。

### 主な機能
- **フィールド可視化**: MSL標準フィールドを3D表示
- **ロボット可視化**: 最大5台のプレイヤーロボットの位置・姿勢表示
- **リアルタイム更新**: TFフレームとして配信される情報を即座に表示
- **プレイヤー数変更**: 柔軟なプレイヤー数設定
- **複数フィールド設定**: 本番環境・デモ環境の設定切り替え対応

## 実行方法

### 基本的な起動
```bash
ros2 launch musashi_rviz bringup_launch.py
```

設定済みのRViz2が起動し、フィールドとプレイヤー（デフォルト5台）が表示されます。

### プレイヤー数を指定する場合
```bash
ros2 launch musashi_rviz team_spawn_launch.py player_num:=3
```

### フィールドパラメータ指定
```bash
ros2 launch musashi_rviz bringup_launch.py config_type:=demo
```

- `demo`: デモ用設定（`field_parameters_demo.yaml`）
- `standard`: 本番環境設定（`field_parameters.yaml`）

## Launch ファイル

### bringup_launch.py

**トップレベルのlaunchファイル** - 通常こちらから起動します

**起動するコンポーネント:**
- フィールド情報パブリッシャーノード
- RViz2（`rviz/config.rviz`設定で起動）
- `team_spawn_launch.py`（プレイヤー生成用）

**パラメータ:**
- `player_num`: プレイヤー数（デフォルト: 5）
- `config_type`: フィールド設定タイプ（デフォルト: standard）

### team_spawn_launch.py

**マルチプレイヤーlaunchファイル**

`player_num`パラメータで指定された数のプレイヤーについて、`player_spawn_launch.py`を繰り返し実行します。

**パラメータ:**
- `player_num`: プレイヤー数（デフォルト: 5）

### player_spawn_launch.py

**個別プレイヤーlaunchファイル**

個別プレイヤーのTF（Transform Frame）を設定してパブリッシュします。

**パラメータ:**
- `player_id`: プレイヤーID（1～5）

## ノード

### node_field_publisher.py

フィールド外形およびゴールエリアなどのフィールド構成情報をTF（Transform）として配信します。

**パブリッシュ:**
- TFフレーム: フィールド境界、ゴールエリア情報

### node_sample01_tf_publisher.py

プレイヤーロボットの位置・姿勢情報をTFフレームとして配信します。

**注意:** このノードはサンプル実装です。実装系のノードに置き換えることが想定されています。

**パブリッシュ:**
- TFフレーム: `player{id}/base_link` (位置・姿勢)

## フレーム構成

### プレイヤーフレーム

各プレイヤーのフレーム階層：
```
map
└── field (フィールド基準フレーム)
    ├── player1
    │   └── base_link (ロボット本体)
    ├── player2
    │   └── base_link
    ├── ...
    └── player5
        └── base_link
```

**フレームプレフィックス:**
```
player1/ player2/ player3/ player4/ player5/
```

### フィールドフレーム

```
map
└── field
    ├── goal (敵ゴール)
    ├── my_goal (自ゴール)
    ├── field_boundary (フィールド境界)
    └── center_circle (センターサークル)
```

## 設定ファイル

### RViz設定
```
rviz/config.rviz
```
- ロボット・フィールド・座標軸表示設定
- ビューポイント・カメラ設定
- パネルレイアウト設定

### フィールドパラメータ

```
config/field_parameters.yaml       # 本番環境用
config/field_parameters_demo.yaml  # デモ用
```

各設定ファイルには以下を記述：
- フィールド寸法（長さ×幅）
- ゴール寸法・位置
- ゴールエリア寸法
- センターサークル半径
- その他フィールド構成要素

## ディレクトリ構成

```
musashi_rviz/
├── README.md
├── package.xml
├── setup.cfg
├── setup.py
├── config/
│   ├── field_parameters.yaml
│   └── field_parameters_demo.yaml
├── launch/
│   ├── bringup_launch.py
│   ├── player_spawn_launch.py
│   └── team_spawn_launch.py
├── musashi_rviz/
│   ├── __init__.py
│   ├── node_field_publisher.py
│   ├── node_sample01_tf_publisher.py
│   └── __pycache__/
├── resource/
│   └── musashi_rviz
├── rviz/
│   └── config.rviz
└── test/
    ├── test_copyright.py
    ├── test_flake8.py
    └── test_pep257.py
```

## 依存関係

- `rclpy`: ROS2 Pythonクライアント
- `rviz2`: 3D可視化フレームワーク
- `tf2`: TFフレーム変換ライブラリ
- `geometry_msgs`: 幾何学メッセージ
- `tf2_ros`: TFメッセージブリッジ
