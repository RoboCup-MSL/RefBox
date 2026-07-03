import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError

import cv2
import neoapi

class MusashiCamera(Node):
    # コンストラクタ
    def __init__(self):
        # 親クラス（rclpy.nodeのNodeクラス）のコンストラクタ呼び出し
        # 引数：ノード名
        super().__init__('node_musashi_camera')
        
        # パブリッシャーの作成
        # create_publisher関数は親クラスが持っている
        self.image_pub = self.create_publisher(Image, '/raw_image', 3)
        
        # パラメータの定義
        # 引数：パラメータ名，初期値
        self.declare_parameter('interval', 0.1)

        # パラメータの読み込み
        interval = self.get_parameter('interval').get_parameter_value().double_value 

        # neoapiのカメラインスタンスを作成する
        self.camera = neoapi.Cam()

        # カメラへ接続
        try:
            self.camera.Connect()            
        except neoapi.NotConnectedException as e:
            pass


    	# opencvの画像型をROSのメッセージ型に変換するためのcv_bridgeインスタンスを作成
        self.bridge = CvBridge()

        # タイマコールバックの設定
        # Nodeクラスがcreate_timer関数を持っている
        # 引数：周期(ms), コールバック関数
        self.timer = self.create_timer(interval, self.timer_callback)
        
    # コールバック関数定義
    # intervalの値に従って呼び出される  
    def timer_callback(self):
        self.get_logger().info('timer callback')
        
        # カメラから画像取得
        image = self.camera.GetImage()

        if not image.IsEmpty():        
            # OpenCVのMat型の配列の並びに変更する
            mat = image.GetNPArray().reshape(image.GetHeight(), image.GetWidth())
            # カメラから来た画像のデータフォーマット:BayerRG
            # ROSで使いたい画像のデータフォーマット:BGR
            # → cv2.cvtColorでデータフォーマットを変換する
            mat = cv2.cvtColor(mat, cv2.COLOR_BayerRG2BGR)
            
            # パブリッシュの用意
            # sensor_msgs.msgのImage型に変換（cv_bridgeを使う）
            img_msg = self.bridge.cv2_to_imgmsg(mat, 'bgr8')
            # パブリッシュ
            self.image_pub.publish(img_msg)

        
def main(args=None):
    # 初期化
    rclpy.init(args=args)
    
    # ノード実態の作成
    # Musashi_Cameraオブジェクトのインスタンスを作成
    node = MusashiCamera()
    
    # 処理ループ開始    
    rclpy.spin(node)

    # spin関数を抜けたらノード削除
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
