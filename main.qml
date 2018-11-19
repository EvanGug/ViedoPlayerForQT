import QtQuick 2.0
import QtQuick.Window 2.0
import QtMultimedia 5.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
ApplicationWindow {
    id: mainWindow
    visible: true
    width: 360
    height: 640
    title: qsTr("Video Player")
    property bool isPlay: false

    //定义了播放界面的矩形空间
    Rectangle{
        id: screenRec
        color: "black"
        width: mainWindow.width
        height: mainWindow.height -50
        anchors.top: mainWindow.top
        anchors.left: mainWindow.left

        //使用MediaPlayer进行音频输出
        MediaPlayer{
            id: player
            autoPlay: true
            autoLoad: false
            //音量由下面定义的Slider进行控制
            volume: voice.value
        }
        //使用VideoOutput进行视频输出
        VideoOutput {
            id: video
            anchors.fill: parent
            //source用的MediaPlayer提供的资源
            source: player
        }
    }

    //定义了进度条和音量条的矩形空间
    Rectangle{
        id:control
        color:"#80202020"
        border.color: "gray"
        border.width: 1
        width: mainWindow.width
        height: 20
        anchors.top: screenRec.bottom
        anchors.left: mainWindow.left
        Row{
            width: parent.width
            height: parent.height
            //定义行空间每个控件之间的间隔
            spacing: parent.width * 0.025
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: parent.width * 0.025
            anchors.left: parent.left
            //调节播放速度
            Slider{
                id:playPos
                width: mainWindow.width*0.65
                height: 10
                maximumValue: player.duration
                minimumValue: 0
                value:player.position
                anchors.verticalCenter: parent.verticalCenter
                stepSize:1000
                style: SliderStyle {
                    groove: Rectangle {
                        width: mainWindow.width*0.65
                        height: 8
                        color: "gray"
                        radius: 2
                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: player.duration>0 ? parent.width*player.position/player.duration : 0
                            color: "green"
                        }
                    }
                    handle: Rectangle {
                        anchors.centerIn: parent
                        color: control.pressed ? "white" : "darkgray"
                        border.color: "gray"
                        border.width: 2
                        implicitWidth: 15
                        implicitHeight: 15
                        radius:7.5
                        Rectangle{
                            width: parent.width-8
                            height: width
                            radius: width/2
                            color: "blue"
                            anchors.centerIn: parent
                        }
                    }
                }
                //点击鼠标设置播放位置
                MouseArea {
                    property int pos
                    anchors.fill: parent
                    onClicked: {
                        if (player.seekable)
                            pos = player.duration * mouse.x/parent.width
                        player.seek(pos)
                        playPos.value=pos;
                    }
                }
            }
            Row{
                width: parent.width * 0.275
                height: parent.height
                spacing: 0
                Image{
                    width: 15
                    height: 15
                    source: "./Images/volume.png"
                    anchors.verticalCenter: parent.verticalCenter
                }
                //调节音量
                Slider{
                    id:voice
                    width: parent.width - 15
                    height: 10
                    value:player.volume
                    stepSize: 0.1
                    maximumValue: 1
                    minimumValue: 0
                    anchors.verticalCenter: parent.verticalCenter
                    style: SliderStyle {
                        groove: Rectangle {
                            implicitWidth: mainWindow.width*0.2
                            implicitHeight: 8
                            color: "gray"
                            radius: 2
                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: player.volume>0?parent.width*player.volume:0
                                color: "green"
                            }
                        }
                        handle: Rectangle {
                            anchors.centerIn: parent
                            color: control.pressed ? "white" : "darkgray"
                            border.color: "gray"
                            border.width: 2
                            implicitWidth: 15
                            implicitHeight: 15
                            radius:7.5
                            Rectangle{
                                width: parent.width-8
                                height: width
                                radius: width/2
                                color: "blue"
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
        }
    }

    //控制按钮矩形空间
    Rectangle{
        id: bottom
        color:"#80202020"
        border.color: "gray"
        width: mainWindow.width
        height: 30
        anchors.left: mainWindow.left
        anchors.top: control.bottom
        Row{
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            spacing: 20

            Button{
                id: openFileButton
                iconSource: "qrc:/Images/open.png"
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                //设置按钮的样式
                style: ButtonStyle{
                    background: Rectangle{
                        implicitWidth: openFileButton.width
                        implicitHeight: openFileButton.height
                        //设置圆角半径为二分之一宽度，即设置按钮为圆形按钮
                        radius: width/2
                    }
                }
                //当按钮被点击的时候，执行的操作
                onClicked: {
                    //执行openFile函数
                    mymediaplayer.openFile()
                }

            }

            Button{
                id: palyButton
                iconSource: "qrc:/Images/play.png"
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                style: ButtonStyle{
                    background: Rectangle{
                        implicitWidth: palyButton.width
                        implicitHeight: palyButton.height
                        radius: width/2
                    }
                }
                onClicked: {
                    //把视频文件的路径赋值给player的资源
                    player.source = mymediaplayer.fileNameUrl
                    if(isPlay == true)
                    {
                        player.pause();
                        console.log("pause")
                        isPlay = false
                        palyButton.iconSource = "qrc:/Images/play.png"
                    }
                    else
                    {
                        player.play() ;
                        console.log("play")
                        isPlay = true
                        palyButton.iconSource = "qrc:/Images/pause.png"
                    }
                }
            }
            Button{
                id: stopButton
                iconSource: "qrc:/Images/stop.png"
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                style: ButtonStyle{
                    background: Rectangle{
                        implicitWidth: stopButton.width
                        implicitHeight: stopButton.height
                        radius: width/2
                    }
                }
                onClicked: {
                    player.stop()
                    isPlay = false
                    palyButton.iconSource = "qrc:/Images/play.png"
                }
            }

            //快进快退10s
            Button{
                id: fastReButton
                iconSource: "qrc:/Images/previoust.png"
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                onClicked: player.seek(player.position-10000)
                style: ButtonStyle{
                    background: Rectangle{
                        implicitWidth: fastReButton.width
                        implicitHeight: fastReButton.height
                        radius: width/2
                    }
                }
            }

            Button{
                id: fastFoButton
                iconSource: "qrc:/Images/next.png"
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                onClicked: player.seek(player.position+10000)
                style: ButtonStyle{
                    background: Rectangle{
                        implicitWidth: fastFoButton.width
                        implicitHeight: fastFoButton.height
                        radius: width/2
                    }
                }
            }

            //显示时间信息
            Text{
                anchors.verticalCenter: parent.verticalCenter
                text:parent.currentTime(player.position)+"/"+parent.currentTime(player.duration)
                color: "white"
            }
            //时间格式化
            function currentTime(time)
            {
                var sec= Math.floor(time/1000);
                var hours=Math.floor(sec/3600);
                var minutes=Math.floor((sec-hours*3600)/60);
                var seconds=sec-hours*3600-minutes*60;
                var hh,mm,ss;
                if(hours.toString().length<2)
                    hh="0"+hours.toString();
                else
                    hh=hours.toString();
                if(minutes.toString().length<2)
                    mm="0"+minutes.toString();
                else
                    mm=minutes.toString();
                if(seconds.toString().length<2)
                    ss="0"+seconds.toString();
                else
                    ss=seconds.toString();
                return hh+":"+mm+":"+ss
            }
        }
    }
}
