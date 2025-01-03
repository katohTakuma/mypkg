#!/bin/bash
set -e

# ""ここでros2の環境をセットアップします""
source /root/ros2_ws/install/setup.bash

# ""テスト1: temperatureノードが起動するかどうかを確認します""
ros2 run mypkg temperature &
TEMP_PID=$!

# ""3びょうまってから、ノードがちゃんと起動しているかをチェックします""
sleep 3
if ! ps -p $TEMP_PID > /dev/null; then
  echo "Test 1 failed: Temperature node did not start properly."
  exit 1
fi
echo "Test 1 passed: Temperature node started successfully."

# ""テスト2: 温度データがトピックにパブリッシュされているかどうかを確認します""
OUTPUT=$(ros2 topic echo /temperature --once 2>/dev/null | grep -E "data")
if [[ -z "$OUTPUT" ]]; then
  echo "Test 2 failed: No data published to /temperature topic."
  kill $TEMP_PID
  exit 1
fi
echo "Test 2 passed: Data is being published to /temperature topic."

# ""テスト3: パブリッシュされるデータが正しい形式かどうかを確認します""
if ! echo "$OUTPUT" | grep -E "^[0-9]+(\.[0-9]+)?$"; then
  echo "Test 3 failed: Published data is not a valid number."
  kill $TEMP_PID
  exit 1
fi
echo "Test 3 passed: Published data is in the correct format."

# ""テスト4: ノードを停止して、きちんと終了するか確認します""
kill $TEMP_PID
sleep 1
if ps -p $TEMP_PID > /dev/null; then
  echo "Test 4 failed: Temperature node did not stop properly."
  exit 1
fi
echo "Test 4 passed: Temperature node stopped successfully."

# ""テスト5: トピックが存在するかどうか確認します""
if ! ros2 topic list | grep -q "/temperature"; then
  echo "Test 5 failed: /temperature topic does not exist."
  exit 1
fi
echo "Test 5 passed: /temperature topic exists."

# ""テスト6: ノードを複数回起動しても問題がないか確認します""
for i in {1..3}; do
  ros2 run mypkg temperature &
  TEMP_PID=$!
  sleep 2
  kill $TEMP_PID
  sleep 1
  if ps -p $TEMP_PID > /dev/null; then
    echo "Test 6 failed: Node did not stop properly on iteration $i."
    exit 1
  fi
done
echo "Test 6 passed: Node runs and stops correctly multiple times."

# ""ぜんぶのテストがパスしました""
echo "All tests passed successfully!"
exit 0

