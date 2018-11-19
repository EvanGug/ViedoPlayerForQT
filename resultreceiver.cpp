//#include "resultreceiver.h"

//#include <QAndroidJniEnvironment>
//#include <QtAndroid>
//#include <QDebug>

//void ResultReceiver::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data)
//{
//    if(receiverRequestCode == requestId)
//    {
//        //这段代码看起来很复杂，很难理解，你只需要知道，这段代码是用来处理Android返回的data，在data中提取出文件的路径信息，我也是在网上找的，也不是很理解
//        jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
//        if(resultCode == RESULT_OK)
//        {
//            QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
//            QAndroidJniObject dadosAndroid = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
//            QAndroidJniEnvironment env;
//            jobjectArray projecao = (jobjectArray)env->NewObjectArray(1, env->FindClass("java/lang/String"), NULL);
//            jobject projacaoDadosAndroid = env->NewStringUTF(dadosAndroid.toString().toStdString().c_str());
//            env->SetObjectArrayElement(projecao, 0, projacaoDadosAndroid);
//            QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
//            QAndroidJniObject cursor = contentResolver.callObjectMethod("query", "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;", uri.object<jobject>(), projecao, NULL, NULL, NULL);
//            jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Ljava/lang/String;)I", dadosAndroid.object<jstring>());
//            cursor.callMethod<jboolean>("moveToFirst", "()Z");
//            QAndroidJniObject resultado = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
//            QString data = "file://" + resultado.toString();
//            qDebug() << data;
//            emit sendData(data);
//        }
//        else
//        {
//            //some code here
//        }
//    }
//}
