// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick
import QtGraphs

// Initialisation of the reference dictionary. It is filled in later, when the required object is
// created and its unique id is assigned and added here instead of 'null'. After that, any object
// whose id is stored here can be accessed from any other qml file.
QtObject {

    // Populated in ApplicationWindows.qml
    readonly property var applicationWindow: {
        'appBarCentralTabs': {
            'homeButton': null,
            'projectButton': null,
            'measurementButton': null,
            'summaryButton': null,
        }
    }

    // Populated in Pages/...
    readonly property var pages: {
        'project': {
            'sidebar': {
                'basic': {
                    'popups': {
                        'openTiffFileDialog': null
                    }
                }
            }
        },
        'measurement':{
            'mainContent': {
                'views': {
                    'spectrumView': null,
                    'measurementViewer': null,
                },
            },
            'sidebar': {
                'basic': {
                    'groups': {
                        'timeFrameSlider': {
                            'slider': null,
                        },
                    },
                    'popups': {
                        'openMeasurementFileDialog': null,
                    },
                },
            },
        },
    }
    // Define series as a Component for dynamic creation elsewhere
    readonly property var testSeriesComponent: Component {
        LineSeries {
            XYPoint { x: 0; y: 0 }
            XYPoint { x: 1.1; y: 2.1 }
            XYPoint { x: 1.9; y: 3.3 }
            XYPoint { x: 2.1; y: 2.1 }
            XYPoint { x: 2.9; y: 4.9 }
            XYPoint { x: 3.4; y: 3.0 }
            XYPoint { x: 4.1; y: 3.3 }
        }
    }
    function getTestSeries() {
        Qt.createComponent("Series.qml").createObject(this, {
            "id": "testSeries"
        });

    }

}
