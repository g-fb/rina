import QtQuick
import QtQuick.Controls

ItemDelegate {
    required property int index
    required property url folderUrl
    required property string folderName

    text: folderName
    font.pointSize: 14
    width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
    highlighted: ListView.view.currentIndex === index
}
