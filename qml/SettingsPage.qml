import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import bldc 1.0

BasicPage {

    id:rootSettings
    height: mainWindow.height - statusBar.height
    width:mainWindow.width
    showBackButton: true
    showSettingsButton: false
    pageTitle: "Settings"

    property int headingTopMargin:4
    property int headingLeftMargin:6
    property int rowVerticalMargin:6
    property int rowLeftMargin:16
    property int rowContentSpacing: 10
    property int rectGap: 20
    property int tabMargin: textTitle.font.pixelSize * 2

    Binding{
        target:rootSettings
        property: "pageComponent"
        value:mainComponent
        when:true
    }
    property Component mainComponent: Rectangle {
        color: "#DCDCDC"

        Flickable{
            id:flickableMain
            height: parent.height
            width: parent.width
            contentWidth: width
            contentHeight:rectContent.height
            Rectangle{
                id:rectContent
                anchors.left: parent.left
                anchors.leftMargin: rowLeftMargin
                anchors.right: parent.right
                anchors.rightMargin: rowLeftMargin
                width: parent.width - rowLeftMargin * 2
                height:rectConnection.height + rectControl.height +rectBEMF.height + rectPlotControl.height + (rectGap * 4)
                color:"#DCDCDC"

                Rectangle{
                    color: "#DCDCDC"
                    id:rectConnection
                    width: parent.width
                    height: textTitle.height + headingTopMargin +rectGridConnection.height + rowVerticalMargin

                    Text{
                        id:textTitle
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.02
                        anchors.top: parent.top
                        anchors.topMargin: headingTopMargin
                        text:"Connection"
                        font.bold: true
                        font.pointSize: 14
                    }

                    Rectangle {
                        id:rectGridConnection
                        width:parent.width - (2 * rowLeftMargin)
                        height: tabview.height + tabMargin
                        anchors.left:parent.left
                        anchors.leftMargin: rowLeftMargin
                        anchors.right: parent.right
                        anchors.rightMargin: rowLeftMargin
                        anchors.top: textTitle.bottom
                        anchors.topMargin: rowVerticalMargin
                        color: parent.color

                        TabView{
                            id: tabview
                            frameVisible: false
                            width: parent.width
                            height: (os == OS.Android) ? 500 : 150
                            Component {
                                id: serialTab
                                //title:"SerialPort"
                                Grid{
                                    id:gridConnection
                                    width: parent.width
                                    anchors.top: parent.top
                                    anchors.topMargin: tabMargin
                                    columns: 2
                                    columnSpacing: rowLeftMargin
                                    rowSpacing: rowVerticalMargin*0.6
                                    //Component.onCompleted: parent.height = childrenRect.height + tabMargin

                                    Layout.fillHeight: true

                                    Text{
                                        id:textPort
                                        text:"Port"
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: 14
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                    }

                                    ComboBox{
                                        id: comboBoxSerialPorts
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        model: serialPortNames
                                    }

                                    Button{
                                        id:buttonConnect
                                        text:"Connect"
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        onClicked: {
                                            currentSerialPort = comboBoxSerialPorts.currentIndex
                                            connectCurrentSerial()
                                        }
                                        style: ButtonStyle {
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                font.pointSize: 12
                                                //color: "blue"
                                                text: control.text
                                            }
                                        }
                                    }
                                    Button{
                                        text:"Refresh"
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        onClicked: {
                                            refreshSerialDevices()
                                            comboBoxSerialPorts.currentIndex = currentSerialPort;
                                        }
                                        style: ButtonStyle {
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                font.pointSize: 12
                                                text: control.text
                                            }
                                        }
                                    }

                                    Button{
                                        id:buttonDisconnect
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        text:"Disconnect"
                                        onClicked: {
                                            disconnectSerial();
                                        }
                                        style: ButtonStyle {
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                font.pointSize: 12
                                                //color: "blue"
                                                text: control.text
                                            }
                                        }
                                    }
                                    Text{
                                        id:textCanId
                                        text: "CAN ID"
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: 14
                                        maximumLineCount: 2
                                        wrapMode: Text.WordWrap
                                        width: rectGridCurrent.width * 0.73
                                    }
                                    TextField{
                                        id:textFieldCanId
                                        width: rectGridCurrent.width*0.25
                                        text: "1"

                                    }
                                    CheckBox{
                                        id:cbSendCan
                                        text: "CAN Fwd"
                                        onCheckedChanged: {
                                           canFwd = checked
                                           canId = textFieldCanId.text
                                        }
                                        style: CheckBoxStyle{
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                // font.bold: true
                                                font.pointSize: 14
                                                text: control.text
                                            }
                                        }
                                    }
                                }
                            }

                            Component.onCompleted: {
                                if (os != OS.IOS && os != OS.Android) {
                                    tabview.addTab("SerialPort", serialTab);
                                }
                            }
                            Tab{
                                id: bluetoothTab
                                title: "Bluetooth"
                                Grid{
                                    width: parent.width
                                    anchors.top: parent.top
                                    anchors.topMargin: tabMargin
                                    columns: 2
                                    columnSpacing: rowLeftMargin
                                    rowSpacing: rowVerticalMargin*0.6
                                    Component.onCompleted: parent.height = childrenRect.height + tabMargin

                                    Text{
                                        text:"Device"
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: 14
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                    }

                                    ComboBox{
                                        id: comboBoxBtDevices
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        model: bleInterface.devicesNames
                                    }

                                    Button{
                                        text:"Connect"
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        onClicked: {
                                            bleInterface.currentDevice = comboBoxBtDevices.currentIndex
                                            connectCurrentBleDevice();
                                        }
                                        style: ButtonStyle {
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                font.pointSize: 12
                                                //color: "blue"
                                                text: control.text
                                            }
                                        }
                                    }
                                    Button{
                                        text:"Scan"
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        onClicked: {
                                            bleInterface.scanDevices();
                                        }
                                        style: ButtonStyle {
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                font.pointSize: 12
                                                //color: "blue"
                                                text: control.text
                                            }
                                        }
                                    }

                                    Button{
                                        width: parent.width *0.5 - rowVerticalMargin*0.6
                                        text:"Disconnect"
                                        onClicked: {
                                            disconnectBle();
                                        }
                                        style: ButtonStyle {
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                font.pointSize: 12
                                                //color: "blue"
                                                text: control.text
                                            }
                                        }
                                    }

                                    Text{
                                        id:textCanId
                                        text: "CAN ID"
                                        verticalAlignment: Text.AlignVCenter
                                        font.pointSize: 14
                                        maximumLineCount: 2
                                        wrapMode: Text.WordWrap
                                        width: rectGridCurrent.width * 0.73
                                    }
                                    TextField{
                                        id:textFieldCanId
                                        width: rectGridCurrent.width*0.25
                                        text: "1"

                                    }
                                    CheckBox{
                                        id:cbSendCan
                                        text: "CAN Fwd"
                                        onCheckedChanged: {
                                           canFwd = checked
                                           canId = textFieldCanId.text
                                        }
                                        style: CheckBoxStyle{
                                            label: Text {
                                                renderType: Text.NativeRendering
                                                verticalAlignment: Text.AlignVCenter
                                                horizontalAlignment: Text.AlignHCenter
                                                font.family: "Helvetica"
                                                // font.bold: true
                                                font.pointSize: 14
                                                text: control.text
                                            }
                                        }
                                    }
                                }
                            }

                            style: TabViewStyle {
                                tabOverlap: 16
                                frameOverlap: 4
                                tabsMovable: true

                                frame: Rectangle {
                                    gradient: Gradient {
                                        GradientStop { color: "#e5e5e5"; position: 0 }
                                        GradientStop { color: "#e0e0e0"; position: 1 }
                                    }
                                    border.color: "#898989"
                                    Rectangle { anchors.fill: parent; anchors.margins: 1; border.color: "white"; color: "transparent" }
                                }

                                tab: Item {
                                    property int totalOverlap: tabOverlap * (control.count - 1)
                                    implicitWidth: Math.max(text.width + 30, mainWindow.width / 2 - image.border.left)
                                    implicitHeight: text.font.pixelSize * 2.0
                                    BorderImage {
                                        id: image
                                        anchors.fill: parent
                                        source: styleData.selected ? "images/tab_selected.png" : "images/tab.png"
                                        border.left: 30; border.right: 30
                                        smooth: true
                                    }
                                    Text {
                                        id: text
                                        text: styleData.title
                                        anchors.centerIn: parent
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle{
                    color: "#DCDCDC"
                    id:rectControl
                    anchors.top:rectConnection.bottom
                    anchors.topMargin:rectGap
                    width: parent.width
                    height: textTitleControl.height + rectGridControl.height + 3 *rowVerticalMargin +kbControlChkRow.height +rectGridCurrent.height

                    Text{
                        id:textTitleControl
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.02
                        text:"Control"
                        font.bold: true
                        font.pointSize: 14
                    }

                    Rectangle{
                        id:rectGridControl
                        width:parent.width - (2 * rowLeftMargin)
                        anchors.left:parent.left
                        anchors.leftMargin: rowLeftMargin
                        anchors.right: parent.right
                        anchors.rightMargin: rowLeftMargin
                        anchors.top:textTitleControl.bottom
                        anchors.topMargin: rowVerticalMargin
                        height: childrenRect.height
                        color: parent.color

                        Grid{
                            id:gridControl
                            width: parent.width
                            columns: 2
                            columnSpacing: rowLeftMargin
                            rowSpacing: rowVerticalMargin*0.6

                            TextField {
                                id:textDutyCycle
                                text:"0.20"
                                //width: 70
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                            }
                            Button{
                                id:buttonDutyCycle
                                text:"Duty Cycle"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                onClicked: {
                                    packetInterface.setDutyCycle(textDutyCycle.text)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text

                                    }
                                }
                            }

                            TextField {
                                id:textRPM
                                text:"15000"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }
                            Button{
                                id:buttonRPM
                                text:"RPM"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                onClicked: {
                                    packetInterface.setRpm(textRPM.text)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text
                                    }
                                }
                            }

                            TextField {
                                id:textCurrent
                                text:"3,00"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }
                            Button{
                                id:buttonCurrent
                                text:"Current"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                onClicked: {
                                    packetInterface.setCurrent(textCurrent.text)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text
                                    }
                                }
                            }


                            TextField {
                                id:textBrakeCurrent
                                text:"3,00"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }
                            Button{
                                id:buttonBrakeCurrent
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                text:"Brake Current"
                                onClicked: {
                                    packetInterface.setCurrentBrake(textBrakeCurrent)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text
                                    }
                                }
                            }
                        }
                    }
                    Row {
                        id: kbControlChkRow
                        anchors.top:rectGridControl.bottom
                        anchors.topMargin:rowVerticalMargin
                        anchors.left: parent.left
                        anchors.leftMargin: rowLeftMargin
                        spacing: 8

                        CheckBox {
                            id: kbControlChkBox
                            text: qsTr("Keyboard Control")
                            checked: true
                            onClicked: overrideKb = checked
                            Component.onCompleted:  overrideKb = checked
                            //                    anchors.topMargin: 8
                            //                    anchors.top: rectControl.bottom
                            //                    anchors.leftMargin: parent.width * 0.02
                            style: CheckBoxStyle{
                                label: Text {
                                    renderType: Text.NativeRendering
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Helvetica"
                                    font.pointSize: 12
                                    text: control.text
                                }
                            }
                        }
                    }

                    Rectangle{
                        id:rectGridCurrent
                        width:parent.width - (2 * rowLeftMargin)
                        anchors.left:parent.left
                        anchors.leftMargin: rowLeftMargin
                        anchors.right: parent.right
                        anchors.rightMargin: rowLeftMargin
                        anchors.top:kbControlChkRow.bottom
                        anchors.topMargin: rowVerticalMargin
                        height: childrenRect.height
                        color: parent.color

                        Grid{
                            id:gridCurrent
                            width: parent.width
                            columns: 2
                            columnSpacing: rowLeftMargin
                            rowSpacing: rowVerticalMargin*0.6

                            Text{
                                id:textKBCurrent
                                //anchors.left: parent.left
                                //anchors.leftMargin: parent.width * 0.02
                                text:"KB Current"
                                //font.bold: true
                                font.pointSize: 12
                                width: parent.width *0.5 - rowVerticalMargin*0.6

                            }
                            TextField {
                                id: textFieldKBCurrent
                                text:"3.00"
                                //width: 70
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                //anchors.left: textKBCurrent.right
                                font.pointSize: 12
                                width: parent.width *0.5 - rowVerticalMargin*0.6

                            }

                            Button{
                                id:buttonRelease
                                text:"Release"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                onClicked: {
                                    packetInterface.setCurrent(0.0)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text
                                    }
                                }
                            }
                            Button{
                                id:buttonFullBrake
                                text:"Full Brake"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                onClicked: {
                                    packetInterface.setDutyCycle(0.0)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text
                                    }
                                }
                            }

                        }}
                }

                Rectangle{
                    color: "#DCDCDC"
                    id:rectBEMF
                    anchors.top:rectControl.bottom
                    anchors.topMargin:rectGap
                    width: parent.width
                    height: textTitleBEMF.height + rowVerticalMargin +rectGridBEMF2.height

                    Text{
                        id:textTitleBEMF
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.02
                        text:"BEMF and Current Sampling"
                        font.bold: true
                        font.pointSize: 14
                    }

                    Rectangle{
                        id:rectGridBEMF2
                        width:parent.width - (2 * rowLeftMargin)
                        anchors.left:parent.left
                        anchors.leftMargin: rowLeftMargin
                        anchors.right: parent.right
                        anchors.rightMargin: rowLeftMargin
                        anchors.top: textTitleBEMF.bottom
                        anchors.topMargin: rowVerticalMargin
                        height: gridBEMF.height
                        color: parent.color


                        Grid{
                            id:gridBEMF
                            width: parent.width
                            columns: 2
                            columnSpacing: rowLeftMargin
                            rowSpacing: rowVerticalMargin*0.6

                            Button{
                                id:buttonNow
                                text:"Now"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                onClicked: {
                                    getSampleData(false, textFieldKSamples.text, textFieldDecimation.text)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text
                                    }
                                }
                            }
                            Button{
                                id:buttonAtStart
                                text:"At Start"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                onClicked: {
                                    getSampleData(true, textFieldKSamples.text, textFieldDecimation.text)
                                }
                                style: ButtonStyle {
                                    label: Text {
                                        renderType: Text.NativeRendering
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.family: "Helvetica"
                                        font.pointSize: 12
                                        //color: "blue"
                                        text: control.text
                                    }
                                }
                            }

                            Text{
                                id:textSamples
                                text:"Samples"
                                font.pointSize: 12
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                            }
                            TextField {
                                id: textFieldKSamples
                                text:"1000"
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                            }

                            Text{
                                id:decimation
                                text:"Decimation"
                                font.pointSize: 12
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                            }
                            TextField {
                                id: textFieldDecimation
                                text:"1"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }

                            Text{
                                id:fftText
                                text:"Fs for FFT"
                                font.pointSize: 12
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                            }
                            TextField {
                                id: textFieldFFT
                                text:"1"
                                width: parent.width *0.5 - rowVerticalMargin*0.6
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                                onEditingFinished: sampleFreq = text
                                Component.onCompleted: sampleFreq = text
                            }



                        }

                    }

                }

                Rectangle{
                    color: "#DCDCDC"
                    id:rectPlotControl
                    anchors.top:rectBEMF.bottom
                    anchors.topMargin:12
                    width: parent.width
                    height: textTitlePlotControl.height + hzoomControlChkRow.height + vzoomControlChkRow.height +buttonsRowPlot.height + 20

                    Text{
                        id:textTitlePlotControl
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width * 0.02
                        text:"Plot Control"
                        font.bold: true
                        font.pointSize: 14
                    }

                    Row {
                        id: hzoomControlChkRow
                        anchors.top:textTitlePlotControl.bottom
                        anchors.topMargin:6
                        anchors.left: parent.left
                        anchors.leftMargin: 32
                        spacing: 8

                        CheckBox {
                            id: hZoomChkBox
                            text: qsTr("Horizontal Zoom")
                            checked: true
                            Component.objectName: verticalZoom = checked
                            onClicked: horizontalZoom = checked
                            style: CheckBoxStyle{
                                label: Text {
                                    renderType: Text.NativeRendering
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Helvetica"
                                    font.pointSize: 12
                                    text: control.text
                                }
                            }
                        }
                    }

                    Row {
                        id: vzoomControlChkRow
                        anchors.top:hzoomControlChkRow.bottom
                        anchors.topMargin:6
                        anchors.left: parent.left
                        anchors.leftMargin: 32
                        spacing: 8

                        CheckBox {
                            id: vZoomChkBox
                            text: qsTr("Vertcial Zoom")
                            checked: true
                            Component.objectName: horizontalZoom = checked
                            onClicked: horizontalZoom = checked
                            style: CheckBoxStyle{
                                label: Text {
                                    renderType: Text.NativeRendering
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Helvetica"
                                    font.pointSize: 12
                                    text: control.text
                                }
                            }
                        }
                    }

                    Row{
                        id:buttonsRowPlot
                        anchors.top:vzoomControlChkRow.bottom
                        anchors.topMargin:8
                        anchors.left: parent.left
                        anchors.leftMargin: 32
                        spacing: 8

                        Button{
                            id:buttonRescale
                            text:"Rescale"
                            width: textFieldFFT.width
                            onClicked: {
                                doRescale = true
                            }
                            style: ButtonStyle {
                                label: Text {
                                    renderType: Text.NativeRendering
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Helvetica"
                                    font.pointSize: 12
                                    //color: "blue"
                                    text: control.text
                                }
                            }
                        }
                        Button{
                            id:buttonReplot
                            text:"Replot"
                            width: textFieldFFT.width
                            onClicked: {
                                doReplot = true
                                doFilterReplot = true
                            }
                            style: ButtonStyle {
                                label: Text {
                                    renderType: Text.NativeRendering
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: "Helvetica"
                                    font.pointSize: 12
                                    //color: "blue"
                                    text: control.text
                                }
                            }
                        }
                    }
                }

            }
        }
    }
}

