#include "player.h"

#include <QDebug>
#include <QTime>
#include <QFileDialog>
#include <QAndroidJniObject>
#include <QtAndroid>
#include <QAndroidJniEnvironment>

Player::Player(QWidget *parent)
    : QWidget(parent)
    , m_receiver(new ResultReceiver(1))
{
    //将sendData这个信号和handleData这个槽函数关联起来，具体可以百度QT的信号和槽函数的使用
    connect(m_receiver, &ResultReceiver::sendData, this, &Player::handleData);
}

Player::~Player()
{
    //用来销毁m_receiver指针的，因为这个指针是创建在堆上的，需要开发者手动销毁，不然会造成内存泄漏
    if (m_receiver)
    {
        delete m_receiver;
    }
}

//调用Android的API来打开文件，获取文件的位置，这边涉及到QT对Java的调用，看起来比较不容易理解，可以查一下QAndroidJniObject的使用
void Player::openFile()
{
    QAndroidJniObject ACTION_PICK = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_PICK", "Ljava/lang/String;");
    QAndroidJniObject EXTERNAL_CONTENT_URI = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$Images$Media", "EXTERNAL_CONTENT_URI", "Landroid/net/Uri;");
//    QAndroidJniObject action = QAndroidJniObject::fromString("android.intent.action.GET_CONTENT");
    QAndroidJniObject intent("android/content/Intent", "(Ljava/lang/String;Landroid/net/Uri;)V", ACTION_PICK.object<jstring>(), EXTERNAL_CONTENT_URI.object<jobject>());

    QAndroidJniObject video = QAndroidJniObject::fromString("video/* audio/*");
    intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", video.object<jstring>());

    QtAndroid::startActivity(intent.object<jobject>(), 1, m_receiver);

    QAndroidJniEnvironment env;
    if(env->ExceptionCheck())
    {
        qDebug() << "exception occured";
        env->ExceptionDescribe();
        env->ExceptionClear();
    }

    //这段注释掉的代码，是Windows上面打开文件，获取文件路径的，比调用Android的方便太多
//    QString filename = QFileDialog::getOpenFileName(this, tr("Video"), ".", tr("Images(*.wmv *.mp4)"));
//    if(filename != QString())
//    {
//        m_fileNameUrl = QUrl("file:///" + filename);
////        qDebug() << m_filName;
//    }
}

//这个函数是用来处理Android文件管理器返回的路径信息的，这边的处理就是把这个路径信息赋值给m_fileNameUrl;
void Player::handleData(QString data)
{
    qDebug() << data;
    m_fileNameUrl = QUrl(data);
}

//这个函数是作为一个接口给外部调用m_fileNameUrl的
QUrl Player::fileNameUrl() const
{
    qDebug() << m_fileNameUrl;
    return m_fileNameUrl;
}



