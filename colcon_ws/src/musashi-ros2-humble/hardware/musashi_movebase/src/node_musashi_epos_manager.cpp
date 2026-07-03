#include <boost/foreach.hpp>
#include <chrono>
#include <functional>
#include <memory>

#include "../include/musashi_move_base/Definitions.h"
#include "musashi_msgs/msg/motor_state.hpp"
#include "musashi_msgs/msg/motor_states.hpp"
#include "rclcpp/rclcpp.hpp"

using namespace std::chrono_literals;

/*
  MaxonEposManagerクラス
  EPOSの接続および，タイマコールバック処理でモータの現在の状態をパブリッシュする
  ノードのクラスになるのでNodeクラスを継承
*/
class MaxonEposManager : public rclcpp::Node {
  // メンバ変数定義
 private:
  rclcpp::TimerBase::SharedPtr _timer;  // タイマインスタンス

  // メンバ関数定義
 public:
  // コンストラクタ
  MaxonEposManager(const rclcpp::NodeOptions &options)
      : Node("node_musashi_epos_manager", options) {
    // パラメータ宣言
    std::vector<std::string> motor_names =
        get_parameter("motor_names").as_string_array();

    // EPOS初期化，設定
    BOOST_FOREACH (std::string motor_name, motor_names) {
      std::string sDevice = get_parameter(motor_name + ".device").as_string();
      std::string sProtocol =
          get_parameter(motor_name + ".protocol_stack").as_string();
      std::string sInterface =
          get_parameter(motor_name + ".interface").as_string();
      std::string sPort = get_parameter(motor_name + ".port").as_string();
      int sNodeId = get_parameter(motor_name + ".node_id").as_int();
      int baudrate = get_parameter(motor_name + ".baudrate").as_int();
      int timeout = get_parameter(motor_name + ".timeout").as_int();

      RCLCPP_INFO(get_logger(), "Loading device : %s", motor_name.c_str());
      RCLCPP_INFO(get_logger(), "  Device   :%s", sDevice.c_str());
      RCLCPP_INFO(get_logger(), "  Protocol :%s", sProtocol.c_str());
      RCLCPP_INFO(get_logger(), "  Interface:%s", sInterface.c_str());
      RCLCPP_INFO(get_logger(), "  Port     :%s", sPort.c_str());
      RCLCPP_INFO(get_logger(), "  NodeID   :%d", sNodeId);
      RCLCPP_INFO(get_logger(), "  Baudrate :%d", baudrate);
      RCLCPP_INFO(get_logger(), "  Timeout  :%d", timeout);

      unsigned int error_code = 0;
      void *handle = 0;
      handle = VCS_OpenDevice(const_cast<char *>(sDevice.c_str()),
                              const_cast<char *>(sProtocol.c_str()),
                              const_cast<char *>(sInterface.c_str()),
                              const_cast<char *>(sPort.c_str()), &error_code);

      if (error_code != 0) {
        RCLCPP_ERROR(get_logger(), "0X%8X", error_code);        
        return;
      }
    }

    // タイマ実態の作成．create_wall_timerはNodeクラス（親クラス）が持っている
    _timer = create_wall_timer(
        500ms, std::bind(&MaxonEposManager::timer_callback, this));
  }

 private:
  // タイマコールバック関数
  void timer_callback() {
    // RCLCPP_INFO(get_logger(), "callback");
  }
};

/*
  main関数
*/
int main(int argc, char *argv[]) {
  // 初期化
  rclcpp::init(argc, argv);

  rclcpp::NodeOptions node_options;
  node_options.allow_undeclared_parameters(true);
  node_options.automatically_declare_parameters_from_overrides(true);

  // spin関数にNodeオブジェクトを渡してノードを実行
  rclcpp::spin(std::make_shared<MaxonEposManager>(node_options));
  // spin関数が終了したらシャットダウン処理
  rclcpp::shutdown();
  return 0;
}