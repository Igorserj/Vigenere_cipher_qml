#include "backend.h"
#include "qdebug.h"
#include <QFile>
#include <QTextStream>

BackEnd::BackEnd(QObject *parent) :
    QObject(parent)
{
}

QString BackEnd::text()
{
    return m_text;
}

void BackEnd::setText(const QString &text)
{
    if (text == m_text)
        return;

    m_text = text;
    emit textChanged();
}
void BackEnd::writing(QString url, QString info) {

    MyThread *thread = new MyThread;
    thread->start();
    QFile file(url);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
        qInfo() << "error writing";
    }
    QTextStream out(&file);
    out.setCodec("UTF-8");
    out.setGenerateByteOrderMark(true);
    out << info;
    file.flush();
    file.close();
    thread->wait();
}
