import rclpy
from rclpy.node import Node
from person_msgs.srv import Query #使う型を変更

rclpy.init()
node = Node("talker")


def cb(request, response):
    if request.name == "上田隆一":
        response.age = 46
    else:
        response.age = 255

    return response

def main():
    srv = node.create_service(Query, "query", cb) #サービスの作成
    rclpy.spin(node)