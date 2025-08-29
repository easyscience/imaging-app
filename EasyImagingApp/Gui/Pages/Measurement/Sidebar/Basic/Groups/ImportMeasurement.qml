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
        id: measurementsTable

        // property int measurementCurrentIndex: Globals.Proxies.main.measurement.currentIndex

        defaultInfoText: qsTr("No measurements imported")

        maxRowCountShow: 5

        // Table model
        model: Globals.BackendWrapper.measurementsList

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
            // mouseArea.onPressed: Globals.Proxies.main.measurement.currentIndex = tableView.currentIndex

            EaComponents.TableViewLabel {
                enabled: false
                text: index + 1
            }

            EaComponents.TableViewButton {
                fontIcon: "microscope"
                backgroundColor: "transparent"
                borderColor: "transparent"
                iconColor: EaStyle.Colors.chartForegroundsExtra[2]
            }

            EaComponents.TableViewTextInput {
                text: tableView.model[index].name
            }

            EaComponents.TableViewButton {
                fontIcon: "minus-circle"
                ToolTip.text: qsTr("Remove this measurement")
                onClicked: {
                    console.debug('Rect list before removal:', Globals.Variables.measurementRoiRectList)
                    console.debug('Series list before removal:', Globals.Variables.measurementRoiSeriesList)
                    Globals.BackendWrapper.measurementRemove(tableView.model[index].name)
                    console.debug("Measurement ROI rect list after removal:", Globals.Variables.measurementRoiRectList);
                    console.debug("Measurement ROI series list after removal:", Globals.Variables.measurementRoiSeriesList);
                }
            }
            mouseArea.onPressed: {
                if (Globals.BackendWrapper.activeMeasurementIndex != index) {
                    console.debug(`Changing active measurement to: ${tableView.model[index].name}`)
                    // for (var i=0; i < Globals.Variables.measurementRoiRectList[Globals.BackendWrapper.activeMeasurementIndex].length; i++) {
                    //     Globals.Variables.measurementRoiRectList[Globals.BackendWrapper.activeMeasurementIndex][i].visible = false;
                    //     console.debug(' Removing Series:' + Globals.Variables.measurementRoiSeriesList[Globals.BackendWrapper.activeMeasurementIndex][i])
                    //     Globals.References.pages.measurement.mainContent.views.spectrumView.removeSeries(0);
                    // }
                    Globals.BackendWrapper.changeActiveMeasurement(tableView.model[index].name)
                    Globals.References.pages.measurement.sidebar.basic.groups.timeFrameSlider.slider.value = 0
                }
            }
        }
        // Table rows
    }
    // Table

    // Control buttons below table
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

        Connections {
            target: Globals.BackendWrapper.activeBackend.measurements
            function onMeasurementCreated() {
                Globals.Variables.measurementRoiRectList.push([]);
                Globals.Variables.measurementRoiSeriesList.push([]);
            }
        }
        Connections {
            target: Globals.BackendWrapper.activeBackend.measurements
            function onMeasurementDeleted(index) {
                for (var i=0; i < Globals.Variables.measurementRoiRectList[index].length; i++) {
                    Globals.Variables.measurementRoiRectList[index][i].destroy()
                }
                Globals.Variables.measurementRoiRectList.splice(index, 1);
                Globals.Variables.measurementRoiSeriesList.splice(index, 1);
            }
        }
        Connections {
            target: Globals.BackendWrapper.activeBackend.measurements
            function onActiveMeasurementChanged(oldIndex) {
                console.debug('MeasurementRoiRectList:' + Globals.Variables.measurementRoiRectList)
                console.debug('Length of MeasurementRoiRectList:' + Globals.Variables.measurementRoiRectList[Globals.BackendWrapper.activeMeasurementIndex].length)
                // Remove old active measurement from views
                for (var i=0; i < Globals.Variables.measurementRoiRectList[oldIndex].length; i++) {
                        Globals.Variables.measurementRoiRectList[oldIndex][i].visible = false;
                        console.debug(' Removing Series:' + Globals.Variables.measurementRoiSeriesList[oldIndex][i])
                        Globals.References.pages.measurement.mainContent.views.spectrumView.removeSeries(0);
                    }
                
                for (var i=0; i < Globals.Variables.measurementRoiRectList[Globals.BackendWrapper.activeMeasurementIndex].length; i++) {
                    Globals.Variables.measurementRoiRectList[Globals.BackendWrapper.activeMeasurementIndex][i].visible = true;
                    console.debug(' Adding Series:' + Globals.Variables.measurementRoiSeriesList[Globals.BackendWrapper.activeMeasurementIndex][i])
                    Globals.References.pages.measurement.mainContent.views.spectrumView.addSeries(
                        Globals.Variables.measurementRoiSeriesList[Globals.BackendWrapper.activeMeasurementIndex][i]
                    );
                }
            }
        }

    }
}
