// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtCore

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Logic as EaLogic

import Gui.Globals as Globals


Column {
    spacing: EaStyle.Sizes.fontPixelSize

    // Table
    EaComponents.TableView {
        id: tableView

        property int measurementCurrentIndex: Globals.Proxies.main.measurement.currentIndex

        defaultInfoText: qsTr("No measurements imported")

        maxRowCountShow: 5
        onMeasurementCurrentIndexChanged: currentIndex = Globals.Proxies.main.measurement.currentIndex

        // Table model
        model: Globals.Proxies.main.measurement.dataBlocksNoMeas

        // Header row
        header: EaComponents.TableViewHeader {

            EaComponents.TableViewLabel {
                width: EaStyle.Sizes.fontPixelSize * 3.0
                //text: qsTr("no.")
            }

            EaComponents.TableViewLabel {
                width: EaStyle.Sizes.tableRowHeight
                //text: qsTr("color")
            }

            EaComponents.TableViewLabel {
                flexibleWidth: true
                horizontalAlignment: Text.AlignLeft
                color: EaStyle.Colors.themeForegroundMinor
                text: qsTr("label")
            }

            EaComponents.TableViewLabel {
                width: EaStyle.Sizes.tableRowHeight
                //text: qsTr("del.")
            }

        }
        // Header row

        // Table rows
        delegate: EaComponents.TableViewDelegate {
            mouseArea.onPressed: Globals.Proxies.main.measurement.currentIndex = tableView.currentIndex

            EaComponents.TableViewLabel {
                enabled: false
                text: index + 1
            }

            EaComponents.TableViewButton {
                fontIcon: "microscope"
                ToolTip.text: qsTr("Measured pattern color")
                backgroundColor: "transparent"
                borderColor: "transparent"
                iconColor: EaStyle.Colors.chartForegroundsExtra[2]
            }

            EaComponents.TableViewParameter {
                selected: index === Globals.Proxies.main.measurement.currentIndex
                text: tableView.model[index].name.value
            }

            EaComponents.TableViewButton {
                enabled: false
                fontIcon: "minus-circle"
                ToolTip.text: qsTr("Remove this dataset")
                onClicked: Globals.Proxies.main.measurement.removeMeasurement(index)
            }

        }
        // Table rows
    }
    // Table

    // Control buttons below table
    Row {
        spacing: EaStyle.Sizes.fontPixelSize

        EaElements.SideBarButton {
            enabled: true
            wide: true
            fontIcon: "upload"
            text: qsTr("Import Scitiff")
            onClicked: {
                console.debug(`Clicking '${text}' button: ${this}`)
                Globals.References.pages.measurement.sidebar.basic.popups.openMeasurementFileDialog.open()
            }

            Loader {
                source: '../Popups/OpenMeasurementFile.qml'
            }

            Component.onCompleted: Globals.Refs.app.measurementPage.importDataFromLocalDriveButton = this
        }
    }
    // Control buttons below table

    // Misc

    FileDialog{
        id: openCifFileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: [ "CIF files (*.cif)", "ASCII data files - 3 columns (*.xye *.xys *.dat)", "ASCII data files - 2 columns (*.xy *.dat)"]
        onAccepted: {
            console.debug('*** Loading measurement(s) from file(s) ***')
            Globals.Proxies.main.measurement.loadMeasurementsFromFiles(selectedFiles)
        }
    }

}
