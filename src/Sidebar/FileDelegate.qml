import QtQuick
import QtQuick.Controls

ItemDelegate {
    required property int index
    required property url fileUrl
    required property string fileName

    text: fileName
    font.pointSize: 12
    width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
    highlighted: ListView.view.currentIndex === index
}
