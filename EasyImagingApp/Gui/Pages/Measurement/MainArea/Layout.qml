// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>
import QtGraphs
import QtQuick
import QtQuick.Layouts


import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Style as EaStyle
// import EasyApp.Gui.Charts as EaCharts
import EasyApp.Gui.Globals as EaGlobals

import Gui.Globals as Globals

import QtGraphs

Column {

    Layout.fillHeight: true

    Rectangle {
        width: parent.width
        height: parent.height * 0.7


        Image {
        id: measurementViewer
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        cache: false
        smooth: false
        retainWhileLoading: true
        asynchronous: true
        source: Globals.BackendWrapper.imageSource
        Component.onCompleted: {
            Globals.References.pages.measurement.mainContent.views.measurementViewer = measurementViewer
        }
    }
    }

    Rectangle {
        
        color: "blue"
        width: parent.width

        height: parent.height * 0.3

        GraphsView {

            id: spectrumViewer
            anchors.fill: parent

                axisX: ValueAxis {
                id: xAxis
                max: 4.1
            }
            axisY: ValueAxis {
                id: yAxis
                max: 4.9
            }

            LineSeries {
                name: "Line"
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 4.9 }
                XYPoint { x: 3.4; y: 3.0 }
                XYPoint { x: 4.1; y: 3.3 }
            }

        Component.onCompleted: {
            Globals.References.pages.measurement.mainContent.views.spectrumView = spectrumViewer;
        }
        }

        // EaCharts.QtCharts1dBase {
        //     id: spectrumViewer

        //     anchors.fill: parent

        //     useOpenGL: EaGlobals.Vars.useOpenGL

        //     axisX.title: 'Time of flight (s)'
        //     axisX.min: 0.015
        //     axisX.max: 0.135

        //     axisY.title: 'Transmission'
        //     axisY.min: 0.0
        //     axisY.max: 8050

        //     LineSeries {
        //         name: "Line"
        //         XYPoint { x: 0; y: 0 }
        //         XYPoint { x: 1.1; y: 2.1 }
        //         XYPoint { x: 1.9; y: 3.3 }
        //         XYPoint { x: 2.1; y: 2.1 }
        //         XYPoint { x: 2.9; y: 4.9 }
        //         XYPoint { x: 3.4; y: 3.0 }
        //         XYPoint { x: 4.1; y: 3.3 }
        //     }

        //     // Tool buttons
        //     Row {
        //         id: toolButtons

        //         x: spectrumViewer.plotArea.x + spectrumViewer.plotArea.width - width
        //         y: spectrumViewer.plotArea.y - height - EaStyle.Sizes.fontPixelSize

        //         spacing: 0.25 * EaStyle.Sizes.fontPixelSize

        //         // EaElements.TabButton {
        //         //     checked: Globals.Variables.showLegendOnExperimentPage
        //         //     autoExclusive: false
        //         //     height: EaStyle.Sizes.toolButtonHeight
        //         //     width: EaStyle.Sizes.toolButtonHeight
        //         //     borderColor: EaStyle.Colors.chartAxis
        //         //     fontIcon: "align-left"
        //         //     ToolTip.text: Globals.Variables.showLegendOnExperimentPage ?
        //         //                     qsTr("Hide legend") :
        //         //                     qsTr("Show legend")
        //         //     onClicked: Globals.Variables.showLegendOnExperimentPage = checked
        //         // }

        //         EaElements.TabButton {
        //             checked: spectrumViewer.allowHover
        //             autoExclusive: false
        //             height: EaStyle.Sizes.toolButtonHeight
        //             width: EaStyle.Sizes.toolButtonHeight
        //             borderColor: EaStyle.Colors.chartAxis
        //             fontIcon: "comment-alt"
        //             ToolTip.text: qsTr("Show coordinates tooltip on hover")
        //             onClicked: spectrumViewer.allowHover = !spectrumViewer.allowHover
        //         }

        //         Item { height: 1; width: 0.5 * EaStyle.Sizes.fontPixelSize }  // spacer

        //         EaElements.TabButton {
        //             checked: !spectrumViewer.allowZoom
        //             autoExclusive: false
        //             height: EaStyle.Sizes.toolButtonHeight
        //             width: EaStyle.Sizes.toolButtonHeight
        //             borderColor: EaStyle.Colors.chartAxis
        //             fontIcon: "arrows-alt"
        //             ToolTip.text: qsTr("Enable pan")
        //             onClicked: spectrumViewer.allowZoom = !spectrumViewer.allowZoom
        //         }

        //         EaElements.TabButton {
        //             checked: spectrumViewer.allowZoom
        //             autoExclusive: false
        //             height: EaStyle.Sizes.toolButtonHeight
        //             width: EaStyle.Sizes.toolButtonHeight
        //             borderColor: EaStyle.Colors.chartAxis
        //             fontIcon: "expand"
        //             ToolTip.text: qsTr("Enable box zoom")
        //             onClicked: spectrumViewer.allowZoom = !spectrumViewer.allowZoom
        //         }

        //         EaElements.TabButton {
        //             checkable: false
        //             height: EaStyle.Sizes.toolButtonHeight
        //             width: EaStyle.Sizes.toolButtonHeight
        //             borderColor: EaStyle.Colors.chartAxis
        //             fontIcon: "backspace"
        //             ToolTip.text: qsTr("Reset axes")
        //             onClicked: spectrumViewer.resetAxes()
        //         }

        //     }
        //     // Tool buttons

        // }
    }
}

